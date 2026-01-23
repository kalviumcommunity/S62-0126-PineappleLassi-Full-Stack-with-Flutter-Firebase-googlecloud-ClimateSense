# Flutter Project Structure Documentation

## Introduction
Flutter follows a well-organized and modular project structure that separates application logic, platform-specific code, assets, and configuration files. Understanding this structure helps developers navigate the codebase easily and build scalable, maintainable applications.

This document explains the purpose of each major folder and file in a default Flutter project.

---

## Project Folder Hierarchy

project_structure_demo/
│
├── lib/
│ ├── main.dart
│ ├── screens/
│ ├── widgets/
│ ├── services/
│ └── models/
│
├── android/
├── ios/
├── assets/
│ ├── images/
│ └── fonts/
│
├── test/
├── pubspec.yaml
├── README.md
├── PROJECT_STRUCTURE.md
├── .gitignore
└── build/

---

## Folder and File Descriptions

### lib/
The `lib` folder contains all Dart code and represents the core logic of the Flutter application.

- **main.dart**  
  The entry point of the application. It initializes and runs the app using the `runApp()` function.

- **screens/**  
  Contains full-page UI screens such as home, login, or dashboard screens.

- **widgets/**  
  Stores reusable UI components like buttons, cards, and custom widgets.

- **services/**  
  Handles business logic, API calls, and data-related operations.

- **models/**  
  Defines data models and structures used throughout the application.

---

### android/
Contains Android-specific files and build configurations.

- Includes Gradle build scripts and AndroidManifest files.
- Enables the Flutter app to run as a native Android application.

---

### ios/
Contains iOS-specific configuration and native files.

- Used when building the app for iPhone or iPad using Xcode.
- Key file: `Info.plist`, which manages app permissions and metadata.

---

### assets/
Stores static resources used in the application.

- Images, fonts, and JSON files are placed here.
- Assets must be declared in `pubspec.yaml` before use.

---

### test/
Contains unit tests and widget tests.

- The default `widget_test.dart` verifies basic app behavior.
- Encourages test-driven development and quality assurance.

---

### pubspec.yaml
The main configuration file for the Flutter project.

- Manages dependencies, assets, fonts, and project metadata.
- Every new package or asset must be registered here.

---

## Supporting Files

- **.gitignore**  
  Specifies files and folders that should not be tracked by Git.

- **README.md**  
  Describes the project purpose, setup instructions, and documentation references.

- **build/**  
  Auto-generated folder containing compiled files. This folder should not be edited manually.

---

## Reflection
Understanding Flutter’s project structure makes it easier to organize code, scale applications, and collaborate with team members. A clear separation of responsibilities improves readability, reduces errors, and speeds up development by allowing developers to quickly locate and manage different parts of the application.
