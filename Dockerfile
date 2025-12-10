# Base image
FROM php:8.2-cli

# Set working directory
WORKDIR /app

# Install system dependencies
# - poppler-utils: for pdftotext
# - libzip-dev: for zip extension
# - libxml2-dev: for xml extension
# - libonig-dev: for mbstring extension
# - git, unzip, curl: utilities
RUN apt-get update && apt-get install -y \
    poppler-utils \
    git \
    unzip \
    curl \
    libzip-dev \
    libxml2-dev \
    libonig-dev \
    && docker-php-ext-install zip mbstring xml \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy composer config
COPY composer.json ./

# Install PHP dependencies
# Using --no-scripts to prevent auto-scripts from running before code is present
RUN composer install --no-dev --optimize-autoloader --no-scripts --prefer-dist

# Copy project files
COPY . .

# Expose the required port
EXPOSE 10000

# Start PHP built-in server
CMD ["php", "-S", "0.0.0.0:10000", "index.php"]
