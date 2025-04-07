from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from rest_framework_simplejwt.tokens import RefreshToken
from django.contrib.auth import login, authenticate
from django.contrib.auth.forms import UserCreationForm
from rest_framework.generics import ListAPIView
from rest_framework.serializers import ModelSerializer
from rest_framework.permissions import BasePermission, IsAuthenticated
from .models import CustomUser, UserRoles  # Ensure UserRoles is correctly imported
from django.shortcuts import render, redirect


# Correct Permission Class
class IsAdminUserOnly(BasePermission):
    def has_permission(self, request, view):
        return (
            request.user and 
            request.user.is_authenticated and 
            request.user.role.lower() == "admin"  # Convert to lowercase for consistency
        )

# User Serializer
class UserSerializer(ModelSerializer):
    class Meta:
        model = CustomUser  
        fields = ['id', 'username', 'full_name', 'date_of_birth', 'bio', 'profile_picture']

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
    username = request.data.get('username')
    password = request.data.get('password')
    role = request.data.get('role', 'Free')  # Default role

    if CustomUser.objects.filter(username=username).exists():
        return Response({'error': 'User already exists'}, status=400)

    user = CustomUser.objects.create_user(username=username, password=password, role=role)
    refresh = RefreshToken.for_user(user)
    
    return Response({
        'id': user.id,
        'username': user.username,
        'role': user.role,
        'refresh': str(refresh),
        'access': str(refresh.access_token),
    })

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
