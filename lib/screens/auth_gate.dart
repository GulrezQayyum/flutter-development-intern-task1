import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'main_shell.dart';
import '../services/auth_service.dart';

/// Listens to Firebase auth state and shows the right screen:
/// - signed out -> LoginScreen
/// - signed in  -> MainShell (the app itself)
/// A returning user with a valid session skips the login form entirely.
class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const MainShell();
        }

        return const LoginScreen();
      },
    );
  }
}