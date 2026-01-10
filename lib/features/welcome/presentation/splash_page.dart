import 'package:climate_sense/features/welcome/presentation/onboarding_page.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top illustration section with orange background
            Expanded(
              flex: 6,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Stack(
                  children: [
                    // Decorative stars/sparkles
                    Positioned(
                      top: 20,
                      right: 60,
                      child: Icon(
                        Icons.add,
                        color: Colors.white.withValues(alpha: 0.6),
                        size: 16,
                      ),
                    ),
                    Positioned(
                      top: 80,
                      left: 40,
                      child: Icon(
                        Icons.add,
                        color: Colors.white.withValues(alpha: 0.6),
                        size: 16,
                      ),
                    ),
                    Positioned(
                      top: 140,
                      right: 30,
                      child: Icon(
                        Icons.add,
                        color: Colors.white.withValues(alpha: 0.6),
                        size: 16,
                      ),
                    ),
                    Positioned(
                      bottom: 80,
                      left: 20,
                      child: Icon(
                        Icons.add,
                        color: Colors.white.withValues(alpha: 0.6),
                        size: 16,
                      ),
                    ),
                    Positioned(
                      bottom: 40,
                      right: 50,
                      child: Icon(
                        Icons.add,
                        color: Colors.white.withValues(alpha: 0.6),
                        size: 16,
                      ),
                    ),
                    // Clouds
                    Positioned(top: 30, left: 20, child: _buildCloud(80, 50)),
                    Positioned(top: 40, right: 40, child: _buildCloud(100, 60)),
                    Positioned(top: 120, left: 60, child: _buildCloud(90, 55)),
                    // Placeholder for character animation
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: MediaQuery.of(context).size.width * 0.6,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            'Animation\nPlaceholder',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom content section
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.08,
                  vertical: 20,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(flex: 2),
                    // Title
                    Text(
                      'Earn rewards for\nevery step you take.',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.065,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: 16),
                    // Subtitle
                    Text(
                      'More than tracking transform\nwalking into winning.',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.038,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                    ),
                    Spacer(flex: 3),
                    // Log in button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to OnboardingPage
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OnboardingPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFF6B35),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Spacer(flex: 1),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCloud(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(height),
          topRight: Radius.circular(height),
          bottomLeft: Radius.circular(height * 0.7),
          bottomRight: Radius.circular(height * 0.7),
        ),
      ),
    );
  }
}
