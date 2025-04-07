# Generated by Django 5.1.7 on 2025-03-19 08:11

from django.db import migrations, models


class Migration(migrations.Migration):
    dependencies = [
        ("users", "0001_initial"),
    ]

    operations = [
        migrations.AddField(
            model_name="customuser",
            name="role",
            field=models.CharField(
                choices=[
                    ("Admin", "Admin"),
                    ("Premium", "Premium User"),
                    ("Free", "Free User"),
                ],
                default="Free",
                max_length=10,
            ),
        ),
    ]
