# PHP CLI image
FROM php:8.2-cli

# Install system dependencies + PHP extensions
RUN apt-get update && \
    apt-get install -y poppler-utils unzip git curl libzip-dev && \
    docker-php-ext-install zip && \
    docker-php-ext-install mbstring && \
    docker-php-ext-install xml && \
    rm -rf /var/lib/apt/lists/*

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Install PHP dependencies
RUN composer install --no-interaction --prefer-dist

# Expose port
EXPOSE 10000

# Start PHP built-in server
CMD ["php", "-S", "0.0.0.0:10000", "index.php"]
