ClimateSense

A full-stack mobile application that helps users understand environmental conditions, climate patterns, and sustainability insights in real time.

ClimateSense combines mobile UI, backend intelligence, and cloud services to deliver meaningful environmental awareness and decision-making support.

Overview

ClimateSense is designed to make climate information simple and actionable.
The app collects environmental data, processes it through a backend API, and presents insights to users through an intuitive mobile interface.

The system integrates:

Mobile Frontend → Flutter

Backend API → FastAPI

Database & Auth → Firebase

Cloud Services → Google Cloud

Users can view environmental conditions, analyze patterns, and become more aware of their surroundings.

Features

Real-time environmental data visualization

User authentication

Cloud-based data storage

Backend prediction & processing

Mobile-first UI/UX

Scalable architecture

Tech Stack
Frontend

Flutter

Dart

Backend

FastAPI (Python)

Database & Authentication

Firebase Firestore

Firebase Authentication

Cloud

Google Cloud Platform

Project Structure
ClimateSense/
│
├── frontend/flutter_app        → Mobile application (Flutter)
│
├── backend/fastapi_app         → API & data processing (FastAPI)
│
├── pubspec.lock                → Flutter dependencies
│
└── .gitignore

Architecture Flow

User → Flutter App → FastAPI Backend → Firebase/Google Cloud → Processed Data → Flutter UI

Installation & Setup
1. Clone the Repository
git clone https://github.com/kalviumcommunity/S62-0126-PineappleLassi-Full-Stack-with-Flutter-Firebase-googlecloud-ClimateSense.git
cd S62-0126-PineappleLassi-Full-Stack-with-Flutter-Firebase-googlecloud-ClimateSense

2. Frontend Setup (Flutter)
cd frontend/flutter_app
flutter pub get
flutter run

3. Backend Setup (FastAPI)
cd backend/fastapi_app

python -m venv venv
source venv/bin/activate      # Linux / Mac
venv\Scripts\activate         # Windows

pip install -r requirements.txt
uvicorn main:app --reload


Backend will run at:

http://127.0.0.1:8000

4. Firebase Configuration

Create a Firebase project

Enable Authentication

Enable Firestore Database

Download config file

Place it inside Flutter project

Usage

Run backend server

Run Flutter app

Login / Register

View climate insights & data

Learning Goals

This project demonstrates:

Full-stack mobile architecture

API communication

Cloud integration

Real-time data handling

Authentication & storage

Production-like project structure

Future Improvements

AI-based climate prediction

Location-based alerts

Sustainability recommendations

Push notifications

Offline data caching

Contributors

Nidhish
Levi 
Paul

License

This project is developed for educational purposes.
