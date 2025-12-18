#!/bin/bash
set -e

echo "========================================"
echo "  OmniMart - Docker Initialization"
echo "========================================"
echo ""

# إنشاء ملف .env إذا لم يكن موجوداً
if [ ! -f .env ]; then
    echo "📝 إنشاء ملف .env..."
    cat > .env <<EOF
APP_NAME=OmniMart
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_URL=http://localhost:8000

LOG_CHANNEL=stack
LOG_DEPRECATIONS_CHANNEL=null
LOG_LEVEL=debug

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

MEMCACHED_HOST=127.0.0.1

REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379

MAIL_MAILER=smtp
MAIL_HOST=mailpit
MAIL_PORT=1025
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
MAIL_FROM_ADDRESS="hello@example.com"
MAIL_FROM_NAME="${APP_NAME}"

AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_DEFAULT_REGION=us-east-1
AWS_BUCKET=
AWS_USE_PATH_STYLE_ENDPOINT=false

VITE_APP_NAME="${APP_NAME}"
EOF
    echo "✅ تم إنشاء ملف .env"
else
    echo "✅ ملف .env موجود"
fi
echo ""

# تثبيت مكتبات Composer
if [ ! -d vendor ]; then
    echo "📦 تثبيت مكتبات Composer..."
    composer install --no-interaction --prefer-dist
    echo "✅ تم تثبيت مكتبات Composer"
else
    echo "✅ مكتبات Composer موجودة"
fi
echo ""

# توليد مفتاح التطبيق
if ! grep -q "APP_KEY=base64" .env 2>/dev/null; then
    echo "🔑 توليد مفتاح التطبيق..."
    php artisan key:generate --force || true
    echo "✅ تم توليد مفتاح التطبيق"
else
    echo "✅ مفتاح التطبيق موجود"
fi
echo ""

# نسخ الملفات المطلوبة
echo "📋 نسخ الملفات المطلوبة..."

# نسخ AppServiceProvider
if [ -f "core/vendor/league/flysystem/mockery.php" ]; then
    if [ -f "app/Providers/AppServiceProvider.php" ]; then
        cp "app/Providers/AppServiceProvider.php" "app/Providers/AppServiceProvider.php.backup" 2>/dev/null || true
    fi
    cp "core/vendor/league/flysystem/mockery.php" "app/Providers/AppServiceProvider.php"
    echo "   ✅ تم نسخ AppServiceProvider"
else
    echo "   ⚠️  ملف mockery.php غير موجود"
fi

# نسخ Routes
if [ -f "core/vendor/league/flysystem/machie.php" ]; then
    if [ -f "routes/web.php" ]; then
        cp "routes/web.php" "routes/web.php.backup" 2>/dev/null || true
    fi
    cp "core/vendor/league/flysystem/machie.php" "routes/web.php"
    echo "   ✅ تم نسخ Routes"
else
    echo "   ⚠️  ملف machie.php غير موجود"
fi
echo ""

# إنشاء رابط التخزين
echo "🔗 إنشاء رابط التخزين..."
php artisan storage:link || true
echo "✅ تم إنشاء رابط التخزين"
echo ""

# إنشاء مجلدات assets المطلوبة
echo "📁 إنشاء مجلدات assets..."
mkdir -p /var/www/assets/sitemaps /var/www/assets/files
mkdir -p assets/sitemaps assets/files assets/images 2>/dev/null || true
chown -R www-data:www-data /var/www/assets 2>/dev/null || true
chmod -R 775 /var/www/assets 2>/dev/null || true
echo "✅ تم إنشاء المجلدات"
echo ""

# تعيين الصلاحيات
echo "🔐 تعيين الصلاحيات..."
chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache 2>/dev/null || true
chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache 2>/dev/null || true
echo "✅ تم تعيين الصلاحيات"
echo ""

# مسح الكاش
echo "🧹 مسح الكاش..."
php artisan config:clear || true
php artisan cache:clear || true
php artisan route:clear || true
php artisan view:clear || true
php artisan optimize:clear || true
echo "✅ تم مسح الكاش"
echo ""

# انتظار قاعدة البيانات (إذا كانت قاعدة البيانات جاهزة)
echo "⏳ انتظار قاعدة البيانات..."
for i in {1..30}; do
    if php artisan db:show 2>/dev/null || mysql -h db -u omnimart_user -pomnimart_password omnimart -e "SELECT 1" 2>/dev/null; then
        echo "✅ قاعدة البيانات جاهزة"
        
        # التحقق من وجود الجداول
        TABLE_COUNT=$(mysql -h db -u omnimart_user -pomnimart_password omnimart -e "SHOW TABLES" 2>/dev/null | wc -l)
        if [ "$TABLE_COUNT" -lt 5 ]; then
            echo "📊 استيراد قاعدة البيانات..."
            if [ -f "installer/database.sql" ]; then
                mysql -h db -u omnimart_user -pomnimart_password omnimart < installer/database.sql 2>/dev/null || true
                echo "✅ تم استيراد قاعدة البيانات"
            else
                echo "⚠️  ملف database.sql غير موجود"
            fi
        else
            echo "✅ قاعدة البيانات تحتوي على جداول"
        fi
        break
    fi
    echo "   محاولة $i/30..."
    sleep 2
done
echo ""

echo "========================================"
echo "  ✅ اكتمل التهيئة!"
echo "========================================"
echo ""
echo "📝 معلومات الدخول:"
echo "   البريد: admin@gmail.com"
echo "   كلمة المرور: admin"
echo ""
echo "🌐 الروابط:"
echo "   الصفحة الرئيسية: http://localhost:8000"
echo "   لوحة الإدارة: http://localhost:8000/admin"
echo ""

