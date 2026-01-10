import 'package:climate_sense/features/auth/presentation/auth_page.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _skipOrFinish() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AuthScreen()),
    );
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _skipOrFinish();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button (only show on screens 1 & 2)
            if (_currentPage < 2)
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextButton(
                    onPressed: _skipOrFinish,
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: Color(0xFFFF6B35),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              )
            else
              SizedBox(height: 56), // Maintain spacing on last page
            // PageView with onboarding screens
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  _buildOnboardingScreen(
                    icon: Icons.public,
                    title: 'Welcome to ClimateSense',
                    description:
                        'Understand your local climate. Take action. Make an impact.',
                    gradient: [Color(0xFF4CAF50), Color(0xFF81C784)],
                    additionalIcons: [
                      Icons.wb_sunny,
                      Icons.water_drop,
                      Icons.air,
                    ],
                  ),
                  _buildOnboardingScreen(
                    icon: Icons.location_on,
                    title: 'Report What You See',
                    description:
                        'Share real-time issues like flooding, pollution, heatwaves, or water shortages in your area.',
                    gradient: [Color(0xFF2196F3), Color(0xFF64B5F6)],
                    tags: ['Flood', 'Heat', 'Pollution', 'Water'],
                  ),
                  _buildOnboardingScreen(
                    icon: Icons.insights,
                    title: 'Stay Informed, Stay Safe',
                    description:
                        'View hyperlocal climate risks, alerts, and insights powered by citizen reports and official data.',
                    gradient: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
                    additionalIcons: [
                      Icons.warning_amber,
                      Icons.thermostat,
                      Icons.location_searching,
                    ],
                  ),
                ],
              ),
            ),

            // Dots indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) => _buildDot(index)),
              ),
            ),

            // Next / Get Started button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF6B35),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    _currentPage == 2 ? 'Get Started' : 'Next',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? Color(0xFFFF6B35) : Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildOnboardingScreen({
    required IconData icon,
    required String title,
    required String description,
    required List<Color> gradient,
    List<String>? tags,
    List<IconData>? additionalIcons,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration area with gradient background
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradient,
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: gradient[0].withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Main icon
                Center(child: Icon(icon, size: 120, color: Colors.white)),
                // Additional icons if provided
                if (additionalIcons != null) ...[
                  Positioned(
                    top: 30,
                    right: 30,
                    child: Icon(
                      additionalIcons[0],
                      size: 40,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                  if (additionalIcons.length > 1)
                    Positioned(
                      bottom: 40,
                      left: 30,
                      child: Icon(
                        additionalIcons[1],
                        size: 36,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  if (additionalIcons.length > 2)
                    Positioned(
                      top: 60,
                      left: 40,
                      child: Icon(
                        additionalIcons[2],
                        size: 32,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                ],
              ],
            ),
          ),
          SizedBox(height: 48),

          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              height: 1.2,
            ),
          ),
          SizedBox(height: 16),

          // Description
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),

          // Tags (if provided)
          if (tags != null) ...[
            SizedBox(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: tags.map((tag) => _buildTag(tag, gradient[0])).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTag(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
