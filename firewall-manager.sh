#!/bin/bash
set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check for root
if [[ $EUID -ne 0 ]]; then
  echo -e "${RED}❌ Please run this script as root.${NC}"
  exit 1
fi

# Global variables
FOREIGN_SERVER_IP=""
ALLOWED_PORTS=()

function install_dependencies() {
  echo -e "${CYAN}[*] Installing iptables-persistent...${NC}"
  apt-get update -y
  DEBIAN_FRONTEND=noninteractive apt-get install -y iptables-persistent
}

function read_config_from_user() {
  read -rp "🔌 Enter allowed ports (comma separated, e.g., 55942,9443,4114): " ports_input
  ports_input=$(echo "$ports_input" | tr -d '[:space:]' | tr -cd '0-9,')
  IFS=',' read -ra ALLOWED_PORTS <<< "$ports_input"


  echo -e "${YELLOW}🔌 Enter allowed ports (comma separated, e.g., 55942,9443,4114):${NC}"
  # حذف فاصله‌های اضافی و کاراکترهای نامناسب
  ports_input=$(echo "$ports_input" | tr -d '[:space:]' | tr -cd '0-9,')
  IFS=',' read -ra ALLOWED_PORTS <<< "$ports_input"


  # Split ports into array
  IFS=',' read -ra ALLOWED_PORTS <<< "$ports_input"

  echo -e "${CYAN}[*] Received Configuration:${NC}"
  echo "  IP: $FOREIGN_SERVER_IP"
  echo "  Ports: ${ALLOWED_PORTS[*]}"
}

function apply_firewall() {
  echo -e "${CYAN}[*] Flushing existing firewall rules...${NC}"
  iptables -F
  iptables -X
  iptables -t nat -F
  iptables -t nat -X
  iptables -t mangle -F
  iptables -t mangle -X

  echo -e "${CYAN}[*] Allowing localhost traffic...${NC}"
  iptables -A INPUT -i lo -j ACCEPT
  iptables -A OUTPUT -o lo -j ACCEPT

  echo -e "${CYAN}[*] Allowing SSH on port 22...${NC}"
  iptables -A INPUT -p tcp --dport 22 -j ACCEPT
  iptables -A OUTPUT -p tcp --sport 22 -j ACCEPT

  echo -e "${CYAN}[*] Applying rules for IP ${FOREIGN_SERVER_IP} and allowed ports...${NC}"
  for port in "${ALLOWED_PORTS[@]}"; do
    echo -e "  - Allowing port ${port} from ${FOREIGN_SERVER_IP}"
    iptables -A INPUT -p tcp -s "$FOREIGN_SERVER_IP" --dport "$port" -j ACCEPT
    iptables -A OUTPUT -p tcp -d "$FOREIGN_SERVER_IP" --sport "$port" -j ACCEPT
  done

  echo -e "${CYAN}[*] Setting default policy to DROP...${NC}"
  iptables -P INPUT DROP
  iptables -P FORWARD DROP
  iptables -P OUTPUT DROP

  echo -e "${CYAN}[*] Disabling ICMP echo (ping)...${NC}"
  if ! grep -q "^net.ipv4.icmp_echo_ignore_all = 1" /etc/sysctl.conf; then
    echo "net.ipv4.icmp_echo_ignore_all = 1" >> /etc/sysctl.conf
  fi
  sysctl -p

  echo -e "${CYAN}[*] Saving iptables rules...${NC}"
  iptables-save > /etc/iptables/rules.v4

  echo -e "${GREEN}[✅] Firewall rules applied successfully.${NC}"
}

function reset_firewall() {
  echo -e "${CYAN}[*] Resetting firewall rules to default (open)...${NC}"
  iptables -F
  iptables -X
  iptables -t nat -F
  iptables -t nat -X
  iptables -t mangle -F
  iptables -t mangle -X

  iptables -P INPUT ACCEPT
  iptables -P FORWARD ACCEPT
  iptables -P OUTPUT ACCEPT

  echo -e "${CYAN}[*] Enabling ICMP echo (ping)...${NC}"
  sed -i '/net.ipv4.icmp_echo_ignore_all/d' /etc/sysctl.conf
  sysctl -w net.ipv4.icmp_echo_ignore_all=0
  sysctl -p

  echo -e "${CYAN}[*] Removing saved iptables rules...${NC}"
  [[ -f /etc/iptables/rules.v4 ]] && rm -f /etc/iptables/rules.v4

  echo -e "${CYAN}[*] Removing iptables-persistent package...${NC}"
  apt-get remove --purge -y iptables-persistent

  echo -e "${GREEN}[✅] Firewall has been fully reset.${NC}"
}

function show_menu() {
  echo -e "${YELLOW}====== Firewall Management Menu ======${NC}"
  echo "1) Apply restrictions (enter allowed IP and ports)"
  echo "2) Reset firewall to open state"
  echo "3) Exit"
  echo -n "Choose an option [1-3]: "
}

while true; do
  show_menu
  read -r choice
  case $choice in
    1)
      install_dependencies
      read_config_from_user
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
