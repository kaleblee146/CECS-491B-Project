from django.urls import path
from .views import UserList, register_user, login_user

urlpatterns = [
    path("list/", UserList.as_view(), name="user_list"),  # API: Get all users
    path("register/", register_user, name="register_user"),  # API: Register user
    path("login/", login_user, name="login_user"),  # API: Login user
]
