import 'package:climate_sense/features/auth/logic/auth_provider.dart';
import 'package:climate_sense/features/auth/presentation/auth_wrapper.dart';
import 'package:flutter/material.dart';
import 'core/config/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 👇 Create Riverpod container manually
  final container = ProviderContainer();

  // 👇 Initialize Google Sign-In ONCE
  await container.read(authServiceProvider).initGoogleSignIn();

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Montserrat'),
      home: AuthWrapper(),
    );
    // return MaterialApp(home: SignInScreen());
  }
}
