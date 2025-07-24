#!/bin/bash
set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Configurable settings
FOREIGN_SERVER_IP="1.2.3.4"
ALLOWED_PORTS=(2053 10000 10001 10002 10003)

# Check for root
if [[ $EUID -ne 0 ]]; then
  echo -e "${RED}❌ Please run this script as root.${NC}"
  exit 1
fi

function apply_firewall() {
  echo -e "${CYAN}[*] Flushing current iptables rules...${NC}"
  iptables -F
  iptables -X
  iptables -t nat -F
  iptables -t nat -X
  iptables -t mangle -F
  iptables -t mangle -X

  echo -e "${CYAN}[*] Allowing localhost traffic...${NC}"
  iptables -A INPUT -i lo -j ACCEPT
  iptables -A OUTPUT -o lo -j ACCEPT

  echo -e "${CYAN}[*] Allowing SSH (port 22) to prevent lockout...${NC}"
  iptables -A INPUT -p tcp --dport 22 -j ACCEPT
  iptables -A OUTPUT -p tcp --sport 22 -j ACCEPT

  echo -e "${CYAN}[*] Applying rules for allowed ports from ${FOREIGN_SERVER_IP}...${NC}"
  for port in "${ALLOWED_PORTS[@]}"; do
    echo -e "  - Port ${port} allowed for ${FOREIGN_SERVER_IP}"
    iptables -A INPUT -p tcp -s "$FOREIGN_SERVER_IP" --dport "$port" -j ACCEPT
    iptables -A OUTPUT -p tcp -d "$FOREIGN_SERVER_IP" --sport "$port" -j ACCEPT
  done

  echo -e "${CYAN}[*] Setting default policy to DROP for higher security...${NC}"
  iptables -P INPUT DROP
  iptables -P FORWARD DROP
  iptables -P OUTPUT DROP

  echo -e "${CYAN}[*] Disabling ping (ICMP echo)...${NC}"
  if ! grep -q "^net.ipv4.icmp_echo_ignore_all = 1" /etc/sysctl.conf; then
    echo "net.ipv4.icmp_echo_ignore_all = 1" >> /etc/sysctl.conf
  fi
  sysctl -p

  echo -e "${CYAN}[*] Installing iptables-persistent to save rules...${NC}"
  apt-get update -y
  DEBIAN_FRONTEND=noninteractive apt-get install -y iptables-persistent
  iptables-save > /etc/iptables/rules.v4

  echo -e "${GREEN}[✅] Firewall rules applied successfully.${NC}"
}

function reset_firewall() {
  echo -e "${CYAN}[*] Resetting firewall to default (open) state...${NC}"
  iptables -F
  iptables -X
  iptables -t nat -F
  iptables -t nat -X
  iptables -t mangle -F
  iptables -t mangle -X

  iptables -P INPUT ACCEPT
  iptables -P FORWARD ACCEPT
  iptables -P OUTPUT ACCEPT

  echo -e "${CYAN}[*] Enabling ping (ICMP echo)...${NC}"
  sed -i '/net.ipv4.icmp_echo_ignore_all/d' /etc/sysctl.conf
  sysctl -w net.ipv4.icmp_echo_ignore_all=0
  sysctl -p

  echo -e "${CYAN}[*] Removing saved iptables rules...${NC}"
  if [[ -f /etc/iptables/rules.v4 ]]; then
    rm -f /etc/iptables/rules.v4
    echo "  - Deleted /etc/iptables/rules.v4"
  fi

  echo -e "${CYAN}[*] Removing iptables-persistent...${NC}"
  apt-get remove --purge -y iptables-persistent

  echo -e "${GREEN}[✅] Firewall fully opened.${NC}"
}

function show_menu() {
  echo -e "${YELLOW}====== Firewall Management Menu ======${NC}"
  echo "1) Apply restrictions (only foreign IP and specific ports)"
  echo "2) Reset firewall to open mode"
  echo "3) Exit"
  echo -n "Select an option [1-3]: "
}

while true; do
  show_menu
  read -r choice
  case $choice in
    1)
      apply_firewall
      ;;
    2)
      reset_firewall
      ;;
    3)
      echo -e "${GREEN}Goodbye!${NC}"
      exit 0
      ;;
    *)
      echo -e "${RED}Invalid option. Please try again.${NC}"
      ;;
  esac
  echo
done
