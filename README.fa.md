# 🔐 اسکریپت فایروال امن برای سرورهای داخل ایران
## [Click to view in English](README.md)

این اسکریپت یک ابزار ساده و خودکار برای **افزایش امنیت سرورهای داخل ایران** است که با اجرای آن، فقط یک سرور خارجی مشخص (مثلاً آلمان) می‌تواند به سرور ایران دسترسی داشته باشد و همه‌ی دسترسی‌های دیگر (از جمله کاربران داخلی ایران) **مسدود می‌شوند**.

این اسکریپت مناسب پروژه‌هایی مثل:

- ✅ **Rathole v2**
- ✅ **Backhaul**
- ✅ **Xray / V2ray**
- ✅ یا هر تونل TCP دیگر

## ✨ ویژگی‌ها

- امنیت بالا با بستن کامل ورودی و خروجی‌ها
- پشتیبانی از تعداد دلخواه پورت (۱ تا بی‌نهایت)
- امکان تعریف فقط یک IP مجاز خارجی
- غیرفعال کردن پاسخ به پینگ (مخفی ماندن)
- ذخیره خودکار قوانین فایروال برای بعد از ریبوت

## ⚙️ پیش‌نیازها

- سرور Ubuntu یا Debian
- دسترسی `root`
- پکیج `iptables` و `iptables-persistent` (در حین اجرا نصب می‌شود)

## 🚀 نحوه استفاده

### 1. دریافت اسکریپت

```bash
wget https://raw.githubusercontent.com/power0matin/Iran-Firewall-Hardening-Script/main/universal-firewall.sh
chmod +x universal-firewall.sh
````

### 2. ویرایش تنظیمات اسکریپت

اسکریپت را با ویرایشگر دلخواه باز کنید:

```bash
nano universal-firewall.sh
```

در ابتدای فایل، این مقادیر را به دلخواه تغییر دهید:

```bash
foreign_server_ip="1.2.3.4"       # آی‌پی سرور خارجی
allowed_ports=(2053 10000 10001)  # لیست پورت‌هایی که سرور خارجی اجازه دسترسی دارد
```

هر تعداد پورت می‌توانید اضافه یا حذف کنید.

### 3. اجرای اسکریپت

```bash
sudo ./universal-firewall.sh
```


## 🔄 بازگردانی تنظیمات فایروال (اسکریپت ریست)

اگر خواستید تمام تغییرات فایروال را حذف کنید و سرور را به حالت کاملاً باز و بدون محدودیت برگردانید، از اسکریپت ریست استفاده کنید:

1. دریافت یا ایجاد فایل `reset-firewall.sh`:

```bash
wget https://raw.githubusercontent.com/power0matin/Iran-Firewall-Hardening-Script/main/reset-firewall.sh
chmod +x reset-firewall.sh
```

2. اجرای اسکریپت:

```bash
sudo ./reset-firewall.sh
```

این اسکریپت:

* تمام قوانین `iptables` را حذف (flush) می‌کند
* سیاست‌های پیش‌فرض را روی ACCEPT (اجازه کامل) تنظیم می‌کند
* پاسخ به پینگ (ICMP) را فعال می‌کند
* قوانین ذخیره‌شده در `iptables-persistent` را پاک می‌کند
* در صورت نیاز، پکیج `iptables-persistent` را حذف می‌کند تا قوانین قدیمی دوباره بارگذاری نشوند


## 🧪 خروجی نمونه

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


## ⚠️ هشدار مهم

* اگر `foreign_server_ip` را اشتباه وارد کنید یا پورت‌ها را غلط تنظیم کنید، **ممکن است دسترسی SSH به سرور قطع شود.**
* قبل از اجرای نهایی، اتصال تونل را از سرور خارجی تست کنید.
* اگر نیاز به دسترسی DNS یا NTP دارید، باید پورت‌های `53` و `123` را در خروجی باز بگذارید.
* **اسکریپت ریست، تمام محدودیت‌های فایروال را حذف می‌کند و سرور را کاملاً باز می‌کند** — فقط در صورت نیاز از آن استفاده کنید.


## 📄 مجوز استفاده

این پروژه تحت لایسنس MIT منتشر شده و استفاده از آن در هر نوع پروژه (شخصی یا تجاری) **آزاد است**.

## 👤 سازنده

ساخته شده با ❤️ توسط [power0matin](https://github.com/power0matin) برای امنیت پروژه‌های تونلی در سرورهای داخل ایران.
