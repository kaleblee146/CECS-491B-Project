# backend/urls.py
from django.contrib import admin
from django.urls import path, include
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView

urlpatterns = [
    path("admin/",         admin.site.urls),
    path("",               include("users.urls")),        # web pages
    path("api/users/",     include("users.api_urls")),    # JSON API
    path("api/workouts/",  include("workouts.urls")),
    path("api/token/",     TokenObtainPairView.as_view(), name="token_obtain_pair"),
    path("api/token/refresh/", TokenRefreshView.as_view(), name="token_refresh"),
    path('django_plotly_dash/', include('django_plotly_dash.urls')), # dash
    path('dash_app/', include('backend.dash_app.urls')),
]
