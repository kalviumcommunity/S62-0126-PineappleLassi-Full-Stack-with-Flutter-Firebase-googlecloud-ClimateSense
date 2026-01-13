import 'package:flutter/material.dart';

class CommunityReportsPage extends StatefulWidget {
  const CommunityReportsPage({Key? key}) : super(key: key);

  @override
  State<CommunityReportsPage> createState() => _CommunityReportsPageState();
}

class _CommunityReportsPageState extends State<CommunityReportsPage> {
  bool _showMap = true;

  // Sample data - replace with your actual data source
  final List<Report> _sampleReports = [
    Report(
      id: '1',
      category: 'Flood',
      severity: 4,
      description: 'Heavy flooding near main street',
      location: 'Downtown Area',
      time: '2 hours ago',
      distance: '0.5 km',
      icon: Icons.water,
      color: Colors.blue,
    ),
    Report(
      id: '2',
      category: 'Heat',
      severity: 3,
      description: 'Extreme heat in the park area',
      location: 'Central Park',
      time: '5 hours ago',
      distance: '1.2 km',
      icon: Icons.wb_sunny,
      color: Colors.orange,
    ),
    Report(
      id: '3',
      category: 'Pollution',
      severity: 5,
      description: 'Heavy air pollution detected',
      location: 'Industrial Zone',
      time: '1 day ago',
      distance: '2.5 km',
      icon: Icons.air,
      color: Colors.grey,
    ),
    Report(
      id: '4',
      category: 'Water Shortage',
      severity: 2,
      description: 'Low water pressure reported',
      location: 'Residential Area',
      time: '3 hours ago',
      distance: '0.8 km',
      icon: Icons.water_drop,
      color: Colors.cyan,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Community Reports',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _showMap ? Icons.list : Icons.map,
              color: Color(0xFFFF6B35),
            ),
            onPressed: () {
              setState(() {
                _showMap = !_showMap;
              });
            },
          ),
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Stats bar
          _buildStatsBar(),

          // Map or List view
          Expanded(
            child: _showMap ? _buildMapView() : _buildListView(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/report-issue');
        },
        backgroundColor: Color(0xFFFF6B35),
        icon: Icon(Icons.add),
        label: Text(
          'Report Issue',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildStatsBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(Icons.report_problem, '${_sampleReports.length}', 'Active'),
          _buildStatItem(Icons.location_on, '2.5 km', 'Radius'),
          _buildStatItem(Icons.people, '124', 'Contributors'),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Color(0xFFFF6B35)),
            SizedBox(width: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildMapView() {
    return Stack(
      children: [
        // Map placeholder - integrate your actual map here
        Container(
          color: Colors.grey[200],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.map,
                  size: 80,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 16),
                Text(
                  'Map View',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Integrate Google Maps or Mapbox here',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Clustered markers overlay (example positions)
        Positioned(
          top: 100,
          left: 80,
          child: _buildMapMarker('3', Colors.blue),
        ),
        Positioned(
          top: 200,
          right: 100,
          child: _buildMapMarker('1', Colors.orange),
        ),
        Positioned(
          bottom: 150,
          left: 120,
          child: _buildMapMarker('2', Colors.grey),
        ),
      ],
    );
  }

  Widget _buildMapMarker(String count, Color color) {
    return GestureDetector(
      onTap: () {
        // Show bottom sheet with reports in this cluster
        _showClusterReports();
      },
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          count,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  void _showClusterReports() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reports in this area',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (context, index) => _buildReportListItem(_sampleReports[index]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _sampleReports.length,
      itemBuilder: (context, index) {
        return _buildReportCard(_sampleReports[index]);
      },
    );
  }

  Widget _buildReportCard(Report report) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReportDetailsPage(report: report),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon with severity color
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: report.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  report.icon,
                  color: report.color,
                  size: 28,
                ),
              ),
              SizedBox(width: 16),
              // Report info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          report.category,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Spacer(),
                        _buildSeverityBadge(report.severity),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      report.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: Colors.grey[500]),
                        SizedBox(width: 4),
                        Text(
                          report.location,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(width: 12),
                        Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                        SizedBox(width: 4),
                        Text(
                          report.time,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportListItem(Report report) {
    return ListTile(
      leading: Icon(report.icon, color: report.color),
      title: Text(report.category),
      subtitle: Text(report.location),
      trailing: _buildSeverityBadge(report.severity),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReportDetailsPage(report: report),
          ),
        );
      },
    );
  }

  Widget _buildSeverityBadge(int severity) {
    Color badgeColor;
    String label;

    if (severity >= 4) {
      badgeColor = Colors.red;
      label = 'High';
    } else if (severity >= 3) {
      badgeColor = Colors.orange;
      label = 'Med';
    } else {
      badgeColor = Colors.green;
      label = 'Low';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: badgeColor.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: badgeColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// Report model
class Report {
  final String id;
  final String category;
  final int severity;
  final String description;
  final String location;
  final String time;
  final String distance;
  final IconData icon;
  final Color color;

  Report({
    required this.id,
    required this.category,
    required this.severity,
    required this.description,
    required this.location,
    required this.time,
    required this.distance,
    required this.icon,
    required this.color,
  });
}

// Report Details Page (simple version)
class ReportDetailsPage extends StatelessWidget {
  final Report report;

  const ReportDetailsPage({Key? key, required this.report}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Report Details',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon
            Center(
              child: Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: report.color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  report.icon,
                  size: 60,
                  color: report.color,
                ),
              ),
            ),
            SizedBox(height: 24),
            // Category and severity
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  report.category,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                _buildSeverityBadge(report.severity),
              ],
            ),
            SizedBox(height: 24),
            // Description
            _buildDetailSection('Description', report.description, Icons.description),
            SizedBox(height: 16),
            // Location
            _buildDetailSection('Location', report.location, Icons.location_on),
            SizedBox(height: 16),
            // Time
            _buildDetailSection('Reported', report.time, Icons.access_time),
            SizedBox(height: 16),
            // Distance
            _buildDetailSection('Distance', report.distance, Icons.near_me),
            SizedBox(height: 32),
            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.share),
                    label: Text('Share'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Color(0xFFFF6B35),
                      side: BorderSide(color: Color(0xFFFF6B35)),
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.flag),
                    label: Text('Report'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF6B35),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, String content, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: report.color),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeverityBadge(int severity) {
    Color badgeColor;
    String label;

    if (severity >= 4) {
      badgeColor = Colors.red;
      label = 'High Severity';
    } else if (severity >= 3) {
      badgeColor = Colors.orange;
      label = 'Medium';
    } else {
      badgeColor = Colors.green;
      label = 'Low';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: badgeColor.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: badgeColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}