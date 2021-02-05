#!/bin/bash

#Ver los comandos ejecutados
set -x

# ---------------------------------------
# Variables de configuración
# ---------------------------------------
DB_NAME=wordpress_db
DB_USER=wordpress_user
DB_PASSWORD=wordpress_password
IP_PRIVADA_FRONTEND=localhost
IP_MYSQL_SERVER=localhost
WP_URL=
CERT_DOMAIN=
#-----------------------------------------
# Variables de configuración
# ---------------------------------------

# Actualizar los repositorios
apt update

# Instalar servidor Apache
apt install apache2 -y

# Instalar servidor MySQL
apt install mysql-server -y

# Instalar módulos PHP
apt install php libapache2-mod-php php-mysql -y

# Reiniciar servidor Apache
systemctl restart apache2

# Copiar el archivo info.php a la carpeta de la página web
cp info.php /var/www/html

# Descargar ejecutable de WP-CLI
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

# Asignar permisos de ejecución y mover y renombrar el archivo a la ruta correspondiente
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

# Descargar el código fuente de Wordpress en español utilizando la herramienta WP
cd /var/www/html
mv index.html index.htmll
wp core download --locale=es_ES --allow-root

# Crear la base de datos y usuario para conectarse a Wordpress
mysql -u root <<< "DROP DATABASE IF EXISTS $DB_NAME;"
mysql -u root <<< "CREATE DATABASE $DB_NAME;"
mysql -u root <<< "CREATE USER $DB_USER@$IP_PRIVADA_FRONTEND IDENTIFIED BY '$DB_PASSWORD';"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $DB_NAME.* TO $DB_USER@$IP_PRIVADA_FRONTEND;"
mysql -u root <<< "FLUSH PRIVILEGES;"

# Crear archivo de configuración de Wordpress
wp config create --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASSWORD --allow-root

# Instalar Wordpress utilizando la aplicación wp
wp core install --url=$WP_URL --title="Ivan_Practica_WPCLI" --admin_user=admin --admin_password=admin123 --admin_email=ivan@admin.com --allow-root

# ---------------------------------------
# Configuración adicional de Wordpress
# ---------------------------------------

# Actualizar todos los plugins a la última versión
wp plugin update --all --allow-root

# Actualizar todos los temas
wp theme update --all --allow-root

# Actualizar la versión de Wordpress
wp core update --allow-root

# Cambiar permisos de la carpeta WP-Content después de actualizar
chmod -R 775 wp-content
chown -R www-data:www-data *

# ---------------------------------------
# Instalación Certbot
# ---------------------------------------
#Instalar y actualizar la herramienta de instalación de paquetes snap
sudo snap install core; sudo snap refresh core
#Eliminar instalaciones previas de Certbot
sudo apt-get remove certbot
#Instalar Certbot
sudo snap install --classic certbot
#Crear alias para el comando "certbot"
sudo ln -s /snap/bin/certbot /usr/bin/certbot
#Obtener certificado y configurarlo en Apache
sudo certbot --apache -m ivan@ivan.com --agree-tos --no-eff-email -d $CERT_DOMAIN
