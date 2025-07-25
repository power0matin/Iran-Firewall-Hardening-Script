# 🔥 Iran Firewall Manager  
## [🇮🇷 مشاهده نسخه فارسی](README.fa.md)

An **interactive and secure Bash script** to harden Iranian servers by strictly controlling which IPs and ports are allowed — ideal for tunneling setups.

> ✅ Tailored for tunnels like **Rathole v2**, **Backhaul**, **Xray**, or private proxy systems.


## 🛡️ Key Features

- ❌ Block all traffic (inbound & outbound) by default  
- 🌍 Allow only specific ports from a **foreign (non-Iranian)** server IP  
- 🔕 Disable ICMP (ping) to avoid discovery  
- 💾 Auto-save rules via `iptables-persistent`  
- 🔁 One-click **reset** to default open state  
- 📱 Interactive emoji-powered menu – no editing needed  
- 🔐 TCP / UDP / Both rule support  
- 🧠 Remembers last used IP & ports  
- 🧪 Ping test to verify foreign IP reachability  
- 📋 View open ports and allowed IPs  
- ✅ All interactive – no manual iptables usage required


## 🚀 One-Line Install & Run

Run the **latest enhanced version (v2)** with all features:

```bash
bash <(curl -Ls https://raw.githubusercontent.com/power0matin/Iran-Firewall-Manager/main/firewall-manager-v2.sh)
```

> ✅ **Recommended**: Includes full menu, UDP support, persistent config, and port visibility.


### 🧪 Legacy Version (Minimal Features)

For the original minimal script:

```bash
bash <(curl -Ls https://raw.githubusercontent.com/power0matin/Iran-Firewall-Manager/main/firewall-manager.sh)
```

> ⚠️ Note: No menu, memory, or advanced options.


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

> 🛑 **Double-check the IP** before applying rules.
> A wrong IP may **lock you out via SSH**. Test your tunnel before activating firewall.

> 🧠 **Need DNS/NTP or other system ports?**
> Add them manually like below before saving:

```bash
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT  # DNS  
iptables -A OUTPUT -p udp --dport 123 -j ACCEPT # NTP  
```

> 📡 UDP is now **fully supported** in interactive mode. Choose `TCP`, `UDP`, or `Both`.


## 🧱 Project Roadmap

| Phase          | Status      | 🔧 Planned Features                                                         | ✅ Details                                                     |
| -------------- | ----------- | --------------------------------------------------------------------------- | ------------------------------------------------------------- |
| 🟢 **Phase 1** | ✅ Complete  | 🔒 Basic TCP rules<br>🌐 IP allowlist<br>🚫 Default deny                    | Base implementation, save support, basic menu                 |
| 🟡 **Phase 2** | 🔛 Current  | 📱 Menu rework<br>📦 UDP support<br>🧠 Config memory<br>🖥️ Port visibility | Full rework with usability in mind                            |
| 🟠 **Phase 3** | 🔜 Soon     | ⏱️ Auto-revert fail-safe<br>🧪 Config profiles<br>🌗 Day/Night modes        | Prevent lockout, switch between profiles, time-based policies |
| 🔵 **Phase 4** | ⏳ Planned   | 🌍 GeoIP blocking<br>📅 Cron apply/reset<br>💬 Language menu (EN/FA)        | Auto-rules by schedule and region, multilingual               |
| 🟣 **Phase 5** | 🧠 Advanced | 📊 Traffic monitor<br>🚨 Telegram alerts<br>📥 External logging             | Monitor usage, notify intrusions, log centralization          |
| 🟤 **Phase 6** | 🧪 Future   | 🐳 Docker-aware firewall<br>🔗 API interface<br>👥 Multi-admin logs/audits  | Integration with containers and dashboards                    |

> 🔧 **Current Phase:** `Phase 2` – Usability, UDP support, and config memory
> 💡 Want a feature? [Open an Issue](https://github.com/power0matin/Iran-Firewall-Manager/issues)


## ⚙️ Requirements

* ✅ Ubuntu or Debian-based system
* 🧑‍💻 Root privileges
* 📦 `iptables`, `iptables-persistent` (auto-installed)


## ✅ Tested On

* Ubuntu 20.04 / 22.04
* Debian 11 / 12
* VPS: KVM, NAT, OpenVZ (IPv4 only)


## 📄 License

[MIT License](LICENSE) – free for personal and commercial use.


## ✨ Author

Built with ❤️ by [power0matin](https://github.com/power0matin)
If you found it useful, please ⭐ the repo and share it 🙌
