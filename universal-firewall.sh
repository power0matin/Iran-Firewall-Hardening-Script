#!/bin/bash

# =============== [🔧 Configuration] ===============
foreign_server_ip="Input_your_foreign_IP"  # Foreign server IP

# List of ports you want to be open only for the external server (separated by spaces)
allowed_ports=(2053 10000 10001 10002 10003)  # For example, tunnel port + panel port + inbound port

# =============== [🚀 Start script] ===============

echo "[*] Flushing old iptables rules..."
iptables -F

echo "[*] Allowing localhost traffic..."
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

echo "[*] Applying firewall rules for foreign_server_ip: $foreign_server_ip"
for port in "${allowed_ports[@]}"
do
  echo " - Allowing port $port for $foreign_server_ip"
  iptables -A INPUT -p tcp -s "$foreign_server_ip" --dport "$port" -j ACCEPT
  iptables -A OUTPUT -p tcp -d "$foreign_server_ip" --sport "$port" -j ACCEPT
done

echo "[*] Blocking all other traffic..."
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

echo "[*] Disabling ping response (ICMP)..."
echo "net.ipv4.icmp_echo_ignore_all = 1" >> /etc/sysctl.conf
sysctl -p

echo "[*] Installing iptables-persistent for saving rules..."
apt update -y && apt install iptables-persistent -y
iptables-save > /etc/iptables/rules.v4

echo "[✅] Done. Only these ports are open to $foreign_server_ip: ${allowed_ports[*]}"
