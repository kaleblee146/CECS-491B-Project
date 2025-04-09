# Resources App

## Overview
The Resources app manages educational content, tutorials, and reference materials for the MoveMentor project. It serves as a knowledge base to help users understand proper exercise techniques and fitness concepts.

## Structure

- **__init__.py:** Marks the directory as a Python package.
- **admin.py:** Registers content models for Django admin.
- **apps.py:** Configuration for the resources app.
- **models.py:** Contains models for articles, tutorials, and resource categories.
- **tests.py:** Unit tests for resource functionalities.
- **views.py:** Manages content display and search.
- **templates/:** Contains templates for displaying educational content.
- **migrations/:** Manages schema changes for content models.

## Models

### ResourceCategory
Categorizes educational content by topic or purpose.

### Article
Educational articles and blog posts with rich content.

### Tutorial
Video or media-rich tutorials for exercise instruction.

## Future Plans
- **Content Management System:** Develop tools for creating and editing content.
- **Rich Text Support:** Integrate rich text editors for articles and guides.
- **Categorization and Tagging:** Add features for content organization.
- **User-Generated Content:** Allow premium users to contribute content.
- **Content Recommendations:** Implement a recommendation system based on user goals and activities.