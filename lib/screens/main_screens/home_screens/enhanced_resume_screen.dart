import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/providers/app_provider.dart';
import 'package:flutter_app/utils/app_theme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:percent_indicator/percent_indicator.dart';

class EnhancedResumeScreen extends StatefulWidget {
  const EnhancedResumeScreen({super.key});

  @override
  State<EnhancedResumeScreen> createState() => _EnhancedResumeScreenState();
}

class _EnhancedResumeScreenState extends State<EnhancedResumeScreen> 
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  String? _selectedFileName;
  bool _isAnalyzing = false;
  bool _hasAnalyzed = false;
  
  // Mock ATS analysis results
  final ATSAnalysisResult _analysisResult = ATSAnalysisResult(
    overallScore: 78,
    sections: [
      ScoreSection('Contact Information', 95, 'Excellent'),
      ScoreSection('Professional Summary', 85, 'Good'),
      ScoreSection('Work Experience', 75, 'Good'),
      ScoreSection('Skills', 60, 'Needs Improvement'),
      ScoreSection('Education', 90, 'Excellent'),
      ScoreSection('Keywords', 45, 'Poor'),
      ScoreSection('Formatting', 88, 'Excellent'),
    ],
    strengths: [
      'Clear contact information',
      'Well-structured work experience',
      'Proper education section',
      'Good use of action verbs',
      'Professional formatting'
    ],
    improvements: [
      'Add more industry-specific keywords',
      'Include quantified achievements',
      'Add a skills section with relevant technologies',
      'Include certifications if any',
      'Optimize for ATS scanning'
    ],
    keywords: [
      KeywordAnalysis('Python', true, 'Found 2 times'),
      KeywordAnalysis('Machine Learning', false, 'Not found - highly recommended'),
      KeywordAnalysis('Project Management', true, 'Found 1 time'),
      KeywordAnalysis('Communication', false, 'Not found - recommended'),
      KeywordAnalysis('Leadership', true, 'Found 1 time'),
      KeywordAnalysis('Data Analysis', false, 'Not found - highly recommended'),
    ],
  );

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: AppDurations.slow,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: AppCurves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _selectedFileName = result.files.first.name;
          _hasAnalyzed = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking file: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _analyzeResume() async {
    if (_selectedFileName == null) return;

    setState(() {
      _isAnalyzing = true;
    });

    // Simulate analysis time
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      setState(() {
        _isAnalyzing = false;
        _hasAnalyzed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: CustomScrollView(
            slivers: [
              _buildAppBar(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildUploadSection(),
                      if (_selectedFileName != null) ...[
                        const SizedBox(height: 24),
                        _buildSelectedFile(),
                      ],
                      if (_isAnalyzing) ...[
                        const SizedBox(height: 24),
                        _buildAnalyzingSection(),
                      ],
                      if (_hasAnalyzed && !_isAnalyzing) ...[
                        const SizedBox(height: 24),
                        _buildAnalysisResults(),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      title: const Text(
        'Resume Analysis',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            _showATSInfo();
          },
          icon: const Icon(Icons.info_outline),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildUploadSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppShadows.medium,
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.description,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'ATS Resume Checker',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Upload your resume and get detailed ATS analysis with improvement suggestions',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _pickFile,
              icon: const Icon(Icons.upload_file),
              label: const Text(
                'Upload Resume',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Supported formats: PDF, DOC, DOCX',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedFile() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.small,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.description,
                  color: AppColors.success,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedFileName!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ready for analysis',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _selectedFileName = null;
                    _hasAnalyzed = false;
                  });
                },
                icon: Icon(
                  Icons.close,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _analyzeResume,
              child: const Text(
                'Analyze Resume',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyzingSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.small,
      ),
      child: Column(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Analyzing your resume...',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This may take a few moments',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildOverallScore(),
        const SizedBox(height: 24),
        _buildSectionScores(),
        const SizedBox(height: 24),
        _buildKeywordAnalysis(),
        const SizedBox(height: 24),
        _buildStrengthsAndImprovements(),
        const SizedBox(height: 24),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildOverallScore() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.small,
      ),
      child: Column(
        children: [
          Text(
            'Overall ATS Score',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          CircularPercentIndicator(
            radius: 80.0,
            lineWidth: 12.0,
            percent: _analysisResult.overallScore / 100,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${_analysisResult.overallScore}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Text(
                  'out of 100',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            progressColor: _getScoreColor(_analysisResult.overallScore.toDouble()),
            backgroundColor: AppColors.surfaceContainerHighest,
            circularStrokeCap: CircularStrokeCap.round,
          ),
          const SizedBox(height: 16),
          Text(
            _getScoreText(_analysisResult.overallScore),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: _getScoreColor(_analysisResult.overallScore.toDouble()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionScores() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Section Analysis',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppShadows.small,
          ),
          child: Column(
            children: _analysisResult.sections
                .map((section) => _buildSectionScore(section))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionScore(ScoreSection section) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  section.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                '${section.score}%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _getScoreColor(section.score.toDouble()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearPercentIndicator(
            lineHeight: 8,
            percent: section.score / 100,
            backgroundColor: AppColors.surfaceContainerHighest,
            progressColor: _getScoreColor(section.score.toDouble()),
            barRadius: const Radius.circular(4),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              section.status,
              style: TextStyle(
                fontSize: 12,
                color: _getScoreColor(section.score.toDouble()),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeywordAnalysis() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Keyword Analysis',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppShadows.small,
          ),
          child: Column(
            children: _analysisResult.keywords
                .map((keyword) => _buildKeywordItem(keyword))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildKeywordItem(KeywordAnalysis keyword) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            keyword.found ? Icons.check_circle : Icons.cancel,
            color: keyword.found ? AppColors.success : AppColors.error,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  keyword.keyword,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  keyword.status,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStrengthsAndImprovements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detailed Feedback',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildStrengthsCard()),
            const SizedBox(width: 16),
            Expanded(child: _buildImprovementsCard()),
          ],
        ),
      ],
    );
  }

  Widget _buildStrengthsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.success.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Strengths',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._analysisResult.strengths.map((strength) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 4,
                  height: 4,
                  margin: const EdgeInsets.only(top: 6),
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    strength,
                    style: const TextStyle(
                      fontSize: 14,
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

  Widget _buildImprovementsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.error.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning,
                color: AppColors.error,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Improvements',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._analysisResult.improvements.map((improvement) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 4,
                  height: 4,
                  margin: const EdgeInsets.only(top: 6),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    improvement,
                    style: const TextStyle(
                      fontSize: 14,
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

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () {
              _downloadReport();
            },
            icon: const Icon(Icons.download),
            label: const Text(
              'Download Detailed Report',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  _analyzeAnotherResume();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Analyze Another'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  _getResumeHelp();
                },
                icon: const Icon(Icons.help),
                label: const Text('Get Help'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return AppColors.success;
    if (score >= 60) return Colors.orange;
    return AppColors.error;
  }

  String _getScoreText(int score) {
    if (score >= 80) return 'Excellent - ATS Friendly';
    if (score >= 60) return 'Good - Minor Improvements Needed';
    return 'Needs Improvement - Major Issues Found';
  }

  void _showATSInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('About ATS'),
          content: const Text(
            'ATS (Applicant Tracking System) is software used by employers to filter resumes. '
            'Our analysis checks how well your resume performs against common ATS criteria including '
            'keywords, formatting, structure, and content quality.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Got it'),
            ),
          ],
        );
      },
    );
  }

  void _downloadReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Detailed report downloaded successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _analyzeAnotherResume() {
    setState(() {
      _selectedFileName = null;
      _hasAnalyzed = false;
      _isAnalyzing = false;
    });
  }

  void _getResumeHelp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening resume help guide...'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class ATSAnalysisResult {
  final int overallScore;
  final List<ScoreSection> sections;
  final List<String> strengths;
  final List<String> improvements;
  final List<KeywordAnalysis> keywords;

  ATSAnalysisResult({
    required this.overallScore,
    required this.sections,
    required this.strengths,
    required this.improvements,
    required this.keywords,
  });
}

class ScoreSection {
  final String name;
  final int score;
  final String status;

  ScoreSection(this.name, this.score, this.status);
}

class KeywordAnalysis {
  final String keyword;
  final bool found;
  final String status;

  KeywordAnalysis(this.keyword, this.found, this.status);
}