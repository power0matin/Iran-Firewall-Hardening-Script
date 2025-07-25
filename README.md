# 🔥 Iran Firewall Manager  
## [برای مشاهده به زبان فارسی کلیک کنید](README.fa.md)

An **interactive and secure Bash script** to harden Iranian servers by strictly controlling which IPs and ports are allowed — perfect for tunneling setups.

> ✅ Designed for tunnels like **Rathole v2**, **Backhaul**, **Xray**, or private proxy systems


## 🛡️ Key Features

- ❌ Blocks all incoming/outgoing traffic by default  
- 🌍 Allows only specific ports from a **foreign (non-Iranian)** server IP  
- 🔕 Disables ping (ICMP) to prevent scanning  
- 💾 Automatically saves firewall rules via `iptables-persistent`  
- 🔁 Includes a full **reset option** to remove all restrictions  
- 📱 Interactive menu with emoji prompts – no need to edit the script  
- 🔐 Supports **TCP / UDP / Both** rules  
- 🧠 Remembers **last used config** (IP + ports)  
- 🧪 Verifies foreign IP with **Ping test**  
- 📋 Shows currently open ports & allowed IPs  
- ✅ Fully interactive – no manual rule writing needed  

## 🚀 One-Line Install & Run

Use the following command to run the **latest enhanced version** (v2):

```bash
bash <(curl -Ls https://raw.githubusercontent.com/power0matin/Iran-Firewall-Manager/main/firewall-manager-v2.sh)
```

> ✅ Recommended: Includes all new features like UDP support, connection tests, persistent config memory, and port status view.


### 🧪 Legacy Version (Minimal Features)

If you prefer the simpler original version (v1), use:

```bash
bash <(curl -Ls https://raw.githubusercontent.com/power0matin/Iran-Firewall-Manager/main/firewall-manager.sh)
```

> ⚠️ Note: Lacks advanced menu, validation, and extended features.

## 📦 Example Output

```bash
[*] Installing iptables-persistent...
[*] Flushing existing firewall rules...
[*] Allowing localhost traffic...
[*] Allowing SSH on port 22...
[*] Applying rules for IP 1.2.3.4 and allowed ports...
  - Allowing TCP port 443 from 1.2.3.4
  - Allowing UDP port 443 from 1.2.3.4
[*] Setting default policy to DROP...
[*] Disabling ICMP echo (ping)...
[*] Saving iptables rules...
[✅] Firewall rules applied successfully.
```


## 📋 Menu Options

```
====== Firewall Management Menu ======
1) Apply secure firewall restrictions
2) Reset firewall to open state
3) Show currently open ports
4) Enable secure mode (allow only selected IP and ports)
0) Exit
```


## ⚠️ Warnings

> 🛑 **Be very careful with the IP you enter.**
> If you enter the wrong IP, you may **lose SSH access** to your server. Always test the tunnel before applying firewall rules.

> 🧠 **Need extra ports like DNS/NTP?**
> You can add rules manually before saving:

```bash
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT  # DNS  
iptables -A OUTPUT -p udp --dport 123 -j ACCEPT # NTP  
```

> 📡 UDP is now **supported** via the interactive menu. Choose `TCP`, `UDP`, or `Both` when prompted.


## 🧱 Project Phases (Upcoming)

The project will continue to evolve with new features and enhancements:

### ✅ Phase 1: Current Version (v2)

* ✅ Menu-based TCP/UDP firewall setup
* ✅ IP/Port validation
* ✅ Ping check before applying rules
* ✅ Persistent config saving (`last_config.log`)
* ✅ Open ports viewer

### 🔜 Phase 2: Advanced Usability

* ⏳ Auto-revert in case of wrong config (e.g., 2-minute timeout)
* 🕒 Scheduled rule sets (day/night separation with cron)
* 🔁 Multiple saved profiles (e.g., dev / prod modes)
* 📅 GeoIP blocking support

### 🧠 Phase 3: Smart Automation

* 📊 Real-time traffic stats (iftop, conntrack)
* ⚠️ Intrusion alert system via Telegram bot
* 📥 Centralized logging to external server
* 👥 Multi-admin audit logs
* 📦 Docker/container-aware rules

If you'd like to suggest a feature, open an [Issue](https://github.com/power0matin/Iran-Firewall-Manager/issues)!


## ⚙️ Requirements

* ✅ Ubuntu or Debian-based server
* 🧑‍💻 Root access
* 📦 `iptables` and `iptables-persistent` (auto-installed)


## ✅ Tested On

* Ubuntu 20.04 / 22.04
* Debian 11 / 12
* VPS types: KVM, NAT, OpenVZ (IPv4 only)


## 📄 License

[MIT License](LICENSE) – free for personal, educational, or commercial use.


## ✨ Author

Created with ❤️ by [power0matin](https://github.com/power0matin)
If you find this useful, please ⭐ the repo and share it!
