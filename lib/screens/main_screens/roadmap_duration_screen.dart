import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/providers/app_provider.dart';
import 'package:flutter_app/utils/app_theme.dart';
import 'package:flutter_app/services/roadmap_service.dart';
import 'package:flutter_app/models/roadmap.dart';
import 'package:flutter_app/screens/main_screens/structured_roadmap_screen.dart';

class RoadmapDurationScreen extends StatefulWidget {
  final String careerPath;
  final String careerTitle;

  const RoadmapDurationScreen({
    super.key,
    required this.careerPath,
    required this.careerTitle,
  });

  @override
  State<RoadmapDurationScreen> createState() => _RoadmapDurationScreenState();
}

class _RoadmapDurationScreenState extends State<RoadmapDurationScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  String? _selectedDuration;
  bool _isLoadingRoadmap = false;
  final RoadmapService _roadmapService = RoadmapService();

  final List<DurationOption> _durationOptions = [
    DurationOption(
      id: '3M',
      title: '3 Months',
      subtitle: 'Quick Start Program',
      description: 'Fast-track learning with core skills and immediate job readiness',
      duration: 3,
      intensity: 'High',
      color: const Color(0xFFEF4444),
      gradient: const LinearGradient(colors: [Color(0xFFEF4444), Color(0xFFDC2626)]),
      features: [
        'Core fundamentals',
        'Essential skills only',
        'Job-ready basics',
        'Quick portfolio projects',
        'Interview preparation'
      ],
      commitment: '15-20 hours/week',
      outcome: 'Entry-level positions',
    ),
    DurationOption(
      id: '6M',
      title: '6 Months',
      subtitle: 'Balanced Learning Path',
      description: 'Comprehensive skill development with practical projects',
      duration: 6,
      intensity: 'Medium',
      color: const Color(0xFF3B82F6),
      gradient: const LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF2563EB)]),
      features: [
        'Comprehensive curriculum',
        'Multiple projects',
        'Industry certifications',
        'Internship opportunities',
        'Professional portfolio'
      ],
      commitment: '10-15 hours/week',
      outcome: 'Mid-level positions',
    ),
    DurationOption(
      id: '1Y',
      title: '12 Months',
      subtitle: 'Professional Mastery',
      description: 'Deep expertise with specialization and advanced projects',
      duration: 12,
      intensity: 'Medium',
      color: const Color(0xFF059669),
      gradient: const LinearGradient(colors: [Color(0xFF059669), Color(0xFF047857)]),
      features: [
        'Advanced specialization',
        'Real-world projects',
        'Industry mentorship',
        'Leadership skills',
        'Professional network'
      ],
      commitment: '8-12 hours/week',
      outcome: 'Senior positions',
    ),
    DurationOption(
      id: '2Y',
      title: '24 Months',
      subtitle: 'Expert Development',
      description: 'Master-level expertise with multiple specializations',
      duration: 24,
      intensity: 'Low',
      color: const Color(0xFF8B5CF6),
      gradient: const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)]),
      features: [
        'Multiple specializations',
        'Leadership training',
        'Industry expertise',
        'Innovation projects',
        'Thought leadership'
      ],
      commitment: '5-8 hours/week',
      outcome: 'Expert/Lead positions',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectDuration(String duration) async {
    setState(() {
      _selectedDuration = duration;
      _isLoadingRoadmap = true;
    });

    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final selectedOption = _durationOptions.firstWhere((opt) => opt.id == duration);

    try {
      // Generate structured roadmap based on duration
      final roadmap = await _generateStructuredRoadmap(
        careerPath: widget.careerPath,
        duration: selectedOption.duration,
        userId: appProvider.user?.id,
      );

      setState(() {
        _isLoadingRoadmap = false;
      });

      // Navigate to structured roadmap screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => StructuredRoadmapScreen(
            roadmap: roadmap,
            durationOption: selectedOption,
            careerTitle: widget.careerTitle,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        _isLoadingRoadmap = false;
        _selectedDuration = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to generate roadmap: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<Roadmap> _generateStructuredRoadmap({
    required String careerPath,
    required int duration,
    String? userId,
  }) async {
    // Generate roadmap with duration-specific structure
    return await _roadmapService.getRoadmapForCareerPath(
      careerPath: careerPath,
      userId: userId,
      currentLevel: 'beginner',
      timeCommitment: _getTimeCommitmentForDuration(duration),
      durationMonths: duration,
    );
  }

  int _getTimeCommitmentForDuration(int duration) {
    switch (duration) {
      case 3:
        return 20; // 20 hours/week for 3 months
      case 6:
        return 15; // 15 hours/week for 6 months
      case 12:
        return 10; // 10 hours/week for 12 months
      case 24:
        return 8; // 8 hours/week for 24 months
      default:
        return 10;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: _isLoadingRoadmap
                      ? _buildLoadingScreen()
                      : _buildDurationSelection(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Choose Your Timeline',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.public,
                          color: Colors.white70,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Powered by Open Source Educational APIs',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 48), // Balance the back button
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              widget.careerTitle,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select the duration that best fits your goals and availability',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(40),
            ),
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Generating Your Personalized Roadmap',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Creating a structured learning path tailored to your timeline...',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDurationSelection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available Learning Paths',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Each path is carefully structured with milestones, projects, and assessments',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          
          ...List.generate(_durationOptions.length, (index) {
            final option = _durationOptions[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildDurationCard(option, index),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDurationCard(DurationOption option, int index) {
    final isSelected = _selectedDuration == option.id;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: GestureDetector(
        onTap: () => _selectDuration(option.id),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: isSelected ? option.gradient : null,
            color: isSelected ? null : AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? Colors.transparent : option.color.withOpacity(0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected 
                    ? option.color.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.1),
                blurRadius: isSelected ? 20 : 10,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? Colors.white.withOpacity(0.2)
                          : option.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getIconForDuration(option.duration),
                      color: isSelected ? Colors.white : option.color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          option.title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          option.subtitle,
                          style: TextStyle(
                            fontSize: 14,
                            color: isSelected 
                                ? Colors.white.withOpacity(0.8)
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? Colors.white.withOpacity(0.2)
                          : option.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${option.intensity} Intensity',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : option.color,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              Text(
                option.description,
                style: TextStyle(
                  fontSize: 16,
                  color: isSelected 
                      ? Colors.white.withOpacity(0.9)
                      : AppColors.textSecondary,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Key Features
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: option.features.map((feature) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? Colors.white.withOpacity(0.15)
                        : option.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    feature,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white : option.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )).toList(),
              ),
              
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Time Commitment',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isSelected 
                                ? Colors.white.withOpacity(0.8)
                                : AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          option.commitment,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Career Outcome',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isSelected 
                                ? Colors.white.withOpacity(0.8)
                                : AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          option.outcome,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForDuration(int duration) {
    switch (duration) {
      case 3:
        return Icons.flash_on;
      case 6:
        return Icons.trending_up;
      case 12:
        return Icons.school;
      case 24:
        return Icons.emoji_events;
      default:
        return Icons.schedule;
    }
  }
}

class DurationOption {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final int duration;
  final String intensity;
  final Color color;
  final Gradient gradient;
  final List<String> features;
  final String commitment;
  final String outcome;

  DurationOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.duration,
    required this.intensity,
    required this.color,
    required this.gradient,
    required this.features,
    required this.commitment,
    required this.outcome,
  });
}