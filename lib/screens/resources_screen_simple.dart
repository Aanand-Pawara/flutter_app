import 'package:flutter/material.dart';
import 'package:flutter_app/utils/app_theme.dart';
import 'package:flutter_app/utils/responsive_utils.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Programming', 'Design', 'Business', 'Data Science'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Learning Resources'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildCategoryFilter(context),
            Expanded(
              child: _buildResourcesList(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilter(BuildContext context) {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.getSpacing(context, scale: 0.5)),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.getSpacing(context)),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;
          
          return Padding(
            padding: EdgeInsets.only(right: ResponsiveUtils.getSpacing(context, scale: 0.5)),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                });
              },
              backgroundColor: AppColors.surface,
              selectedColor: const Color(0x1A2563EB),
              checkmarkColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildResourcesList(BuildContext context) {
    final mockResources = [
      {
        'title': 'Flutter Development Course',
        'description': 'Complete guide to Flutter app development',
        'category': 'Programming',
        'duration': '40 hours',
        'level': 'Beginner',
        'rating': 4.8,
      },
      {
        'title': 'UI/UX Design Fundamentals',
        'description': 'Learn the basics of user interface design',
        'category': 'Design',
        'duration': '25 hours',
        'level': 'Intermediate',
        'rating': 4.6,
      },
      {
        'title': 'Data Science with Python',
        'description': 'Master data analysis and machine learning',
        'category': 'Data Science',
        'duration': '60 hours',
        'level': 'Advanced',
        'rating': 4.9,
      },
      {
        'title': 'Business Strategy',
        'description': 'Strategic thinking for business growth',
        'category': 'Business',
        'duration': '30 hours',
        'level': 'Intermediate',
        'rating': 4.5,
      },
    ];

    final filteredResources = _selectedCategory == 'All'
        ? mockResources
        : mockResources.where((resource) => resource['category'] == _selectedCategory).toList();

    return ListView.builder(
      padding: EdgeInsets.all(ResponsiveUtils.getSpacing(context)),
      itemCount: filteredResources.length,
      itemBuilder: (context, index) {
        final resource = filteredResources[index];
        return _buildResourceCard(context, resource);
      },
    );
  }

  Widget _buildResourceCard(BuildContext context, Map<String, dynamic> resource) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveUtils.getSpacing(context)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.small,
      ),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.getSpacing(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0x1A2563EB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    resource['category'],
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: AppColors.warning,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      resource['rating'].toString(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: ResponsiveUtils.getSpacing(context, scale: 0.75)),
            Text(
              resource['title'],
              style: TextStyle(
                fontSize: ResponsiveUtils.responsiveFontSize(context, mobile: 18, tablet: 20),
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: ResponsiveUtils.getSpacing(context, scale: 0.5)),
            Text(
              resource['description'],
              style: TextStyle(
                fontSize: ResponsiveUtils.responsiveFontSize(context, mobile: 14, tablet: 16),
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: ResponsiveUtils.getSpacing(context, scale: 0.75)),
            Row(
              children: [
                _buildInfoChip(context, Icons.access_time, resource['duration']),
                SizedBox(width: ResponsiveUtils.getSpacing(context, scale: 0.5)),
                _buildInfoChip(context, Icons.signal_cellular_alt, resource['level']),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Start Learning'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
