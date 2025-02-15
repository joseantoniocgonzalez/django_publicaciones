# syntax=docker/dockerfile:1

FROM python:3.12.1-bookworm

# Establecer el directorio de trabajo
WORKDIR /usr/share/app

# Instalar el cliente de MariaDB
RUN apt-get update && apt-get install -y mariadb-client git

# Clonar automáticamente tu repositorio desde GitHub
RUN git clone https://github.com/joseantoniocgonzalez/django_publicaciones.git /usr/share/app/src

# Mover el contenido al directorio raíz
RUN mv /usr/share/app/src/* /usr/share/app/ && rm -rf /usr/share/app/src

# Instalar dependencias
RUN pip install --upgrade --no-cache-dir pip \
    && pip install --no-cache-dir -r requirements.txt \
    && pip install --no-cache-dir mysqlclient

# Copiar el script de inicio
COPY script.sh /usr/local/bin/script.sh
RUN chmod +x /usr/local/bin/script.sh

# Configurar variables de entorno
ENV DB_NAME=django
ENV DB_USER=django
ENV DB_PASSWORD=django
ENV DB_HOST=db
ENV DJ_USER=django
ENV DJ_PASSWORD=django
ENV DJ_EMAIL=a@a.com
ENV ALLOWED_HOSTS=localhost
ENV URL=http://localhost

# Exponer puerto 8600
EXPOSE 8600

# Comando de arranque
CMD ["/usr/local/bin/script.sh"]
