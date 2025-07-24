# 🔒 Iran Firewall Hardening Script
## [برای مشاهده به زبان فارسی کلیک کنید](README.fa.md)


A simple, powerful, and customizable Bash script to **secure Iranian servers** by:

- Blocking all incoming/outgoing traffic by default
- Allowing only specific ports from a trusted external IP (e.g. a foreign server)
- Disabling ICMP (ping) responses
- Persisting firewall rules after reboot

> ✅ Designed for projects using tunnels like **Rathole v2**, **Backhaul**, **Xray**, etc.


## 📦 Features

- Fully automated and minimal setup
- Works on any number of ports (just list them)
- Prevents access from all other sources (including Iran)
- Compatible with `iptables-persistent` for rule saving
- Lightweight and fast (suitable for production)


## ⚙️ Requirements

- Debian or Ubuntu server (root access)
- `iptables` installed (default on most systems)
- `iptables-persistent` (installed automatically by the script)


## 🚀 How to Use

### 1. Clone or Copy the Script

```bash
wget https://raw.githubusercontent.com/power0matin/Iran-Firewall-Hardening-Script/main/universal-firewall.sh
chmod +x universal-firewall.sh
```

### 2. Edit the Script

Open the file with your favorite editor and set:

```bash
foreign_server_ip="1.2.3.4"  # Your external server's IP (e.g., foreign VPS)

allowed_ports=(2053 10000 10001 10002 10003)  # Replace with your actual tunnel/panel ports
```

You can list as many ports as you like.

### 3. Run the Script

```bash
sudo ./universal-firewall.sh
```


## 🧪 Example Output

```bash
[*] Flushing old iptables rules...
[*] Allowing localhost traffic...
[*] Applying firewall rules for foreign_server_ip: 1.2.3.4
 - Allowing port 2053 for 1.2.3.4
 - Allowing port 10000 for 1.2.3.4
 - Allowing port 10001 for 1.2.3.4
[*] Blocking all other traffic...
[*] Disabling ping response (ICMP)...
[*] Installing iptables-persistent...
[✅] Done. Only these ports are open to 1.2.3.4: 2053 10000 10001
```


## ⚠️ Important Notes

* Be sure you enter the **correct external IP** before running. Otherwise, you may lose SSH access to the server.
* Test the tunnel from your external server **before** applying final firewall restrictions.
* If you’re using UDP ports, modify the script to include `-p udp` rules.
* If the server needs DNS or NTP access, add exceptions for ports `53` and `123` in `OUTPUT` rules.


## 📄 License

MIT License – use it freely in personal or commercial projects.


## ✨ Credits

Created by [YourName](https://github.com/power0matin) for secure tunnel deployments inside Iran.
