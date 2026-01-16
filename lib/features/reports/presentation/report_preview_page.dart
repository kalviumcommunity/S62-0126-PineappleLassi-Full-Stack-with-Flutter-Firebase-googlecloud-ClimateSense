import 'package:flutter/material.dart';
import 'dart:io';

class ReportPreviewPage extends StatelessWidget {
  const ReportPreviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String category = args['category'];
    final double severity = args['severity'];
    final String description = args['description'];
    final String location = args['location'];
    final File? image = args['image'];

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
          'Review Report',
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
            Center(
              child: Column(
                children: [
                  Icon(Icons.preview, size: 60, color: Color(0xFFFF6B35)),
                  SizedBox(height: 12),
                  Text(
                    'Review Your Report',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Please verify all details before submitting',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 16,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Category', style: TextStyle(color: Colors.white70)),
                            SizedBox(height: 4),
                            Text(category, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                          ],
                        ),
                        _buildSeverityBadge(severity.toInt()),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _buildDetailRow(Icons.description, 'Description', description),
                        Divider(height: 32),
                        _buildDetailRow(Icons.location_on, 'Location', location),
                        if (image != null) ...[
                          Divider(height: 32),
                          _buildPhotoPreview(image),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[700]),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Your report will be visible to the community and help others stay informed.',
                      style: TextStyle(fontSize: 13, color: Colors.blue[900]),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Color(0xFFFF6B35),
                      side: BorderSide(color: Color(0xFFFF6B35), width: 2),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text('Edit', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        '/report-success',
                        arguments: {'category': category, 'location': location},
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF6B35),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Submit Report', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        SizedBox(width: 8),
                        Icon(Icons.send, size: 18),
                      ],
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

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFFFF6B35).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Color(0xFFFF6B35), size: 20),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              SizedBox(height: 4),
              Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoPreview(File image) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFFFF6B35).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.photo, color: Color(0xFFFF6B35), size: 20),
            ),
            SizedBox(width: 12),
            Text('Attached Photo', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
        SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(image, height: 150, width: double.infinity, fit: BoxFit.cover),
        ),
      ],
    );
  }

  Widget _buildSeverityBadge(int severity) {
    Color badgeColor = severity >= 4 ? Colors.red : severity >= 3 ? Colors.orange : Colors.green;
    String label = severity >= 4 ? 'High' : severity >= 3 ? 'Medium' : 'Low';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: badgeColor, shape: BoxShape.circle)),
          SizedBox(width: 8),
          Text(label, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}