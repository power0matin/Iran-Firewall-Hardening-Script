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
  echo -e "${RED}❌ لطفاً اسکریپت را با دسترسی روت اجرا کنید.${NC}"
  exit 1
fi

# Global variables
FOREIGN_SERVER_IP=""
ALLOWED_PORTS=()

function read_config_from_user() {
  echo -e "${YELLOW}📡 لطفاً آی‌پی سرور خارجی را وارد کنید:${NC}"
  read -rp "IP: " FOREIGN_SERVER_IP

  echo -e "${YELLOW}🔌 لطفاً پورت‌ها را با کاما جدا وارد کنید (مثال: 55942,9443,4114):${NC}"
  read -rp "Ports: " ports_input

  # تبدیل پورت‌ها به آرایه
  IFS=',' read -ra ALLOWED_PORTS <<< "$ports_input"

  echo -e "${CYAN}[*] تنظیمات دریافتی:${NC}"
  echo "  آی‌پی: $FOREIGN_SERVER_IP"
  echo "  پورت‌ها: ${ALLOWED_PORTS[*]}"
}

function apply_firewall() {
  echo -e "${CYAN}[*] پاک‌سازی قوانین فعلی فایروال...${NC}"
  iptables -F
  iptables -X
  iptables -t nat -F
  iptables -t nat -X
  iptables -t mangle -F
  iptables -t mangle -X

  echo -e "${CYAN}[*] اجازه به ترافیک لوکال هاست...${NC}"
  iptables -A INPUT -i lo -j ACCEPT
  iptables -A OUTPUT -o lo -j ACCEPT

  echo -e "${CYAN}[*] اجازه به SSH روی پورت 22 برای جلوگیری از قفل شدن...${NC}"
  iptables -A INPUT -p tcp --dport 22 -j ACCEPT
  iptables -A OUTPUT -p tcp --sport 22 -j ACCEPT

  echo -e "${CYAN}[*] اعمال قوانین برای آی‌پی ${FOREIGN_SERVER_IP} و پورت‌های مجاز...${NC}"
  for port in "${ALLOWED_PORTS[@]}"; do
    echo -e "  - اجازه به پورت ${port} از ${FOREIGN_SERVER_IP}"
    iptables -A INPUT -p tcp -s "$FOREIGN_SERVER_IP" --dport "$port" -j ACCEPT
    iptables -A OUTPUT -p tcp -d "$FOREIGN_SERVER_IP" --sport "$port" -j ACCEPT
  done

  echo -e "${CYAN}[*] ست کردن سیاست پیش‌فرض DROP برای امنیت بیشتر...${NC}"
  iptables -P INPUT DROP
  iptables -P FORWARD DROP
  iptables -P OUTPUT DROP

  echo -e "${CYAN}[*] غیرفعال‌سازی پینگ (ICMP echo)...${NC}"
  if ! grep -q "^net.ipv4.icmp_echo_ignore_all = 1" /etc/sysctl.conf; then
    echo "net.ipv4.icmp_echo_ignore_all = 1" >> /etc/sysctl.conf
  fi
  sysctl -p

  echo -e "${CYAN}[*] نصب iptables-persistent برای ذخیره قوانین...${NC}"
  apt-get update -y
  DEBIAN_FRONTEND=noninteractive apt-get install -y iptables-persistent
  iptables-save > /etc/iptables/rules.v4

  echo -e "${GREEN}[✅] فایروال با موفقیت اعمال شد.${NC}"
}

function reset_firewall() {
  echo -e "${CYAN}[*] بازگردانی فایروال به حالت باز (پیش‌فرض)...${NC}"
  iptables -F
  iptables -X
  iptables -t nat -F
  iptables -t nat -X
  iptables -t mangle -F
  iptables -t mangle -X

  iptables -P INPUT ACCEPT
  iptables -P FORWARD ACCEPT
  iptables -P OUTPUT ACCEPT

  echo -e "${CYAN}[*] فعال‌سازی مجدد پینگ (ICMP echo)...${NC}"
  sed -i '/net.ipv4.icmp_echo_ignore_all/d' /etc/sysctl.conf
  sysctl -w net.ipv4.icmp_echo_ignore_all=0
  sysctl -p

  echo -e "${CYAN}[*] حذف قوانین ذخیره‌شده iptables...${NC}"
  [[ -f /etc/iptables/rules.v4 ]] && rm -f /etc/iptables/rules.v4

  echo -e "${CYAN}[*] حذف iptables-persistent...${NC}"
  apt-get remove --purge -y iptables-persistent

  echo -e "${GREEN}[✅] فایروال به‌طور کامل باز شد.${NC}"
}

function show_menu() {
  echo -e "${YELLOW}====== منوی مدیریت فایروال ======${NC}"
  echo "1) اعمال محدودیت (وارد کردن آی‌پی و پورت دلخواه)"
  echo "2) بازگردانی کامل به حالت آزاد"
  echo "3) خروج"
  echo -n "لطفاً یک گزینه انتخاب کنید [1-3]: "
}

while true; do
  show_menu
  read -r choice
  case $choice in
    1)
      read_config_from_user
      apply_firewall
      ;;
    2)
      reset_firewall
      ;;
    3)
      echo -e "${GREEN}خدانگهدار!${NC}"
      exit 0
      ;;
    *)
      echo -e "${RED}گزینه نامعتبر. لطفاً مجدداً تلاش کنید.${NC}"
      ;;
  esac
  echo
done
