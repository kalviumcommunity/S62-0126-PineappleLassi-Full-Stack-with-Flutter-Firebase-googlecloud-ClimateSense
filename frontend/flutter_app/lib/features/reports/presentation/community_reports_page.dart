import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class CommunityReportsPage extends StatefulWidget {
  const CommunityReportsPage({Key? key}) : super(key: key);

  @override
  State<CommunityReportsPage> createState() => _CommunityReportsPageState();
}

class _CommunityReportsPageState extends State<CommunityReportsPage> {
  LatLng? _userLocation;
  bool _loadingLocation = true;

  final List<_DummyReportPoint> _dummyReports = [];

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final center = LatLng(position.latitude, position.longitude);

    setState(() {
      _userLocation = center;
      _dummyReports.addAll(_generateDummyReports(center));
      _loadingLocation = false;
    });
  }

  // ---------------------------------------------------------------------------
  // INITIAL DUMMY REPORTS (≤ 5 KM)
  // ---------------------------------------------------------------------------
  List<_DummyReportPoint> _generateDummyReports(LatLng center) {
    final random = Random();
    const maxOffset = 0.045; // ~5 km

    return List.generate(5, (index) {
      final latOffset = (random.nextDouble() - 0.5) * maxOffset;
      final lngOffset = (random.nextDouble() - 0.5) * maxOffset;

      return _DummyReportPoint(
        location: LatLng(
          center.latitude + latOffset,
          center.longitude + lngOffset,
        ),
        title: index.isEven ? 'High Temperature' : 'Poor Air Quality',
        description: index.isEven
            ? 'Unusual temperature rise reported in this area.'
            : 'High AQI levels detected in this area.',
        severity: index.isEven ? 'High' : 'Moderate',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Community Reports',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        children: [
          _buildStatsBar(),
          Expanded(child: _buildMapView()),
        ],
      ),

      // ✅ ADD REPORT → REFLECT IMMEDIATELY
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/report-issue');

          if (result != null && result is Map<String, dynamic>) {
            setState(() {
              _dummyReports.insert(
                0,
                _DummyReportPoint(
                  location: LatLng(
                    result['lat'],
                    result['lng'],
                  ),
                  title: result['title'],
                  description: result['description'],
                  severity: result['severity'],
                ),
              );
            });
          }
        },
        backgroundColor: const Color(0xFFFF6B35),
        icon: const Icon(Icons.add),
        label: const Text(
          'Report Issue',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildStatsBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _Stat(
            icon: Icons.report_problem,
            value: _dummyReports.length.toString(),
            label: 'Reports',
          ),
          const _Stat(icon: Icons.circle_outlined, value: '1 KM', label: 'Radius'),
          const _Stat(icon: Icons.people, value: '124', label: 'Contributors'),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // MAP WITH 1 KM CIRCLES AROUND EACH REPORT
  // ---------------------------------------------------------------------------
  Widget _buildMapView() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: _loadingLocation || _userLocation == null
            ? const Center(child: CircularProgressIndicator())
            : FlutterMap(
                options: MapOptions(
                  initialCenter: _userLocation!,
                  initialZoom: 14,
                  interactiveFlags: InteractiveFlag.all,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.climatesense',
                  ),

                  // 🔵 1 KM CIRCLES AROUND REPORTS (ZOOM AWARE)
                  CircleLayer(
                    circles: _dummyReports.map((report) {
                      return CircleMarker(
                        point: report.location,
                        radius: 1000, // 1 KM
                        useRadiusInMeter: true,
                        color: Colors.orange.withOpacity(0.15),
                        borderColor: Colors.orange.withOpacity(0.6),
                        borderStrokeWidth: 2,
                      );
                    }).toList(),
                  ),

                  MarkerLayer(
                    markers: [
                      // User location
                      Marker(
                        point: _userLocation!,
                        width: 30,
                        height: 30,
                        child: const Icon(
                          Icons.my_location,
                          color: Colors.blue,
                          size: 28,
                        ),
                      ),

                      // 📍 Report pins
                      ..._dummyReports.map((report) {
                        return Marker(
                          point: report.location,
                          width: 40,
                          height: 40,
                          child: GestureDetector(
                            onTap: () => _showReportPopup(report),
                            child: const Text(
                              '📍',
                              style: TextStyle(fontSize: 28),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // REPORT POPUP
  // ---------------------------------------------------------------------------
  void _showReportPopup(_DummyReportPoint report) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                report.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                report.description,
                style: TextStyle(color: Colors.grey[700]),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.warning, size: 18, color: Colors.red),
                  const SizedBox(width: 6),
                  Text(
                    'Severity: ${report.severity}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// SUPPORT
// ---------------------------------------------------------------------------
class _Stat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _Stat({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: const Color(0xFFFF6B35)),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}

class _DummyReportPoint {
  final LatLng location;
  final String title;
  final String description;
  final String severity;

  _DummyReportPoint({
    required this.location,
    required this.title,
    required this.description,
    required this.severity,
  });
}
