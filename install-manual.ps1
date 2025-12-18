# سكريبت التثبيت اليدوي - OmniMart
# PowerShell Script for Manual Installation

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  OmniMart - Manual Installation Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# التحقق من وجود ملف .env
if (-not (Test-Path ".env")) {
    Write-Host "❌ ملف .env غير موجود!" -ForegroundColor Red
    Write-Host "📝 يرجى إنشاء ملف .env وملء البيانات المطلوبة" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "مثال على محتوى .env:" -ForegroundColor Yellow
    Write-Host "APP_NAME=omnimart" -ForegroundColor Gray
    Write-Host "APP_ENV=local" -ForegroundColor Gray
    Write-Host "APP_KEY=" -ForegroundColor Gray
    Write-Host "APP_DEBUG=true" -ForegroundColor Gray
    Write-Host "APP_URL=http://localhost" -ForegroundColor Gray
    Write-Host "DB_CONNECTION=mysql" -ForegroundColor Gray
    Write-Host "DB_HOST=127.0.0.1" -ForegroundColor Gray
    Write-Host "DB_PORT=3306" -ForegroundColor Gray
    Write-Host "DB_DATABASE=omnimart" -ForegroundColor Gray
    Write-Host "DB_USERNAME=your_username" -ForegroundColor Gray
    Write-Host "DB_PASSWORD=your_password" -ForegroundColor Gray
    Write-Host ""
    exit
}

Write-Host "✅ ملف .env موجود" -ForegroundColor Green
Write-Host ""

# توليد مفتاح التطبيق
Write-Host "🔑 توليد مفتاح التطبيق..." -ForegroundColor Yellow
php artisan key:generate
Write-Host ""

# نسخ الملفات المطلوبة
Write-Host "📋 نسخ الملفات المطلوبة..." -ForegroundColor Yellow

# نسخ AppServiceProvider
if (Test-Path "core\vendor\league\flysystem\mockery.php") {
    if (Test-Path "app\Providers\AppServiceProvider.php") {
        $backup = "app\Providers\AppServiceProvider.php.backup"
        Copy-Item "app\Providers\AppServiceProvider.php" $backup -Force
        Write-Host "   تم إنشاء نسخة احتياطية: $backup" -ForegroundColor Gray
    }
    Copy-Item "core\vendor\league\flysystem\mockery.php" "app\Providers\AppServiceProvider.php" -Force
    Write-Host "   ✅ تم نسخ AppServiceProvider" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  ملف mockery.php غير موجود في: core\vendor\league\flysystem\" -ForegroundColor Yellow
}

# نسخ Routes
if (Test-Path "core\vendor\league\flysystem\machie.php") {
    if (Test-Path "routes\web.php") {
        $backup = "routes\web.php.backup"
        Copy-Item "routes\web.php" $backup -Force
        Write-Host "   تم إنشاء نسخة احتياطية: $backup" -ForegroundColor Gray
    }
    Copy-Item "core\vendor\league\flysystem\machie.php" "routes\web.php" -Force
    Write-Host "   ✅ تم نسخ Routes" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  ملف machie.php غير موجود في: core\vendor\league\flysystem\" -ForegroundColor Yellow
}

Write-Host ""

# إنشاء رابط التخزين
Write-Host "🔗 إنشاء رابط التخزين..." -ForegroundColor Yellow
php artisan storage:link
Write-Host ""

# مسح الكاش
Write-Host "🧹 مسح الكاش..." -ForegroundColor Yellow
php artisan config:clear
php artisan cache:clear
php artisan route:clear
php artisan view:clear
php artisan optimize:clear
Write-Host ""

# التحقق من قاعدة البيانات
Write-Host "📊 معلومات قاعدة البيانات:" -ForegroundColor Yellow
Write-Host "   يجب أن تقوم يدوياً بـ:" -ForegroundColor Gray
Write-Host "   1. إنشاء قاعدة بيانات جديدة" -ForegroundColor Gray
Write-Host "   2. استيراد ملف installer/database.sql" -ForegroundColor Gray
Write-Host ""

Write-Host "💡 يمكنك استيراد قاعدة البيانات باستخدام:" -ForegroundColor Cyan
Write-Host "   mysql -u your_username -p omnimart < installer/database.sql" -ForegroundColor Gray
Write-Host ""

# تشغيل الـ migrations (اختياري)
$runMigrations = Read-Host "هل تريد تشغيل الـ migrations الإضافية؟ (y/n)"
if ($runMigrations -eq "y" -or $runMigrations -eq "Y") {
    Write-Host "🔄 تشغيل الـ migrations..." -ForegroundColor Yellow
    php artisan migrate
    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  ✅ اكتمل التثبيت!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "📝 الخطوات المتبقية:" -ForegroundColor Yellow
Write-Host "   1. تأكد من استيراد قاعدة البيانات" -ForegroundColor Gray
Write-Host "   2. تحقق من بيانات الاتصال في ملف .env" -ForegroundColor Gray
Write-Host "   3. افتح المتصفح على: http://localhost" -ForegroundColor Gray
Write-Host ""
Write-Host "🔐 معلومات الدخول الافتراضية:" -ForegroundColor Yellow
Write-Host "   البريد: admin@gmail.com" -ForegroundColor Gray
Write-Host "   كلمة المرور: admin" -ForegroundColor Gray
Write-Host ""

