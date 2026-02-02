import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

enum MapLayerType { aqi, heat, temperature }

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  LatLng? _currentLocation;
  bool _loading = true;
  MapLayerType _selectedLayer = MapLayerType.aqi;

  late List<LatLng> _nearbyPoints;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // ---------------------------------------------------------------------------
  // LOCATION
  // ---------------------------------------------------------------------------
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _loading = false);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      setState(() => _loading = false);
      return;
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final userLatLng = LatLng(position.latitude, position.longitude);

    setState(() {
      _currentLocation = userLatLng;
      _nearbyPoints = _generateNearbyPoints(userLatLng, 8);
      _loading = false;
    });
  }

  // ---------------------------------------------------------------------------
  // DUMMY NEARBY POINTS (WITHIN ~5 KM)
  // ---------------------------------------------------------------------------
  List<LatLng> _generateNearbyPoints(LatLng center, int count) {
    final random = Random();
    const maxOffset = 0.045; // ≈ 5 km

    return List.generate(count, (_) {
      final latOffset = (random.nextDouble() - 0.5) * maxOffset;
      final lngOffset = (random.nextDouble() - 0.5) * maxOffset;

      return LatLng(
        center.latitude + latOffset,
        center.longitude + lngOffset,
      );
    });
  }

  // ---------------------------------------------------------------------------
  // UI
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_currentLocation == null) {
      return const Scaffold(
        body: Center(child: Text('Location unavailable')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Maps'),
        actions: [_buildLayerDropdown()],
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: _currentLocation!,
          initialZoom: 14,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.climatesense',
          ),

          _buildOverlayLayer(),

          // User location marker (always visible)
          MarkerLayer(
            markers: [
              Marker(
                point: _currentLocation!,
                width: 36,
                height: 36,
                child: const Icon(
                  Icons.my_location,
                  color: Colors.blue,
                  size: 32,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // DROPDOWN
  // ---------------------------------------------------------------------------
  Widget _buildLayerDropdown() {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<MapLayerType>(
          value: _selectedLayer,
          onChanged: (value) {
            if (value != null) {
              setState(() => _selectedLayer = value);
            }
          },
          items: const [
            DropdownMenuItem(value: MapLayerType.aqi, child: Text('AQI')),
            DropdownMenuItem(value: MapLayerType.heat, child: Text('Heat')),
            DropdownMenuItem(
              value: MapLayerType.temperature,
              child: Text('Temperature'),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // OVERLAY SWITCH
  // ---------------------------------------------------------------------------
  Widget _buildOverlayLayer() {
    switch (_selectedLayer) {
      case MapLayerType.aqi:
        return _aqiLayer();
      case MapLayerType.heat:
        return _heatLayer();
      case MapLayerType.temperature:
        return _temperatureLayer();
    }
  }

  // ---------------------------------------------------------------------------
  // AQI — ZOOM-AWARE CIRCLES (METERS)
  // ---------------------------------------------------------------------------
  Widget _aqiLayer() {
    return CircleLayer(
      circles: _nearbyPoints.map((point) {
        return CircleMarker(
          point: point,
          radius: 400, // meters
          useRadiusInMeter: true,
          color: _randomAQIColor().withOpacity(0.3),
          borderColor: Colors.transparent,
        );
      }).toList(),
    );
  }

  // ---------------------------------------------------------------------------
  // HEAT — ZOOM-AWARE CIRCLES (METERS)
  // ---------------------------------------------------------------------------
  Widget _heatLayer() {
    return CircleLayer(
      circles: _nearbyPoints.map((point) {
        return CircleMarker(
          point: point,
          radius: 700, // meters
          useRadiusInMeter: true,
          color: Colors.red.withOpacity(0.25),
          borderColor: Colors.transparent,
        );
      }).toList(),
    );
  }

  // ---------------------------------------------------------------------------
  // TEMPERATURE — MARKERS
  // ---------------------------------------------------------------------------
  Widget _temperatureLayer() {
    return MarkerLayer(
      markers: _nearbyPoints.map((point) {
        final temp = 30 + Random().nextInt(8); // 30–37°C
        return Marker(
          point: point,
          width: 60,
          height: 40,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '$temp°C',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ---------------------------------------------------------------------------
  // HELPERS
  // ---------------------------------------------------------------------------
  Color _randomAQIColor() {
    final colors = [
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.red,
    ];
    return colors[Random().nextInt(colors.length)];
  }
}
