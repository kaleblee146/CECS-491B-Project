import os
from pathlib import Path
from datetime import timedelta

# ─── BASE PATH ────────────────────────────────────────────────────────────────
BASE_DIR = Path(__file__).resolve().parent.parent

# ─── CORE SETTINGS ──────────────────────────────────────────────────────────────
DEBUG = True  # Change to False in production!
SECRET_KEY = "django-insecure-1a_uj6_vp)%%l5-dnfwt^q_h0a=lnnrp3gwkog8$zmrh&ze&!o"  # Change in production
ROOT_URLCONF = "backend.urls"
WSGI_APPLICATION = "backend.wsgi.application"
ASGI_APPLICATION = "backend.routing.application"

# ─── SECURITY ──────────────────────────────────────────────────────────────────
ALLOWED_HOSTS = [
    "movementor.app",
    "www.movementor.app",
    "api.movementor.app",
    "52.53.157.43",
    "ec2-52-53-157-43.us-west-1.compute.amazonaws.com",
    "localhost",
    "127.0.0.1",
    "green-env-usw1.us-west-1.elasticbeanstalk.com",
    "green-env-usw1-new.us-west-1.elasticbeanstalk.com",
    "*",  # Wildcard for EB health checks
]

# Add any extra hosts from environment variables
extra_hosts = os.getenv("ALLOWED_HOSTS_EXTRA", "")
if extra_hosts:
    ALLOWED_HOSTS += [h.strip() for h in extra_hosts.split(",") if h.strip()]

# CSRF and SSL settings
CSRF_TRUSTED_ORIGINS = [
    "https://movementor.app",
    "https://www.movementor.app",
    "https://movementor-blue.us-west-2.elasticbeanstalk.com",
    "https://green-env-usw1.us-west-1.elasticbeanstalk.com",
    "https://green-env-usw1-new.us-west-1.elasticbeanstalk.com",
]

# SSL Configuration
SECURE_PROXY_SSL_HEADER = ("HTTP_X_FORWARDED_PROTO", "https")
SECURE_SSL_REDIRECT = False

# Health check paths that should be exempt from SSL redirect
HEALTH_CHECK_PATHS = ['/dbtest/', '/health/']
SECURE_SSL_REDIRECT_EXEMPT = HEALTH_CHECK_PATHS

# ─── INSTALLED APPS ───────────────────────────────────────────────────────────
INSTALLED_APPS = [
    # Django contrib apps
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",

    # Static files
    "whitenoise.runserver_nostatic",  # first so runserver uses Whitenoise too
    "django.contrib.staticfiles",
    "django.contrib.staticfiles",

    # Third-party apps
    "corsheaders",
    "rest_framework",
    "rest_framework.authtoken",
    "rest_framework_simplejwt",
    "django_plotly_dash.apps.DjangoPlotlyDashConfig",
    "channels",
    "whitenoise.runserver_nostatic",

    # Project apps
    "backend.dash_app.apps.DashAppConfig",
    "analytics",
    "core",
    "notifications",
    "plans",
    "resources",
    "users",
    "workouts",
]

# ─── MIDDLEWARE ────────────────────────────────────────────────────────────────
MIDDLEWARE = [
    # Security first
    "django.middleware.security.SecurityMiddleware",
    "whitenoise.middleware.WhiteNoiseMiddleware"     # whitenoise compression
    
    # Custom middleware
    'core.middleware.RequestLoggingMiddleware',
    
    # CORS
    "corsheaders.middleware.CorsMiddleware",
    
    # Django standard middleware
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
    
    # Plotly Dash
    "django_plotly_dash.middleware.BaseMiddleware",
]

# ─── TEMPLATES ─────────────────────────────────────────────────────────────────
TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [BASE_DIR / "users" / "templates" / "users"],
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

# ─── DATABASE ─────────────────────────────────────────────────────────────────
DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.postgresql",
        "NAME": "movementor_django_db",
        "USER": "MoveMentor",
        "PASSWORD": "mentorMove123!",  # Store in environment variable in production
        "HOST": "movementor-django-db.cfuoimgmmxni.us-west-1.rds.amazonaws.com",
        "PORT": "5432",
        "CONN_MAX_AGE": 60,  # Keep connections alive for 60 seconds
        "OPTIONS": {
            "sslmode": "require",  # Enforce SSL for security
        },
    }
}

# ─── CACHES ─────────────────────────────────────────────────────────────────
CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.locmem.LocMemCache',
    }
}

# ─── AUTHENTICATION ─────────────────────────────────────────────────────────
AUTH_USER_MODEL = "users.CustomUser"
LOGIN_REDIRECT_URL = "/home"
LOGOUT_REDIRECT_URL = "/"  # Redirect to homepage after logout

AUTH_PASSWORD_VALIDATORS = [
    {"NAME": "django.contrib.auth.password_validation.UserAttributeSimilarityValidator"},
    {"NAME": "django.contrib.auth.password_validation.MinimumLengthValidator"},
    {"NAME": "django.contrib.auth.password_validation.CommonPasswordValidator"},
    {"NAME": "django.contrib.auth.password_validation.NumericPasswordValidator"},
]

# ─── REST FRAMEWORK & JWT ──────────────────────────────────────────────────────
REST_FRAMEWORK = {
    "DEFAULT_PERMISSION_CLASSES": ["rest_framework.permissions.IsAuthenticated"],
    "DEFAULT_AUTHENTICATION_CLASSES": [
        "rest_framework_simplejwt.authentication.JWTAuthentication",
        "rest_framework.authentication.SessionAuthentication",  # For browsable API
    ],
    "DEFAULT_PAGINATION_CLASS": "rest_framework.pagination.PageNumberPagination",
    "PAGE_SIZE": 20,
    "DEFAULT_THROTTLE_CLASSES": [
        "rest_framework.throttling.AnonRateThrottle",
        "rest_framework.throttling.UserRateThrottle",
    ],
    "DEFAULT_THROTTLE_RATES": {
        "anon": "100/day",
        "user": "1000/day",
    },
}

SIMPLE_JWT = {
    "ACCESS_TOKEN_LIFETIME": timedelta(minutes=60),
    "REFRESH_TOKEN_LIFETIME": timedelta(days=1),
    "ROTATE_REFRESH_TOKENS": False,
    "BLACKLIST_AFTER_ROTATION": False,
}

# ─── CORS CONFIGURATION ───────────────────────────────────────────────────────
CORS_ALLOW_ALL_ORIGINS = True  # Change to False in production
# CORS_ALLOWED_ORIGINS = [
#     "https://movementor.app",
#     "https://www.movementor.app",
#     "http://localhost:3000",
# ]
CORS_ALLOW_CREDENTIALS = True

# ─── STATIC & MEDIA FILES ────────────────────────────────────────────────────
STATIC_URL = "/static/"
STATIC_ROOT = BASE_DIR / "staticfiles"
STATICFILES_DIRS = [
    BASE_DIR / "static",
]
WHITENOISE_KEEP_ONLY_HASHED_FILES = True
MEDIA_URL = "/media/"
MEDIA_ROOT = BASE_DIR / "media"

# ─── CHANNELS (WEBSOCKETS) ─────────────────────────────────────────────────────
CHANNEL_LAYERS = {
    "default": {
        "BACKEND": "channels.layers.InMemoryChannelLayer",
        # For production use Redis:
        # "BACKEND": "channels_redis.core.RedisChannelLayer",
        # "CONFIG": {"hosts": [("redis-server-name", 6379)]},
    }
}

# ─── PLOTLY DASH ───────────────────────────────────────────────────────────────
PLOTLY_DASH = {
    "serve_locally": True,
}
X_FRAME_OPTIONS = "SAMEORIGIN"  # Allow Dash iframes

# ─── INTERNATIONALIZATION ─────────────────────────────────────────────────────
LANGUAGE_CODE = "en-us"
TIME_ZONE = "UTC"
USE_I18N = True
USE_TZ = True

# ─── LOGGING ─────────────────────────────────────────────────────────────────
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'verbose': {
            'format': '{levelname} {asctime} {module} {message}',
            'style': '{',
        },
        'simple': {
            'format': '{levelname} {message}',
            'style': '{',
        },
    },
    'handlers': {
        'console': {
            'level': 'DEBUG',
            'class': 'logging.StreamHandler',
            'formatter': 'verbose',
        },
        'file': {
            'level': 'INFO',
            'class': 'logging.FileHandler',
            'filename': os.path.join(BASE_DIR, 'django.log'),
            'formatter': 'verbose',
        },
    },
    'loggers': {
        'django': {
            'handlers': ['console', 'file'],
            'level': 'INFO',
            'propagate': True,
        },
        'movementor': {  # Your custom logger
            'handlers': ['console', 'file'],
            'level': 'DEBUG',
            'propagate': True,
        },
    },
}

# ─── EMAIL SETTINGS ─────────────────────────────────────────────────────────────
EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
EMAIL_HOST = 'smtp.example.com'  # Update with your SMTP server
EMAIL_PORT = 587
EMAIL_USE_TLS = True
EMAIL_HOST_USER = 'noreply@movementor.com'  # Update or use env var
EMAIL_HOST_PASSWORD = ''  # Use env var in production
DEFAULT_FROM_EMAIL = 'MoveMentor <noreply@movementor.com>'

# ─── HEALTH CHECK CONFIGURATION ─────────────────────────────────────────────────
HEALTH_CHECK_SETTINGS = {
    'DB_TIMEOUT': 3,  # seconds
}

# ─── DEFAULT AUTO FIELD ─────────────────────────────────────────────────────────
DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

# ─── STORAGES  ──────────────────────────────────────────────────────────────────
STORAGES = {
    "staticfiles": {
        "BACKEND": "whitenoise.storage.CompressedManifestStaticFilesStorage",
    }
}