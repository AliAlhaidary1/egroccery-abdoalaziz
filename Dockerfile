# استخدام صورة PHP 8.2 مع Apache
FROM php:8.2-apache

# تثبيت المتطلبات الأساسية
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    unzip \
    nodejs \
    npm \
    netcat-openbsd \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# تثبيت IMAP - تثبيت المكتبات المطلوبة من مستودع bookworm
RUN echo "deb http://deb.debian.org/debian bookworm main" > /etc/apt/sources.list.d/bookworm.list \
    && apt-get update \
    && apt-get install -y --allow-downgrades \
        libc-client-dev/bookworm \
        libkrb5-dev/bookworm \
        libkrb5-3/bookworm \
        libk5crypto3/bookworm \
        libgssapi-krb5-2/bookworm \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install imap \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/bookworm.list

# تثبيت Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# تفعيل mod_rewrite لـ Apache
RUN a2enmod rewrite

# تعيين مجلد العمل
WORKDIR /var/www/html

# تعيين Apache DocumentRoot إلى public
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
RUN sed -ri -e 's!<Directory /var/www/>!<Directory ${APACHE_DOCUMENT_ROOT}>!g' /etc/apache2/apache2.conf
RUN sed -ri -e 's!<Directory /var/www/html>!<Directory ${APACHE_DOCUMENT_ROOT}>!g' /etc/apache2/apache2.conf

# فتح المنفذ 80
EXPOSE 80

# نسخ سكريبت التهيئة
COPY docker-init.sh /var/www/html/
RUN chmod +x /var/www/html/docker-init.sh

CMD ["apache2-foreground"]

