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
    - [AWS RDS](#aws-rds)
    - [Camera](#camera)
    - [DjangoBackend](#djangobackend)
    - [MoveMentorApp](#movementorapp)
  - [License](#license)

## Directory Structure

```bash
.
├── AWS RDS
│   ├── MoveMentor.pem
│   └── movementordb.pem
├── Camera
│   ├── Configuration
│   │   └── SampleCode.xcconfig
│   ├── PoseFinder
│   │   ├── App
│   │   ├── Extensions+Types
│   │   ├── Model
│   │   ├── Pose
│   │   ├── UI
│   │   └── Utils
│   └── PoseFinder.xcodeproj
├── DjangoBackend
│   ├── Dockerfile
│   ├── requirements.txt
│   ├── manage.py
│   ├── analytics
│   ├── core
│   ├── notifications
│   ├── plans
│   ├── resources
│   ├── users
│   └── workouts
├── MoveMentorApp
│   ├── MoveMentorApp
│   ├── MoveMentorApp.xcodeproj
│   ├── MoveMentorAppTests
│   └── MoveMentorAppUITests
├── docker-compose.yml
├── Dockerrun.aws.json
├── README.md
└── env
    └── … (virtualenv files)
```

> **Note:** The old `moveMentorPhoneTest` directory has been removed. **MoveMentorApp** is now the sole iOS front-end.

## Prerequisites

- **macOS** (for building/running the iOS front-end)  
- **Xcode 13+**  
- **Python 3.8+**  
- **pip**  
- **Docker & Docker Compose**  
- **AWS CLI** & **EB CLI**  

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

2. **Create your environment** (only once)  
   ```bash
   eb create movementor-prod
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

### AWS RDS  
- Manages our PostgreSQL database.  
- **Security:** Credentials injected via environment variables; rotate keys regularly.

### Camera  
- Swift-based module for capturing video and streaming to the backend for pose analysis.

### DjangoBackend  
- **Frameworks:** Django + DRF  
- **Responsibilities:**  
  - User auth  
  - Movement analytics CRUD  
  - REST endpoints for front-end & camera  
  - Admin interface  

### MoveMentorApp  
- Swift iOS app:  
  - Login & user profile  
  - Workout plan views  
  - Real-time feedback UI  

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.