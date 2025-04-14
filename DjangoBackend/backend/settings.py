from pathlib import Path
from datetime import timedelta  # JWT settings

# ─── BASE PATH ────────────────────────────────────────────────────────────────
BASE_DIR = Path(__file__).resolve().parent.parent

# ─── SECURITY ──────────────────────────────────────────────────────────────────
SECRET_KEY = "django-insecure-1a_uj6_vp)%%l5-dnfwt^q_h0a=lnnrp3gwkog8$zmrh&ze&!o"
DEBUG = True  # Change to False in production!
ALLOWED_HOSTS = [
    "movementor.app",
    "www.movementor.app",
    "52.53.157.43",
    "ec2-52-53-157-43.us-west-1.compute.amazonaws.com",
    "localhost",
    "127.0.0.1",
]
CSRF_TRUSTED_ORIGINS = [
    "https://movementor.app",
    "https://www.movementor.app",
]
# Behind nginx terminating SSL:
SECURE_PROXY_SSL_HEADER = ("HTTP_X_FORWARDED_PROTO", "https")
# Optional—Django will redirect any HTTP → HTTPS if True.
SECURE_SSL_REDIRECT = True

# ─── INSTALLED APPS ───────────────────────────────────────────────────────────
INSTALLED_APPS = [
    # Django contrib
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",

    # Third‑party
    "corsheaders",
    "rest_framework",
    "rest_framework.authtoken",
    "rest_framework_simplejwt",
    "django_plotly_dash.apps.DjangoPlotlyDashConfig",
    "channels",

    # Your apps
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
    "django.middleware.security.SecurityMiddleware",
    'core.middleware.RequestLoggingMiddleware',

    # CORS (for API testing only—lock this down later!)
    "corsheaders.middleware.CorsMiddleware",

    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.common.CommonMiddleware",

    # CSRF protection
    "django.middleware.csrf.CsrfViewMiddleware",

    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",

    # Plotly Dash
    "django_plotly_dash.middleware.BaseMiddleware",
]

# ─── URLS & TEMPLATES ─────────────────────────────────────────────────────────
ROOT_URLCONF = "backend.urls"
WSGI_APPLICATION = "backend.wsgi.application"
ASGI_APPLICATION = "backend.routing.application"

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
        "PASSWORD": "mentorMove123!",
        "HOST": "movementor-django-db.cfuoimgmmxni.us-west-1.rds.amazonaws.com",
        "PORT": "5432",
    }
}
# (Local Postgres block commented out below for reference)

# ─── AUTHENTICATION & PASSWORDS ───────────────────────────────────────────────
AUTH_USER_MODEL = "users.CustomUser"
LOGIN_REDIRECT_URL = "/home"

AUTH_PASSWORD_VALIDATORS = [
    {"NAME": "django.contrib.auth.password_validation.UserAttributeSimilarityValidator"},
    {"NAME": "django.contrib.auth.password_validation.MinimumLengthValidator"},
    {"NAME": "django.contrib.auth.password_validation.CommonPasswordValidator"},
    {"NAME": "django.contrib.auth.password_validation.NumericPasswordValidator"},
]

# ─── INTERNATIONALIZATION ─────────────────────────────────────────────────────
LANGUAGE_CODE = "en-us"
TIME_ZONE = "UTC"
USE_I18N = True
USE_TZ = True

# ─── STATIC FILES ─────────────────────────────────────────────────────────────
STATIC_URL = "/static/"
STATIC_ROOT = BASE_DIR / "staticfiles"

# ─── REST FRAMEWORK & JWT ──────────────────────────────────────────────────────
REST_FRAMEWORK = {
    "DEFAULT_PERMISSION_CLASSES": ["rest_framework.permissions.IsAuthenticated"],
    "DEFAULT_AUTHENTICATION_CLASSES": [
        "rest_framework_simplejwt.authentication.JWTAuthentication",
    ],
}

SIMPLE_JWT = {
    "ACCESS_TOKEN_LIFETIME": timedelta(minutes=60),
    "REFRESH_TOKEN_LIFETIME": timedelta(days=1),
}

# ─── CORS (FOR TESTING ONLY) ───────────────────────────────────────────────────
CORS_ALLOW_ALL_ORIGINS = True  # switch to explicit whitelist in production

# ─── CHANNELS (WEBSOCKETS) ─────────────────────────────────────────────────────
CHANNEL_LAYERS = {
    "default": {
        "BACKEND": "channels.layers.InMemoryChannelLayer",
        # For production you’d swap in Redis:
        # "BACKEND": "channels_redis.core.RedisChannelLayer",
        # "CONFIG": {"hosts": [("redis-server-name", 6379)]},
    }
}

# ─── PLOTLY DASH ───────────────────────────────────────────────────────────────
PLOTLY_DASH = {
    "serve_locally": True,
}

X_FRAME_OPTIONS = "SAMEORIGIN"  # allow Dash iframes

# ─── FINAL NOTES ───────────────────────────────────────────────────────────────
# • DEBUG=False is mandatory in production.
# • You can remove the local‑DB block entirely once you’re fully on RDS.
# • Lock down CORS_ALLOW_ALL_ORIGINS before going live.
