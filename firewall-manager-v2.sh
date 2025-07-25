#!/bin/bash
set -euo pipefail

FIREWALL_LOG="/etc/firewall-manager/last_config.log"

mkdir -p /etc/firewall-manager

# ANSI Colors
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
NC="\033[0m"

# Trap Ctrl+C
trap ctrl_c INT
function ctrl_c() {
  echo -e "\n${YELLOW}⚠️  Exiting...${NC}"
  exit 1
}

function validate_ip() {
  local ip=$1
  local stat=1

  if [[ $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
    OIFS=$IFS
    IFS='.' read -r -a ip_array <<< "$ip"
    IFS=$OIFS
    [[ ${ip_array[0]} -le 255 && ${ip_array[1]} -le 255 && \
       ${ip_array[2]} -le 255 && ${ip_array[3]} -le 255 ]]
    stat=$?
  fi

  return $stat
}

function validate_ports() {
  local ports=$1
  for port in $(echo "$ports" | tr ',' ' '); do
    if ! [[ $port =~ ^[0-9]+$ ]] || ((port < 1 || port > 65535)); then
      return 1
    fi
  done
  return 0
}

function ping_check() {
  echo -e "${YELLOW}🔍 Checking if $1 is reachable...${NC}"
  if ping -c 1 -W 2 "$1" &>/dev/null; then
    echo -e "${GREEN}✅ $1 is reachable${NC}"
  else
    echo -e "${RED}⚠️  $1 is NOT reachable. Continue anyway? (y/n)${NC}"
    read -r confirm
    [[ $confirm == "y" ]] || exit 1
  fi
}

function save_config() {
  echo "$1|$2|$3" > "$FIREWALL_LOG"
}

function load_config() {
  if [[ -f $FIREWALL_LOG ]]; then
    IFS='|' read -r old_ip old_ports old_proto < "$FIREWALL_LOG"
    echo "$old_ip|$old_ports|$old_proto"
  fi
}

function show_firewall_status() {
  echo -e "${YELLOW}🔎 Open ports by IP:${NC}"
  iptables -L INPUT -n --line-numbers | grep -E "ACCEPT" | grep -v "127.0.0.1"
}

function apply_firewall() {
  echo -e "${YELLOW}[*] Clearing current firewall rules...${NC}"
  iptables -F
  iptables -P INPUT DROP
  iptables -P FORWARD DROP
  iptables -P OUTPUT ACCEPT

  echo -e "[*] Allowing localhost and SSH..."
  iptables -A INPUT -i lo -j ACCEPT
  iptables -A INPUT -p tcp --dport 22 -j ACCEPT

  for port in $(echo "$2" | tr ',' ' '); do
    if [[ "$3" == "TCP" || "$3" == "BOTH" ]]; then
      iptables -A INPUT -p tcp -s "$1" --dport "$port" -j ACCEPT
    fi
    if [[ "$3" == "UDP" || "$3" == "BOTH" ]]; then
      iptables -A INPUT -p udp -s "$1" --dport "$port" -j ACCEPT
    fi
  done

  echo -e "[*] Blocking ping (ICMP)..."
  echo 'net.ipv4.icmp_echo_ignore_all = 1' >> /etc/sysctl.conf
  sysctl -p

  save_config "$1" "$2" "$3"
  netfilter-persistent save
  echo -e "${GREEN}✅ Firewall rules applied successfully!${NC}"
}

function reset_firewall() {
  iptables -F
  iptables -P INPUT ACCEPT
  iptables -P FORWARD ACCEPT
  iptables -P OUTPUT ACCEPT
  sed -i '/icmp_echo_ignore_all/d' /etc/sysctl.conf
  sysctl -p
  netfilter-persistent save
  echo -e "${GREEN}✅ Firewall reset to open state.${NC}"
}

function show_menu() {
  echo -e "${YELLOW}====== Firewall Manager ======${NC}"
  echo "1) Apply Firewall Rules"
  echo "2) Show Firewall Status"
  echo "3) Reset Firewall"
  echo "0) Exit"
  echo -n "Choose an option [0-3]: "
  read -r choice

  case $choice in
    1)
      config=$(load_config || true)
      IFS='|' read -r def_ip def_ports def_proto <<< "$config"

      echo -n "📡 Enter IP [${def_ip:-None}]: "
      read -r ip
      ip="${ip:-$def_ip}"
      validate_ip "$ip" || { echo -e "${RED}❌ Invalid IP.${NC}"; exit 1; }

      echo -n "🔌 Enter ports (comma-separated) [${def_ports:-None}]: "
      read -r ports
      ports="${ports:-$def_ports}"
      validate_ports "$ports" || { echo -e "${RED}❌ Invalid ports.${NC}"; exit 1; }

      echo -n "📦 Protocol (TCP/UDP/BOTH) [${def_proto:-TCP}]: "
      read -r proto
      proto="${proto:-${def_proto:-TCP}}"

      ping_check "$ip"
      apply_firewall "$ip" "$ports" "$proto"
      ;;
    2)
      show_firewall_status
      ;;
    3)
      reset_firewall
      ;;
    0)
      echo -e "${YELLOW}Bye.${NC}"
      exit 0
      ;;
    *)
      echo -e "${RED}Invalid option.${NC}"
      ;;
  esac
}

# Ensure iptables-persistent is installed
if ! command -v netfilter-persistent >/dev/null; then
  echo -e "${YELLOW}Installing iptables-persistent...${NC}"
  apt update >/dev/null && apt install -y iptables-persistent
fi

while true; do
  show_menu
  echo ""
done
