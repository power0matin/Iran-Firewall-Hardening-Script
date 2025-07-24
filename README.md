# 🔥 Iran Firewall Manager
## [برای مشاهده به زبان فارسی کلیک کنید](README.fa.md)

A **powerful interactive Bash script** to secure Iranian servers by strictly controlling allowed connections and ports.

> ✅ Designed for use cases involving tunnels like **Rathole v2**, **Backhaul**, **Xray**, or **personal tunneling projects**


## 🛡️ What This Script Does

- 🔐 Blocks **all inbound/outbound** traffic by default
- 🎯 Allows access to **specific ports from a foreign (non-Iranian) IP**
- 🚫 Disables **ICMP ping responses**
- 💾 Saves firewall rules with `iptables-persistent` to survive reboots
- 📥 Provides a **reset option** to fully undo all changes


## 📦 Features

- Interactive menu (no need to modify the script manually)
- Simple, clean CLI interface with emoji-enhanced prompts
- Supports **multiple ports**, entered as a comma-separated list
- Disables `ping` (optional, auto-enabled)
- Compatible with system startup using `iptables-persistent`
- Lightweight and safe for production use


## ⚙️ Requirements

- ✅ Debian or Ubuntu (root access required)
- ✅ `iptables` and `iptables-persistent` (installed automatically)


## 🚀 How to Use

### Step 1 – Download and Run

```bash
wget https://raw.githubusercontent.com/power0matin/Iran-Firewall-Hardening-Script/main/firewall-manager.sh
chmod +x firewall-manager.sh
sudo ./firewall-manager.sh
````


## 📋 What You'll Be Asked

The script will ask:

1. The **foreign server IP address** (e.g., your external VPS)
2. The list of **allowed ports** (e.g., `443,8443,50000`)

Then it will:

* Apply iptables rules
* Save them
* Disable ping
* Set default DROP policy on all chains


## 🔄 Reset Firewall to Open State

You can also **reset** everything via menu option 2:

* Flush all iptables rules (all chains/tables)
* Set all default policies to `ACCEPT`
* Enable ICMP (ping)
* Delete `iptables-persistent` rules file
* Optionally remove `iptables-persistent` package


## 📷 Sample Output

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

> 🛑 **Incorrect IP = Locked out!**
> Make absolutely sure the IP address you enter is your **external trusted server** (not your current local IP). Test tunnel first.

> 🟡 **Need DNS/NTP?**
> If your service requires DNS or time syncing, you should **manually add OUTPUT rules for**:

```bash
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT  # DNS
iptables -A OUTPUT -p udp --dport 123 -j ACCEPT # NTP
```

> 🧠 **UDP Support**
> Currently the script only opens **TCP ports**. You can edit and duplicate the port rules with `-p udp` if your service needs it.


## 🧪 Tested On

* Ubuntu 22.04 / 20.04
* Debian 11 / 12
* KVM VPS instances inside Iran
* OpenVZ and NAT-VPS scenarios


## 📝 License

[MIT License](LICENSE) – free for personal, commercial, or open-source projects.


## ✨ Credits

Created by [power0matin](https://github.com/power0matin)
If you like this, please ⭐ the repo and share it with your network!
