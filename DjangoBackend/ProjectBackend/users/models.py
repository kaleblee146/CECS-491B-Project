# users/models.py
from django.db import models
from django.contrib.auth.models import AbstractUser

class UserRoles(models.TextChoices):
    FREE = "Free", "Free User"
    PREMIUM = "Premium", "Premium User"
    ADMIN = "Admin", "Admin"

class CustomUser(AbstractUser):
    firstName = models.CharField(max_length=150, blank=True)
    lastName = models.CharField(max_length=150, blank=True)
    email = models.EmailField(blank=True)
    phone = models.CharField(max_length=20, blank=True)
    dob = models.DateField(null=True, blank=True)
    gender = models.CharField(max_length=20, blank=True)
    age = models.IntegerField(null=True, blank=True)
    units = models.CharField(max_length=20, blank=True)
    weight = models.FloatField(null=True, blank=True)
    height = models.FloatField(null=True, blank=True)
    goals = models.TextField(blank=True)
    

    reset_code = models.CharField(max_length=6, null=True, blank=True)
    bio = models.TextField(blank=True, default="")
    profile_picture = models.URLField(blank=True, default="")
    role = models.CharField(
        max_length=10, 
        choices=UserRoles.choices, 
        default=UserRoles.FREE
    )

    def __str__(self):
        return f"{self.username} ({self.role})"
