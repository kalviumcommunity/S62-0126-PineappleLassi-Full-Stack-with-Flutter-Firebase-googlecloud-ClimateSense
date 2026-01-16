import 'package:climate_sense/features/auth/logic/auth_provider.dart';
import 'package:climate_sense/features/auth/logic/unauth_flow_provider.dart';
import 'package:climate_sense/features/auth/presentation/auth_page.dart';
import 'package:climate_sense/features/auth/presentation/register_screen.dart';
import 'package:climate_sense/features/auth/presentation/signin_screen.dart';
import 'package:climate_sense/features/dashboard/presentation/climate_dashboard_page.dart';
import 'package:climate_sense/features/dashboard/presentation/demodashboard.dart';
import 'package:climate_sense/features/welcome/presentation/splash_page.dart';
import 'package:climate_sense/features/welcome/presentation/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final unauthStep = ref.watch(unauthStepProvider);

    return authState.when(
      loading: () =>
          // TODO: Add a loading screen here
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) =>
          Scaffold(body: Center(child: Text(error.toString()))),
      data: (user) {
        if (user != null) {
          // 🔓 AUTHENTICATED
          // return const Demodashboard();
          return const ClimateDashboardPage();
        }

        // 🔐 UNAUTHENTICATED FLOW (STATE-BASED)
        switch (unauthStep) {
          case UnauthStep.splash:
            return const SplashPage();

          case UnauthStep.onboarding:
            return const OnboardingPage();

          case UnauthStep.auth:
            return const AuthScreen();

          case UnauthStep.signIn:
            return const SignInScreen();

          case UnauthStep.register:
            return const RegisterScreen();
        }
      },
    );
  }
}
