import 'package:climate_sense/features/auth/logic/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Demodashboard extends ConsumerWidget {
  const Demodashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Center(child: Text("Dashboard")),
        ElevatedButton(
          onPressed: () async {
            await ref.read(authServiceProvider).signOut();
          },
          child: Text("Logout"),
        ),
      ],
    );
  }
}
