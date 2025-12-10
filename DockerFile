# PHP CLI image
FROM php:8.2-cli

# Install dependencies
RUN apt-get update && apt-get install -y poppler-utils unzip git && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && composer install --no-interaction --prefer-dist

# Expose port
EXPOSE 10000

# Start PHP built-in server
CMD ["php", "-S", "0.0.0.0:10000", "index.php"]
