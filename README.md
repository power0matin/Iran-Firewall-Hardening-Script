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


### 🧱 Project Roadmap

| Phase          | Status          | 🔧 Planned Features                                                                     | ✅ Details                                                               |
| -------------- | --------------- | --------------------------------------------------------------------------------------- | ----------------------------------------------------------------------- |
| 🟢 **Phase 1** | ✅ Completed     | 🔒 Basic TCP rules<br>🌐 IP whitelisting<br>🚫 Block all by default                     | Foundation built with iptables, persistent rules, simple menu           |
| 🟡 **Phase 2** | 🔛 Current      | 📱 Full menu rework<br>📦 UDP support<br>🧠 Remember last config<br>🖥️ Show open ports | Interactive secure mode, config file, ICMP off, better UX               |
| 🟠 **Phase 3** | 🔜 Upcoming     | ⏱️ Auto-revert (timeout fail-safe)<br>🧪 Profile system<br>🌓 Day/Night schedule        | Prevent lockout, allow mode switching (dev/prod), time-based rules      |
| 🔵 **Phase 4** | ⏳ Planned       | 🌍 GeoIP blocking<br>📅 Cron-based apply/reset\<br💬 Menu language selector (EN/FA)     | Prevent certain countries, automate daily flows, multilingual support   |
| 🟣 **Phase 5** | 🧠 Advanced     | 📊 Traffic monitor (iftop/netstat)<br>🚨 Telegram alerts<br>📥 External logs            | Real-time usage display, intrusion alerts, log centralization           |
| 🟤 **Phase 6** | 🧪 Experimental | 🐳 Docker-aware firewall<br>🔗 API interface<br>👥 Multi-admin log/audit                | Future: Docker integration, admin access logs, remote config management |


🔧 **Current Phase:** `Phase 2` – Focusing on interactive usability, persistent memory, and UDP flexibility.
📅 **Next Step:** Begin implementing auto-revert & config profiles in Phase 3.

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
