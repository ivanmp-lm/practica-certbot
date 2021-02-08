---
description: >-
  En esta práctica se utilizará Certbot y Let's Encrypt para lanzar un Wordpress
  con conexión segura.
---

# HTTPS Con Certbot y Let's Encrypt

**Dominio registrado:** [**https://practicacertbotivan.tk/**](https://practicacertbotivan.tk/)

Se utilizará el script de la práctica de WP-CLI para realizar esta \(también se alojará una copia en este repositorio incluyendo los cambios aquí descritos\).

Con la máquina lanzada y la página de Wordpress operativa, habrá que registrarse en la página [Freenom ](https://www.freenom.com/es/index.html?lang=es)para registrar un nombre de dominio gratuito. Habrá que editar la dirección y la ciudad en el área de cliente ya que si no, no se podrá adquirir un dominio. 

Tras esto y con el dominio registrado \(services -&gt; register a new domain\) se accederá a "**Services -&gt; My Domains**" y se pulsará en "**Manage Domain**":

![](https://i.ibb.co/KcZPyp4/image-42.png)

En la pestaña "**Manage Freenom DNS**" se añadirán dos registros con la ip pública de la máquina de Amazon para darle al servidor DNS la información necesaria:

![](https://i.ibb.co/WngMTfT/image-41.png)

Una vez hecho esto se procederá a configurar la herramienta [Certbot](https://certbot.eff.org/), que sirve para instalar certificados SSL expedidos por la autoridad certificadora [Let's Encrypt](https://letsencrypt.org/).

Se ejecutarán los siguientes comandos para instalar la herramienta:

```text
#Instalar y actualizar la herramienta de instalación de paquetes snap
sudo snap install core; sudo snap refresh core
#Eliminar instalaciones previas de Certbot
sudo apt-get remove certbot
#Instalar Certbot
sudo snap install --classic certbot
#Crear alias para el comando "certbot"
sudo ln -s /snap/bin/certbot /usr/bin/certbot
#Obtener certificado y configurarlo en Apache
sudo certbot --apache -m ivan@ivan.com --agree-tos --no-eff-email -d practicacertbotivan.tk
```

Donde en el último comando habrá que adaptar los parámetros a lo que se requiera \(email y dominio\).

Como última configuración también sería necesario ingresar en phpMyAdmin y cambiar la tabla "**wp\_options**" de la base de datos de Wordpress para adecuar la nueva URL de la página:

![](https://i.ibb.co/Ntzv3nX/image-38.png)

Tras esto, se podrá acceder a Wordpress utilizando el certificado SSL que se ha adquirido por medio de Certbot:

![](https://i.ibb.co/2jCL5md/image-37.png)
