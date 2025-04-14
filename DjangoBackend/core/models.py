# core/models.py
from django.db import models
from django.utils import timezone
import json

# Generic segment for AI model
class BodySegment(models.TextChoices):
    """Standardized body segments for tracking"""
    HEAD = "HD", "Head"
    TORSO_UPPER = "TU", "Upper Torso"
    TORSO_LOWER = "TL", "Lower Torso"
    ARM_L_UPPER = "ALU", "Left Upper Arm"
    ARM_L_LOWER = "ALL", "Left Lower Arm"
    ARM_R_UPPER = "ARU", "Right Upper Arm"
    ARM_R_LOWER = "ARL", "Right Lower Arm"
    LEG_L_UPPER = "LLU", "Left Upper Leg"
    LEG_L_LOWER = "LLL", "Left Lower Leg"
    LEG_R_UPPER = "LRU", "Right Upper Leg"
    LEG_R_LOWER = "LRL", "Right Lower Leg"

class BaseTimeStampModel(models.Model):
    """Base model with timestamps"""
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        abstract = True

# Logging
class RequestLog(models.Model):
    """Model to store HTTP request logs from Django and Nginx"""
    
    # Request metadata
    timestamp = models.DateTimeField(default=timezone.now)
    source = models.CharField(max_length=10, choices=[
        ('DJANGO', 'Django'),
        ('NGINX', 'Nginx'),
    ])
    
    # Request details
    ip_address = models.GenericIPAddressField(null=True, blank=True)
    method = models.CharField(max_length=10, blank=True)
    path = models.CharField(max_length=255)
    status_code = models.IntegerField(null=True, blank=True)
    user_agent = models.TextField(blank=True)
    referer = models.URLField(blank=True, null=True)
    
    # Performance metrics
    response_time = models.FloatField(null=True, blank=True, help_text="Response time in seconds")
    
    # Additional data
    request_body = models.TextField(blank=True, null=True)
    extra_data = models.JSONField(null=True, blank=True)
    
    class Meta:
        ordering = ['-timestamp']
        indexes = [
            models.Index(fields=['timestamp']),
            models.Index(fields=['source']),
            models.Index(fields=['ip_address']),
            models.Index(fields=['status_code']),
            models.Index(fields=['path']),
        ]
    
    def __str__(self):
        return f"{self.source} - {self.timestamp} - {self.path} - {self.status_code}"

class ServerMetric(models.Model):
    """Model to store server performance metrics"""
    
    timestamp = models.DateTimeField(default=timezone.now)
    cpu_usage = models.FloatField(help_text="CPU usage percentage")
    memory_usage = models.FloatField(help_text="Memory usage percentage")
    disk_usage = models.FloatField(help_text="Disk usage percentage")
    network_in = models.FloatField(help_text="Network incoming traffic in KB/s")
    network_out = models.FloatField(help_text="Network outgoing traffic in KB/s")
    
    class Meta:
        ordering = ['-timestamp']
        indexes = [
            models.Index(fields=['timestamp']),
        ]
    
    def __str__(self):
        return f"Server metrics at {self.timestamp}"