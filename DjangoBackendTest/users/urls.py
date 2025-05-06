# users/urls.py
from django.urls import path
from django.contrib.auth.views import LoginView, LogoutView
from django.views.generic import TemplateView
from .views import UserList, register_user, login_user, home_view, welcome_view, registration_view, confirm_password_reset, request_password_reset, social_login, upload_profile_picture

urlpatterns = [
    # Web views
    #path("", home_view, name="home"),  # Home Page (Web)
    path("", welcome_view, name="welcome"),  # Home Page (Web)
    path("login/", LoginView.as_view(template_name="users/login.html"), name="login"),  # Web Login Page
    path("logout/", LogoutView.as_view(next_page="home"), name="logout"),  # Web Logout
    path("register/", registration_view, name="register"),  # Web Register Page
    path('terms/', TemplateView.as_view(template_name="terms.html"), name='terms'),

    # API views
    path("api/list/", UserList.as_view(), name="user-list"),  # API: Get all users
    path("api/register/", register_user, name="register-user"),  # API: Register user
    path("api/login/", login_user, name="login-user"),  # API: Login user
    path("api/users/request-password-reset/", request_password_reset, name="request-password-reset"),
    path("api/users/confirm-password-reset/", confirm_password_reset, name="confirm-password-reset"),
    path('api/social-login/', social_login, name='social-login'),
    path("api/upload-profile-picture/", upload_profile_picture, name="upload-profile-picture")
] 
