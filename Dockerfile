FROM php:7.4-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libxml2-dev \
    unzip \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mysqli pdo pdo_mysql \
    && docker-php-ext-enable gd

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Set the ServerName globally to suppress the warning
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Set the working directory inside the container
WORKDIR /var/www/html

# Copy the PHP application code into the container
COPY . /var/www/html

# Set proper permissions for the application
RUN chown -R www-data:www-data /var/www/html

# Expose port 80 to the outside world
EXPOSE 80

# Start Apache in the foreground
CMD ["apache2-foreground"]
