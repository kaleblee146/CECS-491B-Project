# users/models.py
from django.db import models
from django.contrib.auth.models import AbstractUser

class UserRoles(models.TextChoices):
    FREE = "Free", "Free User"
    PREMIUM = "Premium", "Premium User"
    ADMIN = "Admin", "Admin"

class CustomUser(AbstractUser):
    full_name = models.CharField(max_length=150, blank=True, default="")
    date_of_birth = models.DateField(null=True, blank=True)
    bio = models.TextField(blank=True, default="")
    profile_picture = models.URLField(blank=True, default="")
    role = models.CharField(
        max_length=10, 
        choices=UserRoles.choices, 
        default=UserRoles.FREE
    )

    def __str__(self):
        return f"{self.username} ({self.role})"
