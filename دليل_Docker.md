# دليل تشغيل مشروع OmniMart باستخدام Docker

## 📋 المتطلبات

- ✅ **Docker Desktop** مثبت ومشغل
- ✅ **Docker Compose** (يأتي مع Docker Desktop)

---

## 🚀 التشغيل السريع

### الطريقة 1: للتطوير (Development)

```bash
# تشغيل جميع الخدمات
docker-compose -f docker-compose.dev.yml up -d

# عرض السجلات
docker-compose -f docker-compose.dev.yml logs -f

# إيقاف الخدمات
docker-compose -f docker-compose.dev.yml down
```

### الطريقة 2: للإنتاج (Production)

```bash
# بناء الصور
docker-compose build

# تشغيل الخدمات
docker-compose up -d

# عرض السجلات
docker-compose logs -f

# إيقاف الخدمات
docker-compose down
```

---

## 📝 خطوات الإعداد الكاملة

### 1. إنشاء ملف `.env`

أنشئ ملف `.env` في المجلد الرئيسي (أو في مجلد `core` إذا كان المشروع يستخدمه):

```env
APP_NAME=OmniMart
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_URL=http://localhost:8000

DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_DATABASE=omnimart
DB_USERNAME=omnimart_user
DB_PASSWORD=omnimart_password

BROADCAST_DRIVER=log
CACHE_DRIVER=file
FILESYSTEM_DISK=local
QUEUE_CONNECTION=sync
SESSION_DRIVER=file
SESSION_LIFETIME=120
```

### 2. تشغيل Docker Compose

```bash
# للتطوير
docker-compose -f docker-compose.dev.yml up -d

# أو للإنتاج
docker-compose up -d
```

### 3. تثبيت المكتبات وإنشاء المفتاح

```bash
# الدخول إلى container التطبيق
docker-compose exec app bash

# أو للتطوير
docker-compose -f docker-compose.dev.yml exec app bash

# داخل الـ container:
composer install
cd core && npm install && npm run build
php artisan key:generate
php artisan storage:link
```

### 4. تشغيل Migrations

```bash
# الدخول إلى container التطبيق
docker-compose exec app bash

# تشغيل Migrations
php artisan migrate

# أو مع Seeders
php artisan migrate --seed
```

---

## 🌐 الوصول للمشروع

بعد تشغيل Docker Compose:

- **الموقع الرئيسي:** http://localhost:8000
- **Vite Dev Server:** http://localhost:5173
- **قاعدة البيانات:** localhost:3306

---

## 🔧 الأوامر المفيدة

### عرض حالة الخدمات

```bash
docker-compose ps
```

### عرض السجلات

```bash
# جميع الخدمات
docker-compose logs -f

# خدمة محددة
docker-compose logs -f app
docker-compose logs -f db
docker-compose logs -f vite
```

### إعادة تشغيل خدمة

```bash
docker-compose restart app
```

### تنفيذ أوامر Artisan

```bash
docker-compose exec app php artisan migrate
docker-compose exec app php artisan cache:clear
docker-compose exec app php artisan config:clear
```

### تنفيذ أوامر Composer

```bash
docker-compose exec app composer install
docker-compose exec app composer update
```

### الدخول إلى قاعدة البيانات

```bash
docker-compose exec db mysql -u omnimart_user -pomnimart_password omnimart
```

### إيقاف وحذف كل شيء

```bash
# إيقاف الخدمات
docker-compose down

# إيقاف وحذف Volumes (سيحذف قاعدة البيانات!)
docker-compose down -v
```

---

## 🗄️ إعدادات قاعدة البيانات

### معلومات الاتصال الافتراضية:

- **Host:** `db` (داخل Docker network) أو `localhost` (من خارج Docker)
- **Port:** `3306`
- **Database:** `omnimart`
- **Username:** `omnimart_user`
- **Password:** `omnimart_password`
- **Root Password:** `root_password`

### تغيير كلمات المرور:

عدّل ملف `docker-compose.yml` أو `docker-compose.dev.yml`:

```yaml
db:
  environment:
    MYSQL_ROOT_PASSWORD: your_new_root_password
    MYSQL_PASSWORD: your_new_password
```

---

## 🔍 استكشاف الأخطاء

### المشكلة: "Port already in use"

```bash
# غيّر المنفذ في docker-compose.yml
ports:
  - "8001:80"  # بدلاً من 8000:80
```

### المشكلة: "Permission denied"

```bash
# داخل container
docker-compose exec app chmod -R 755 storage bootstrap/cache
docker-compose exec app chown -R www-data:www-data storage bootstrap/cache
```

### المشكلة: "Database connection failed"

1. تأكد من أن خدمة `db` تعمل:
   ```bash
   docker-compose ps
   ```

2. تحقق من السجلات:
   ```bash
   docker-compose logs db
   ```

3. انتظر حتى تصبح قاعدة البيانات جاهزة:
   ```bash
   docker-compose exec db mysqladmin ping -h localhost -u root -proot_password
   ```

### المشكلة: "Vite not working"

1. تحقق من أن خدمة `vite` تعمل:
   ```bash
   docker-compose logs vite
   ```

2. أعد تشغيل الخدمة:
   ```bash
   docker-compose restart vite
   ```

### المشكلة: "Composer install failed"

```bash
# امسح cache وثبت من جديد
docker-compose exec app composer clear-cache
docker-compose exec app composer install
```

---

## 📦 البناء المخصص

### بناء الصور يدوياً

```bash
# بناء صورة التطبيق
docker build -t omnimart-app .

# بناء مع Docker Compose
docker-compose build
docker-compose build --no-cache  # بدون استخدام cache
```

---

## 🔄 التحديثات

### تحديث الكود

```bash
# سحب التحديثات
git pull

# إعادة بناء الصور
docker-compose build

# إعادة تشغيل الخدمات
docker-compose restart
```

### تحديث المكتبات

```bash
docker-compose exec app composer update
docker-compose exec vite npm update
```

---

## 📝 ملاحظات مهمة

1. **الملفات المحلية:** جميع التغييرات على الملفات المحلية ستظهر مباشرة في الـ containers (بفضل volumes)

2. **قاعدة البيانات:** البيانات محفوظة في Docker volume، لن تُحذف عند إيقاف الـ containers إلا إذا استخدمت `docker-compose down -v`

3. **البيئة:** استخدم `docker-compose.dev.yml` للتطوير و `docker-compose.yml` للإنتاج

4. **الأداء:** في Windows/Mac، قد يكون الأداء أبطأ قليلاً بسبب volumes

---

## ✅ ملخص سريع

```bash
# 1. تشغيل المشروع
docker-compose -f docker-compose.dev.yml up -d

# 2. تثبيت المكتبات
docker-compose exec app composer install
docker-compose exec vite npm install

# 3. إعداد Laravel
docker-compose exec app php artisan key:generate
docker-compose exec app php artisan storage:link
docker-compose exec app php artisan migrate

# 4. افتح المتصفح
# http://localhost:8000
```

---

## 🆘 المساعدة

إذا واجهت مشاكل:
1. تحقق من السجلات: `docker-compose logs -f`
2. تأكد من أن Docker Desktop يعمل
3. تحقق من أن المنافذ غير مستخدمة
4. أعد بناء الصور: `docker-compose build --no-cache`

