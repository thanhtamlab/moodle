FROM php:8.1-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libxml2-dev \
    libzip-dev \
    unzip \
    git \
    libicu-dev \
    && rm -rf /var/lib/apt/lists/*

# Configure GD with proper flags
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd intl mysqli zip soap xmlrpc

# Enable Apache rewrite
RUN a2enmod rewrite
