# Plans App

## Overview
The Plans app manages workout programming, scheduling, and progression planning in the MoveMentor project. It enables users to create and follow structured workout plans, either predefined or customized.

## Structure

- **__init__.py:** Marks this directory as a Python package.
- **admin.py:** Registers plan-related models for the Django admin interface.
- **apps.py:** Configuration for the plans app.
- **models.py:** Contains models for workout plans, schedules, and programs.
- **tests.py:** Unit tests for plan functionality.
- **views.py:** Handles business logic for managing workout plans.
- **migrations/:** Manages database schema changes.
- **templates/:** Contains templates for displaying plan information.

## Models

### WorkoutPlan
Defines a structured workout program spanning multiple days/weeks.

### PlanSubscription
Links users to their active workout plans and tracks progress.

### PlannedWorkout
Template for workouts within a plan, organized by week and day.

### PlannedExercise
Specific exercises included in a planned workout with set/rep schemes.

## Future Plans
- **Plan Templates:** Develop a library of predefined workout programs.
- **Adaptive Programming:** Implement algorithms for plan adjustments based on user progress.
- **Calendar Integration:** Add features for syncing workout plans with calendar apps.
- **Social Sharing:** Enable users to share and discover workout plans.
- **forms.py:** Defines forms for creating and editing workout plans.