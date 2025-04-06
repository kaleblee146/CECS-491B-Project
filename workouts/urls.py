# workouts/urls.py

from django.urls import path
from .views import WorkoutList

urlpatterns = [
    path('', WorkoutList.as_view(), name='workout-list'),
]
