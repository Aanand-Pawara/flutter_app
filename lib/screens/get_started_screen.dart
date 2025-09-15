import 'package:flutter/material.dart';
import 'package:flutter_app/utils/app_theme.dart';
import 'package:flutter_app/utils/responsive_utils.dart';
import 'auth_screen.dart';
import 'user_selection_screen.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: ResponsiveUtils.responsivePadding(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Logo/Icon
              Container(
                width: ResponsiveUtils.getIconSize(context) * 3.75,
                height: ResponsiveUtils.getIconSize(context) * 3.75,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(60),
                  boxShadow: AppShadows.large,
                ),
                child: Icon(
                  Icons.rocket_launch,
                  size: ResponsiveUtils.getIconSize(context) * 1.875,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              
              // Title
              Text(
                'OSCAR',
                style: TextStyle(
                  fontSize: ResponsiveUtils.responsiveFontSize(context, mobile: 48, tablet: 56, desktop: 64),
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              
              // Subtitle
              Text(
                'Career Platform',
                style: TextStyle(
                  fontSize: ResponsiveUtils.responsiveFontSize(context, mobile: 24, tablet: 28, desktop: 32),
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              
              // Description
              Text(
                'Your AI-powered companion for career guidance, skill development, and scholarship opportunities',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: ResponsiveUtils.responsiveFontSize(context, mobile: 16, tablet: 18, desktop: 20),
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),
              
              // Features
              _buildFeatureRow(Icons.psychology, 'AI Career Guidance'),
              const SizedBox(height: 16),
              _buildFeatureRow(Icons.school, 'Scholarship Matching'),
              const SizedBox(height: 16),
              _buildFeatureRow(Icons.description, 'Resume Analysis'),
              const SizedBox(height: 16),
              _buildFeatureRow(Icons.trending_up, 'Skill Development'),
              
              const Spacer(),
              
              // Get Started Button
              SizedBox(
                width: double.infinity,
                height: ResponsiveUtils.getButtonHeight(context),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const UserSelectionScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 8,
                    shadowColor: AppColors.primary.withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Skip for now
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const AuthScreen()),
                  );
                },
                child: Text(
                  'Skip for now',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Row(
      children: [
        Container(
          width: ResponsiveUtils.getIconSize(context) * 1.25,
          height: ResponsiveUtils.getIconSize(context) * 1.25,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: ResponsiveUtils.getIconSize(context) * 0.625,
          ),
        ),
        SizedBox(width: ResponsiveUtils.getSpacing(context)),
        Text(
          text,
          style: TextStyle(
            fontSize: ResponsiveUtils.responsiveFontSize(context, mobile: 16),
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
