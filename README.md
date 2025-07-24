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


## 🚀 One-Line Install & Run

Use this single command to run the script directly:

```bash
bash <(curl -Ls https://raw.githubusercontent.com/power0matin/Iran-Firewall-Manager/main/firewall-manager.sh)
````

You’ll be guided through:

* Entering your foreign server IP
* Defining which ports to allow
* Applying or resetting firewall rules


## ⚙️ Requirements

* ✅ Ubuntu or Debian-based system
* 🧑‍💻 Root access (the script checks and enforces it)
* 🧩 `iptables` and `iptables-persistent` (installed automatically)


## 📋 Menu Options

```
====== Firewall Management Menu ======
1) Apply restrictions (enter allowed IP and ports)
2) Reset firewall to open state
0) Exit
```


## 🔄 Resetting the Firewall

Use option `2` in the menu to fully undo all changes:

* Flush all `iptables` rules
* Set all chains to `ACCEPT`
* Enable ping again
* Remove persistent rule files
* Uninstall `iptables-persistent`


## 📦 Example Output

```bash
[*] Installing iptables-persistent...
[*] Flushing existing firewall rules...
[*] Allowing localhost traffic...
[*] Allowing SSH on port 22...
[*] Applying rules for IP 1.2.3.4 and allowed ports...
  - Allowing port 443 from 1.2.3.4
  - Allowing port 8443 from 1.2.3.4
[*] Setting default policy to DROP...
[*] Disabling ICMP echo (ping)...
[*] Saving iptables rules...
[✅] Firewall rules applied successfully.
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

> 📡 **UDP support** is not included by default. To allow UDP ports, you must add `-p udp` versions of your allowed rules manually.


## ✅ Tested On

* ✅ Ubuntu 20.04 / 22.04
* ✅ Debian 11 / 12
* ✅ KVM, OpenVZ, NAT VPS (IPv4 only)


## 📄 License

MIT License – free for personal, educational, or commercial use.


## ✨ Author

Created with ❤️ by [power0matin](https://github.com/power0matin)
If you find this useful, please ⭐ the repo and share it!
