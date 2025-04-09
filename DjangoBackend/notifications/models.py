# notifications/models.py
from django.db import models
from django.conf import settings
from core.models import BodySegment
from analytics.models import ExerciseAnalysis

class Notification(models.Model):
    """Base notification model"""
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='notifications'
    )
    title = models.CharField(max_length=100)
    message = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    read = models.BooleanField(default=False)
    
    NOTIFICATION_TYPES = [
        ('SYSTEM', 'System'),
        ('ACHIEVEMENT', 'Achievement'),
        ('REMINDER', 'Reminder'),
        ('CORRECTION', 'Form Correction'),
    ]
    notification_type = models.CharField(max_length=20, choices=NOTIFICATION_TYPES)
    
    class Meta:
        ordering = ['-created_at']
        
    def __str__(self):
        return f"{self.title} for {self.user.username}"

class FormCorrection(models.Model):
    """AI-generated real-time feedback"""
    analysis = models.ForeignKey(
        ExerciseAnalysis,
        on_delete=models.CASCADE,
        related_name='corrections'
    )
    timestamp = models.FloatField()
    segment = models.CharField(max_length=3, choices=BodySegment.choices)
    
    SEVERITY_LEVELS = [
        (1, "Minor"),
        (2, "Moderate"), 
        (3, "Critical")
    ]
    severity = models.PositiveSmallIntegerField(choices=SEVERITY_LEVELS)
    message = models.TextField()
    suggested_cue = models.CharField(max_length=200)
    
    class Meta:
        ordering = ['timestamp']
        
    def __str__(self):
        return f"{self.get_severity_display()} correction at {self.timestamp}s"