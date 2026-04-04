import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/providers/app_provider.dart';
import 'package:flutter_app/utils/app_theme.dart';
import 'package:flutter_app/services/roadmap_service.dart';
import 'package:flutter_app/screens/main_screens/government_jobs_specialization_screen.dart';
import 'dart:math' as math;

class CareerSelectionScreen extends StatefulWidget {
  const CareerSelectionScreen({super.key});

  @override
  State<CareerSelectionScreen> createState() => _CareerSelectionScreenState();
}

class _CareerSelectionScreenState extends State<CareerSelectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _backgroundController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _backgroundAnimation;
  String? _selectedCareerPath;
  int? _hoveredIndex;
  final RoadmapService _roadmapService = RoadmapService();
  bool _isLoadingRoadmap = false;

  final List<CareerOption> _careerOptions = [
    CareerOption(
      id: '10th',
      title: '10th Standard',
      subtitle: 'Explore career paths after 10th grade',
      description:
          'Discover various streams and career opportunities available after completing your 10th standard.',
      icon: Icons.school,
      color: AppColors.primary,
      gradient: AppColors.primaryGradient,
      glowColor: AppColors.primary.withOpacity(0.3),
      opportunities: [
        'Science Stream',
        'Commerce Stream',
        'Arts Stream',
        'Vocational Courses',
      ],
    ),
    CareerOption(
      id: '12th',
      title: '12th Standard',
      subtitle: 'Plan your next step after 12th',
      description:
          'Find the perfect college course and career path based on your 12th standard background.',
      icon: Icons.school_outlined,
      color: AppColors.accent,
      gradient: AppColors.accentGradient,
      glowColor: AppColors.accent.withOpacity(0.3),
      opportunities: [
        'Engineering',
        'Medical',
        'Commerce',
        'Arts & Humanities',
      ],
    ),
    CareerOption(
      id: 'neet',
      title: 'NEET Preparation',
      subtitle: 'Medical entrance exam guidance',
      description:
          'Comprehensive preparation strategy and career guidance for NEET and medical field.',
      icon: Icons.medical_services,
      color: const Color(0xFFEF4444),
      gradient: const LinearGradient(
        colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
      ),
      glowColor: const Color(0xFFEF4444).withOpacity(0.3),
      opportunities: ['MBBS', 'BDS', 'AYUSH', 'Veterinary Science'],
    ),
    CareerOption(
      id: 'jee',
      title: 'JEE Preparation',
      subtitle: 'Engineering entrance exam guidance',
      description:
          'Strategic preparation for JEE and comprehensive engineering career guidance.',
      icon: Icons.calculate,
      color: AppColors.secondary,
      gradient: AppColors.secondaryGradient,
      glowColor: AppColors.secondary.withOpacity(0.3),
      opportunities: [
        'Computer Science',
        'Mechanical',
        'Electrical',
        'Civil Engineering',
      ],
    ),
    CareerOption(
      id: 'govt',
      title: 'Government Jobs',
      subtitle: 'Public sector career opportunities',
      description:
          'Explore various government job opportunities and preparation strategies.',
      icon: Icons.account_balance,
      color: const Color(0xFF8B5CF6),
      gradient: const LinearGradient(
        colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
      ),
      glowColor: const Color(0xFF8B5CF6).withOpacity(0.3),
      opportunities: ['UPSC', 'Banking', 'Railway', 'Defense Services'],
    ),
    CareerOption(
      id: 'ssc',
      title: 'SSC Preparation',
      subtitle: 'Staff Selection Commission exams',
      description:
          'Complete guidance for SSC exams and related career opportunities.',
      icon: Icons.assignment,
      color: const Color(0xFF06B6D4),
      gradient: const LinearGradient(
        colors: [Color(0xFF06B6D4), Color(0xFF0891B2)],
      ),
      glowColor: const Color(0xFF06B6D4).withOpacity(0.3),
      opportunities: ['SSC CGL', 'SSC CHSL', 'SSC MTS', 'SSC JE'],
    ),
    CareerOption(
      id: 'professional',
      title: 'Working Professional',
      subtitle: 'Career advancement & upskilling',
      description:
          'Enhance your career with new skills and advancement opportunities.',
      icon: Icons.work,
      color: const Color(0xFF059669),
      gradient: const LinearGradient(
        colors: [Color(0xFF059669), Color(0xFF047857)],
      ),
      glowColor: const Color(0xFF059669).withOpacity(0.3),
      opportunities: [
        'Skill Development',
        'Career Switch',
        'Leadership',
        'Entrepreneurship',
      ],
    ),
    CareerOption(
      id: 'technology',
      title: 'Technology & IT',
      subtitle: 'Tech career paths & skills',
      description:
          'Explore cutting-edge technology careers and required skill development.',
      icon: Icons.computer,
      color: const Color(0xFF3B82F6),
      gradient: const LinearGradient(
        colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
      ),
      glowColor: const Color(0xFF3B82F6).withOpacity(0.3),
      opportunities: [
        'Software Development',
        'Data Science',
        'AI/ML',
        'Cybersecurity',
      ],
    ),
  ];

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

    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: AppCurves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: AppCurves.easeOut,
          ),
        );

    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.linear),
    );

    _animationController.forward();
    _backgroundController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  void _selectCareerPath(String careerPath) async {
    setState(() {
      _selectedCareerPath = careerPath;
      _isLoadingRoadmap = true;
    });

    final appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.setCareerPath(careerPath);

    // Find the selected career option
    final selectedOption = _careerOptions.firstWhere(
      (option) => option.id == careerPath,
    );

    // Special handling for government jobs - show specialization screen
    if (careerPath == 'govt') {
      setState(() {
        _isLoadingRoadmap = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const GovernmentJobsSpecializationScreen(),
        ),
      );
    } else {
      // Generate roadmap directly without timeline selection
      try {
        final roadmap = await _roadmapService.getRoadmapForCareerPath(
          careerPath: careerPath,
          userId: appProvider.user?.id,
          currentLevel: 'beginner',
          timeCommitment: 12, // Default 12 hours/week
          durationMonths: 6, // Default 6 months duration
        );

        setState(() {
          _isLoadingRoadmap = false;
        });

        // Show simple success message and navigate to dashboard
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${selectedOption.title} path selected! Navigate to dashboard to continue.',
            ),
            backgroundColor: AppColors.primary,
            duration: const Duration(seconds: 3),
          ),
        );

        // Navigate to dashboard after short delay
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            _navigateToDashboard();
          }
        });
      } catch (e) {
        setState(() {
          _isLoadingRoadmap = false;
          _selectedCareerPath = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate roadmap: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _navigateToDashboard() {
    Future.delayed(AppDurations.medium, () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const MainDashboard(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
          transitionDuration: AppDurations.medium,
        ),
      );
    });
  }

  /// Builds custom logos for each career path
  Widget _buildCareerLogo(
    String careerPath,
    Color primaryColor,
    bool isSelected,
  ) {
    final logoColor = isSelected ? primaryColor : primaryColor;
    final secondaryColor = isSelected
        ? primaryColor.withOpacity(0.7)
        : primaryColor.withOpacity(0.6);

    switch (careerPath) {
      case '10th':
        return Stack(
          children: [
            Center(
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: logoColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: logoColor, width: 2),
                ),
                child: Center(
                  child: Text(
                    '10',
                    style: TextStyle(
                      color: logoColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 2,
              right: 2,
              child: Icon(Icons.school, color: secondaryColor, size: 14),
            ),
          ],
        );

      case '12th':
        return Stack(
          children: [
            Center(
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [logoColor.withOpacity(0.8), logoColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    '12',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 2,
              right: 2,
              child: Icon(Icons.school_outlined, color: Colors.white, size: 12),
            ),
          ],
        );

      case 'neet':
        return Stack(
          children: [
            Center(
              child: Icon(Icons.medical_services, color: logoColor, size: 24),
            ),
            Positioned(
              bottom: 2,
              right: 2,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: logoColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 10),
              ),
            ),
          ],
        );

      case 'jee':
        return Stack(
          children: [
            Center(child: Icon(Icons.calculate, color: logoColor, size: 24)),
            Positioned(
              top: 2,
              right: 2,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: logoColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.functions,
                  color: Colors.white,
                  size: 8,
                ),
              ),
            ),
          ],
        );

      case 'govt':
        return Stack(
          children: [
            Center(
              child: Icon(Icons.account_balance, color: logoColor, size: 24),
            ),
            Positioned(
              bottom: 2,
              left: 2,
              child: Container(
                width: 12,
                height: 8,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFF6B35),
                      Color(0xFF138808),
                      Color(0xFF000080),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        );

      case 'ssc':
        return Stack(
          children: [
            Center(
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: logoColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: logoColor, width: 2),
                ),
                child: Center(
                  child: Text(
                    'SSC',
                    style: TextStyle(
                      color: logoColor,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 1,
              right: 1,
              child: Icon(Icons.verified, color: secondaryColor, size: 12),
            ),
          ],
        );

      case 'professional':
        return Stack(
          children: [
            Center(child: Icon(Icons.work_outline, color: logoColor, size: 24)),
            Positioned(
              top: 2,
              right: 2,
              child: Icon(Icons.trending_up, color: secondaryColor, size: 14),
            ),
          ],
        );

      case 'technology':
        return Stack(
          children: [
            Center(
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [logoColor.withOpacity(0.3), logoColor],
                    center: Alignment.center,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.computer,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
            Positioned(
              bottom: 1,
              right: 1,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        );

      default:
        return Icon(Icons.help_outline, color: logoColor, size: 24);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.background,
                  AppColors.primary.withOpacity(0.05),
                  AppColors.accent.withOpacity(0.05),
                ],
              ),
            ),
            child: SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Stack(
                    children: [
                      // Animated background elements
                      _buildAnimatedBackground(),

                      CustomScrollView(
                        slivers: [
                          // Header
                          SliverToBoxAdapter(child: _buildEnhancedHeader()),

                          // Career Options List
                          SliverPadding(
                            padding: const EdgeInsets.all(20),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _buildCareerListItem(
                                    _careerOptions[index],
                                    index,
                                  ),
                                );
                              }, childCount: _careerOptions.length),
                            ),
                          ),

                          // Bottom spacing
                          const SliverToBoxAdapter(child: SizedBox(height: 32)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Loading overlay
          if (_isLoadingRoadmap)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                          strokeWidth: 3,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Generating Your Roadmap',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Creating a personalized learning path...',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _backgroundAnimation,
      builder: (context, child) {
        return Positioned.fill(
          child: CustomPaint(
            painter: _BackgroundPatternPainter(_backgroundAnimation.value),
          ),
        );
      },
    );
  }

  Widget _buildEnhancedHeader() {
    final user = Provider.of<AppProvider>(context).user;

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome message with animated gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.accent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.stars,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome Back!',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            '${user?.name ?? 'Future Leader'} 🚀',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Text(
                  'Your journey to success starts with the right career choice',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Single career paths card (removed success stories)
          Row(
            children: [
              Expanded(
                child: _buildStatsCard(
                  '50+',
                  'Career Paths',
                  Icons.trending_up,
                  AppColors.secondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Selection instruction
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.1),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.touch_app,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Choose Your Path',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Select the option that best matches your current situation',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(
    String number,
    String label,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            number,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Builds line-by-line career selection items
  Widget _buildCareerListItem(CareerOption option, int index) {
    final isSelected = _selectedCareerPath == option.id;
    final isHovered = _hoveredIndex == index;

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 200 + (index * 50)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: MouseRegion(
              onEnter: (_) {
                setState(() {
                  _hoveredIndex = index;
                });
              },
              onExit: (_) {
                setState(() {
                  _hoveredIndex = null;
                });
              },
              child: GestureDetector(
                onTap: _isLoadingRoadmap
                    ? null
                    : () => _selectCareerPath(option.id),
                child: AnimatedContainer(
                  duration: AppDurations.fast,
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: isSelected ? option.gradient : null,
                    color: isSelected
                        ? null
                        : isHovered
                        ? AppColors.surface
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : isHovered
                          ? option.color.withOpacity(0.3)
                          : AppColors.outline.withOpacity(0.3),
                      width: isSelected ? 0 : 1,
                    ),
                    boxShadow: isSelected || isHovered
                        ? [
                            BoxShadow(
                              color: option.glowColor,
                              blurRadius: isSelected ? 20 : 10,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          // Logo with enhanced design
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: isSelected
                                    ? [
                                        Colors.white.withOpacity(0.9),
                                        Colors.white.withOpacity(0.7),
                                      ]
                                    : [Colors.white, Colors.grey.shade50],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: option.color.withOpacity(0.25),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: _buildCareerLogo(
                              option.id,
                              option.color,
                              isSelected,
                            ),
                          ),

                          const SizedBox(width: 16),

                          // Content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        option.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: isSelected
                                                  ? Colors.white
                                                  : AppColors.textPrimary,
                                              fontSize: 18,
                                            ),
                                      ),
                                    ),
                                    // Selection indicator
                                    if (isSelected)
                                      Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.1,
                                              ),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.check,
                                          color: option.color,
                                          size: 16,
                                        ),
                                      ),
                                  ],
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  option.subtitle,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: isSelected
                                            ? Colors.white.withOpacity(0.9)
                                            : AppColors.textSecondary,
                                        fontSize: 14,
                                      ),
                                ),

                                const SizedBox(height: 8),

                                // Opportunities and arrow
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Colors.white.withOpacity(0.2)
                                            : option.color.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                        border: isSelected
                                            ? Border.all(
                                                color: Colors.white.withOpacity(
                                                  0.3,
                                                ),
                                                width: 1,
                                              )
                                            : null,
                                      ),
                                      child: Text(
                                        '${option.opportunities.length} opportunities',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: isSelected
                                                  ? Colors.white
                                                  : option.color,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 11,
                                            ),
                                      ),
                                    ),

                                    // Animated arrow
                                    AnimatedContainer(
                                      duration: AppDurations.fast,
                                      transform: Matrix4.identity()
                                        ..translate(isHovered ? 4.0 : 0.0, 0.0),
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        color: isSelected
                                            ? Colors.white.withOpacity(0.8)
                                            : option.color.withOpacity(0.6),
                                        size: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Loading overlay
                      if (isSelected && _isLoadingRoadmap)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.black.withOpacity(0.7),
                            ),
                            child: const Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Generating Roadmap...',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CareerOption {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;
  final LinearGradient gradient;
  final Color glowColor;
  final List<String> opportunities;

  CareerOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
    required this.gradient,
    required this.glowColor,
    required this.opportunities,
  });
}

// Custom painter for animated background
class _BackgroundPatternPainter extends CustomPainter {
  final double animationValue;

  _BackgroundPatternPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withOpacity(0.02)
      ..style = PaintingStyle.fill;

    final paint2 = Paint()
      ..color = AppColors.accent.withOpacity(0.02)
      ..style = PaintingStyle.fill;

    // Draw animated circles
    for (int i = 0; i < 5; i++) {
      final offset = Offset(
        size.width * (0.2 + (i * 0.2)),
        size.height * (0.1 + (i * 0.15)) +
            math.sin(animationValue * 2 * math.pi + i) * 20,
      );

      canvas.drawCircle(
        offset,
        30 + math.sin(animationValue * 2 * math.pi + i) * 10,
        i.isEven ? paint : paint2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Custom painter for card patterns
class _CardPatternPainter extends CustomPainter {
  final Color color;

  _CardPatternPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw subtle pattern lines
    for (int i = 0; i < 3; i++) {
      final path = Path();
      path.moveTo(size.width * 0.7, size.height * (0.2 + i * 0.3));
      path.quadraticBezierTo(
        size.width * 0.9,
        size.height * (0.1 + i * 0.3),
        size.width,
        size.height * (0.2 + i * 0.3),
      );
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
