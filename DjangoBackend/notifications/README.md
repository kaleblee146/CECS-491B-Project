# Notifications App

## Overview
The Notifications app manages communication, alerts, and feedback within the MoveMentor project. It provides a centralized system for delivering messages to users through various channels, including in-app alerts, emails, and exercise feedback.

## Structure

- **__init__.py:** Marks the app as a Python package.
- **admin.py:** Registers notification models for admin management.
- **apps.py:** Configuration for the notifications app.
- **models.py:** Contains models for notifications and form corrections.
- **tests.py:** Unit tests for notification functionalities.
- **views.py:** Handles notification delivery and management.
- **templates/:** Contains email and notification templates.
- **migrations/:** Tracks database schema changes.

## Models

### Notification
Base model for user notifications of various types.

### FormCorrection
AI-generated real-time feedback on exercise form.

## Future Plans
- **Email Notifications:** Implement robust email handling.
- **In-app Alerts:** Develop a system for real-time notifications.
- **SMS Integration:** Explore SMS notifications if required.
- **Notification Preferences:** Allow users to customize notification settings.
- **Real-time Feedback:** Enhance exercise feedback with real-time suggestions.
- **services/:** Directory for notification processing services.
  - **email_service.py:** Handles email delivery.
  - **push_service.py:** Manages push notifications.