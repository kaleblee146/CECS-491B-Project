# workouts/models.py
from django.db import models
from django.conf import settings
from django.utils import timezone
from core.models import BodySegment

class ExerciseType(models.Model):
    """Exercise template with standard form parameters"""
    name = models.CharField(max_length=100)
    description = models.TextField(blank=True)
    difficulty_level = models.PositiveSmallIntegerField(default=1)
    target_muscles = models.JSONField(default=list)
    form_guidelines = models.TextField(blank=True)
    video_tutorial_url = models.URLField(blank=True)
    
    def __str__(self):
        return self.name

class Workout(models.Model):
    """A complete workout session"""
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='workouts')
    title = models.CharField(max_length=100)
    date_time = models.DateTimeField(default=timezone.now)
    duration = models.DurationField(null=True, blank=True)
    notes = models.TextField(blank=True)
    completed = models.BooleanField(default=False)
    
    def __str__(self):
        return f"{self.title} - {self.date_time.date()}"

class Exercise(models.Model):
    """Instance of an exercise performed in a workout"""
    workout = models.ForeignKey(Workout, on_delete=models.CASCADE, related_name='exercises')
    exercise_type = models.ForeignKey(ExerciseType, on_delete=models.PROTECT)
    order = models.PositiveSmallIntegerField(default=0)
    notes = models.TextField(blank=True)
    
    class Meta:
        ordering = ['order']
    
    def __str__(self):
        return f"{self.exercise_type.name} in {self.workout}"

class ExerciseSet(models.Model):
    """A set of repetitions for an exercise"""
    exercise = models.ForeignKey(Exercise, on_delete=models.CASCADE, related_name='sets')
    set_number = models.PositiveSmallIntegerField()
    reps = models.PositiveSmallIntegerField(null=True, blank=True)
    weight = models.FloatField(null=True, blank=True)
    duration = models.DurationField(null=True, blank=True)
    rest_after = models.DurationField(null=True, blank=True)
    started_at = models.DateTimeField(null=True, blank=True)
    completed_at = models.DateTimeField(null=True, blank=True)
    
    class Meta:
        ordering = ['set_number']
        unique_together = ['exercise', 'set_number']
    
    def __str__(self):
        return f"Set {self.set_number} of {self.exercise}"