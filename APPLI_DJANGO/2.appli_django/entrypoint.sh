#!/bin/bash

cd pret_bancaire

echo "Starting migrations..."
python manage.py makemigrations
python manage.py migrate

echo "Collecting static files..."
python manage.py collectstatic --noinput --clear

echo "Creating superuser..."
python manage.py shell <<EOF
from django_api.models import User
if not User.objects.filter(username='admin').exists():
    User.objects.create_superuser(
        username='Admin',
        email='admin@mondomaine.com',
        password='admin',
        first_name='Admin',
        last_name='Super',
        sexe='homme',
        birth_date='1990-01-01',
        user_type='conseiller'
    )
EOF

echo "Starting Gunicorn..."
exec gunicorn pret_bancaire.wsgi:application --bind 0.0.0.0:8000 --workers 3 --log-level debug