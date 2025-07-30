FROM php:7.4-apache

RUN apt-get update && apt-get install -y \
    git unzip zip curl libicu-dev \
    && docker-php-ext-install pdo pdo_mysql intl \
    && apt-get clean

RUN a2enmod rewrite

# Instala Composer 1.10.27 (compatível com Zend antigo)
RUN curl -sS https://getcomposer.org/installer | php -- --version=1.10.27 && \
    mv composer.phar /usr/bin/composer && chmod +x /usr/bin/composer

# Cria pasta de cache e dá permissões
RUN mkdir -p /var/www/html/data/cache \
    && chown -R www-data:www-data /var/www/html/data \
    && chmod -R 775 /var/www/html/data

WORKDIR /var/www/html

COPY . /var/www/html

COPY docker/apache/apache.conf /etc/apache2/sites-available/000-default.conf


RUN git config --global --add safe.directory /var/www/html

# Executa composer install automaticamente (opcional)
# RUN composer install

# Ajusta permissões (caso necessário para uploads ou cache)
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
