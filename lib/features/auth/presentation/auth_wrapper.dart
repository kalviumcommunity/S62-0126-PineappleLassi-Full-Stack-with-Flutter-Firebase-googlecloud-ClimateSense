import 'package:climate_sense/features/auth/logic/auth_provider.dart';
import 'package:climate_sense/features/auth/presentation/welcome_page.dart';
import 'package:climate_sense/features/dashboard/presentation/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key, this.pageIfNotConnected});

  final Widget? pageIfNotConnected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) =>
          Scaffold(body: Center(child: Text(error.toString()))),
      data: (user) {
        if (user != null) {
          return const Dashboard();
        } else {
          return pageIfNotConnected ?? const WelcomeScreen();
        }
      },
    );
  }
}
