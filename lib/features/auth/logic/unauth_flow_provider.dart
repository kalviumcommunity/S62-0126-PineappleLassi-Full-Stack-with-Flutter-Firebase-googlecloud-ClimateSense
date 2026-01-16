import 'package:flutter_riverpod/legacy.dart';

/// All possible unauthenticated screens
enum UnauthStep { splash, onboarding, auth, signIn, register }

/// Controls which unauth screen is currently shown
final unauthStepProvider = StateProvider<UnauthStep>(
  (ref) => UnauthStep.splash,
);
