import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/providers/app_provider.dart';
import 'package:flutter_app/utils/app_theme.dart';
import 'package:flutter_app/utils/responsive_utils.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('OSCAR Dashboard'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: ResponsiveUtils.responsivePadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeCard(context),
              SizedBox(height: ResponsiveUtils.getSpacing(context)),
              _buildQuickActions(context),
              SizedBox(height: ResponsiveUtils.getSpacing(context)),
              _buildProgressOverview(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveUtils.getSpacing(context)),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.medium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to OSCAR',
            style: TextStyle(
              fontSize: ResponsiveUtils.responsiveFontSize(context, mobile: 24, tablet: 28),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: ResponsiveUtils.getSpacing(context, scale: 0.5)),
          Text(
            'Your AI-powered career guidance platform',
            style: TextStyle(
              fontSize: ResponsiveUtils.responsiveFontSize(context, mobile: 16, tablet: 18),
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ResponsiveUtils.getSpacing(context, scale: 0.75)),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: ResponsiveUtils.isMobile(context) ? 2 : 4,
          crossAxisSpacing: ResponsiveUtils.getSpacing(context, scale: 0.75),
          mainAxisSpacing: ResponsiveUtils.getSpacing(context, scale: 0.75),
          childAspectRatio: 1.2,
          children: [
            _buildActionCard(
              context,
              'AI Chat',
              Icons.smart_toy,
              AppColors.primary,
              () {},
            ),
            _buildActionCard(
              context,
              'Resume Analysis',
              Icons.description,
              AppColors.accent,
              () {},
            ),
            _buildActionCard(
              context,
              'Find Jobs',
              Icons.work,
              AppColors.success,
              () {},
            ),
            _buildActionCard(
              context,
              'Scholarships',
              Icons.school,
              AppColors.secondary,
              () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppShadows.small,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: ResponsiveUtils.getIconSize(context),
              ),
            ),
            SizedBox(height: ResponsiveUtils.getSpacing(context, scale: 0.5)),
            Text(
              title,
              style: TextStyle(
                fontSize: ResponsiveUtils.responsiveFontSize(context, mobile: 14, tablet: 16),
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressOverview(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Progress',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ResponsiveUtils.getSpacing(context, scale: 0.75)),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(ResponsiveUtils.getSpacing(context)),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppShadows.small,
          ),
          child: Column(
            children: [
              _buildProgressItem(context, 'Profile Completion', 0.8),
              SizedBox(height: ResponsiveUtils.getSpacing(context)),
              _buildProgressItem(context, 'Skills Assessment', 0.6),
              SizedBox(height: ResponsiveUtils.getSpacing(context)),
              _buildProgressItem(context, 'Career Planning', 0.4),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressItem(BuildContext context, String title, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: ResponsiveUtils.responsiveFontSize(context, mobile: 16, tablet: 18),
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: ResponsiveUtils.responsiveFontSize(context, mobile: 14, tablet: 16),
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveUtils.getSpacing(context, scale: 0.5)),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: AppColors.surfaceContainerHighest,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}
