# Task Manager App

A clean and efficient Flutter task manager that demonstrates a complete user flow from login to task management. It includes persistent local storage, smooth animations, and a modern Material 3 interface built for a polished user experience [web:2][web:3][web:6].

## Features

- User authentication with email and password validation.
- Animated splash screen with Lottie after login.
- Full task CRUD:
    - Create tasks with title and optional description.
    - View all saved tasks.
    - Edit task details or toggle completion status.
    - Delete tasks with confirmation.
- Local persistence using `shared_preferences`.
- Responsive Material 3 UI.

## Demo Flow

1. Login with valid credentials.
2. View a 3-second animated splash screen.
3. Manage tasks on the home dashboard.

## Tech Stack

- Flutter
- Dart
- `shared_preferences`
- `lottie`

## Project Structure

```text
lib/
├── main.dart
├── models/
│   └── task.dart
├── screens/
│   ├── login_screen.dart
│   ├── splash_screen.dart
│   └── home_screen.dart
└── services/
    └── task_service.dart
```

## Getting Started

### Prerequisites

- Flutter SDK installed.
- A connected device or emulator.
- Android Studio, VS Code, or another Flutter-compatible editor.

### Installation

```bash
git clone https://github.com/GulrezQayyum/flutter-development-intern-task1.git
cd flutter-development-intern-task1
flutter pub get
flutter run
```

## Future Improvements

- Add task categories and priorities.
- Add due dates and reminders.
- Add search and filter functionality.
- Sync tasks with cloud storage.
- Improve authentication with real backend support.

## Contributing

Contributions are welcome. Feel free to fork the repository and submit a pull request with improvements.
