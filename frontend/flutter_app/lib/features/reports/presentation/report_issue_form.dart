import 'package:flutter/material.dart';
import 'dart:io';

class ReportIssueFormPage extends StatefulWidget {
  const ReportIssueFormPage({Key? key}) : super(key: key);

  @override
  State<ReportIssueFormPage> createState() => _ReportIssueFormPageState();
}

class _ReportIssueFormPageState extends State<ReportIssueFormPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;
  double _severity = 3;
  final _descriptionController = TextEditingController();
  String _location = 'Fetching location...';
  File? _selectedImage;

  final List<CategoryOption> _categories = [
    CategoryOption('Flood', Icons.water, Colors.blue),
    CategoryOption('Heat', Icons.wb_sunny, Colors.orange),
    CategoryOption('Pollution', Icons.air, Colors.grey),
    CategoryOption('Water Shortage', Icons.water_drop, Colors.cyan),
    CategoryOption('Storm', Icons.thunderstorm, Colors.purple),
    CategoryOption('Other', Icons.warning, Colors.amber),
  ];

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  void _fetchLocation() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _location = 'Downtown Area, City Name';
      });
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _pickImage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Image picker integration needed'),
        backgroundColor: Color(0xFFFF6B35),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select a category'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      Navigator.pushNamed(
        context,
        '/report-preview',
        arguments: {
          'category': _selectedCategory,
          'severity': _severity,
          'description': _descriptionController.text,
          'location': _location,
          'image': _selectedImage,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Report Issue',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What issue do you want to report?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Your report helps the community stay informed',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 32),
              _buildSectionTitle('Category', true),
              SizedBox(height: 12),
              _buildCategoryGrid(),
              SizedBox(height: 32),
              _buildSectionTitle('Severity Level', true),
              SizedBox(height: 12),
              _buildSeveritySlider(),
              SizedBox(height: 32),
              _buildSectionTitle('Description', true),
              SizedBox(height: 12),
              _buildDescriptionField(),
              SizedBox(height: 32),
              _buildSectionTitle('Location', false),
              SizedBox(height: 12),
              _buildLocationField(),
              SizedBox(height: 32),
              _buildSectionTitle('Photo (Optional)', false),
              SizedBox(height: 12),
              _buildPhotoUpload(),
              SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF6B35),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool required) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        if (required) ...[
          SizedBox(width: 4),
          Text(
            '*',
            style: TextStyle(
              color: Colors.red,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCategoryGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
        final isSelected = _selectedCategory == category.name;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedCategory = category.name;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? category.color.withOpacity(0.1) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? category.color : Colors.grey[300]!,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: category.color.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  category.icon,
                  size: 32,
                  color: isSelected ? category.color : Colors.grey[600],
                ),
                SizedBox(height: 8),
                Text(
                  category.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? category.color : Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSeveritySlider() {
    Color sliderColor;
    String severityLabel;

    if (_severity >= 4) {
      sliderColor = Colors.red;
      severityLabel = 'High';
    } else if (_severity >= 3) {
      sliderColor = Colors.orange;
      severityLabel = 'Medium';
    } else {
      sliderColor = Colors.green;
      severityLabel = 'Low';
    }

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Severity:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: sliderColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: sliderColor.withOpacity(0.3)),
                ),
                child: Text(
                  severityLabel,
                  style: TextStyle(
                    color: sliderColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: sliderColor,
              inactiveTrackColor: sliderColor.withOpacity(0.2),
              thumbColor: sliderColor,
              overlayColor: sliderColor.withOpacity(0.2),
              trackHeight: 6,
            ),
            child: Slider(
              value: _severity,
              min: 1,
              max: 5,
              divisions: 4,
              onChanged: (value) {
                setState(() {
                  _severity = value;
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('1', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              Text('2', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              Text('3', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              Text('4', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              Text('5', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: _descriptionController,
        maxLines: 5,
        maxLength: 500,
        decoration: InputDecoration(
          hintText: 'Describe the issue in detail...',
          hintStyle: TextStyle(color: Colors.grey[400]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.all(16),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please provide a description';
          }
          if (value.trim().length < 10) {
            return 'Description must be at least 10 characters';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildLocationField() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xFFFF6B35).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.location_on,
              color: Color(0xFFFF6B35),
              size: 24,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Location',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  _location,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit_location_alt, color: Color(0xFFFF6B35)),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoUpload() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey[300]!,
            width: 2,
            style: BorderStyle.solid,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: _selectedImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.file(
                  _selectedImage!,
                  fit: BoxFit.cover,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Add Photo',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Tap to upload',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class CategoryOption {
  final String name;
  final IconData icon;
  final Color color;

  CategoryOption(this.name, this.icon, this.color);
}