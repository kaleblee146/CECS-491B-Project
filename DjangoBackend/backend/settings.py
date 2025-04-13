from pathlib import Path
from datetime import timedelta  # Add this import for JWT settings

# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent


# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/5.1/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = "django-insecure-1a_uj6_vp)%%l5-dnfwt^q_h0a=lnnrp3gwkog8$zmrh&ze&!o"

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

ALLOWED_HOSTS = [
     '52.53.157.43',
    'ec2-52-53-157-43.us-west-1.compute.amazonaws.com',
    'localhost', '127.0.0.1' # while still testing locally
]


# Application definition

INSTALLED_APPS = [
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
    'django_plotly_dash.apps.DjangoPlotlyDashConfig',
    'channels',
    'backend.dash_app.apps.DashAppConfig',
    # DRF and JWT
    "rest_framework",
    "rest_framework_simplejwt",
    'rest_framework.authtoken',
    # Apps
    "analytics",
    "core",
    "notifications",
    "plans",
    "resources",
    "users",
    "workouts",

    # Cross-Origin Requests
    "corsheaders"
]

MIDDLEWARE = [
    "django.middleware.security.SecurityMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
    "corsheaders.middleware.CorsMiddleware",
    "django.middleware.common.CommonMiddleware",
    'django_plotly_dash.middleware.BaseMiddleware',
]

ROOT_URLCONF = "backend.urls"

TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [BASE_DIR / 'users/templates/users'],  # Ensure Django looks for templates here
        "APP_DIRS": True,
        "OPTIONS": {
            "context_processors": [
                "django.template.context_processors.debug",
                "django.template.context_processors.request",
                "django.contrib.auth.context_processors.auth",
                "django.contrib.messages.context_processors.messages",
            ],
        },
    },
]

WSGI_APPLICATION = "backend.wsgi.application"
ASGI_APPLICATION = "backend.routing.application"

# Django Plotly Dash settings
PLOTLY_DASH = {
    "serve_locally": True,  # Serve the JS, CSS files from local, not from CDN
}

X_FRAME_OPTIONS = 'SAMEORIGIN'  # Needed for the iframe to work

# Database
# https://docs.djangoproject.com/en/5.1/ref/settings/#databases

# Replace the SQLite database with PostgreSQL

# AWS RDS
DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.postgresql",
        "NAME": "movementor_django_db",  # Replace with your database name
        "USER": "MoveMentor",  # Replace with your database user
        "PASSWORD": "mentorMove123!",  # Replace with your database password
        "HOST": "movementor-django-db.cfuoimgmmxni.us-west-1.rds.amazonaws.com",
        "PORT": "5432",
    }
}

# Local DB
'''
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'postgres',            # Replace with your database name
        'USER': 'chasesansom',         # Replace with your database user
        'PASSWORD': '',                # Replace with your database password
        'HOST': 'localhost',
        'PORT': '5432',
    }
}
'''

# Password validation
# https://docs.djangoproject.com/en/5.1/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {
        "NAME": "django.contrib.auth.password_validation.UserAttributeSimilarityValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.MinimumLengthValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.CommonPasswordValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.NumericPasswordValidator",
    },
]


# Internationalization
# https://docs.djangoproject.com/en/5.1/topics/i18n/

LANGUAGE_CODE = "en-us"

TIME_ZONE = "UTC"

USE_I18N = True

USE_TZ = True


# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/5.1/howto/static-files/

STATIC_URL = "static/"

# Default primary key field type
# https://docs.djangoproject.com/en/5.1/ref/settings/#default-auto-field

DEFAULT_AUTO_FIELD = "django.db.models.BigAutoField"


# Add DRF configuration
REST_FRAMEWORK = {
    'DEFAULT_PERMISSION_CLASSES': [
        'rest_framework.permissions.IsAuthenticated',
    ],
    "DEFAULT_AUTHENTICATION_CLASSES": (
        "rest_framework_simplejwt.authentication.JWTAuthentication",
    ),
}

# Add JWT settings (optional customization)
SIMPLE_JWT = {
    "ACCESS_TOKEN_LIFETIME": timedelta(minutes=60),
    "REFRESH_TOKEN_LIFETIME": timedelta(days=1),
}

# Add custom user model
AUTH_USER_MODEL = "users.CustomUser"

# TESTING ONLY, CHANGE TO WHITELIST FOR PRODUCTION
# CORS settings
CORS_ALLOW_ALL_ORIGINS = True

# Login redirect
LOGIN_REDIRECT_URL = '/home'

# Add channels configuration
CHANNEL_LAYERS = {
    'default': {
        'BACKEND': 'channels.layers.InMemoryChannelLayer',
        # For production, use Redis:
        # 'BACKEND': 'channels_redis.core.RedisChannelLayer',
        # 'CONFIG': {
        #     'hosts': [('redis-server-name', 6379)],
        # }
    }
}

# SSL Redirect
SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTO', 'https')
SECURE_SSL_REDIRECT = True