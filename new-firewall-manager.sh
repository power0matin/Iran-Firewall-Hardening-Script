#!/bin/bash
set -euo pipefail

# ── Colors ─────────────────────────
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
RED='\033[0;31m'
NC='\033[0m'

CONFIG_FILE="/etc/firewall_manager/last_config.log"

# ── Root Check ─────────────────────
if [[ $EUID -ne 0 ]]; then
  echo -e "${RED}❌ Please run this script as root.${NC}"
  exit 1
fi

# ── Dependencies ────────────────────
function install_deps() {
  echo -e "${CYAN}[*] Installing iptables-persistent...${NC}"
  apt-get update -y
  DEBIAN_FRONTEND=noninteractive apt-get install -y iptables-persistent iputils-ping
}

# ── Validate Input ─────────────────
function is_valid_ip() {
  [[ $1 =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]] && \
  (awk -F. '{ for(i=1;i<=4;i++) if($i>255){exit 1}}' <<< "$1")
}

function is_valid_port() {
  [[ $1 =~ ^[0-9]+$ ]] && ((1 <= $1 && $1 <= 65535))
}

# ── Read Config ────────────────────
function read_config() {
  local prev_ip prev_tcp prev_udp
  if [[ -f $CONFIG_FILE ]]; then
    read -r prev_ip prev_tcp prev_udp < "$CONFIG_FILE"
    echo -e "${YELLOW}[Loaded previous config]${NC}"
    printf "IP [%s]: " "$prev_ip"
    read -r FOREIGN_SERVER_IP
    FOREIGN_SERVER_IP="${FOREIGN_SERVER_IP:-$prev_ip}"

    printf "TCP ports [%s]: " "$prev_tcp"
    read -r tre
    tre="${tre:-$prev_tcp}"

    printf "UDP ports [%s]: " "$prev_udp"
    read -r ure
    ure="${ure:-$prev_udp}"
  else
    read -rp "Enter foreign server IP: " FOREIGN_SERVER_IP
    read -rp "Enter TCP ports (comma-separated, e.g. 443,8443): " tre
    read -rp "Enter UDP ports (comma-separated, e.g. 1194): " ure
  fi

  # Validate IP
  if ! is_valid_ip "$FOREIGN_SERVER_IP"; then
    echo -e "${RED}❌ Invalid IP format.${NC}"
    exit 1
  fi

  # Process ports
  IFS=',' read -ra TCP_PORTS <<< "$(echo "$tre" | tr -cd '0-9,')"
  IFS=',' read -ra UDP_PORTS <<< "$(echo "$ure" | tr -cd '0-9,')"

  for p in "${TCP_PORTS[@]}"; do is_valid_port "$p" || { echo -e "${RED}❌ Invalid TCP port: $p${NC}"; exit 1; }; done
  for p in "${UDP_PORTS[@]}"; do is_valid_port "$p" || { echo -e "${RED}❌ Invalid UDP port: $p${NC}"; exit 1; }; done

  echo -e "${CYAN}[*] Configuration:${NC}"
  echo "  IP: $FOREIGN_SERVER_IP"
  echo "  TCP ports: ${TCP_PORTS[*]}"
  echo "  UDP ports: ${UDP_PORTS[*]}"
}

# ── Save Config ─────────────────────
function save_config() {
  mkdir -p "$(dirname "$CONFIG_FILE")"
  printf "%s\n%s\n%s\n" "$FOREIGN_SERVER_IP" "${TCP_PORTS[*]// /,}" "${UDP_PORTS[*]// /,}" > "$CONFIG_FILE"
}

# ── Ping Test ───────────────────────
function ping_test() {
  echo -e "${CYAN}[*] Testing reachability to $FOREIGN_SERVER_IP...${NC}"
  if ! ping -c1 -W2 "$FOREIGN_SERVER_IP" &>/dev/null; then
    echo -e "${YELLOW}⚠️ Warning: IP not reachable via ping.${NC}"
    read -rp "Continue anyway? [y/N]: " yn
    [[ "${yn,,}" == "y" ]] || exit 1
  fi
}

# ── Apply Firewall ─────────────────
function apply_firewall() {
  echo -e "${CYAN}[*] Flushing firewall rules...${NC}"
  iptables -F && iptables -X && iptables -t nat -F && iptables -t mangle -F

  echo -e "${CYAN}[*] Allowing localhost...${NC}"
  iptables -A INPUT -i lo -j ACCEPT
  iptables -A OUTPUT -o lo -j ACCEPT

  echo -e "${CYAN}[*] Allowing SSH port 22...${NC}"
  iptables -A INPUT -p tcp --dport 22 -j ACCEPT
  iptables -A OUTPUT -p tcp --sport 22 -j ACCEPT

  echo -e "${CYAN}[*] Allowing TCP ports from $FOREIGN_SERVER_IP...${NC}"
  for p in "${TCP_PORTS[@]}"; do
    iptables -A INPUT -p tcp -s "$FOREIGN_SERVER_IP" --dport "$p" -j ACCEPT
    iptables -A OUTPUT -p tcp -d "$FOREIGN_SERVER_IP" --sport "$p" -j ACCEPT
  done

  if (( ${#UDP_PORTS[@]} )); then
    echo -e "${CYAN}[*] Allowing UDP ports from $FOREIGN_SERVER_IP...${NC}"
    for p in "${UDP_PORTS[@]}"; do
      iptables -A INPUT -p udp -s "$FOREIGN_SERVER_IP" --dport "$p" -j ACCEPT
      iptables -A OUTPUT -p udp -d "$FOREIGN_SERVER_IP" --sport "$p" -j ACCEPT
    done
  fi

  echo -e "${CYAN}[*] Setting default DROP policies...${NC}"
  iptables -P INPUT DROP && iptables -P OUTPUT DROP && iptables -P FORWARD DROP

  echo -e "${CYAN}[*] Disabling ICMP ping...${NC}"
  [[ "$(grep -c net.ipv4.icmp_echo_ignore_all /etc/sysctl.conf)" -eq 0 ]] && echo "net.ipv4.icmp_echo_ignore_all = 1" >> /etc/sysctl.conf
  sysctl -p

  echo -e "${CYAN}[*] Saving rules...${NC}"
  iptables-save > /etc/iptables/rules.v4

  echo -e "${GREEN}[✅] Firewall applied.${NC}"
}

# ── Reset Firewall ─────────────────
function reset_firewall() {
  echo -e "${CYAN}[*] Resetting firewall...${NC}"
  iptables -F && iptables -X && iptables -t nat -F && iptables -t mangle -F
  iptables -P INPUT ACCEPT && iptables -P OUTPUT ACCEPT && iptables -P FORWARD ACCEPT

  echo -e "${CYAN}[*] Enabling ICMP ping...${NC}"
  sed -i '/net.ipv4.icmp_echo_ignore_all/d' /etc/sysctl.conf
  sysctl -w net.ipv4.icmp_echo_ignore_all=0

  echo -e "${CYAN}[*] Removing saved rules..."${NC}
  [[ -f /etc/iptables/rules.v4 ]] && rm -f /etc/iptables/rules.v4

  echo -e "${CYAN}[*] Removing iptables-persistent...${NC}"
  apt-get remove --purge -y iptables-persistent

  echo -e "${GREEN}[✅] Firewall reset and opened.${NC}"
}

# ── Show Status ────────────────────
function show_status() {
  echo -e "${CYAN}[*] Open firewall ports: ${NC}"
  iptables -L -n | grep -E 'ACCEPT.*'$FOREIGN_SERVER_IP
}

# ── Menu ───────────────────────────
function show_menu() {
  echo -e "${YELLOW}====== Firewall Management ======${NC}"
  echo "1) Apply restrictions (TCP/UDP)"
  echo "2) Show current firewall status"
  echo "3) Reset firewall to open"
  echo "0) Exit"
  echo -n "Choose [0-3]: "
}

# ── Main Loop ─────────────────────
while true; do
  show_menu
  read -r choice
  case $choice in
    1)
      install_deps
      read_config
      ping_test
      apply_firewall
      save_config
      ;;
    2)
      show_status
      ;;
    3)
      reset_firewall
      ;;
    0)
      echo -e "${GREEN}Goodbye!${NC}"
      exit 0
      ;;
    *)
      echo -e "${RED}Invalid option.${NC}"
      ;;
  esac
  echo
done
