import 'package:flutter/material.dart';
import '../data/mock_hourly_data.dart';
import '../utils/stress_color.dart';
import 'widgets/widgets.dart';

class ClimateDashboardPage extends StatefulWidget {
  const ClimateDashboardPage({super.key});

  @override
  State<ClimateDashboardPage> createState() => _ClimateDashboardPageState();
}

class _ClimateDashboardPageState extends State<ClimateDashboardPage>
    with TickerProviderStateMixin {
  // 🔢 Number animation
  late AnimationController numberController;
  late Animation<int> numberAnimation;

  // ✨ Glow animation
  late AnimationController glowController;

  // 📜 Scroll animation
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;
  double _scrollOpacity = 1.0;

  int selectedIndex = 2;

  @override
  void initState() {
    super.initState();

    // 🔢 Number animation controller
    numberController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    // ✨ Glow controller (looping)
    glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // 🔢 Initial number animation (prevents LateError)
    numberAnimation = IntTween(
      begin: hourlyData[selectedIndex].stress,
      end: hourlyData[selectedIndex].stress,
    ).animate(CurvedAnimation(parent: numberController, curve: Curves.easeOut));

    // 📜 Scroll listener
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
        _scrollOpacity = (1.0 - (_scrollOffset / 300)).clamp(0.0, 1.0);
      });
    });
  }

  void onSelect(int index) {
    numberAnimation = IntTween(
      begin: hourlyData[selectedIndex].stress,
      end: hourlyData[index].stress,
    ).animate(CurvedAnimation(parent: numberController, curve: Curves.easeOut));

    setState(() {
      selectedIndex = index;
    });

    numberController.forward(from: 0);
  }

  @override
  void dispose() {
    numberController.dispose();
    glowController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final current = hourlyData[selectedIndex];
    final stressColor = getStressColor(current.stress);

    return Scaffold(
      body: Stack(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 600),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  stressColor.withOpacity(0.3),
                  stressColor.withOpacity(0.5),
                  stressColor.withOpacity(0.7),
                ],
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: CustomScrollView(
              controller: _scrollController,
              physics: BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Opacity(
                    opacity: _scrollOpacity,
                    child: Transform.translate(
                      offset: Offset(0, _scrollOffset * 0.3),
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          const Header(),
                          SizedBox(height: 40),
                          HeroStress(
                            stress: current.stress,
                            glowController: glowController,
                            numberController: numberController,
                            numberAnimation: numberAnimation,
                          ),
                          SizedBox(height: 8),
                          InteractiveWave(
                            data: hourlyData,
                            selectedIndex: selectedIndex,
                            color: stressColor,
                            onChanged: onSelect,
                          ),
                          SizedBox(height: 30),
                          SizedBox(height: 50),

                          // _buildCTA(),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      ReasonCard(data: current),
                      SizedBox(height: 16),
                      WeatherCard(data: current),
                      SizedBox(height: 16),
                      const Forecast7DayCard(),
                      SizedBox(height: 16),
                      const HourlyCard(),
                      SizedBox(height: 16),
                      TrendCard(data: hourlyData, color: stressColor),
                      SizedBox(height: 16),
                      AQICard(aqi: current.aqi),
                      SizedBox(height: 16),
                      const HealthCard(),
                      SizedBox(height: 40),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
