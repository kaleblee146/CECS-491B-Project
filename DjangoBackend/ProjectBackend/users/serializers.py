# users/serializers.py
from rest_framework import serializers
from .models import CustomUser
from rest_framework.serializers import ModelSerializer

class UserSerializer(ModelSerializer):
    class Meta:
        model = CustomUser  
        fields = ['id',
            'username',
            'firstName',
            'lastName',
            'dob',
            'email',
            'phone',
            'gender',
            'age',
            'units',
            'weight',
            'height',
            'goals',
            'bio',
            'profile_picture',
            'role',
            'date_joined']


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
        password = validated_data.pop('password')
        user = CustomUser(
            username=validated_data.get('username'),
            email=validated_data.get('email'),
            firstName=validated_data.get('firstName', ''),
            lastName=validated_data.get('lastName', ''),
            dob=validated_data.get('dob'),
            phone=validated_data.get('phone', ''),
            gender=validated_data.get('gender', ''),
            age=validated_data.get('age'),
            units=validated_data.get('units', ''),
            weight=validated_data.get('weight'),
            height=validated_data.get('height'),
            goals=validated_data.get('goals', ''),
            bio=validated_data.get('bio', ''),
            profile_picture=validated_data.get('profile_picture', ''),
            role=validated_data.get('role', 'Free'),
        )
        user.set_password(password)
        user.save()
        return user
