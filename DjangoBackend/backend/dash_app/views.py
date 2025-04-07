from django.shortcuts import render

# Create your views here.
# Home page/dashboard
def home_dashboard(request):
    return render(request, 'home_dynamic.html')