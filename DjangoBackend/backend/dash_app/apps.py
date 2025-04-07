from django.apps import AppConfig

# Default
#class DashAppConfig(AppConfig):
#    default_auto_field = 'django.db.models.BigAutoField'
#    name = 'dash_app'

class DashAppConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'backend.dash_app'
    def ready(self):
        # Import the dash.py file so that DjangoPlotlyDash registers the Dash app
        import backend.dash_app.dash_apps.dash
