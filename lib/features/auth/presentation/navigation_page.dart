import 'package:climate_sense/features/dashboard/presentation/climate_dashboard_page.dart';
import 'package:climate_sense/features/reports/presentation/community_reports_page.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _HomePageState();
}

class _HomePageState extends State<NavigationPage>
    with TickerProviderStateMixin {
  int currentIndex = 0;
  late final List<Widget> pages;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    pages = const [ClimateDashboardPage(), CommunityReportsPage()];

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (index != currentIndex) {
      _animationController.forward(from: 0);
      setState(() {
        currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // Main content with bottom padding to avoid navbar overlap
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 90), // Space for navbar
              child: IndexedStack(index: currentIndex, children: pages),
            ),
          ),

          // Bottom Navigation Bar - Universal Design
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _UniversalBottomNavBar(
              currentIndex: currentIndex,
              onTap: _onTabTapped,
              animationController: _animationController,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// UNIVERSAL BOTTOM NAVIGATION BAR
// ============================================================================
class _UniversalBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final AnimationController animationController;

  const _UniversalBottomNavBar({
    required this.currentIndex,
    required this.onTap,
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        bottomPadding > 0 ? bottomPadding : 10,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              // Universal gradient that works on any background
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        Colors.grey.shade900.withValues(alpha: 0.8),
                        Colors.grey.shade800.withValues(alpha: 0.7),
                      ]
                    : [
                        Colors.white.withValues(alpha: 0.8),
                        Colors.white.withValues(alpha: 0.6),
                      ],
              ),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.white.withValues(alpha: 0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.3)
                      : Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavBarItem(
                  icon: Icons.dashboard_rounded,
                  label: 'Dashboard',
                  isSelected: currentIndex == 0,
                  onTap: () => onTap(0),
                  animationController: animationController,
                  isDark: isDark,
                ),
                _NavBarItem(
                  icon: Icons.groups_rounded,
                  label: 'Reports',
                  isSelected: currentIndex == 1,
                  onTap: () => onTap(1),
                  animationController: animationController,
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// NAVIGATION BAR ITEM
// ============================================================================
class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final AnimationController animationController;
  final bool isDark;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.animationController,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    // Define accent color for selected state
    final accentColor = Theme.of(context).colorScheme.primary;
    final textColor = isDark ? Colors.white : Colors.grey.shade800;
    final selectedBgColor = isDark
        ? Colors.white.withValues(alpha: 0.15)
        : Theme.of(context).colorScheme.primary.withValues(alpha: 0.1);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? selectedBgColor : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: isSelected
                        ? 1.0 + (animationController.value * 0.2)
                        : 1.0,
                    child: Icon(
                      icon,
                      color: isSelected ? accentColor : textColor,
                      size: isSelected ? 26 : 23,
                    ),
                  );
                },
              ),
              const SizedBox(height: 2),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  color: isSelected ? accentColor : textColor,
                  fontSize: isSelected ? 11 : 10,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  overflow: TextOverflow.clip,
                ),
                child: Text(label, maxLines: 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*
ICON OPTIONS:
Dashboard alternatives:
- Icons.dashboard_rounded ✓ (current)
- Icons.home_rounded
- Icons.analytics_rounded
- Icons.speed_rounded
- Icons.wb_sunny_rounded (weather theme)

Reports alternatives:
- Icons.groups_rounded ✓ (current)
- Icons.people_rounded
- Icons.report_problem_rounded
- Icons.feedback_rounded
- Icons.forum_rounded

Additional tabs you might add:
- Map: Icons.map_rounded
- Alerts: Icons.notifications_rounded
- Profile: Icons.person_rounded
- Settings: Icons.settings_rounded
*/
