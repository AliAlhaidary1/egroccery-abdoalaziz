#!/bin/bash

# سكريبت التثبيت اليدوي - OmniMart
# Bash Script for Manual Installation

echo "========================================"
echo "  OmniMart - Manual Installation Script"
echo "========================================"
echo ""

# التحقق من وجود ملف .env
if [ ! -f ".env" ]; then
    echo "❌ ملف .env غير موجود!"
    echo "📝 يرجى إنشاء ملف .env وملء البيانات المطلوبة"
    echo ""
    echo "مثال على محتوى .env:"
    echo "APP_NAME=omnimart"
    echo "APP_ENV=local"
    echo "APP_KEY="
    echo "APP_DEBUG=true"
    echo "APP_URL=http://localhost"
    echo "DB_CONNECTION=mysql"
    echo "DB_HOST=127.0.0.1"
    echo "DB_PORT=3306"
    echo "DB_DATABASE=omnimart"
    echo "DB_USERNAME=your_username"
    echo "DB_PASSWORD=your_password"
    echo ""
    exit 1
fi

echo "✅ ملف .env موجود"
echo ""

# توليد مفتاح التطبيق
echo "🔑 توليد مفتاح التطبيق..."
php artisan key:generate
echo ""

# نسخ الملفات المطلوبة
echo "📋 نسخ الملفات المطلوبة..."

# نسخ AppServiceProvider
if [ -f "core/vendor/league/flysystem/mockery.php" ]; then
    if [ -f "app/Providers/AppServiceProvider.php" ]; then
        cp "app/Providers/AppServiceProvider.php" "app/Providers/AppServiceProvider.php.backup"
        echo "   تم إنشاء نسخة احتياطية: app/Providers/AppServiceProvider.php.backup"
    fi
    cp "core/vendor/league/flysystem/mockery.php" "app/Providers/AppServiceProvider.php"
    echo "   ✅ تم نسخ AppServiceProvider"
else
    echo "   ⚠️  ملف mockery.php غير موجود في: core/vendor/league/flysystem/"
fi

# نسخ Routes
if [ -f "core/vendor/league/flysystem/machie.php" ]; then
    if [ -f "routes/web.php" ]; then
        cp "routes/web.php" "routes/web.php.backup"
        echo "   تم إنشاء نسخة احتياطية: routes/web.php.backup"
    fi
    cp "core/vendor/league/flysystem/machie.php" "routes/web.php"
    echo "   ✅ تم نسخ Routes"
else
    echo "   ⚠️  ملف machie.php غير موجود في: core/vendor/league/flysystem/"
fi

echo ""

# إنشاء رابط التخزين
echo "🔗 إنشاء رابط التخزين..."
php artisan storage:link
echo ""

# ضبط الصلاحيات (Linux/Mac فقط)
if [[ "$OSTYPE" != "msys" && "$OSTYPE" != "win32" ]]; then
    echo "🔐 ضبط صلاحيات المجلدات..."
    chmod -R 775 storage bootstrap/cache
    echo "   ✅ تم ضبط الصلاحيات"
    echo ""
fi

# مسح الكاش
echo "🧹 مسح الكاش..."
php artisan config:clear
php artisan cache:clear
php artisan route:clear
php artisan view:clear
php artisan optimize:clear
echo ""

# التحقق من قاعدة البيانات
echo "📊 معلومات قاعدة البيانات:"
echo "   يجب أن تقوم يدوياً بـ:"
echo "   1. إنشاء قاعدة بيانات جديدة"
echo "   2. استيراد ملف installer/database.sql"
echo ""

echo "💡 يمكنك استيراد قاعدة البيانات باستخدام:"
echo "   mysql -u your_username -p omnimart < installer/database.sql"
echo ""

# تشغيل الـ migrations (اختياري)
read -p "هل تريد تشغيل الـ migrations الإضافية؟ (y/n) " runMigrations
if [ "$runMigrations" = "y" ] || [ "$runMigrations" = "Y" ]; then
    echo "🔄 تشغيل الـ migrations..."
    php artisan migrate
    echo ""
fi

echo "========================================"
echo "  ✅ اكتمل التثبيت!"
echo "========================================"
echo ""
echo "📝 الخطوات المتبقية:"
echo "   1. تأكد من استيراد قاعدة البيانات"
echo "   2. تحقق من بيانات الاتصال في ملف .env"
echo "   3. افتح المتصفح على: http://localhost"
echo ""
echo "🔐 معلومات الدخول الافتراضية:"
echo "   البريد: admin@gmail.com"
echo "   كلمة المرور: admin"
echo ""

