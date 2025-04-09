# MoveMentor Project

MoveMentor is an AI-powered form tracking app that provides users with real-time feedback on their movements and delivers customized, AI-generated workout plans tailored to individual goals.

## Table of Contents

1. [Directory Structure](#directory-structure)
2. [Prerequisites](#prerequisites)
3. [AWS EC2 Server Setup](#aws-ec2-server-setup)
4. [Component Overviews](#component-overviews)
5. [Contributing](#contributing)
6. [License](#license)
6. [Contributing](#contributing)
7. [License](#license)

## Directory Structure

```bash
(env) chasesansom@Chases-MacBook-Pro-2 MoveMentor Project % tree -L 3
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
│   ├── PoseFinder.xcodeproj
│   │   ├── project.pbxproj
│   │   ├── project.xcworkspace
│   │   └── xcshareddata
│   └── readme.rd
├── DjangoBackend
│   ├── analytics
│   ├── backend
│   ├── core
│   ├── manage.py
│   ├── notifications
│   ├── plans
│   ├── requirements.txt
│   ├── resources
│   ├── users
│   └── workouts
├── MoveMentorApp
│   ├── MoveMentorApp
│   ├── MoveMentorApp.xcodeproj
│   ├── MoveMentorAppTests
│   └── MoveMentorAppUITests
├── README.md
├── env
│   ├── bin
│   ├── etc
│   ├── include
│   ├── lib
│   ├── pyvenv.cfg
│   └── share
└── moveMentorPhoneTest
    ├── moveMentorPhoneTest
    ├── moveMentorPhoneTest.xcodeproj
    ├── moveMentorPhoneTestTests
    └── moveMentorPhoneTestUITests
```

## Prerequisites

- **macOS** (required for Xcode projects)
- **Xcode 13+** (for building iOS front-end)
- **Python 3.8+** (for backend and camera app)
- **pip** (Python package installer)
- **AWS CLI** (for provisioning RDS)
- **Virtualenv** (recommended)

## AWS EC2 Server Setup

1. SSH into AWS RDS EC2 server
    
    ```bash
    ssh -i "AWS RDS"/movementordb.pem ec2-user@52.53.157.43
    ```
    
2. New server? (Otherwise skip)
    
    ```bash
    sudo yum update -y
    sudo yum install python3 pip git -y
    pip3 install virtualenv
    ```
    
3. Clone GitHub repository
    
    ```bash
    git clone https://github.com/kaleblee146/CECS-491B-Project.git
    ```
    
4. Authenticate with GitHub if necessary to clone the repository

5. Setup and activate virtual environment
    
    ```bash
    python3 -m venv env
    source env/bin/activate
    ```
    
6. Install dependencies
    
    ```bash
    pip install -r requirements.txt
    ```
    
7. Make and apply migrations
    
    ```bash
    python manage.py makemigrations
    python manage.py migrate
    ```
    
8. Run the server
    
    ```bash
    python manage.py runserver 0.0.0.0:8000
    ```
    
9. Access the application
    
    http://52.53.157.43:8000

## Component Overviews

### AWS RDS

Contains keys, scripts, and configuration for provisioning and managing the PostgreSQL database in AWS RDS. Ensure you secure access and rotate credentials regularly.

### Camera

A Swift-based camera tracking application that captures and streams video for real-time movement analysis, with data processing handled in Python on the backend.

### DjangoBackend

The RESTful API built with Django and Django REST Framework. Responsible for:

- User authentication and authorization
- Storing and retrieving movement analytics
- Exposing endpoints for mobile and camera clients
- Admin interface for data inspection

### MoveMentorApp

An early draft of the iOS front-end, written in Swift and developed in Xcode. Features include:

- User login and profile management
- Basic navigation structure

> **Note:** This draft is experimental and may be unstable.

### moveMentorPhoneTest

The current working version of the iOS front-end, written in Swift. This is the main mobile application intended for testing and production builds.

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

