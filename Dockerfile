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

# Configure and install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd intl mysqli zip soap xmlrpc \
    && docker-php-ext-enable mysqli

# Enable Apache rewrite
RUN a2enmod rewrite

# Copy Moodle source code (assuming you cloned into ./src)
COPY ./src /var/www/html

# Create moodledata directory
RUN mkdir -p /var/www/moodledata \
    && chown -R www-data:www-data /var/www/html /var/www/moodledata \
    && chmod -R 755 /var/www/moodledata

EXPOSE 80
