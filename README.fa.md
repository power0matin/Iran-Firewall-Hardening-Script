# 🔐 اسکریپت مدیریت فایروال امن برای سرورهای داخل ایران  
## [Click to view in English](README.md)

این اسکریپت یک ابزار تعاملی، قدرتمند و کاملاً خودکار برای **ایمن‌سازی سرورهای ایران** است که فقط اجازه‌ی دسترسی به پورت‌های مشخص از یک آی‌پی خارجی را می‌دهد و تمام دیگر ارتباطات (ورودی/خروجی) را مسدود می‌کند.

> ✅ مناسب پروژه‌هایی مثل: **Rathole v2**، **Backhaul**، **Xray** یا تونل‌های شخصی TCP

## ✨ ویژگی‌ها

- بستن کامل ترافیک ورودی و خروجی به‌صورت پیش‌فرض
- اجازه به فقط پورت‌های دلخواه از آی‌پی خارجی مشخص
- غیرفعال کردن پاسخ به پینگ (پنهان ماندن از اسکن)
- ذخیره‌ی قوانین فایروال برای اجرا پس از ریبوت با `iptables-persistent`
- منوی کاملاً تعاملی (بدون نیاز به ویرایش دستی اسکریپت)
- امکان بازگردانی کامل تنظیمات فایروال

## 🚀 اجرای سریع با یک خط

فقط کافیست این دستور را اجرا کنید:

```bash
bash <(curl -Ls https://raw.githubusercontent.com/power0matin/Iran-Firewall-Manager/main/firewall-manager.sh)
```

پس از اجرا، اسکریپت از شما می‌پرسد:

* آی‌پی سرور خارجی (مبدأ مجاز)
* لیست پورت‌هایی که می‌خواهید اجازه داده شوند (با کاما جدا کنید)

و سپس به‌صورت خودکار همه چیز را انجام می‌دهد.

## ⚙️ پیش‌نیازها

* سیستم عامل Ubuntu یا Debian
* دسترسی روت (`root`)
* ابزارهای `iptables` و `iptables-persistent` (در زمان اجرا نصب می‌شوند)

## 📋 منوی اسکریپت

```
====== Firewall Management Menu ======
1) Apply restrictions (enter allowed IP and ports)
2) Reset firewall to open state
0) Exit
```

## 🔄 بازگردانی کامل فایروال

با انتخاب گزینه‌ی ۲ از منو، همه‌چیز به حالت پیش‌فرض بازمی‌گردد:

* حذف تمام قوانین فایروال (flush)
* باز کردن تمام ورودی/خروجی‌ها (ACCEPT)
* فعال‌سازی مجدد پاسخ به پینگ
* حذف فایل‌های ذخیره‌شده فایروال
* حذف پکیج `iptables-persistent` (در صورت نیاز)

## 🧪 خروجی نمونه

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

## ⚠️ هشدارهای مهم

> 🛑 اگر آی‌پی اشتباهی وارد کنید یا پورت اشتباه بدهید، ممکن است **دسترسی SSH شما به سرور قطع شود.**

> 🧪 قبل از اعمال نهایی محدودیت‌ها، تونل را از سمت سرور خارجی تست کنید.

> 🧠 اگر نیاز به DNS یا NTP دارید، باید دستی پورت‌های `53` (DNS) و `123` (NTP) را در خروجی باز کنید:

```bash
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -A OUTPUT -p udp --dport 123 -j ACCEPT
```

> 📡 در حال حاضر فقط پورت‌های TCP باز می‌شوند. برای UDP باید قوانین جدید اضافه کنید.

## ✅ تست شده روی

* Ubuntu 20.04 / 22.04
* Debian 11 / 12
* سرورهای KVM و NAT-VPS
* مناسب برای استفاده در تولید (Production)

## 📄 مجوز استفاده

منتشر شده تحت [لایسنس MIT](LICENSE)
استفاده از آن برای پروژه‌های شخصی، آموزشی یا تجاری **کاملاً آزاد است**

## 👤 سازنده

ساخته شده با ❤️ توسط [power0matin](https://github.com/power0matin)
اگر این ابزار برایتان مفید بود، لطفاً آن را ⭐ کرده و با دیگران به اشتراک بگذارید.
