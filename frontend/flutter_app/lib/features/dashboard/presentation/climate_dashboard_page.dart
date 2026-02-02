import 'package:climate_sense/core/permissions/location_permission_provider.dart';
import 'package:climate_sense/features/dashboard/data/models/timeline_model.dart';
import 'package:climate_sense/features/dashboard/data/dashboard_api.dart';
import 'package:climate_sense/features/dashboard/data/models/current_model.dart';
import 'package:climate_sense/features/dashboard/data/models/dashboard_state.dart';
import 'package:climate_sense/widgets/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/stress_color.dart';
import 'widgets/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ClimateDashboardPage extends ConsumerStatefulWidget {
  const ClimateDashboardPage({super.key});

  @override
  ConsumerState<ClimateDashboardPage> createState() =>
      _ClimateDashboardPageState();
}

class _ClimateDashboardPageState extends ConsumerState<ClimateDashboardPage>
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

  late DashboardState dashboard = DashboardState.loading();

  late DashboardApi api;

  final baseURL = dotenv.env['BASE_URL'];

  Future<void> loadDashboard() async {
    try {
      final notifier = ref.read(locationPermissionProvider.notifier);
      final position = await notifier.getCurrentLocation();

      final double lat = position['lat'] ?? 12.852;
      final double lng = position['lng'] ?? 77.436;

      setState(() => dashboard = DashboardState.loading());

      final results = await Future.wait([
        api.fetchCurrent(lat, lng),
        api.fetchTimeline(lat, lng),
      ]);

      final current = results[0] as CurrentData;
      final timeline = results[1] as List<ClimateHour>;

      final city = await api.fetchCityStress("Bengaluru Urban");

      setState(() {
        dashboard = DashboardState(
          isLoading: false,
          current: current,
          timeline: timeline,
          city: city,
        );
      });
    } catch (e) {
      debugPrint("Dashboard load failed: $e");

      setState(() {
        dashboard = DashboardState(
          isLoading: false,
          current: null,
          timeline: null,
          city: null,
        );
      });
    }
  }

  List<ClimateHour> sampleTimeline(List<ClimateHour> full, int count) {
    if (full.length <= count) return full;

    final step = (full.length - 1) / (count - 1);

    return List.generate(count, (i) {
      final index = (i * step).round();
      return full[index];
    });
  }

  @override
  void initState() {
    super.initState();

    api = DashboardApi(baseURL!);

    // Controllers
    numberController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // SAFE initial animation (no data yet)
    numberAnimation = IntTween(
      begin: 0,
      end: 0,
    ).animate(CurvedAnimation(parent: numberController, curve: Curves.easeOut));

    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
        _scrollOpacity = (1.0 - (_scrollOffset / 300)).clamp(0.0, 1.0);
      });
    });

    loadDashboard();
  }

  void onSelect(int index) {
    if (dashboard.timeline == null) return;

    final timeline = dashboard.timeline!;
    if (index < 0 || index >= timeline.length) return;

    numberAnimation = IntTween(
      begin: timeline[selectedIndex].stress,
      end: timeline[index].stress,
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
    if (dashboard.timeline == null || dashboard.current == null) {
      return const LoadingScreen();
    }

    final timeline = dashboard.timeline!;
    final waveData = sampleTimeline(timeline, 5);
    final safeIndex = selectedIndex.clamp(0, timeline.length - 1);
    final current = timeline[safeIndex];

    final stressColor = getStressColor(waveData[selectedIndex].stress);

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
                          sectionOrLoader(
                            isReady: dashboard.timeline != null,
                            child: HeroStress(
                              stress: waveData[selectedIndex].stress,
                              glowController: glowController,
                              numberController: numberController,
                              numberAnimation: numberAnimation,
                            ),
                          ),

                          SizedBox(height: 8),
                          sectionOrLoader(
                            isReady: dashboard.timeline != null,
                            child: InteractiveWave(
                              data: waveData,
                              selectedIndex: selectedIndex.clamp(
                                0,
                                waveData.length - 1,
                              ),
                              color: stressColor,
                              onChanged: onSelect,
                            ),
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
                      if (dashboard.current != null)
                        ReasonCard(data: dashboard.current!)
                      else
                        const SizedBox.shrink(),
                      SizedBox(height: 16),
                      WeatherCard(data: current),
                      SizedBox(height: 16),
                      const Forecast7DayCard(),
                      SizedBox(height: 16),
                      HourlyCard(data: waveData),
                      SizedBox(height: 16),
                      TrendCard(data: dashboard.timeline!, color: stressColor),
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

Widget sectionOrLoader({required bool isReady, required Widget child}) {
  return isReady
      ? child
      : const Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Center(child: CircularProgressIndicator()),
        );
}
