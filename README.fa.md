# 🔥 مدیریت فایروال ایران

## [برای مشاهده به زبان فارسی کلیک کنید](README.fa.md)

یک **اسکریپت امن و تعاملی Bash** برای ایمن‌سازی سرورهای ایرانی با کنترل دقیق روی آی‌پی‌ها و پورت‌های مجاز — مخصوص تنظیمات تونلینگ.

> ✅ طراحی‌شده برای تونل‌هایی مانند **Rathole v2**، **Backhaul**، **Xray** یا سیستم‌های پراکسی شخصی


## 🛡️ ویژگی‌های کلیدی

* ❌ مسدودسازی کامل تمام ترافیک ورودی/خروجی به‌صورت پیش‌فرض
* 🌍 اجازه فقط به پورت‌های خاص از یک **آی‌پی خارجی (غیر ایرانی)**
* 🔕 غیرفعال‌سازی پینگ (ICMP) برای جلوگیری از اسکن
* 💾 ذخیره خودکار قوانین فایروال با استفاده از `iptables-persistent`
* 🔁 امکان بازنشانی کامل (ریست) برای حذف تمام محدودیت‌ها
* 📱 منوی تعاملی با ایموجی – بدون نیاز به ویرایش دستی اسکریپت


## 🚀 اجرای سریع با یک خط

از دستور زیر برای اجرای مستقیم اسکریپت استفاده کنید:

```bash
bash <(curl -Ls https://raw.githubusercontent.com/power0matin/Iran-Firewall-Manager/main/firewall-manager.sh)
```

در این مرحله از شما خواسته می‌شود:

* آی‌پی سرور خارجی را وارد کنید
* لیست پورت‌های مجاز را تعریف کنید
* قوانین را اعمال یا ریست کنید


## ⚙️ پیش‌نیازها

* ✅ سیستم‌عامل Ubuntu یا Debian
* 🧑‍💻 دسترسی به Root
* 🧩 نصب خودکار `iptables` و `iptables-persistent`


## 📋 گزینه‌های منو

```
====== Firewall Management Menu ======
1) Apply restrictions (enter allowed IP and ports)
2) Reset firewall to open state
0) Exit
```


## 🔄 بازنشانی فایروال

با انتخاب گزینه `2` تمام تنظیمات حذف می‌شوند:

* حذف کامل تمام قوانین فایروال
* تغییر سیاست پیش‌فرض به ACCEPT
* فعال‌سازی مجدد پینگ
* حذف فایل‌های ذخیره‌شده
* حذف `iptables-persistent`


## 📦 خروجی نمونه

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


## ⚠️ هشدارها

> 🛑 **در وارد کردن آی‌پی دقت کنید.**
> وارد کردن آی‌پی اشتباه ممکن است باعث **قطع دسترسی SSH** شود. حتماً قبل از اعمال نهایی، تونل را تست کنید.

> 🧠 **نیاز به پورت‌های دیگر دارید؟ (مثل DNS/NTP)**
> می‌توانید قبل از ذخیره، قوانین دستی اضافه کنید:

```bash
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT  # DNS
iptables -A OUTPUT -p udp --dport 123 -j ACCEPT # NTP
```

> 📡 **پشتیبانی از UDP به‌صورت پیش‌فرض فعال نیست.**
> برای مجاز کردن UDP، باید نسخه‌های `-p udp` از قوانین خودتان را دستی اضافه کنید.


## ✅ تست‌شده روی

* ✅ Ubuntu 20.04 / 22.04
* ✅ Debian 11 / 12
* ✅ KVM، OpenVZ، NAT VPS (فقط IPv4)


## 📄 مجوز

[لایسنس MIT](LICENSE) – رایگان برای استفاده شخصی، آموزشی یا تجاری


## ✨ نویسنده

ساخته شده با ❤️ توسط [power0matin](https://github.com/power0matin)
اگر مفید بود لطفاً ⭐ بدهید و با دیگران به اشتراک بگذارید.
