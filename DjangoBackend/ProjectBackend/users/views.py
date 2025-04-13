from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from rest_framework_simplejwt.tokens import RefreshToken

from django.core.mail import send_mail
from django.contrib.auth import login, authenticate
from django.contrib.auth.forms import UserCreationForm

from django.contrib.auth.password_validation import validate_password
from django.core.exceptions import ValidationError

from rest_framework.generics import ListAPIView
from rest_framework.serializers import ModelSerializer
from rest_framework.permissions import BasePermission, IsAuthenticated

from google.oauth2 import id_token as google_id_token
from google.auth.transport import requests as google_requests
import requests as external_requests
from jose import jwt

from .models import CustomUser, UserRoles  # Ensure UserRoles is correctly imported
from .serializers import RegisterSerializer, UserSerializer
from django.shortcuts import render, redirect


import random


# Correct Permission Class
class IsAdminUserOnly(BasePermission):
    def has_permission(self, request, view):
        return (
            request.user and 
            request.user.is_authenticated and 
            request.user.role.lower() == "admin"  # Convert to lowercase for consistency
        )

# User List View
class UserList(ListAPIView):
    queryset = CustomUser.objects.all()
    serializer_class = UserSerializer
    permission_classes = [IsAuthenticated, IsAdminUserOnly]  # Require auth + admin

    def get(self, request, *args, **kwargs):
        print(f"Authenticated user: {request.user}")  # Debugging output
        return super().get(request, *args, **kwargs)

# Register User API
@api_view(['POST'])
def register_user(request):
    print("Incoming request data:", request.data)  # 👈 See exactly what's coming in

    serializer = RegisterSerializer(data=request.data)
    if serializer.is_valid():
        user = serializer.save()
        refresh = RefreshToken.for_user(user)

        return Response({
            'id': user.id,
            'username': user.username,
            'firstName': user.firstName,
            'lastName': user.lastName,
            'email': user.email,
            'phone': user.phone,
            'role': user.role,
            'refresh': str(refresh),
            'access': str(refresh.access_token),
            'date_joined': user.date_joined.isoformat()
            
        })

    print("Serializer errors:", serializer.errors)  
    return Response(serializer.errors, status=400)


# Login User API
@api_view(['POST'])
def login_user(request):
    username = request.data.get('username')
    password = request.data.get('password')

    user = authenticate(username=username, password=password)
    if user is None:
        return Response({'error': 'Invalid credentials'}, status=400)

    refresh = RefreshToken.for_user(user)
    return Response({
        'refresh': str(refresh),
        'access': str(refresh.access_token),
        'email': user.email,
        'username': user.username,
        'firstName': user.firstName,
        'lastName': user.lastName,
        'age': user.age,
        'height': user.height,
        'weight': user.weight,
        'role': user.role,
        'id': user.id,
        'date_joined': user.date_joined.isoformat()
    })

@api_view(['POST'])
def request_password_reset(request):
    email = request.data.get("email")

    try:
        user = CustomUser.objects.get(email=email)
        print("✅ Found user. Stored reset_code:", user.reset_code)
        verif_code = str(random.randint(100000, 999999))
        user.reset_code = verif_code
        user.save()

        send_mail(
            subject= "Your MoveMentor Password Reset Code:",
            message=f"Your verification code is {verif_code}",
            from_email="noreply@movementor.com",
            recipient_list=[email]
        )

        return Response({"message": "Verification code sent!", "code": verif_code})
    except CustomUser.DoesNotExist:
        return Response({"error": "Email not found"}, status=404)

@api_view(['POST'])
def confirm_password_reset(request):
    email = request.data.get("email").strip().lower()
    code = request.data.get("code").strip()
    new_password = request.data.get("new_password")

    print("➡️ Received email:", email)
    print("➡️ Received code:", code)

    if not new_password:
        return Response({"error": "Password cannot be empty."}, status=400)

    try:
        user = CustomUser.objects.get(email=email)
        print("✅ Found user. Stored code in DB:", user.reset_code)

        if user.reset_code != code:
            print("❌ Code mismatch!")
            return Response({"error": "Incorrect verification code."}, status=400)

        try:
            validate_password(new_password, user=user)
        except ValidationError as e:
            return Response({"error": e.messages}, status=400)

        user.set_password(new_password)
       #user.reset_code = None
        user.save()
        
        return Response({"message": "Password reset successfully!"})

    except CustomUser.DoesNotExist:
        print("❌ Email not found in database.")
        return Response({"error": "Invalid email."}, status=404)
    
@api_view(['POST'])
def social_login(request):
    id_token = request.data.get('id_token')
    provider = request.data.get('provider')

    if not id_token or not provider:
        return Response({'error': 'Missing id token or provider'}, status=400)
    
    email = None
    first_name = ''
    last_name = ''
    user_sub = ''

    try: 
        if provider == 'google':
            id_info = google_id_token.verify_oauth2_token(
                id_token,
                google_requests.Request(),
                "618878648276-tkeke30tmufij8fd0g9oala35mk1sv9c.apps.googleusercontent.com"
            )
            email = id_info.get('email')
            first_name = id_info.get('given_name', '')
            last_name = id_info.get('family_name', '')
            user_sub = id_info.get('sub')
        
        elif provider == 'apple':
            response = external_requests.get('http://appleid.apple.com/auth/keys')
            apple_keys = response.json()['keys']

            for key in apple_keys:
                try:
                    decoded = jwt.decode(id_token, key, algorithms=['RS256'], audience=".com.your.bundle.id")
                    email = decoded.get('email')
                    user_sub = decoded.get('sub')
                    break
                except Exception: 
                    continue

            if email is None:
                return Response({'error': 'Apple token verification failed'}, status=400)
        
        else:
            return Response({'error': 'Unsupported provider'}, status=400)
        
    except Exception as e:
        print(f'Token verification failed: {e}')
        return Response({'error': 'Invalid ID token'}, status=400)
    
    try:
        user = CustomUser.objects.get(email=email)
    except CustomUser.DoesNotExist:
        # Create user
        user = CustomUser.objects.create_user(
            username=email,
            email=email,
            firstName=first_name,
            lastName=last_name,
            password=CustomUser.objects.make_random_password(),
            role="user"  # or set default role logic
        )
        user.save()

    refresh = RefreshToken.for_user(user)
    return Response({
        'refresh': str(refresh),
        'access': str(refresh.access_token),
        'email': user.email,
        'username': user.username,
        'firstName': user.firstName,
        'lastName': user.lastName,
        'age': user.age,
        'height': user.height,
        'weight': user.weight,
        'role': user.role,
        'id': user.id,
        'date_joined': user.date_joined.isoformat()
    })




# Renders home.html for web users
def home_view(request):
    return render(request, "home.html")

def welcome_view(request):
    return render(request, 'welcome.html')

def login_view(request):
    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('password')
        user = authenticate(request, username=username, password=password)
        if user is not None:
            login(request, user)
            return redirect('dashboard')  # Redirect to your dashboard page
    return render(request, 'login.html')

def registration_view(request):
    if request.method == "POST":
        form = UserCreationForm(request.POST)
        if form.is_valid():
            user = form.save()
            login(request, user)
            return redirect("home")  # Redirect to home after signup
    else:
        form = UserCreationForm()
    return render(request, "users/register.html", {"form": form})
