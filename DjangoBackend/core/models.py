# core/models.py
from django.db import models

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