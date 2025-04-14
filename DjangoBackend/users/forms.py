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
            "phone",
            "dob",         # matches your model
            "password1",
            "password2",
        ]
        widgets = {
            "username": forms.TextInput(attrs={
                "class": "form-control",
                "placeholder": "Username",
            }),
            "email": forms.EmailInput(attrs={
                "class": "form-control",
                "placeholder": "Email",
            }),
            "phone": forms.TextInput(attrs={
                "class": "form-control",
                "placeholder": "Phone",
            }),
            "dob": forms.DateInput(attrs={
                "class": "form-control",
                "placeholder": "Date of birth",
                "type": "date",
            }),
            "password1": forms.PasswordInput(attrs={
                "class": "form-control",
                "placeholder": "Password",
            }),
            "password2": forms.PasswordInput(attrs={
                "class": "form-control",
                "placeholder": "Confirm Password",
            }),
        }
