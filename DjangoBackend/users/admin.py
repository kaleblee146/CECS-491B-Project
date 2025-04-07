# users/admin.py
from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import CustomUser

# Register your models here.
class CustomUserModel(UserAdmin):
    fieldsets = UserAdmin.fieldsets + (
        ("Custom Fields", {"fields": ("role", "firstName", "lastName", "dob", "bio", "profile_picture")}),

    )
    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': ('username', 'email', 'firstName', 'lastName', 'password1', 'password2', 'role')}
        ),
    )
    list_display = ("username", "email", "role", "is_staff", "is_active")


admin.site.register(CustomUser, CustomUserModel)