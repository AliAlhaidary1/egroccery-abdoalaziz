# 🐳 بدء سريع مع Docker

## التشغيل السريع (3 خطوات)

```bash
# 1. تشغيل جميع الخدمات
docker-compose -f docker-compose.dev.yml up -d

# 2. إعداد Laravel (في terminal جديد)
docker-compose -f docker-compose.dev.yml exec app bash -c "cd core && php artisan key:generate && php artisan storage:link"

# 3. تشغيل Migrations
docker-compose -f docker-compose.dev.yml exec app bash -c "cd core && php artisan migrate"
```

## الوصول للمشروع

- 🌐 **الموقع:** http://localhost:8000
- ⚡ **Vite:** http://localhost:5173

## أوامر مفيدة

```bash
# عرض السجلات
docker-compose -f docker-compose.dev.yml logs -f

# إيقاف الخدمات
docker-compose -f docker-compose.dev.yml down

# إعادة تشغيل
docker-compose -f docker-compose.dev.yml restart
```

## 📖 للمزيد من التفاصيل

راجع ملف `دليل_Docker.md` للتعليمات الكاملة.

