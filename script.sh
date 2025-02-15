#!/bin/bash

echo "Esperando a que la base de datos esté disponible..."
until mysql -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASSWORD" -e "SELECT 1;" &> /dev/null; do
    echo "Esperando a la base de datos..."
    sleep 5
done

echo "Base de datos disponible."

# Aplicar las migraciones
echo "Aplicando migraciones..."
python manage.py migrate

# Crear superusuario si no existe
echo "Creando superusuario de Django..."
echo "from django.contrib.auth import get_user_model; \
User = get_user_model(); \
User.objects.filter(username='$DJ_USER').exists() or \
User.objects.create_superuser('$DJ_USER', '$DJ_EMAIL', '$DJ_PASSWORD')" | python manage.py shell

# Iniciar el servidor en el puerto 8000
echo "Iniciando el servidor Django..."
exec python manage.py runserver 0.0.0.0:8000
