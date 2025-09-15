import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter_app/providers/app_provider.dart';
import 'package:flutter_app/utils/app_theme.dart';

class ResumeAnalysisScreen extends StatefulWidget {
  const ResumeAnalysisScreen({super.key});

  @override
  State<ResumeAnalysisScreen> createState() => _ResumeAnalysisScreenState();
}

class _ResumeAnalysisScreenState extends State<ResumeAnalysisScreen> {
  final _formKey = GlobalKey<FormState>();
  final _targetRoleController = TextEditingController();
  final _targetCompanyController = TextEditingController();
  String? _selectedIndustry;
  String? _selectedExperience;
  String? _selectedFilePath;
  bool _isAnalyzing = false;
  bool _hasResults = false;
  Map<String, dynamic> _analysisResults = {};
  double _uploadProgress = 0.0;

  final List<String> _industries = [
    'Technology',
    'Healthcare',
    'Finance',
    'Education',
    'Manufacturing',
    'Retail',
    'Other'
  ];

  final List<String> _experienceLevels = [
    'Entry Level (0-2 years)',
    'Mid Level (3-5 years)',
    'Senior Level (6-10 years)',
    'Executive Level (10+ years)'
  ];

  @override
  void dispose() {
    _targetRoleController.dispose();
    _targetCompanyController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    setState(() {
      _uploadProgress = 0.0;
    });
    
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    
    if (result != null) {
      setState(() {
        _selectedFilePath = result.files.single.name;
      });
      
      // Simulate file upload progress
      Timer.periodic(const Duration(milliseconds: 100), (timer) {
        setState(() {
          _uploadProgress += 0.05;
        });
        
        if (_uploadProgress >= 1.0) {
          timer.cancel();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ ${result.files.single.name} uploaded successfully!'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      });
    }

  }

  Future<void> _analyzeResume() async {
    if (!_formKey.currentState!.validate() || _selectedFilePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields and select a resume file'),
          backgroundColor: const Color(0xFFEF4444),
        ),
      );
      return;
    }

    final appProvider = Provider.of<AppProvider>(context, listen: false);
    await appProvider.analyzeResume(_selectedFilePath!, _targetRoleController.text);

    if (mounted && appProvider.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Resume analysis completed!'),
          backgroundColor: const Color(0xFF10B981),
        ),
      );
    }
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return const Color(0xFF10B981);
    if (score >= 60) return const Color(0xFFF97316);
    return const Color(0xFFEF4444);
  }

  String _getScoreLabel(int score) {
    if (score >= 80) return 'Excellent';
    if (score >= 60) return 'Good';
    return 'Needs Improvement';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Resume Analysis'),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildUploadSection(appProvider),
                const SizedBox(height: 20),
                if (_isAnalyzing) _buildAnalyzingWidget(),
                if (appProvider.resumeAnalysis.atsScore > 0) _buildResultsSection(appProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUploadSection(AppProvider appProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Upload Your Resume',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // File Upload
              Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: _pickFile,
                  borderRadius: BorderRadius.circular(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _selectedFilePath != null ? Icons.check_circle : Icons.cloud_upload,
                        size: 48,
                        color: _selectedFilePath != null ? const Color(0xFF10B981) : Colors.grey[400],
                      ),
                      const SizedBox(height: 8),
                      if (_uploadProgress > 0 && _uploadProgress < 1)
                        LinearProgressIndicator(
                          value: _uploadProgress,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                        ),
                      Text(
                        _selectedFilePath != null 
                          ? 'File selected: $_selectedFilePath'
                          : 'Tap to select resume (PDF, DOC, DOCX)',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: _selectedFilePath != null ? const Color(0xFF10B981) : Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Form Fields
              TextFormField(
                controller: _targetRoleController,
                decoration: const InputDecoration(
                  labelText: 'Target Job Role *',
                  hintText: 'e.g., Software Engineer',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter target job role';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _targetCompanyController,
                decoration: const InputDecoration(
                  labelText: 'Target Company (Optional)',
                  hintText: 'e.g., Google, Microsoft',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedIndustry,
                decoration: const InputDecoration(
                  labelText: 'Industry *',
                  border: OutlineInputBorder(),
                ),
                items: _industries.map((industry) {
                  return DropdownMenuItem(
                    value: industry,
                    child: Text(industry),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedIndustry = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select an industry';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedExperience,
                decoration: const InputDecoration(
                  labelText: 'Experience Level *',
                  border: OutlineInputBorder(),
                ),
                items: _experienceLevels.map((level) {
                  return DropdownMenuItem(
                    value: level,
                    child: Text(level),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedExperience = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select experience level';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isAnalyzing ? null : _analyzeResume,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isAnalyzing
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('Analyzing...'),
                        ],
                      )
                    : const Text(
                        'Analyze Resume',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultsSection(AppProvider appProvider) {
    final analysis = appProvider.resumeAnalysis;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ATS Compatibility Score',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: CircularPercentIndicator(
                radius: 80,
                lineWidth: 12,
                percent: analysis.atsScore / 100,
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${analysis.atsScore}%',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _getScoreColor(analysis.atsScore),
                      ),
                    ),
                    Text(
                      _getScoreLabel(analysis.atsScore),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                progressColor: _getScoreColor(analysis.atsScore),
                backgroundColor: Colors.grey[200]!,
                circularStrokeCap: CircularStrokeCap.round,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyzingWidget() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0x1A000000),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Analyzing your resume...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
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



  Widget _buildScoreCards() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0x1A000000),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analysis Results',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildScoreCard('ATS Score', _analysisResults['atsScore'], AppColors.primary)),
              const SizedBox(width: 12),
              Expanded(child: _buildScoreCard('Skills Match', _analysisResults['skillsMatch'], AppColors.accent)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildScoreCard('Experience', _analysisResults['experienceMatch'], AppColors.success)),
              const SizedBox(width: 12),
              Expanded(child: _buildScoreCard('Keywords', _analysisResults['keywordDensity'], AppColors.warning)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard(String title, int score, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color.fromARGB(26, color.red, color.green, color.blue),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color.fromARGB(77, color.red, color.green, color.blue)),
      ),
      child: Column(
        children: [
          Text(
            '$score%',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: score / 100,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ),
    );
  }

  Widget _buildStrengthsAndImprovements() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0x1A10B981),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0x4D10B981)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.check_circle, color: AppColors.success, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Strengths',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...(_analysisResults['strengths'] as List).map((strength) => 
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 4,
                          height: 4,
                          margin: const EdgeInsets.only(top: 6, right: 8),
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            strength,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0x1AF59E0B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0x4DF59E0B)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.lightbulb_outline, color: AppColors.warning, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Improvements',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.warning,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...(_analysisResults['improvements'] as List).map((improvement) => 
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 4,
                          height: 4,
                          margin: const EdgeInsets.only(top: 6, right: 8),
                          decoration: BoxDecoration(
                            color: AppColors.warning,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            improvement,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMissingKeywords() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0x1A000000),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.search, color: AppColors.error, size: 20),
              const SizedBox(width: 8),
              Text(
                'Missing Keywords',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (_analysisResults['missingKeywords'] as List).map((keyword) => 
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0x1AEF4444),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0x4DEF4444)),
                ),
                child: Text(
                  keyword,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0x1A000000),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.school, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Recommended Courses',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...(_analysisResults['recommendations'] as List).map((course) => 
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0x0D2563EB),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0x332563EB)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course['title'],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${course['provider']} • ${course['duration']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.star, color: AppColors.warning, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              course['rating'].toString(),
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Opening ${course['title']}...'),
                          backgroundColor: AppColors.primary,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      'Start',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
