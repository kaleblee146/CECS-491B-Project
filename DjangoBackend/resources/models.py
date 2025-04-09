# resources/models.py
from django.db import models
from django.conf import settings
from workouts.models import ExerciseType

class ResourceCategory(models.Model):
    """Categories for educational content"""
    name = models.CharField(max_length=100)
    slug = models.SlugField(unique=True)
    description = models.TextField(blank=True)
    
    def __str__(self):
        return self.name
    
    class Meta:
        verbose_name_plural = "Resource categories"

class Article(models.Model):
    """Educational articles and blog posts"""
    title = models.CharField(max_length=200)
    slug = models.SlugField(unique=True)
    author = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.PROTECT,
        related_name='articles'
    )
    category = models.ForeignKey(
        ResourceCategory,
        on_delete=models.PROTECT,
        related_name='articles'
    )
    content = models.TextField()
    summary = models.TextField(blank=True)
    featured_image = models.URLField(blank=True)
    published = models.BooleanField(default=False)
    published_date = models.DateTimeField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    related_exercises = models.ManyToManyField(
        ExerciseType,
        blank=True,
        related_name='related_articles'
    )
    
    def __str__(self):
        return self.title

class Tutorial(models.Model):
    """Video or media-rich tutorials"""
    title = models.CharField(max_length=200)
    slug = models.SlugField(unique=True)
    description = models.TextField()
    video_url = models.URLField()
    duration = models.DurationField()
    difficulty_level = models.PositiveSmallIntegerField(default=1)
    category = models.ForeignKey(
        ResourceCategory,
        on_delete=models.PROTECT,
        related_name='tutorials'
    )
    published = models.BooleanField(default=False)
    published_date = models.DateTimeField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    related_exercises = models.ManyToManyField(
        ExerciseType,
        blank=True,
        related_name='related_tutorials'
    )
    
    def __str__(self):
        return self.title