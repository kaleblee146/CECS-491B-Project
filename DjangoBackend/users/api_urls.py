# users/api_urls.py
from django.urls import path
from .views import (
    UserList,
    register_user,
    login_user,
    request_password_reset,
    confirm_password_reset,
)

urlpatterns = [
    path("list/",                      UserList.as_view(),         name="user-list"),
    path("register/",                  register_user,              name="register-user"),
    path("login/",                     login_user,                 name="login-user"),
    path("request-password-reset/",    request_password_reset,     name="request-password-reset"),
    path("confirm-password-reset/",    confirm_password_reset,     name="confirm-password-reset"),
]
