# analytics/models.py
from django.db import models
from workouts.models import ExerciseSet
from core.models import BodySegment

class BodySegmentPosition(models.Model):
    """
    Tracks 3D position and orientation of body segments during exercises.
    Uses relative coordinates (0-1) normalized to user's body dimensions.
    """
    exercise_set = models.ForeignKey(
        ExerciseSet,
        on_delete=models.CASCADE,
        related_name='segment_positions'
    )
    timestamp = models.FloatField(help_text="Time in seconds from set start")
    segment = models.CharField(max_length=3, choices=BodySegment.choices)
    
    # Position (normalized to body dimensions)
    x = models.FloatField(help_text="Left/Right position (0=left, 1=right)")
    y = models.FloatField(help_text="Vertical position (0=bottom, 1=top)")
    z = models.FloatField(help_text="Forward/Back position (0=front, 1=back)")
    
    # Orientation (Euler angles)
    pitch = models.FloatField(help_text="Nodding angle (degrees)")
    yaw = models.FloatField(help_text="Shaking angle (degrees)")
    roll = models.FloatField(help_text="Tilting angle (degrees)")
    
    # Relationships to adjacent segments
    angle_to_parent = models.FloatField(
        help_text="Angle difference from proximal segment (degrees)"
    )
    distance_to_parent = models.FloatField(
        help_text="Distance from joint to parent segment (normalized)"
    )

    class Meta:
        indexes = [
            models.Index(fields=['exercise_set', 'timestamp']),
            models.Index(fields=['segment'])
        ]
        ordering = ['timestamp']

    def __str__(self):
        return f"{self.get_segment_display()} @ {self.timestamp}s"

class ExerciseAnalysis(models.Model):
    """Aggregated metrics for each exercise set"""
    exercise_set = models.OneToOneField(
        ExerciseSet,
        on_delete=models.CASCADE,
        related_name='analysis'
    )
    
    # Segment-specific metrics
    segment_ranges = models.JSONField(
        default=dict,
        help_text="Max angular ranges per segment during movement"
    )
    joint_centering = models.JSONField(
        default=dict,
        help_text="Joint alignment scores (0-100)"
    )
    
    # Composite scores
    symmetry_score = models.FloatField(
        null=True,
        blank=True,
        help_text="Left/right movement symmetry (0-100)"
    )
    fluidity_score = models.FloatField(
        null=True,
        blank=True,
        help_text="Movement smoothness (0-100)"
    )

    def calculate_segment_metrics(self):
        """Process raw position data into actionable metrics"""
        positions = self.exercise_set.segment_positions.all()
        # Implementation would use vector math to calculate:
        # - Angular ranges
        # - Velocity profiles
        # - Bilateral symmetry
        pass