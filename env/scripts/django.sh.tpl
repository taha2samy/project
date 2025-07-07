#!/bin/bash
yum update -y
yum groupinstall -y "Development Tools"

# Enable & install Python 3.8
amazon-linux-extras enable python3.8 -y
yum install -y python3.8 python3.8-devel python3.8-pip

# 1. Clone the repo and set up the environment
mkdir -p /srv/app
sudo chown -R ec2-user:ec2-user /srv/app
git clone https://github.com/taha2samy/QuickConnect.git /srv/app
cd /srv/app

python3.8 -m venv venv
source venv/bin/activate
cd /srv/app/QuickConnect
cat requirements.txt << EOF 
asgiref==3.8.1
attrs==24.2.0
autobahn==24.4.2
automat==24.8.1
cffi==1.17.1
channels==4.1.0
constantly==23.10.4
cryptography==43.0.1
daphne==4.1.2
django==5.1.1
hyperlink==21.0.0
idna==3.10
incremental==24.7.2
pyasn1==0.6.1
pyasn1-modules==0.4.1
pycparser==2.22
pyopenssl==24.2.1
service-identity==24.1.0
setuptools==75.1.0
sqlparse==0.5.1
twisted[tls]==24.7.0
txaio==23.1.1
channels==4.2.2
channels_redis==4.2.1
typing-extensions==4.12.2
tzdata==2024.2; sys_platform == 'win32'
zope-interface==7.0.3
psycopg2-binary

EOF

cat > settings.py <<EOF
"""
Dynamically generated settings.py via user-data
"""
from pathlib import Path
import os
import tempfile

# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent


# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = 'django-insecure-r)%&d-!_e&iys7!kkl871@=)nwl+l-vx&1jwq*cj1o3!$vw_6k'

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = False
TIME_OUT=86400
# Allow all hosts for testing. In production, you should lock this down.
ALLOWED_HOSTS = ['*']
KEY=b'rE_u1FSWlkSUjNDWFUPDbwBXPdA26qRHC39Bn0ERRTw='

# Application definition
INSTALLED_APPS = [
    'accounts.apps.AccountsConfig',
    'rooms.apps.RoomsConfig',
    'daphne',
    'channels',
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'QuickConnect.urls'
WSGI_APPLICATION = 'QuickConnect.wsgi.application'
ASGI_APPLICATION = 'QuickConnect.asgi.application'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [BASE_DIR / 'templates'], # Best practice to have a root templates folder
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

# Database
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': '${DB_NAME}',
        'USER': '${DB_USER}',
        'PASSWORD': '${DB_PASSWORD}',
        'HOST': '${DB_HOST}',
        'PORT': '5432',
    }
}

# Channels for real-time communication
CHANNEL_LAYERS = {
        "default": {
            "BACKEND": "channels_redis.core.RedisChannelLayer",
            "CONFIG": {
                "hosts": [
                    f"rediss://:${REDIS_PASSWORD}@${REDIS_HOST}:${REDIS_PORT}"
                ],
            },
        },
    }
# Internationalization
LANGUAGE_CODE = 'en-us'
TIME_ZONE = 'UTC'
USE_I18N = True
USE_TZ = True

# --- STATIC AND MEDIA FILE CONFIGURATION (THE FIX IS HERE) ---
STATIC_URL = '/static/'
MEDIA_URL = '/media/'

# Directories where Django looks for your static files (CSS, JS) within your project
STATICFILES_DIRS = [
    BASE_DIR / "static",
]

# The single directory where 'collectstatic' will place all static files for deployment.
# This line was MISSING and caused the main error.
STATIC_ROOT = BASE_DIR / 'staticfiles'

# Directory where user-uploaded files will be stored.
MEDIA_ROOT = BASE_DIR / 'media'

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

EOF

# 4. Run commands in the CORRECT order and use the right server
# Go back to the project root where manage.py is
cd /srv/app

# FIRST, apply migrations to set up the database schema
echo "Running database migrations..."

# SECOND, collect all static files into STATIC_ROOT
echo "Collecting static files..."

# FINALLY, start the production-ready ASGI server (daphne)


sudo chown -R ec2-user:ec2-user /srv/app
pip install --upgrade pip wheel
pip install -r requirements.txt
pip install psycopg2-binary daphne django
sudo chown -R ec2-user:ec2-user /srv/app
pip install channels
pip install redis
pip install channels_redis==4.2.1
# 2. Create the necessary directories BEFORE running Django commands
# This fixes the "(staticfiles.W004) The directory ... does not exist" warning
mkdir -p /srv/app/static
mkdir -p /srv/app/media
# 3. Overwrite settings.py with the CORRECT configuration
# The main changes are adding STATIC_ROOT and allowing all hosts for now
python manage.py migrate --noinput
python manage.py collectstatic --noinput
sudo amazon-linux-extras install nginx1 -y
sudo cat > /etc/nginx/conf.d/quickconnect.conf <<EOF
server {
    listen 80;
    server_name _; 

    location /static/ {
        alias /srv/app/staticfiles/;
    }

    location /media/ {
        alias /srv/app/media/;
    }

    location /ws/ {
        proxy_pass http://127.0.0.1:8000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "Upgrade";
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF
sudo setsebool -P httpd_can_network_connect 1
sudo systemctl start nginx
sudo systemctl enable nginx
export DJANGO_SUPERUSER_USERNAME=admin
export DJANGO_SUPERUSER_EMAIL=admin@example.com
export DJANGO_SUPERUSER_PASSWORD=123
python manage.py createsuperuser --noinput || echo "Superuser already exists."


eecho "Starting Daphne server..." > 1.txt
nohup daphne -b 0.0.0.0 -p 8000 QuickConnect.asgi:application &


