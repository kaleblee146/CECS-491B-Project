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
    dbtest,
    bug_report_view,
    simple_health,
)

urlpatterns = [
    # Existing routes
    path("", welcome_view, name="welcome"),
    path("register/", registration_view, name="register"),
    path("login/", login_view, name="login"),
    path("logout/", LogoutView.as_view(next_page="welcome"), name="logout"),
    path("home/", home_view, name="home"),
    path("terms/", TemplateView.as_view(template_name="terms.html"), name="terms"),
    path("password-reset/", password_reset_view, name="password_reset"),
    path("dbtest/", dbtest, name="dbtest"),
    path('api/bug-reports/', bug_report_view, name='bug-reports'),
    
    # Health check endpoint that doesn't require database access
    path("health/", simple_health, name="simple_health"),
]