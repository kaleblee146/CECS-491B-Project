# users/url.py
from django.urls import path
from .views import UserList, register_user, login_user

urlpatterns = [
    path('', UserList.as_view(), name='user-list'), # This will respond to /api/users/
    path('register/', register_user, name='register'),
    path('login/', login_user, name='login'),

]
