import 'package:flutter/material.dart';
import 'package:flutter_app/utils/app_theme.dart';
import 'package:flutter_app/utils/responsive_utils.dart';

class ResumeAnalysisScreen extends StatefulWidget {
  const ResumeAnalysisScreen({super.key});

  @override
  State<ResumeAnalysisScreen> createState() => _ResumeAnalysisScreenState();
}

class _ResumeAnalysisScreenState extends State<ResumeAnalysisScreen> {
  bool _isAnalyzing = false;
  bool _hasAnalyzed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Resume Analysis'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: ResponsiveUtils.responsivePadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUploadSection(context),
              if (_hasAnalyzed) ...[
                SizedBox(height: ResponsiveUtils.getSpacing(context)),
                _buildAnalysisResults(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveUtils.getSpacing(context)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.small,
      ),
      child: Column(
        children: [
          Icon(
            Icons.upload_file,
            size: ResponsiveUtils.getIconSize(context) * 2,
            color: AppColors.primary,
          ),
          SizedBox(height: ResponsiveUtils.getSpacing(context)),
          Text(
            'Upload Your Resume',
            style: TextStyle(
              fontSize: ResponsiveUtils.responsiveFontSize(context, mobile: 20, tablet: 24),
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: ResponsiveUtils.getSpacing(context, scale: 0.5)),
          Text(
            'Get instant ATS score and improvement suggestions',
            style: TextStyle(
              fontSize: ResponsiveUtils.responsiveFontSize(context, mobile: 14, tablet: 16),
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ResponsiveUtils.getSpacing(context)),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isAnalyzing ? null : _analyzeResume,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveUtils.getSpacing(context, scale: 0.75),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isAnalyzing
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Choose File & Analyze',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.responsiveFontSize(context, mobile: 16, tablet: 18),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisResults(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Analysis Results',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ResponsiveUtils.getSpacing(context, scale: 0.75)),
        _buildScoreCard(context),
        SizedBox(height: ResponsiveUtils.getSpacing(context)),
        _buildRecommendations(context),
      ],
    );
  }

  Widget _buildScoreCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveUtils.getSpacing(context)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.small,
      ),
      child: Column(
        children: [
          Text(
            'ATS Score',
            style: TextStyle(
              fontSize: ResponsiveUtils.responsiveFontSize(context, mobile: 18, tablet: 20),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: ResponsiveUtils.getSpacing(context, scale: 0.5)),
          Text(
            '78/100',
            style: TextStyle(
              fontSize: ResponsiveUtils.responsiveFontSize(context, mobile: 48, tablet: 56),
              fontWeight: FontWeight.bold,
              color: AppColors.warning,
            ),
          ),
          SizedBox(height: ResponsiveUtils.getSpacing(context, scale: 0.5)),
          LinearProgressIndicator(
            value: 0.78,
            backgroundColor: AppColors.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.warning),
            borderRadius: BorderRadius.circular(4),
          ),
          SizedBox(height: ResponsiveUtils.getSpacing(context, scale: 0.5)),
          Text(
            'Good score! A few improvements can make it excellent.',
            style: TextStyle(
              fontSize: ResponsiveUtils.responsiveFontSize(context, mobile: 14, tablet: 16),
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations(BuildContext context) {
    final recommendations = [
      'Add more quantified achievements',
      'Include relevant keywords for ATS',
      'Improve formatting consistency',
      'Add technical skills section',
      'Use stronger action verbs',
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveUtils.getSpacing(context)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.small,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recommendations',
            style: TextStyle(
              fontSize: ResponsiveUtils.responsiveFontSize(context, mobile: 18, tablet: 20),
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: ResponsiveUtils.getSpacing(context, scale: 0.75)),
          ...recommendations.map((recommendation) => Padding(
            padding: EdgeInsets.only(bottom: ResponsiveUtils.getSpacing(context, scale: 0.5)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: ResponsiveUtils.getSpacing(context, scale: 0.5)),
                Expanded(
                  child: Text(
                    recommendation,
                    style: TextStyle(
                      fontSize: ResponsiveUtils.responsiveFontSize(context, mobile: 14, tablet: 16),
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  void _analyzeResume() {
    setState(() {
      _isAnalyzing = true;
    });

    // Simulate analysis
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isAnalyzing = false;
        _hasAnalyzed = true;
      });
    });
  }
}
