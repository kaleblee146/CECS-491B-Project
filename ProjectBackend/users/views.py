from rest_framework.response import Response
from rest_framework.decorators import api_view
from rest_framework_simplejwt.tokens import RefreshToken
from django.contrib.auth import authenticate
from rest_framework.generics import ListAPIView
from rest_framework.serializers import ModelSerializer
from .models import CustomUser  # Import the correct user model

# Create your views here.   
@api_view(['POST'])
def register_user(request):
    username = request.data.get('username')
    password = request.data.get('password')

    if CustomUser.objects.filter(username=username).exists():
        return Response({'error': 'User already exists'}, status=400)

    user = CustomUser.objects.create_user(username=username, password=password)
    refresh = RefreshToken.for_user(user)
    return Response({
        'refresh': str(refresh),
        'access': str(refresh.access_token),
    })

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

# Serializer for user data
class UserSerializer(ModelSerializer):
    class Meta:
        model = CustomUser  # Ensure we use CustomUser here
        fields = ['id', 'username', 'full_name', 'date_of_birth', 'bio', 'profile_picture']

# User list view
class UserList(ListAPIView):
    queryset = CustomUser.objects.all()  # Query the custom user model
    serializer_class = UserSerializer
