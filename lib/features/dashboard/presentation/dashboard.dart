import 'package:climate_sense/features/auth/logic/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Dashboard extends ConsumerWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const Center(child: Text("This is the dashboard")),
        ElevatedButton(
          onPressed: () async {
            await ref.read(authServiceProvider).signOut();
          },
          child: const Text("Logout"),
        ),
      ],
    );
  }
}
