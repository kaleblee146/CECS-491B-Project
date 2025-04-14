# core/middleware.py
import time
import json
from .models import RequestLog

class RequestLoggingMiddleware:
    """Django middleware to log all HTTP requests"""
    
    def __init__(self, get_response):
        self.get_response = get_response
        
    def __call__(self, request):
        start_time = time.time()
        
        # Process the request
        response = self.get_response(request)
        
        # Calculate response time
        response_time = time.time() - start_time
        
        # Don't log requests to static files or admin media
        path = request.path
        if not (path.startswith('/static/') or path.startswith('/media/') or path.startswith('/admin/jsi18n/')):
            # Create log entry
            try:
                # Safely get request body if possible
                request_body = None
                if request.method in ('POST', 'PUT', 'PATCH') and hasattr(request, 'body'):
                    try:
                        # Try to parse JSON
                        if 'application/json' in request.headers.get('Content-Type', ''):
                            request_body = json.loads(request.body.decode('utf-8'))
                        # For form data, use POST dict
                        elif hasattr(request, 'POST'):
                            request_body = dict(request.POST)
                    except:
                        request_body = None
                
                # Create log entry
                RequestLog.objects.create(
                    source='DJANGO',
                    ip_address=self.get_client_ip(request),
                    method=request.method,
                    path=request.path,
                    status_code=response.status_code,
                    user_agent=request.headers.get('User-Agent', ''),
                    referer=request.headers.get('Referer', ''),
                    response_time=response_time,
                    request_body=json.dumps(request_body) if request_body else None,
                    extra_data={
                        'user_id': request.user.id if request.user.is_authenticated else None,
                        'query_params': dict(request.GET),
                    }
                )
            except Exception as e:
                # Just to be safe - we don't want the logging to break the app
                print(f"Error logging request: {str(e)}")
                
        return response
    
    def get_client_ip(self, request):
        """Extract real client IP, considering proxy headers"""
        x_forwarded_for = request.headers.get('X-Forwarded-For')
        if x_forwarded_for:
            ip = x_forwarded_for.split(',')[0].strip()
        else:
            ip = request.META.get('REMOTE_ADDR')
        return ip


