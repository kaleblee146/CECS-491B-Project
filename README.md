# MoveMentor Project

MoveMentor is an AI-powered form-tracking app that provides real-time feedback on your movements and delivers customized, AI-generated workout plans tailored to your goals.

## Table of Contents

- [MoveMentor Project](#movementor-project)
  - [Table of Contents](#table-of-contents)
  - [Directory Structure](#directory-structure)
  - [Prerequisites](#prerequisites)
  - [Local Development](#local-development)
  - [Containerization \& AWS Deployment](#containerization--aws-deployment)
  - [Component Overviews](#component-overviews)
    - [Diagrams](#diagrams)
    - [DjangoBackend](#djangobackend)
    - [Web Server Stack](#web-server-stack)
    - [Camera](#camera)
    - [MoveMentorApp](#movementorapp)
  - [License](#license)

## Directory Structure

```
.
├── Diagrams/                      # System architecture and database schema diagrams
├── DjangoBackend/                 # Django server application
│   ├── analytics/                 # Movement data processing and analysis
│   ├── backend/                   # Main Django project configuration
│   │   └── dash_app/              # Data visualization dashboards
│   ├── core/                      # Shared utilities and base models
│   ├── notifications/             # User alerts and feedback system
│   ├── plans/                     # Workout programming and scheduling
│   ├── resources/                 # Educational content management
│   ├── users/                     # User authentication and profiles
│   ├── workouts/                  # Exercise tracking and logging
│   ├── .platform/                 # AWS/Nginx configuration files
│   │   └── nginx/                 # Nginx server configuration
│   ├── Dockerfile                 # Container configuration
│   ├── docker-compose.yml         # Docker services configuration
│   ├── Procfile                   # Process definitions for Gunicorn
│   ├── requirements.txt           # Python dependencies
│   └── manage.py                  # Django management script
└── MoveMentorApp/                 # iOS frontend application
    ├── MoveMentorApp/             # Main application code
    │   ├── Managers/              # Network and data management
    │   └── Views/                 # SwiftUI views and screens
    └── MoveMentorAppTests/        # Application test suite
```

## Prerequisites

- **macOS** (for building/running the iOS front-end)  
- **Xcode 13+**  
- **Python 3.8+**  
- **pip**  
- **Docker & Docker Compose**  
- **AWS CLI** & **EB CLI**  
- **Nginx** & **Gunicorn** (handled by Docker in deployment)

## Local Development

1. **Backend**  
   ```bash
   cd DjangoBackend
   docker-compose build
   docker-compose up -d
   ```
   - The Django API will be available at `http://localhost:8000`.

2. **iOS Front-end**  
   - Open `MoveMentorApp/MoveMentorApp.xcodeproj` in Xcode.  
   - In `AppConfig.swift`, set the API base URL to `http://host.docker.internal:8000`.  
   - Run on the iOS Simulator.

## Containerization & AWS Deployment

1. **Login & initialize EB**  
   ```bash
   eb init MoveMentor \
     --platform docker \
     --region us-west-1
   ```

2. **Create your environment with VPC configuration**  
   ```bash
   # Set your VPC and security group IDs
   export VPC=your-vpc-id
   export INSTANCE_SG=your-security-group-id

   # Create the environment
   eb create green-env-fresh \
     --platform "Docker running on 64bit Amazon Linux 2" \
     --elb-type application \
     --region us-west-1 \
     --vpc.id $VPC \
     --vpc.publicip \
     --vpc.elbpublic \
     --vpc.elbsubnets subnet-public-1,subnet-public-2 \
     --vpc.ec2subnets subnet-private-1,subnet-private-2 \
     --vpc.securitygroups $INSTANCE_SG \
     --instance_type t3.micro \
     --timeout 30
   ```

3. **Deploy**  
   ```bash
   eb deploy
   ```

4. **View logs** & health  
   ```bash
   eb logs
   eb health
   ```

> **Tip:** Store your DB credentials in EB environment variables or use AWS Parameter Store, not in plain text.

## Component Overviews

### Diagrams
- Database schema and entity relationship diagrams
- System architecture diagrams showing component interactions
- Visual documentation of project structure

### DjangoBackend  
- **Frameworks:** Django + Django REST Framework  
- **Responsibilities:**  
  - User authentication and authorization  
  - Movement analytics data processing
  - REST API endpoints for front-end & camera  
  - Admin interface for content management

### Web Server Stack
- **Nginx:**
  - Acts as a reverse proxy for the application
  - Handles SSL termination
  - Serves static and media files
  - Configuration in `.platform/nginx/conf.d/`

- **Gunicorn:**
  - WSGI HTTP server for running the Django application
  - Managed through Procfile for production deployment
  - Configured for reliability and performance with multiple workers

### Camera  
- Swift-based module for capturing video and streaming to the backend for pose analysis.

### MoveMentorApp  
- Swift iOS app:  
  - Login & user profile  
  - Workout plan views  
  - Real-time feedback UI  

## License

This project is licensed under the MIT License.