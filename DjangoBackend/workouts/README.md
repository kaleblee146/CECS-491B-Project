# Workouts App

## Overview
The Workouts app manages exercise sessions, workout logging, and progress tracking for the MoveMentor project. It provides the core functionality for recording and analyzing exercise performance.

## Structure

- **__init__.py:** Marks the directory as a Python package.
- **admin.py:** Registers workout-related models for Django admin.
- **apps.py:** Configuration for the workouts app.
- **models.py:** Contains models for workouts, exercises, and sets.
- **tests.py:** Unit tests for workout functionalities.
- **views.py:** Handles business logic for managing workouts.
- **urls.py** Defines URL patterns and routes requests to views.
- **forms.py:** Defines forms for scheduling and logging workouts.
- **templates/:** Contains templates for displaying workout information.
- **migrations/:** Manages database schema changes.

## Models

### ExerciseType
Template for exercises with form guidelines and target muscles.

### Workout
A complete workout session with metadata.

### Exercise
Instance of an exercise performed in a workout.

### ExerciseSet
A set of repetitions for an exercise with performance data.

## Future Plans
- **Advanced Scheduling:** Develop features for personalized workout plans.
- **Progress Tracking:** Implement detailed metrics and performance tracking.
- **Integration:** Enable better data integration with analytics and user profiles.
- **Exercise Library:** Build a comprehensive database of exercise types with form guidelines.
- **Video Integration:** Add support for recording and analyzing exercise videos.