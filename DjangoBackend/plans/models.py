# plans/models.py
from django.db import models
from django.conf import settings
from workouts.models import ExerciseType

class WorkoutPlan(models.Model):
    """A structured workout program spanning multiple days"""
    name = models.CharField(max_length=100)
    description = models.TextField(blank=True)
    creator = models.ForeignKey(
        settings.AUTH_USER_MODEL, 
        on_delete=models.CASCADE,
        related_name='created_plans'
    )
    is_public = models.BooleanField(default=False)
    difficulty_level = models.PositiveSmallIntegerField(default=1)
    duration_weeks = models.PositiveSmallIntegerField(default=4)
    created_at = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return self.name

class PlanSubscription(models.Model):
    """User's active workout plan"""
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='plan_subscriptions'
    )
    plan = models.ForeignKey(
        WorkoutPlan,
        on_delete=models.CASCADE,
        related_name='subscriptions'
    )
    start_date = models.DateField()
    is_active = models.BooleanField(default=True)
    current_week = models.PositiveSmallIntegerField(default=1)
    
    def __str__(self):
        return f"{self.user.username} - {self.plan.name}"

class PlannedWorkout(models.Model):
    """Template for a workout in a plan"""
    plan = models.ForeignKey(
        WorkoutPlan, 
        on_delete=models.CASCADE,
        related_name='workouts'
    )
    name = models.CharField(max_length=100)
    description = models.TextField(blank=True)
    week_number = models.PositiveSmallIntegerField()
    
    DAY_CHOICES = [
        (1, 'Monday'),
        (2, 'Tuesday'),
        (3, 'Wednesday'),
        (4, 'Thursday'),
        (5, 'Friday'),
        (6, 'Saturday'),
        (7, 'Sunday'),
    ]
    day_of_week = models.PositiveSmallIntegerField(choices=DAY_CHOICES)
    estimated_duration = models.DurationField(null=True, blank=True)
    
    class Meta:
        ordering = ['week_number', 'day_of_week']
        
    def __str__(self):
        return f"{self.name} (Week {self.week_number}, Day {self.day_of_week})"

class PlannedExercise(models.Model):
    """Exercise included in a planned workout"""
    planned_workout = models.ForeignKey(
        PlannedWorkout,
        on_delete=models.CASCADE,
        related_name='exercises'
    )
    exercise_type = models.ForeignKey(
        ExerciseType,
        on_delete=models.CASCADE
    )
    order = models.PositiveSmallIntegerField(default=0)
    sets = models.PositiveSmallIntegerField(default=3)
    reps = models.CharField(max_length=50, default="8-12", help_text="Can be a range or single number")
    rest_seconds = models.PositiveSmallIntegerField(default=60)
    notes = models.TextField(blank=True)
    
    class Meta:
        ordering = ['order']
        
    def __str__(self):
        return f"{self.exercise_type.name} in {self.planned_workout}"