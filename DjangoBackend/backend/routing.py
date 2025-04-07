from channels.routing import ProtocolTypeRouter, URLRouter
from django.urls import path
from channels.auth import AuthMiddlewareStack
from django.core.asgi import get_asgi_application
import django_plotly_dash.routing

application = ProtocolTypeRouter({
    'http': get_asgi_application(),
    'websocket': AuthMiddlewareStack(
        URLRouter(
            django_plotly_dash.routing.get_routing_patterns()
        )
    ),
})