# users/views.py
import logging
from rest_framework import permissions, status
from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.views import APIView
from django.contrib.auth import login, authenticate
from django.contrib.auth.decorators import login_required
from django.shortcuts import render, redirect
from django.http import HttpResponse
from django.core.mail import send_mail
from django.contrib.auth.password_validation import validate_password
from django.core.exceptions import ValidationError
from django.db import connections

from rest_framework.generics import ListAPIView
from rest_framework.permissions import IsAuthenticated

from .models import CustomUser, BugReport
from .serializers import RegisterSerializer, UserSerializer
from .forms import CustomUserCreationForm
from .permissions import IsAdminUserOnly

# Configure logger
logger = logging.getLogger(__name__)

# ===== WEB VIEWS (HTML TEMPLATES) =====

def welcome_view(request):
    """Render the welcome page"""
    return render(request, 'welcome.html')

def home_view(request):
    """Render the home dashboard"""
    return render(request, "home_dynamic.html")

def login_view(request):
    """Handle user login and render login page"""
    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('password')
        user = authenticate(request, username=username, password=password)
        if user is not None:
            login(request, user)
            return redirect('home')  # Changed from 'welcome' to 'home'
    return render(request, 'login.html')

def registration_view(request):
    """Handle user registration and render registration page"""
    if request.method == "POST":
        form = CustomUserCreationForm(request.POST)
        if form.is_valid():
            user = form.save()
            login(request, user)
            return redirect("home")
    else:
        form = CustomUserCreationForm()
    return render(request, "register.html", {"form": form})

def password_reset_view(request):
    """Render password reset page"""
    return render(request, "password_reset.html")

# ===== API VIEWS (JSON RESPONSES) =====

@api_view(['POST'])
def register_user(request):
    """API endpoint for user registration"""
    logger.info(f"Registration request received: {request.data}")
    
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
        })

    logger.warning(f"Registration validation failed: {serializer.errors}")
    return Response(serializer.errors, status=400)

@api_view(['POST'])
def login_user(request):
    """API endpoint for user login"""
    username = request.data.get('username')
    password = request.data.get('password')

    user = authenticate(username=username, password=password)
    if user is None:
        logger.warning(f"Failed login attempt for username: {username}")
        return Response({'error': 'Invalid credentials'}, status=400)

    refresh = RefreshToken.for_user(user)
    return Response({
        'refresh': str(refresh),
        'access': str(refresh.access_token),
        'email': user.email,
        'username': user.username,
        'firstName': user.firstName,
        'lastName': user.lastName,
        'role': user.role,
        'id': user.id
    })

class UserList(ListAPIView):
    """API endpoint to list all users (admin only)"""
    queryset = CustomUser.objects.all()
    serializer_class = UserSerializer
    permission_classes = [IsAuthenticated, IsAdminUserOnly]

@api_view(['POST'])
def request_password_reset(request):
    """API endpoint to request password reset"""
    email = request.data.get("email")
    if not email:
        return Response({"error": "Email is required"}, status=400)

    try:
        user = CustomUser.objects.get(email=email)
        verif_code = str(random.randint(100000, 999999))
        user.reset_code = verif_code
        user.save()

        send_mail(
            subject="Your MoveMentor Password Reset Code",
            message=f"Your verification code is {verif_code}",
            from_email="noreply@movementor.com",
            recipient_list=[email]
        )

        return Response({"message": "Verification code sent!"})
    except CustomUser.DoesNotExist:
        logger.info(f"Password reset requested for non-existent email: {email}")
        return Response({"error": "Email not found"}, status=404)
    except Exception as e:
        logger.error(f"Error sending password reset email: {str(e)}")
        return Response({"error": "Failed to send reset code"}, status=500)

@api_view(['POST'])
def confirm_password_reset(request):
    """API endpoint to confirm password reset"""
    email = request.data.get("email", "").strip().lower()
    code = request.data.get("code", "").strip()
    new_password = request.data.get("new_password")

    if not all([email, code, new_password]):
        return Response({"error": "Email, code and new password are required"}, status=400)

    try:
        user = CustomUser.objects.get(email=email)

        if user.reset_code != code:
            return Response({"error": "Incorrect verification code"}, status=400)

        try:
            validate_password(new_password, user=user)
        except ValidationError as e:
            return Response({"error": e.messages}, status=400)

        user.set_password(new_password)
        user.reset_code = None  # Clear the reset code
        user.save()

        return Response({"message": "Password reset successfully!"})

    except CustomUser.DoesNotExist:
        return Response({"error": "Invalid email"}, status=404)
    except Exception as e:
        logger.error(f"Error resetting password: {str(e)}")
        return Response({"error": "Failed to reset password"}, status=500)

@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def bug_report_view(request):
    serializer = BugReportSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save(user=request.user)
        return Response(serializer.data, status=201)
    return Response(serializer.errors, status=400)

# ===== HEALTH CHECK =====

def dbtest(request):
    """Health check endpoint for database connectivity"""
    try:
        connections['default'].cursor().execute('SELECT 1')
        return HttpResponse('DB OK')
    except Exception as e:
        logger.error(f"Database connection error: {str(e)}")
        return HttpResponse(f'DB ERROR: {e}', status=500)

def simple_health(request):
    """Simple health check that doesn't require database access"""
    return HttpResponse("OK")