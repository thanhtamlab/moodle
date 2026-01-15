FROM php:8.1-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libzip-dev \
    libxml2-dev \
    libicu-dev \
    unzip \
    git \
    && rm -rf /var/lib/apt/lists/*

# Configure GD
RUN docker-php-ext-configure gd --with-freetype --with-jpeg

# Install PHP extensions (drop xmlrpc if it fails)
RUN docker-php-ext-install -j$(nproc) gd intl mysqli zip soap

# Enable Apache rewrite
RUN a2enmod rewrite

# Copy Moodle source code
COPY ./src /var/www/html

# Create moodledata directory
RUN mkdir -p /var/www/moodledata \
    && chown -R www-data:www-data /var/www/html /var/www/moodledata \
    && chmod -R 755 /var/www/moodledata

EXPOSE 80

COPY ./src /var/www/html
