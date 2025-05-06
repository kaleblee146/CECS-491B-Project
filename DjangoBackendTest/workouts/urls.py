# workouts/urls.py

from django.urls import path, include
from django.contrib import admin
from .views import WorkoutList
from .views import RegisterView

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/users/', include('users.urls')),

    path('', WorkoutList.as_view(), name='workout-list'),
    path('register/', RegisterView.as_view(), name = 'register'),
]
