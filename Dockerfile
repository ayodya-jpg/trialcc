# --- Base Stage ---
# Use an official PHP 8.2 image with FPM (FastCGI Process Manager)
FROM php:8.2-fpm-alpine AS base

# Set working directory
WORKDIR /var/www/html

# Install system dependencies
# - PDO (PHP Data Objects) and pdo_mysql for database access
# - Other extensions as needed by Laravel
RUN docker-php-ext-install pdo pdo_mysql

# Get composer in its own stage
FROM composer:2.7 AS composer

# --- Development Stage (default) ---
# This is what docker-compose will use
FROM base AS development
# The ARG instruction was missing here in the previous version
ARG TARGETPLATFORM=${BUILDPLATFORM:-linux/amd64}

# Copy composer in
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Set correct permissions for storage and cache (for local dev)
# 'www-data' is the default user for php-fpm
RUN chown -R www-data:www-data /var/www/html

# --- Production Stage (REVISED - Nginx Removed) ---
# This is what our CI/CD will build.
# It now only contains the PHP-FPM environment.
FROM base AS prod
# The ARG instruction was missing here in the previous version
ARG TARGETPLATFORM=${BUILDPLATFORM:-linux/amd64}

# --- Install Production Dependencies (Nginx removal done here) ---
# Nginx and other utilities installation removed.
# Only composer copy remains relevant.

# Copy composer in
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Copy all our source code into the image
COPY ./src /var/www/html

# --- Configure Nginx (REMOVED) ---
# Nginx config and startup script copies removed.
# COPY nginx.prod.conf /etc/nginx/nginx.conf  <-- REMOVED
# COPY start-prod.sh /usr/local/bin/start-prod.sh <-- REMOVED
# RUN chmod +x /usr/local/bin/start-prod.sh <-- REMOVED

# --- Build Laravel Application ---
# Install composer dependencies
RUN composer install --no-interaction --no-dev --optimize-autoloader

# Optimize Laravel for production
RUN php artisan config:cache && \
    php artisan route:cache && \
    php artisan view:cache && \
    php artisan event:cache

# Set correct permissions for production
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Expose port 9000 (default FPM port, not 80)
EXPOSE 9000

# The main command to run PHP-FPM
# The default command for php:8.2-fpm-alpine is typically php-fpm,
# but we explicitly set it here for clarity.
CMD ["php-fpm"]
