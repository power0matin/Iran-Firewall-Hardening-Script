#!/bin/bash

echo "[*] Flushing all iptables rules..."
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X

echo "[*] Setting default policies to ACCEPT..."
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

echo "[*] Removing ICMP ping block (enabling ping)..."
sed -i '/net.ipv4.icmp_echo_ignore_all/d' /etc/sysctl.conf
sysctl -w net.ipv4.icmp_echo_ignore_all=0
sysctl -p

echo "[*] Removing persistent firewall rules..."
if [ -f /etc/iptables/rules.v4 ]; then
  rm /etc/iptables/rules.v4
  echo "Deleted: /etc/iptables/rules.v4"
fi

echo "[*] Optionally removing iptables-persistent (press Y if asked)..."
apt remove --purge iptables-persistent -y

echo "[✅] Firewall reset complete. Server is now fully open (not secure)."
