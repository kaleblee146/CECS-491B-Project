# users/forms.py
from django import forms
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth import get_user_model

CustomUser = get_user_model()

class CustomUserCreationForm(UserCreationForm):
    class Meta(UserCreationForm.Meta):
        model = CustomUser
        fields = [
            "username",
            "email",
            "firstName",
            "lastName",
            "dob",
            "phone",
            "gender",
            "units",
            "weight",
            "height",
            "goals",
            "bio",
            "profile_picture",
            "role",
        ]
