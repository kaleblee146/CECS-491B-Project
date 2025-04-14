# users/urls.py
from django.urls import path
from django.contrib.auth.views import LoginView, LogoutView
from django.views.generic import TemplateView
from .views import (
    registration_view,
    login_view,
    welcome_view,
    home_view,
    password_reset_view,
)

urlpatterns = [
    path("",               welcome_view,          name="welcome"),   # GET /
    path("register/",      registration_view,     name="register"),  # GET/POST /register/
    path("login/",         login_view,            name="login"),     # GET/POST /login/
    path("logout/",        LogoutView.as_view(next_page="welcome"), name="logout"),
    path("home/",          home_view,             name="home"),
    path("terms/",         TemplateView.as_view(template_name="terms.html"), name="terms"),
    path("password-reset/", password_reset_view,  name="password_reset"),
]