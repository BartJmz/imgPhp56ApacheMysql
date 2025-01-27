# Usamos la imagen oficial de PHP 5.6 con Apache
FROM php:5.6-apache

# Configuramos los repositorios antiguos de Debian Stretch
RUN sed -i 's|http://deb.debian.org/debian|http://archive.debian.org/debian|g' /etc/apt/sources.list && \
    sed -i 's|http://security.debian.org/debian-security|http://archive.debian.org/debian-security|g' /etc/apt/sources.list && \
    sed -i '/stretch-updates/d' /etc/apt/sources.list && \
    echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid

# Instalamos las dependencias necesarias
RUN apt-get update && apt-get install -y --allow-unauthenticated \
    libcurl4-openssl-dev \
    libmariadb-dev \
    libmariadb-dev-compat \
    gnupg \
    curl \
    nano \
    && apt-get clean

# Instalamos las extensiones de PHP
RUN docker-php-ext-install mysql mysqli pdo_mysql \
    && docker-php-ext-enable mysqli

# Habilitamos mod_rewrite de Apache
RUN a2enmod rewrite

# Limpiamos para reducir el tamaño de la imagen
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Exponemos el puerto 80
EXPOSE 80

# Copiar archivos del proyecto
COPY . /var/www/html/

# Comando para iniciar Apache
CMD ["apache2-foreground"]
