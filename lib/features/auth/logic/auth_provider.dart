import 'package:climate_sense/features/auth/data/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides a single instance of AuthService
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// Provides auth state (logged in / logged out)
final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStatechanges;
});
