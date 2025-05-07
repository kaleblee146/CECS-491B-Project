# users/serializers.py
from rest_framework import serializers
from .models import CustomUser, BugReport

class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)

    class Meta:
        model = CustomUser
        fields = [
            'username', 'email', 'password', 'firstName', 'lastName',
            'dob', 'phone', 'gender', 'age', 'units', 'weight',
            'height', 'goals', 'bio', 'profile_picture', 'role'
        ]

    def create(self, validated_data):
        password = validated_data.pop('password', None)
        print("Password entered:", password)
        user = CustomUser.objects.create_user(password=password, **validated_data)
        print("User created with password hash:", user.password)
        return user
    
    class BugReportSerializer(serializers.ModelSerializer):
        class Meta:
            model = BugReport
            fields = ['id', 'user', 'description', 'submitted_at']
            read_only_fields = ['id', 'submitted_at', 'user']