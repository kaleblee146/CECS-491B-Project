# core/admin.py
from django.contrib import admin
from django.utils.html import format_html
from django.db.models import Count, Avg, Max, Min
from django.db.models.functions import TruncHour, TruncDay
import json
from .models import RequestLog, ServerMetric

@admin.register(RequestLog)
class RequestLogAdmin(admin.ModelAdmin):
    list_display = ('timestamp', 'source', 'ip_address', 'method', 'path_display', 
                   'status_code', 'status_colored', 'response_time_display', 'user_agent_short')
    list_filter = ('source', 'method', 'status_code', 'timestamp')
    search_fields = ('path', 'ip_address', 'user_agent')
    readonly_fields = ('request_body_formatted', 'extra_data_formatted')
    date_hierarchy = 'timestamp'
    
    def path_display(self, obj):
        """Truncate path for display"""
        if len(obj.path) > 50:
            return obj.path[:47] + "..."
        return obj.path
    path_display.short_description = "Path"
    
    def status_colored(self, obj):
        """Display status code with color based on status"""
        if not obj.status_code:
            return '-'
        
        if obj.status_code < 300:
            color = 'green'
        elif obj.status_code < 400:
            color = 'blue'
        elif obj.status_code < 500:
            color = 'orange'
        else:
            color = 'red'
            
        return format_html('<span style="color: {};">{}</span>', color, obj.status_code)
    status_colored.short_description = "Status"
    
    def response_time_display(self, obj):
        """Format response time in milliseconds"""
        if obj.response_time is None:
            return '-'
        return f"{obj.response_time * 1000:.1f} ms"
    response_time_display.short_description = "Response Time"
    
    def user_agent_short(self, obj):
        """Truncate user agent for display"""
        if not obj.user_agent:
            return '-'
        if len(obj.user_agent) > 50:
            return obj.user_agent[:47] + "..."
        return obj.user_agent
    user_agent_short.short_description = "User Agent"
    
    def request_body_formatted(self, obj):
        """Format request body as readable JSON"""
        if not obj.request_body:
            return '-'
        
        try:
            data = json.loads(obj.request_body)
            return format_html('<pre>{}</pre>', json.dumps(data, indent=2))
        except:
            return format_html('<pre>{}</pre>', obj.request_body)
    request_body_formatted.short_description = "Request Body"
    
    def extra_data_formatted(self, obj):
        """Format extra data as readable JSON"""
        if not obj.extra_data:
            return '-'
        return format_html('<pre>{}</pre>', json.dumps(obj.extra_data, indent=2))
    extra_data_formatted.short_description = "Extra Data"
    
    def get_readonly_fields(self, request, obj=None):
        """Make all fields readonly since logs should not be edited"""
        if obj:  # Editing existing object
            return [field.name for field in obj._meta.fields]
        return self.readonly_fields
        
    def has_add_permission(self, request):
        """Disable adding logs through admin"""
        return False
        
    def has_change_permission(self, request, obj=None):
        """Disable editing logs"""
        return False

    def changelist_view(self, request, extra_context=None):
        """Add statistics to the log list view"""
        extra_context = extra_context or {}
        
        # Get basic statistics
        total_requests = RequestLog.objects.count()
        avg_response_time = RequestLog.objects.aggregate(avg=Avg('response_time'))['avg']
        status_summary = RequestLog.objects.values('status_code').annotate(
            count=Count('id')).order_by('status_code')
        
        extra_context.update({
            'total_requests': total_requests,
            'avg_response_time': f"{avg_response_time * 1000:.1f} ms" if avg_response_time else "N/A",
            'status_summary': status_summary,
        })
        
        return super().changelist_view(request, extra_context=extra_context)


@admin.register(ServerMetric)
class ServerMetricAdmin(admin.ModelAdmin):
    list_display = ('timestamp', 'cpu_usage_display', 'memory_usage_display', 
                   'disk_usage_display', 'network_in_display', 'network_out_display')
    list_filter = ('timestamp',)
    date_hierarchy = 'timestamp'
    
    def cpu_usage_display(self, obj):
        """Format CPU usage with color indicator"""
        color = 'green'
        if obj.cpu_usage > 70:
            color = 'red'
        elif obj.cpu_usage > 40:
            color = 'orange'
            
        return format_html('<span style="color: {};">{:.1f}%</span>', color, obj.cpu_usage)
    cpu_usage_display.short_description = "CPU Usage"
    
    def memory_usage_display(self, obj):
        """Format memory usage with color indicator"""
        color = 'green'
        if obj.memory_usage > 80:
            color = 'red'
        elif obj.memory_usage > 60:
            color = 'orange'
            
        return format_html('<span style="color: {};">{:.1f}%</span>', color, obj.memory_usage)
    memory_usage_display.short_description = "Memory Usage"
    
    def disk_usage_display(self, obj):
        """Format disk usage with color indicator"""
        color = 'green'
        if obj.disk_usage > 90:
            color = 'red'
        elif obj.disk_usage > 70:
            color = 'orange'
            
        return format_html('<span style="color: {};">{:.1f}%</span>', color, obj.disk_usage)
    disk_usage_display.short_description = "Disk Usage"
    
    def network_in_display(self, obj):
        return f"{obj.network_in:.2f} KB/s"
    network_in_display.short_description = "Network In"
    
    def network_out_display(self, obj):
        return f"{obj.network_out:.2f} KB/s"
    network_out_display.short_description = "Network Out"
    
    def get_readonly_fields(self, request, obj=None):
        """Make all fields readonly"""
        if obj:
            return [field.name for field in obj._meta.fields]
        return self.readonly_fields
        
    def has_add_permission(self, request):
        """Disable adding metrics through admin"""
        return False
        
    def has_change_permission(self, request, obj=None):
        """Disable editing metrics"""
        return False