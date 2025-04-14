# Core App

## Overview
The Core app serves as a foundation for shared components, utilities, and base models used across the MoveMentor project. It centralizes common functionality to promote code reusability and maintain consistency throughout the application.

## Structure

- **__init__.py:** Marks this directory as a Python package.
- **admin.py:** Registers shared models for Django admin access.
- **apps.py:** Configuration for the core app.
- **models.py:** Contains base models, abstract classes, and shared enums (like BodySegment).
- **tests.py:** Unit tests for core functionality.
- **urls.py** Defines URL patterns and routes requests to views.
- **migrations/:** Manages database schema migrations for core models.

## Models

### BodySegment
A TextChoices class defining standardized body segments used for exercise tracking and analysis.

### BaseTimeStampModel
An abstract model that provides created_at and updated_at fields for model inheritance.

## Future Plans
- **Extended Base Models:** Add more abstract models for common patterns.
- **Service Layer:** Implement service classes for business logic abstraction.
- **API Utilities:** Create reusable components for API standardization.
- **Performance Monitoring:** Add utilities for monitoring application performance.