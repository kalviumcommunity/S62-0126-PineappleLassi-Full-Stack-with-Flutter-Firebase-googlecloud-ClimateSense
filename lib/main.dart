import 'package:climate_sense/features/auth/logic/auth_provider.dart';
import 'package:climate_sense/features/auth/presentation/auth_wrapper.dart';
import 'package:flutter/material.dart';
import 'core/config/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './features/welcome/presentation/onboarding_page.dart';

import 'features/reports/presentation/community_reports_page.dart';
import 'features/reports/presentation/report_issue_form.dart';
import 'features/reports/presentation/report_preview_page.dart';
import 'features/reports/presentation/report_success_page.dart';
import 'features/dashboard/presentation/dashboard.dart';




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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Montserrat'),
      // Start with AuthWrapper
      home: CommunityReportsPage(),

      routes: {
        '/onboarding': (context) => OnboardingPage(),
        // '/dashboard': (context) => DashboardPage(),
        '/community-reports': (context) => CommunityReportsPage(),
        '/report-issue': (context) => ReportIssueFormPage(),
        '/report-preview': (context) => ReportPreviewPage(),
        '/report-success': (context) => ReportSuccessPage(),
      },
    );
  }
}