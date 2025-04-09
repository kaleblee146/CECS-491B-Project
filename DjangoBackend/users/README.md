# Users App

## Overview
The Users app manages user authentication, registration, and profile management for the MoveMentor project. It serves as the foundation for handling user accounts, roles, and preferences.

## Structure

- **__init__.py:** Marks this directory as a Python package.
- **admin.py:** Registers user models for Django admin.
- **apps.py:** Configuration for the users app.
- **models.py:** Contains the CustomUser model and related profile data.
- **tests.py:** Unit tests for user-related functionalities.
- **views.py:** Handles authentication, registration, and profile management.
- **forms.py:** Defines forms for user registration and profile updates.
- **urls.py** Defines URL patterns and routes requests to views.
- **templates/:** Holds templates for user-related pages.
- **static/:** Contains CSS files for styling.
- **migrations/:** Tracks database schema changes.

## Models

### CustomUser
Extends Django's AbstractUser with additional profile fields:
- Physical attributes (height, weight, etc.)
- Personal information (firstName, lastName, etc.)
- Preferences (units, goals)
- Role-based access (Free, Premium, Admin)

## Future Plans
- **Enhanced Authentication:** Implement advanced security measures.
- **Social Authentication:** Integrate with third-party authentication services.
- **User Analytics:** Add features for tracking user engagement and activity.
- **Role-Based Permissions:** Expand the permission system based on user roles.
- **Profile Customization:** Add more profile customization options.