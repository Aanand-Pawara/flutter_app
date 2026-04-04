import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_app/providers/app_provider.dart';
import 'package:flutter_app/utils/app_theme.dart';
import 'package:flutter_app/utils/responsive_utils.dart';
import 'package:flutter_app/services/open_source_study_service.dart';
import 'package:flutter_app/services/duration_roadmap_service.dart';
import 'package:flutter_app/services/scholarship_service.dart';
import 'package:flutter_app/models/scholarship.dart';
import 'package:flutter_app/models/roadmap.dart';
import 'package:flutter_app/screens/main_screens/home_screens/avatar_interview_screen.dart';
import 'package:flutter_app/screens/main_screens/roadmap_duration_screen.dart';
import 'package:flutter_app/screens/main_screens/structured_roadmap_screen.dart';
import 'dart:math' as math;

class EnhancedDashboardScreen extends StatefulWidget {
  const EnhancedDashboardScreen({super.key});

  @override
  State<EnhancedDashboardScreen> createState() =>
      _EnhancedDashboardScreenState();
}

class _EnhancedDashboardScreenState extends State<EnhancedDashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Open source study service
  final OpenSourceStudyService _studyService = OpenSourceStudyService();

  // Duration-based roadmap service
  final DurationRoadmapService _durationRoadmapService =
      DurationRoadmapService();

  // Scholarship service
  final ScholarshipService _scholarshipService = ScholarshipService();

  final Map<String, Map<String, dynamic>> _careerPathData = {
    '10th': {
      'title': '10th Standard Path',
      'color': AppColors.primary,
      'gradient': AppColors.primaryGradient,
      'icon': Icons.school,
      'resources': [
        'Stream Selection Guide',
        'Career Exploration',
        'Study Tips',
        'Board Exam Prep',
      ],
      'nextSteps': [
        'Choose your stream (Science/Commerce/Arts)',
        'Research career options',
        'Plan 11th-12th subjects',
      ],
      'scholarships': 3,
      'opportunities': 12,
      'streams': {
        'science': {
          'title': 'Science Stream',
          'subjects': ['Physics', 'Chemistry', 'Mathematics', 'Biology'],
          'careers': ['Engineering', 'Medicine', 'Research', 'Technology'],
          'color': Color(0xFF10B981),
        },
        'commerce': {
          'title': 'Commerce Stream',
          'subjects': [
            'Accountancy',
            'Business Studies',
            'Economics',
            'Mathematics',
          ],
          'careers': ['CA/CS', 'Banking', 'Business', 'Finance'],
          'color': Color(0xFF3B82F6),
        },
        'arts': {
          'title': 'Arts Stream',
          'subjects': ['History', 'Political Science', 'Psychology', 'English'],
          'careers': ['Civil Services', 'Teaching', 'Journalism', 'Law'],
          'color': Color(0xFF8B5CF6),
        },
      },
    },
    '12th': {
      'title': '12th Standard Path',
      'color': AppColors.accent,
      'gradient': AppColors.accentGradient,
      'icon': Icons.school_outlined,
      'resources': [
        'College Selection',
        'Entrance Exam Prep',
        'Application Guide',
        'Career Counseling',
      ],
      'nextSteps': [
        'Prepare for entrance exams',
        'Apply to colleges',
        'Choose your course',
      ],
      'scholarships': 8,
      'opportunities': 25,
      'streams': {
        'science': {
          'title': 'Science Stream',
          'subjects': ['Physics', 'Chemistry', 'Mathematics', 'Biology'],
          'careers': [
            'JEE (Engineering)',
            'NEET (Medicine)',
            'Research Programs',
          ],
          'color': Color(0xFF10B981),
        },
        'commerce': {
          'title': 'Commerce Stream',
          'subjects': [
            'Accountancy',
            'Business Studies',
            'Economics',
            'Mathematics',
          ],
          'careers': ['BBA/BMS', 'CA Foundation', 'Economics Honors'],
          'color': Color(0xFF3B82F6),
        },
        'arts': {
          'title': 'Arts Stream',
          'subjects': ['History', 'Political Science', 'Psychology', 'English'],
          'careers': ['BA Programs', 'Law Entrance', 'Mass Communication'],
          'color': Color(0xFF8B5CF6),
        },
      },
    },
    'neet': {
      'title': 'NEET Preparation',
      'color': AppColors.error,
      'gradient': LinearGradient(colors: [AppColors.error, Color(0xFFDC2626)]),
      'icon': Icons.medical_services,
      'resources': [
        'NEET Study Material',
        'Mock Tests',
        'Previous Papers',
        'Biology Focus',
      ],
      'nextSteps': [
        'Complete syllabus',
        'Practice mock tests',
        'Revision strategy',
      ],
      'scholarships': 5,
      'opportunities': 15,
    },
    'jee': {
      'title': 'JEE Preparation',
      'color': AppColors.secondary,
      'gradient': AppColors.secondaryGradient,
      'icon': Icons.calculate,
      'resources': [
        'JEE Study Plan',
        'Mathematics Focus',
        'Physics Labs',
        'Chemistry Notes',
      ],
      'nextSteps': [
        'Master mathematics',
        'Practice problem solving',
        'Mock test series',
      ],
      'scholarships': 6,
      'opportunities': 20,
    },
    'govt': {
      'title': 'Government Jobs',
      'color': Color(0xFF8B5CF6),
      'gradient': LinearGradient(
        colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
      ),
      'icon': Icons.account_balance,
      'resources': [
        'UPSC Guide',
        'Current Affairs',
        'Mock Tests',
        'Interview Prep',
      ],
      'nextSteps': [
        'Choose exam category',
        'Start preparation',
        'Join study groups',
      ],
      'scholarships': 4,
      'opportunities': 18,
    },
    'technology': {
      'title': 'Technology & IT',
      'color': Color(0xFF3B82F6),
      'gradient': LinearGradient(
        colors: [Color(0xFF3B82F6), AppColors.primary],
      ),
      'icon': Icons.computer,
      'resources': [
        'Programming Courses',
        'Project Ideas',
        'Industry Trends',
        'Certification Guide',
      ],
      'nextSteps': ['Learn programming', 'Build projects', 'Get certified'],
      'scholarships': 7,
      'opportunities': 35,
    },
  };

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

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: AppCurves.easeOut,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _studyService.dispose();
    _durationRoadmapService.dispose();
    _scholarshipService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Enhanced Modern App Bar
              _buildModernAppBar(),

              // Main Content with better spacing
              SliverToBoxAdapter(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildModernWelcomeSection(),
                      const SizedBox(height: 20),
                      _buildInteractiveCareerCard(),
                      const SizedBox(height: 20),
                      _buildModernQuickActions(),
                      const SizedBox(height: 100), // Bottom padding
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

  Widget _buildModernAppBar() {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return SliverAppBar(
          expandedHeight: 0,
          floating: false,
          pinned: true,
          elevation: 0,
          backgroundColor: const Color(0xFFF5F7FA),
          foregroundColor: AppColors.textPrimary,
          flexibleSpace: Container(
            decoration: const BoxDecoration(color: Color(0xFFF5F7FA)),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF667EEA).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Text(
                  'OSCAR',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Dashboard',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () => _showModernNotificationsDialog(context),
                icon: Stack(
                  children: [
                    const Icon(
                      Icons.notifications_none_rounded,
                      color: AppColors.textPrimary,
                      size: 24,
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF6B6B),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
        );
      },
    );
  }

  Widget _buildModernWelcomeSection() {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final user = appProvider.user;
        final timeOfDay = DateTime.now().hour;
        String greeting = timeOfDay < 12
            ? 'Good Morning'
            : timeOfDay < 17
            ? 'Good Afternoon'
            : 'Good Evening';

        String emoji = timeOfDay < 12
            ? '🌅'
            : timeOfDay < 17
            ? '☀️'
            : '🌙';

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF667EEA).withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$greeting $emoji',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${user?.name ?? 'Student'}!',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Ready to advance your career today?',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.85),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.trending_up_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      color: Colors.white.withOpacity(0.9),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'AI-Powered Career Guidance',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInteractiveCareerCard() {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final selectedPath = appProvider.selectedCareerPath;
        if (selectedPath == null) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(
                  Icons.explore_rounded,
                  size: 48,
                  color: AppColors.primary.withOpacity(0.7),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Discover Your Path',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Start by selecting your career path to get personalized guidance',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _showCareerSelectionDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Choose Your Path',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          );
        }

        final pathData = _careerPathData[selectedPath];
        if (pathData == null) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: (pathData['color'] as Color).withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header with gradient
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: pathData['gradient'] as LinearGradient,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        pathData['icon'] as IconData,
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
                            pathData['title'] as String,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Your Active Path',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.keyboard_arrow_right_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.timeline_rounded,
                          color: pathData['color'] as Color,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Next Steps:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...((pathData['nextSteps'] as List<String>)
                        .take(2)
                        .map(
                          (step) => Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: (pathData['color'] as Color).withOpacity(
                                0.05,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: (pathData['color'] as Color).withOpacity(
                                  0.1,
                                ),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: pathData['color'] as Color,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Icon(
                                    Icons.check_rounded,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    step,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                    const SizedBox(height: 16),
                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _showRoadmapFlow(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: pathData['color'] as Color,
                              side: BorderSide(
                                color: pathData['color'] as Color,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Start Learning',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _navigateToScreen(context, 2),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: pathData['color'] as Color,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Get Guidance',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModernQuickActions() {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final selectedPath = appProvider.selectedCareerPath;
        final isStudentPath = selectedPath == '10th' || selectedPath == '12th';

        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.getSpacing(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.getSpacing(context, scale: 0.25),
                ),
                child: Row(
                  children: [
                    Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.responsiveFontSize(
                          context,
                          mobile: 20,
                          tablet: 22,
                          desktop: 24,
                        ),
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'View All',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: ResponsiveUtils.responsiveFontSize(
                            context,
                            mobile: 14,
                            tablet: 15,
                            desktop: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: ResponsiveUtils.getSpacing(context)),

              // Responsive grid layout
              ResponsiveUtils.isMobile(context)
                  ? _buildMobileActionsList(isStudentPath)
                  : _buildTabletDesktopActionsGrid(isStudentPath),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModernActionCard(
    String title,
    String subtitle,
    IconData icon,
    LinearGradient gradient,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(
          ResponsiveUtils.getSpacing(context, scale: 1.25),
        ),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.getBorderRadius(context),
          ),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withOpacity(0.3),
              blurRadius: ResponsiveUtils.getCardElevation(context) * 3,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: ResponsiveUtils.responsive(
                    context,
                    mobile: 36,
                    tablet: 40,
                    desktop: 44,
                  ),
                  height: ResponsiveUtils.responsive(
                    context,
                    mobile: 36,
                    tablet: 40,
                    desktop: 44,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(
                      ResponsiveUtils.getBorderRadius(context) * 0.75,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: ResponsiveUtils.responsive(
                      context,
                      mobile: 18,
                      tablet: 20,
                      desktop: 22,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white.withOpacity(0.8),
                  size: ResponsiveUtils.responsive(
                    context,
                    mobile: 14,
                    tablet: 16,
                    desktop: 18,
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveUtils.getSpacing(context)),
            Text(
              title,
              style: TextStyle(
                fontSize: ResponsiveUtils.responsiveFontSize(
                  context,
                  mobile: 14,
                  tablet: 16,
                  desktop: 18,
                ),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: ResponsiveUtils.getSpacing(context, scale: 0.25)),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: ResponsiveUtils.responsiveFontSize(
                  context,
                  mobile: 11,
                  tablet: 12,
                  desktop: 13,
                ),
                color: Colors.white.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileActionsList(bool isStudentPath) {
    final actions = _getActionsList(isStudentPath);

    return Column(
      children: actions
          .map(
            (action) => Padding(
              padding: EdgeInsets.only(
                bottom: ResponsiveUtils.getSpacing(context, scale: 0.75),
              ),
              child: _buildModernActionCard(
                action['title'],
                action['subtitle'],
                action['icon'],
                action['gradient'],
                action['onTap'],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildTabletDesktopActionsGrid(bool isStudentPath) {
    final actions = _getActionsList(isStudentPath);
    final crossAxisCount = ResponsiveUtils.responsive(
      context,
      mobile: 2,
      tablet: 2,
      desktop: 3,
    );

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: ResponsiveUtils.getSpacing(context, scale: 0.75),
        mainAxisSpacing: ResponsiveUtils.getSpacing(context, scale: 0.75),
        childAspectRatio: ResponsiveUtils.responsive(
          context,
          mobile: 1.3,
          tablet: 1.2,
          desktop: 1.1,
        ),
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return _buildModernActionCard(
          action['title'],
          action['subtitle'],
          action['icon'],
          action['gradient'],
          action['onTap'],
        );
      },
    );
  }

  List<Map<String, dynamic>> _getActionsList(bool isStudentPath) {
    return [
      {
        'title': 'My Roadmap',
        'subtitle': 'View learning path',
        'icon': Icons.map_rounded,
        'gradient': const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        'onTap': () => _showRoadmapFlow(context),
      },
      {
        'title': 'AI Mentor',
        'subtitle': 'Get instant guidance',
        'icon': Icons.psychology_rounded,
        'gradient': const LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        'onTap': () => _navigateToScreen(context, 2),
      },
      {
        'title': isStudentPath ? 'Stream Guide' : 'Interview Prep',
        'subtitle': isStudentPath
            ? 'Choose your stream'
            : 'Practice with AI bot',
        'icon': isStudentPath
            ? Icons.explore_rounded
            : Icons.record_voice_over_rounded,
        'gradient': const LinearGradient(
          colors: [Color(0xFFFF6B6B), Color(0xFFEE5A52)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        'onTap': () => isStudentPath
            ? _showStreamSelectionDialog(context)
            : _navigateToInterviewScreen(context),
      },
      {
        'title': 'Scholarships',
        'subtitle': 'Find funding opportunities',
        'icon': Icons.card_giftcard_rounded,
        'gradient': const LinearGradient(
          colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        'onTap': () => _showScholarshipDialog(context),
      },
      {
        'title': 'Study Resources',
        'subtitle': 'Access materials',
        'icon': Icons.library_books_rounded,
        'gradient': const LinearGradient(
          colors: [Color(0xFFFFA726), Color(0xFFFF9800)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        'onTap': () => _showOpenSourceStudyMaterials(context),
      },
      if (isStudentPath)
        {
          'title': 'Study Videos',
          'subtitle': 'Watch tutorials',
          'icon': Icons.play_circle_filled_rounded,
          'gradient': const LinearGradient(
            colors: [Color(0xFF9C27B0), Color(0xFF673AB7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          'onTap': () => _showStudyVideosDialog(context),
        },
    ];
  }

  /// Navigate to a specific tab in the main dashboard
  void _navigateToScreen(BuildContext context, int tabIndex) {
    // Find the MainDashboard state and update the selected index
    final scaffold = Scaffold.of(context);
    if (scaffold.hasDrawer) {
      // Use Navigator to push new screen if needed
      // For now, we'll use a simple approach
    }
    // Alternative approach: Use a callback or provider to update navigation
    // This is a simplified implementation
    print('Navigate to tab: $tabIndex');
  }

  /// Show modern notifications dialog
  void _showModernNotificationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: double.maxFinite,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.notifications_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Notifications',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '3 new updates',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildNotificationItem(
                  'New Career Opportunity',
                  'Software Developer positions available in your area',
                  Icons.work_rounded,
                  const Color(0xFF3B82F6),
                  '2h ago',
                ),
                const SizedBox(height: 16),
                _buildNotificationItem(
                  'Scholarship Alert',
                  'New scholarships available for engineering students',
                  Icons.school_rounded,
                  const Color(0xFF10B981),
                  '1d ago',
                ),
                const SizedBox(height: 16),
                _buildNotificationItem(
                  'Resume Tip',
                  'Update your skills section based on latest trends',
                  Icons.description_rounded,
                  const Color(0xFFF59E0B),
                  '3d ago',
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Close'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          // Navigate to full notifications screen
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'View All',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Show stream selection dialog for 10th/12th students
  void _showStreamSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<AppProvider>(
          builder: (context, appProvider, child) {
            final selectedPath = appProvider.selectedCareerPath;
            final pathData = selectedPath != null
                ? _careerPathData[selectedPath]
                : null;
            final streams = pathData?['streams'] as Map<String, dynamic>?;

            if (streams == null) return const SizedBox.shrink();

            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                width: double.maxFinite,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.explore_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Choose Your Stream',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                'Select the stream that interests you',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ...streams.entries.map((entry) {
                      final streamData = entry.value as Map<String, dynamic>;
                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: _buildStreamOption(
                          context,
                          entry.key,
                          streamData['title'] as String,
                          streamData['subjects'] as List<String>,
                          streamData['careers'] as List<String>,
                          streamData['color'] as Color,
                        ),
                      );
                    }),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStreamOption(
    BuildContext context,
    String streamKey,
    String title,
    List<String> subjects,
    List<String> careers,
    Color color,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        _showStreamResourcesDialog(
          context,
          streamKey,
          title,
          subjects,
          careers,
          color,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2), width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(_getStreamIcon(streamKey), color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Subjects: ${subjects.take(3).join(', ')}${subjects.length > 3 ? '...' : ''}',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Careers: ${careers.take(2).join(', ')}${careers.length > 2 ? '...' : ''}',
                    style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: color, size: 16),
          ],
        ),
      ),
    );
  }

  IconData _getStreamIcon(String streamKey) {
    switch (streamKey) {
      case 'science':
        return Icons.science_rounded;
      case 'commerce':
        return Icons.business_rounded;
      case 'arts':
        return Icons.palette_rounded;
      default:
        return Icons.school_rounded;
    }
  }

  /// Show stream-specific resources dialog
  void _showStreamResourcesDialog(
    BuildContext context,
    String streamKey,
    String title,
    List<String> subjects,
    List<String> careers,
    Color color,
  ) {
    final resources = _getStreamResources(streamKey);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height * 0.75,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        _getStreamIcon(streamKey),
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$title Resources',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Study materials and videos',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView(
                    children: [
                      // Subjects Section
                      _buildResourceSection(
                        'Subjects',
                        subjects,
                        Icons.subject_rounded,
                        color,
                        true,
                      ),
                      const SizedBox(height: 16),
                      // Study Materials Section
                      _buildResourceSection(
                        'Study Materials',
                        resources['materials'] as List<String>,
                        Icons.library_books_rounded,
                        color,
                        false,
                      ),
                      const SizedBox(height: 16),
                      // Video Resources Section
                      _buildResourceSection(
                        'Video Lectures',
                        resources['videos'] as List<String>,
                        Icons.play_circle_filled_rounded,
                        color,
                        false,
                      ),
                      const SizedBox(height: 16),
                      // Career Paths Section
                      _buildResourceSection(
                        'Career Opportunities',
                        careers,
                        Icons.work_rounded,
                        color,
                        false,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildResourceSection(
    String title,
    List<String> items,
    IconData icon,
    Color color,
    bool isSubject,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items
                .map(
                  (item) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSubject ? color.withOpacity(0.1) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: color.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isSubject ? color : AppColors.textPrimary,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Map<String, List<String>> _getStreamResources(String streamKey) {
    final resources = {
      'science': {
        'materials': [
          'NCERT Physics Textbook',
          'NCERT Chemistry Textbook',
          'NCERT Mathematics Textbook',
          'NCERT Biology Textbook',
          'Lab Manual & Practical Notes',
          'Previous Year Question Papers',
        ],
        'videos': [
          'Khan Academy Physics',
          'Khan Academy Chemistry',
          'Khan Academy Mathematics',
          'Khan Academy Biology',
          'Vedantu Free Classes',
          'BYJU\'S Free Videos',
        ],
      },
      'commerce': {
        'materials': [
          'NCERT Accountancy Textbook',
          'NCERT Business Studies',
          'NCERT Economics Textbook',
          'NCERT Mathematics Textbook',
          'Sample Papers & Mock Tests',
          'Case Study Materials',
        ],
        'videos': [
          'Khan Academy Economics',
          'Commerce Study Materials',
          'Accountancy Video Lectures',
          'Business Studies Videos',
          'Mathematics for Commerce',
          'Current Affairs Updates',
        ],
      },
      'arts': {
        'materials': [
          'NCERT History Textbooks',
          'NCERT Political Science',
          'NCERT Psychology Textbook',
          'NCERT English Literature',
          'Geography Study Materials',
          'Sociology Reference Books',
        ],
        'videos': [
          'History Documentary Series',
          'Political Science Lectures',
          'Psychology Case Studies',
          'English Literature Analysis',
          'Current Affairs & GK',
          'Essay Writing Techniques',
        ],
      },
    };

    return resources[streamKey] ??
        {
          'materials': ['Study Materials Available'],
          'videos': ['Video Lectures Available'],
        };
  }

  /// Show study videos dialog with actual loading
  void _showStudyVideosDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<AppProvider>(
          builder: (context, appProvider, child) {
            final selectedPath = appProvider.selectedCareerPath;

            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                width: double.maxFinite,
                height: MediaQuery.of(context).size.height * 0.7,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.play_circle_filled_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Study Videos',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                'Free educational videos for ${selectedPath ?? 'students'}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: FutureBuilder<List<Widget>>(
                        future: _loadVideoChannels(selectedPath),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 16),
                                  Text('Loading video resources...'),
                                ],
                              ),
                            );
                          }

                          if (snapshot.hasError) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    size: 48,
                                    color: AppColors.textSecondary,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Failed to load video resources',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed: () => setState(() {}),
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            );
                          }

                          final videoChannels = snapshot.data ?? [];
                          return ListView(children: videoChannels);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<List<Widget>> _loadVideoChannels(String? selectedPath) async {
    // Simulate API loading delay
    await Future.delayed(const Duration(seconds: 1));

    return _buildVideoChannels(selectedPath);
  }

  List<Widget> _buildVideoChannels(String? selectedPath) {
    final channels = [
      {
        'name': 'Khan Academy',
        'description': 'Free world-class education for anyone, anywhere',
        'subjects': 'Math, Science, Economics, Computing',
        'icon': Icons.school_rounded,
        'color': Color(0xFF14A085),
        'url': 'https://khanacademy.org',
      },
      {
        'name': 'BYJU\'S Free Classes',
        'description': 'Quality education content for Indian students',
        'subjects': 'All Subjects, Board Exam Prep',
        'icon': Icons.play_lesson_rounded,
        'color': Color(0xFF8E44AD),
        'url': 'https://byjus.com/free-classes',
      },
      {
        'name': 'Vedantu Free',
        'description': 'Live online tutoring platform',
        'subjects': 'CBSE, ICSE, State Boards',
        'icon': Icons.live_tv_rounded,
        'color': Color(0xFF3498DB),
        'url': 'https://vedantu.com',
      },
      {
        'name': 'NCERT Official',
        'description': 'Official NCERT video lectures',
        'subjects': 'All NCERT Subjects',
        'icon': Icons.library_books_rounded,
        'color': Color(0xFFE74C3C),
        'url': 'https://ncert.nic.in',
      },
      {
        'name': 'YouTube EDU',
        'description': 'Educational channels compilation',
        'subjects': 'Various Educational Content',
        'icon': Icons.video_library_rounded,
        'color': Color(0xFFFF5722),
        'url': 'https://youtube.com/education',
      },
    ];

    return channels
        .map(
          (channel) => GestureDetector(
            onTap: () async {
              // Show confirmation dialog before opening URL
              final bool? shouldOpen = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Open ${channel['name']}?'),
                  content: Text(
                    'This will open ${channel['name']} in your browser.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Open'),
                    ),
                  ],
                ),
              );

              if (shouldOpen == true) {
                try {
                  final Uri url = Uri.parse(channel['url'] as String);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Could not open ${channel['name']}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error opening ${channel['name']}: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: (channel['color'] as Color).withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: (channel['color'] as Color).withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: (channel['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      channel['icon'] as IconData,
                      color: channel['color'] as Color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          channel['name'] as String,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          channel['description'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          channel['subjects'] as String,
                          style: TextStyle(
                            fontSize: 11,
                            color: channel['color'] as Color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.open_in_new_rounded,
                    color: channel['color'] as Color,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();
  }

  /// Show open source study materials dialog
  void _showOpenSourceStudyMaterials(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<AppProvider>(
          builder: (context, appProvider, child) {
            final selectedPath = appProvider.selectedCareerPath;

            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                width: double.maxFinite,
                height: MediaQuery.of(context).size.height * 0.8,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFA726), Color(0xFFFF9800)],
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.auto_stories_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Open Source Study Materials',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                'Free educational resources for ${selectedPath ?? 'students'}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: _buildStudyMaterialCategories(selectedPath),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStudyMaterialCategories(String? selectedPath) {
    final categories = _getStudyCategories(selectedPath);

    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: _buildStudyCategoryCard(
            category['title'] as String,
            category['subjects'] as List<String>,
            category['description'] as String,
            category['icon'] as IconData,
            category['color'] as Color,
            category['priority'] as String,
          ),
        );
      },
    );
  }

  Widget _buildStudyCategoryCard(
    String title,
    List<String> subjects,
    String description,
    IconData icon,
    Color color,
    String priority,
  ) {
    return GestureDetector(
      onTap: () => _loadStudyMaterials(subjects.first, priority),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (priority == 'government')
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'GOVT APPROVED',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          if (priority == 'open_source')
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF3B82F6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'OPEN SOURCE',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, color: color, size: 16),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: subjects
                  .map(
                    (subject) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: color.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        subject,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: color,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getStudyCategories(String? selectedPath) {
    switch (selectedPath?.toLowerCase()) {
      case '10th':
        return [
          {
            'title': 'NCERT Class 10 Resources',
            'subjects': [
              'Mathematics',
              'Science',
              'English',
              'Social Science',
              'Hindi',
            ],
            'description':
                'Official NCERT textbooks and DIKSHA platform content for Class 10',
            'icon': Icons.account_balance_rounded,
            'color': const Color(0xFF10B981),
            'priority': 'government',
          },
          {
            'title': 'Board Exam Preparation',
            'subjects': [
              'Sample Papers',
              'Previous Year Questions',
              'Mock Tests',
            ],
            'description': 'CBSE/State board exam preparation materials',
            'icon': Icons.quiz_rounded,
            'color': const Color(0xFFFF6B6B),
            'priority': 'exam',
          },
          {
            'title': 'Khan Academy (Class 10)',
            'subjects': ['Math', 'Science', 'English Grammar'],
            'description':
                'Interactive lessons and practice for Class 10 subjects',
            'icon': Icons.school_rounded,
            'color': const Color(0xFF3B82F6),
            'priority': 'open_source',
          },
        ];

      case '12th':
        return [
          {
            'title': 'NCERT Class 12 Resources',
            'subjects': [
              'Physics',
              'Chemistry',
              'Mathematics',
              'Biology',
              'English',
            ],
            'description':
                'Official NCERT textbooks and solutions for Class 12',
            'icon': Icons.account_balance_rounded,
            'color': const Color(0xFF10B981),
            'priority': 'government',
          },
          {
            'title': 'Board Exam Resources',
            'subjects': [
              'Sample Papers',
              'Marking Schemes',
              'Important Questions',
            ],
            'description':
                'Complete preparation for Class 12 board examinations',
            'icon': Icons.assignment_rounded,
            'color': const Color(0xFFFF6B6B),
            'priority': 'exam',
          },
          {
            'title': 'Stream-Specific Resources',
            'subjects': ['Science Stream', 'Commerce Stream', 'Arts Stream'],
            'description': 'Specialized resources based on your chosen stream',
            'icon': Icons.category_rounded,
            'color': const Color(0xFF8B5CF6),
            'priority': 'stream',
          },
        ];

      case 'neet':
        return [
          {
            'title': 'NEET Physics Resources',
            'subjects': [
              'Mechanics',
              'Thermodynamics',
              'Optics',
              'Modern Physics',
            ],
            'description':
                'Comprehensive physics preparation for NEET examination',
            'icon': Icons.science_rounded,
            'color': const Color(0xFF10B981),
            'priority': 'subject',
          },
          {
            'title': 'NEET Chemistry Resources',
            'subjects': [
              'Organic',
              'Inorganic',
              'Physical Chemistry',
              'Biomolecules',
            ],
            'description': 'Complete chemistry curriculum for NEET preparation',
            'icon': Icons.biotech_rounded,
            'color': const Color(0xFFFF6B6B),
            'priority': 'subject',
          },
          {
            'title': 'NEET Biology Resources',
            'subjects': [
              'Human Physiology',
              'Plant Biology',
              'Genetics',
              'Ecology',
            ],
            'description': 'Detailed biology study materials for NEET success',
            'icon': Icons.eco_rounded,
            'color': const Color(0xFF8B5CF6),
            'priority': 'subject',
          },
          {
            'title': 'NEET Test Series & Mock Tests',
            'subjects': [
              'Full Length Tests',
              'Subject Tests',
              'Previous Year Papers',
            ],
            'description': 'Practice tests and analysis for NEET examination',
            'icon': Icons.quiz_rounded,
            'color': const Color(0xFFF59E0B),
            'priority': 'test',
          },
        ];

      case 'jee':
        return [
          {
            'title': 'JEE Mathematics Resources',
            'subjects': [
              'Calculus',
              'Coordinate Geometry',
              'Algebra',
              'Trigonometry',
            ],
            'description':
                'Advanced mathematics preparation for JEE Main & Advanced',
            'icon': Icons.calculate_rounded,
            'color': const Color(0xFF3B82F6),
            'priority': 'subject',
          },
          {
            'title': 'JEE Physics Resources',
            'subjects': [
              'Mechanics',
              'Electromagnetism',
              'Modern Physics',
              'Waves',
            ],
            'description': 'Complete physics curriculum for JEE preparation',
            'icon': Icons.science_rounded,
            'color': const Color(0xFF10B981),
            'priority': 'subject',
          },
          {
            'title': 'JEE Chemistry Resources',
            'subjects': [
              'Physical Chemistry',
              'Organic Chemistry',
              'Inorganic Chemistry',
            ],
            'description': 'Comprehensive chemistry study materials for JEE',
            'icon': Icons.biotech_rounded,
            'color': const Color(0xFFFF6B6B),
            'priority': 'subject',
          },
          {
            'title': 'JEE Strategy & Mock Tests',
            'subjects': [
              'Problem Solving',
              'Time Management',
              'Mock Tests',
              'Analysis',
            ],
            'description': 'Strategic preparation and practice for JEE success',
            'icon': Icons.psychology_rounded,
            'color': const Color(0xFF8B5CF6),
            'priority': 'strategy',
          },
        ];

      case 'govt':
      case 'government jobs':
        return [
          {
            'title': 'General Knowledge & Current Affairs',
            'subjects': [
              'Current Affairs',
              'Indian History',
              'Geography',
              'Polity',
            ],
            'description':
                'Essential GK preparation for government job examinations',
            'icon': Icons.public_rounded,
            'color': const Color(0xFF3B82F6),
            'priority': 'core',
          },
          {
            'title': 'Reasoning & Aptitude',
            'subjects': [
              'Logical Reasoning',
              'Quantitative Aptitude',
              'Data Interpretation',
            ],
            'description':
                'Problem-solving skills for competitive examinations',
            'icon': Icons.psychology_rounded,
            'color': const Color(0xFF10B981),
            'priority': 'aptitude',
          },
          {
            'title': 'English & Communication',
            'subjects': [
              'Grammar',
              'Vocabulary',
              'Reading Comprehension',
              'Essay Writing',
            ],
            'description':
                'English language skills for government job preparation',
            'icon': Icons.book_rounded,
            'color': const Color(0xFF8B5CF6),
            'priority': 'language',
          },
          {
            'title': 'Exam-Specific Preparation',
            'subjects': ['SSC', 'UPSC', 'Banking', 'Railway', 'State PSC'],
            'description':
                'Targeted preparation for specific government job exams',
            'icon': Icons.work_rounded,
            'color': const Color(0xFFFF6B6B),
            'priority': 'exam_specific',
          },
        ];

      case 'technology':
        return [
          {
            'title': 'Programming Fundamentals',
            'subjects': [
              'Python',
              'Java',
              'JavaScript',
              'Data Structures',
              'Algorithms',
            ],
            'description':
                'Core programming concepts and problem-solving skills',
            'icon': Icons.code_rounded,
            'color': const Color(0xFF3B82F6),
            'priority': 'programming',
          },
          {
            'title': 'Web Development',
            'subjects': ['HTML/CSS', 'React', 'Node.js', 'Databases', 'APIs'],
            'description': 'Full-stack web development skills and frameworks',
            'icon': Icons.web_rounded,
            'color': const Color(0xFF10B981),
            'priority': 'web',
          },
          {
            'title': 'Software Engineering',
            'subjects': [
              'System Design',
              'Software Architecture',
              'Testing',
              'DevOps',
            ],
            'description': 'Professional software development practices',
            'icon': Icons.engineering_rounded,
            'color': const Color(0xFFFF6B6B),
            'priority': 'engineering',
          },
          {
            'title': 'Industry Certifications',
            'subjects': [
              'AWS',
              'Google Cloud',
              'Microsoft Azure',
              'Docker',
              'Kubernetes',
            ],
            'description': 'Professional certifications and cloud technologies',
            'icon': Icons.verified_rounded,
            'color': const Color(0xFF8B5CF6),
            'priority': 'certification',
          },
        ];

      default:
        // Generic resources for unspecified or other career paths
        return [
          {
            'title': 'Government Resources',
            'subjects': ['NCERT', 'DIKSHA', 'SWAYAM', 'ePathshala'],
            'description':
                'Official government educational resources and platforms',
            'icon': Icons.account_balance_rounded,
            'color': const Color(0xFF10B981),
            'priority': 'government',
          },
          {
            'title': 'Open Source Platforms',
            'subjects': ['Khan Academy', 'MIT OCW', 'Coursera Free', 'edX'],
            'description': 'World-class education from leading institutions',
            'icon': Icons.school_rounded,
            'color': const Color(0xFF3B82F6),
            'priority': 'open_source',
          },
          {
            'title': 'Professional Development',
            'subjects': [
              'Skill Development',
              'Industry Training',
              'Certifications',
            ],
            'description': 'Career-focused learning and skill enhancement',
            'icon': Icons.work_rounded,
            'color': const Color(0xFFFF6B6B),
            'priority': 'professional',
          },
          {
            'title': 'Research & Resources',
            'subjects': ['Research Papers', 'Case Studies', 'Industry Reports'],
            'description': 'Academic and industry research materials',
            'icon': Icons.science_rounded,
            'color': const Color(0xFF8B5CF6),
            'priority': 'research',
          },
        ];
    }
  }

  void _loadStudyMaterials(String subject, String priority) async {
    final selectedPath = Provider.of<AppProvider>(
      context,
      listen: false,
    ).selectedCareerPath;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'Loading ${selectedPath ?? 'study'} materials...',
                style: TextStyle(fontSize: 16, color: AppColors.textPrimary),
              ),
              Text(
                'Subject: $subject',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );

    try {
      final materials = await _studyService.getStudyMaterials(
        subject.toLowerCase(),
        grade: selectedPath ?? 'general',
      );

      Navigator.of(context).pop(); // Close loading dialog

      if (materials.isNotEmpty) {
        _showDetailedStudyMaterials(context, subject, materials);
      } else {
        _showNoMaterialsDialog(context, subject);
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close loading dialog
      print('Error loading study materials: $e');
      _showErrorDialog(
        context,
        'Failed to load study materials for ${selectedPath ?? 'selected path'}. Please check your internet connection and try again.',
      );
    }
  }

  void _showNoMaterialsDialog(BuildContext context, String subject) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.info_outline_rounded, color: Colors.orange, size: 28),
            const SizedBox(width: 12),
            const Text('No Materials Found'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'No study materials found for $subject.',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            const Text(
              'Try selecting a different subject or check back later.',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showDetailedStudyMaterials(
    BuildContext context,
    String subject,
    Map<String, dynamic> materials,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height * 0.85,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF10B981), Color(0xFF059669)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.auto_stories_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${subject.substring(0, 1).toUpperCase()}${subject.substring(1)} Study Materials',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '${materials['total_resources']} resources available',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView(
                    children: [
                      // Government Resources Section (Priority 1)
                      if (materials['government_resources'] != null)
                        _buildMaterialSection(
                          'Government Approved Resources',
                          materials['government_resources'] as List<dynamic>,
                          Icons.account_balance_rounded,
                          const Color(0xFF10B981),
                          'Verified by Government of India',
                        ),

                      // Open Source Platforms Section (Priority 2)
                      if (materials['open_source_platforms'] != null)
                        _buildMaterialSection(
                          'Open Source Educational Platforms',
                          materials['open_source_platforms'] as List<dynamic>,
                          Icons.school_rounded,
                          const Color(0xFF3B82F6),
                          'World-class free education',
                        ),

                      // Video Resources Section (Priority 3)
                      if (materials['video_resources'] != null)
                        _buildMaterialSection(
                          'Video Learning Resources',
                          materials['video_resources'] as List<dynamic>,
                          Icons.play_circle_filled_rounded,
                          const Color(0xFFFF6B6B),
                          'Visual and interactive learning',
                        ),

                      // GitHub Resources Section (Priority 4)
                      if (materials['github_resources'] != null)
                        _buildMaterialSection(
                          'GitHub Educational Repositories',
                          materials['github_resources'] as List<dynamic>,
                          Icons.code_rounded,
                          const Color(0xFF8B5CF6),
                          'Community-driven content',
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMaterialSection(
    String title,
    List<dynamic> resources,
    IconData icon,
    Color color,
    String subtitle,
  ) {
    if (resources.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      subtitle,
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
          const SizedBox(height: 12),
          ...resources.map(
            (resource) =>
                _buildResourceItem(resource as Map<String, dynamic>, color),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceItem(Map<String, dynamic> resource, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  resource['title'] ?? 'Resource',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              if (resource['free'] == true)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'FREE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              if (resource['verified'] == true)
                Container(
                  margin: const EdgeInsets.only(left: 4),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'VERIFIED',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (resource['description'] != null)
            Text(
              resource['description'],
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.language_rounded,
                size: 14,
                color: AppColors.textTertiary,
              ),
              const SizedBox(width: 4),
              Text(
                resource['provider'] ?? 'Unknown',
                style: TextStyle(fontSize: 11, color: AppColors.textTertiary),
              ),
              if (resource['language'] != null) ...[
                const SizedBox(width: 12),
                Icon(
                  Icons.translate_rounded,
                  size: 14,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(width: 4),
                Text(
                  resource['language'],
                  style: TextStyle(fontSize: 11, color: AppColors.textTertiary),
                ),
              ],
              const Spacer(),
              GestureDetector(
                onTap: () async {
                  try {
                    final Uri url = Uri.parse(resource['url']);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Could not open ${resource['title']}',
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error opening link: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Open',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.open_in_new_rounded,
                        size: 12,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Show career selection dialog
  void _showCareerSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height * 0.7,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.explore_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Choose Your Path',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Select your career path to get started',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.85,
                    children: _careerPathData.entries.map((entry) {
                      return _buildCareerOption(
                        context,
                        entry.key,
                        entry.value['title'] as String,
                        entry.value['icon'] as IconData,
                        entry.value['color'] as Color,
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCareerOption(
    BuildContext context,
    String key,
    String title,
    IconData icon,
    Color color,
  ) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return GestureDetector(
          onTap: () async {
            // Close the dialog first
            Navigator.of(context).pop();

            // Set the career path
            appProvider.setCareerPath(key);

            // Show loading dialog
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: color),
                      const SizedBox(height: 16),
                      Text(
                        'Generating Your Roadmap',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Creating personalized learning path for $title...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );

            try {
              // Generate roadmap using the roadmap service
              final roadmap = await _durationRoadmapService
                  .generateDurationBasedRoadmap(
                    careerPath: key,
                    duration: '6M', // Default to 6 months
                    currentLevel: 'beginner',
                  );

              // Close loading dialog
              Navigator.of(context).pop();

              // Navigate to structured roadmap screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StructuredRoadmapScreen(
                    roadmap: _convertToRoadmapModel(roadmap, key),
                    durationOption: DurationOption(
                      id: '6M',
                      title: '6 Months',
                      subtitle: 'Balanced Learning',
                      description:
                          'Comprehensive learning with sustainable pace',
                      duration: 6,
                      intensity: 'Moderate',
                      color: color,
                      gradient: LinearGradient(
                        colors: [color, color.withOpacity(0.7)],
                      ),
                      features: [
                        'Structured Phases',
                        'Regular Assessments',
                        'Practical Projects',
                      ],
                      commitment: '10-15 hours per week',
                      outcome: 'Job-ready skills',
                    ),
                    careerTitle: title,
                  ),
                ),
              );
            } catch (e) {
              // Close loading dialog
              Navigator.of(context).pop();

              // Show error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to generate roadmap: $e'),
                  backgroundColor: Colors.red,
                  action: SnackBarAction(
                    label: 'Retry',
                    textColor: Colors.white,
                    onPressed: () {
                      // Retry by calling this function again
                      _buildCareerOption(context, key, title, icon, color);
                    },
                  ),
                ),
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.3), width: 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build individual notification item
  Widget _buildNotificationItem(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    String time,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.1), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(fontSize: 12, color: AppColors.textTertiary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: TextStyle(
                  color: AppColors.textTertiary,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Navigate to interview screen
  void _navigateToInterviewScreen(BuildContext context) {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AvatarInterviewScreen(
            category: 'technical',
            level: 'intermediate',
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error opening interview: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Show comprehensive roadmap screen with all features
  void _showComprehensiveRoadmapScreen(
    BuildContext context,
    Map<String, dynamic> roadmapData,
    String careerPath,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.95,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: DefaultTabController(
            length: 6, // Always 6 tabs for all career paths
            child: Column(
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Header
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.auto_awesome_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              roadmapData['title'] ?? 'Your Learning Journey',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              '${roadmapData['total_resources'] ?? 0} resources available',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                ),
                // Tab Bar
                TabBar(
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.textSecondary,
                  indicatorColor: AppColors.primary,
                  isScrollable: true,
                  tabs: [
                    const Tab(text: 'Roadmap'),
                    const Tab(text: 'Resources'),
                    const Tab(text: 'Scholarships'),
                    const Tab(text: 'Subject Notes'),
                    const Tab(text: 'AI Mentor'),
                    const Tab(text: 'Videos'),
                  ],
                ),
                // Tab Content
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildRoadmapTab(roadmapData),
                      _buildResourcesTab(roadmapData),
                      _buildScholarshipsTab(careerPath),
                      _buildSubjectNotesTab(careerPath),
                      _buildAIMentorTab(),
                      _buildVideosTab(careerPath),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build roadmap tab content
  Widget _buildRoadmapTab(Map<String, dynamic> roadmapData) {
    final phases = roadmapData['phases'] as List? ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Learning Phases',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          if (phases.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'No phases available yet. Please try again.',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            )
          else
            ...phases.asMap().entries.map((entry) {
              final index = entry.key;
              final phase = entry.value;
              return _buildPhaseCard(phase, index, phases.length);
            }),
        ],
      ),
    );
  }

  /// Build resources tab content
  Widget _buildResourcesTab(Map<String, dynamic> roadmapData) {
    final selectedPath = Provider.of<AppProvider>(
      context,
      listen: false,
    ).selectedCareerPath;
    final pathDisplayName = _getCareerPathDisplayName(
      selectedPath ?? 'general',
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_stories_rounded,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Study Resources - $pathDisplayName',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Curated study materials specifically for $pathDisplayName preparation',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          // Career Path Specific Resources Button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF10B981), Color(0xFF059669)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.auto_stories_rounded,
                  color: Colors.white,
                  size: 48,
                ),
                const SizedBox(height: 12),
                Text(
                  '$pathDisplayName Study Materials',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Government-approved resources, specialized courses, and practice materials for $pathDisplayName',
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _showOpenSourceStudyMaterials(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF10B981),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Access Resources',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Resources are specifically curated for $pathDisplayName based on curriculum requirements and exam patterns.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Total Resources Available: ${_getResourceCountForPath(selectedPath)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  /// Build scholarships tab
  Widget _buildScholarshipsTab(String careerPath) {
    final scholarships = _getScholarshipsForCareerPath(careerPath);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.card_giftcard_rounded,
                color: Color(0xFFFF6B6B),
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Available Scholarships',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...scholarships.map(
            (scholarship) => _buildScholarshipCardFromMap(scholarship),
          ),
        ],
      ),
    );
  }

  /// Build subject notes tab for any career path
  Widget _buildSubjectNotesTab(String careerPath) {
    final subjects = _getSubjectsForCareerPath(careerPath);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_getCareerPathDisplayName(careerPath)} Subject Notes',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...subjects.entries.map(
            (entry) => _buildSubjectCard(
              entry.key,
              entry.value['chapters'] as List<String>,
              entry.value['color'] as Color,
              entry.value['icon'] as IconData,
            ),
          ),
        ],
      ),
    );
  }

  /// Get subjects based on career path
  Map<String, Map<String, dynamic>> _getSubjectsForCareerPath(
    String careerPath,
  ) {
    switch (careerPath.toLowerCase()) {
      case '10th':
        return {
          'Mathematics': {
            'chapters': ['Number Systems', 'Algebra', 'Geometry', 'Statistics'],
            'color': const Color(0xFF3B82F6),
            'icon': Icons.calculate_rounded,
          },
          'Science': {
            'chapters': ['Physics', 'Chemistry', 'Biology', 'Lab Activities'],
            'color': const Color(0xFF10B981),
            'icon': Icons.science_rounded,
          },
          'Social Science': {
            'chapters': ['History', 'Geography', 'Civics', 'Economics'],
            'color': const Color(0xFF8B5CF6),
            'icon': Icons.public_rounded,
          },
          'English': {
            'chapters': [
              'Grammar',
              'Literature',
              'Writing Skills',
              'Communication',
            ],
            'color': const Color(0xFFF59E0B),
            'icon': Icons.book_rounded,
          },
        };

      case '12th':
        return {
          'Mathematics': {
            'chapters': ['Calculus', 'Algebra', 'Trigonometry', 'Statistics'],
            'color': const Color(0xFF3B82F6),
            'icon': Icons.calculate_rounded,
          },
          'Physics': {
            'chapters': [
              'Mechanics',
              'Thermodynamics',
              'Optics',
              'Modern Physics',
            ],
            'color': const Color(0xFF10B981),
            'icon': Icons.science_rounded,
          },
          'Chemistry': {
            'chapters': [
              'Organic Chemistry',
              'Inorganic Chemistry',
              'Physical Chemistry',
            ],
            'color': const Color(0xFFFF6B6B),
            'icon': Icons.biotech_rounded,
          },
          'Biology': {
            'chapters': ['Genetics', 'Ecology', 'Evolution', 'Biotechnology'],
            'color': const Color(0xFF8B5CF6),
            'icon': Icons.eco_rounded,
          },
        };

      case 'neet':
        return {
          'Physics': {
            'chapters': [
              'Mechanics',
              'Waves & Oscillations',
              'Modern Physics',
              'Electromagnetism',
            ],
            'color': const Color(0xFF10B981),
            'icon': Icons.science_rounded,
          },
          'Chemistry': {
            'chapters': [
              'Organic Chemistry',
              'Inorganic Chemistry',
              'Physical Chemistry',
              'Biomolecules',
            ],
            'color': const Color(0xFFFF6B6B),
            'icon': Icons.biotech_rounded,
          },
          'Biology': {
            'chapters': [
              'Human Physiology',
              'Plant Biology',
              'Genetics & Evolution',
              'Ecology',
            ],
            'color': const Color(0xFF8B5CF6),
            'icon': Icons.eco_rounded,
          },
          'NEET Strategy': {
            'chapters': [
              'Time Management',
              'Mock Tests',
              'Revision Techniques',
              'Previous Year Analysis',
            ],
            'color': const Color(0xFF3B82F6),
            'icon': Icons.psychology_rounded,
          },
        };

      case 'jee':
        return {
          'Mathematics': {
            'chapters': [
              'Calculus',
              'Coordinate Geometry',
              'Algebra',
              'Trigonometry',
            ],
            'color': const Color(0xFF3B82F6),
            'icon': Icons.calculate_rounded,
          },
          'Physics': {
            'chapters': [
              'Mechanics',
              'Electromagnetism',
              'Modern Physics',
              'Waves',
            ],
            'color': const Color(0xFF10B981),
            'icon': Icons.science_rounded,
          },
          'Chemistry': {
            'chapters': [
              'Physical Chemistry',
              'Organic Chemistry',
              'Inorganic Chemistry',
            ],
            'color': const Color(0xFFFF6B6B),
            'icon': Icons.biotech_rounded,
          },
          'JEE Strategy': {
            'chapters': [
              'Problem Solving',
              'Time Management',
              'Mock Tests',
              'Previous Year Papers',
            ],
            'color': const Color(0xFF8B5CF6),
            'icon': Icons.psychology_rounded,
          },
        };

      case 'govt':
      case 'government jobs':
        return {
          'General Knowledge': {
            'chapters': ['Current Affairs', 'History', 'Geography', 'Polity'],
            'color': const Color(0xFF3B82F6),
            'icon': Icons.public_rounded,
          },
          'Reasoning': {
            'chapters': [
              'Logical Reasoning',
              'Analytical Reasoning',
              'Verbal Reasoning',
              'Non-Verbal Reasoning',
            ],
            'color': const Color(0xFF10B981),
            'icon': Icons.psychology_rounded,
          },
          'Quantitative Aptitude': {
            'chapters': [
              'Mathematics',
              'Data Interpretation',
              'Number Systems',
              'Algebra',
            ],
            'color': const Color(0xFFFF6B6B),
            'icon': Icons.calculate_rounded,
          },
          'English': {
            'chapters': [
              'Grammar',
              'Vocabulary',
              'Reading Comprehension',
              'Writing Skills',
            ],
            'color': const Color(0xFF8B5CF6),
            'icon': Icons.book_rounded,
          },
        };

      case 'technology':
        return {
          'Programming': {
            'chapters': [
              'Data Structures',
              'Algorithms',
              'Object-Oriented Programming',
              'Database Systems',
            ],
            'color': const Color(0xFF3B82F6),
            'icon': Icons.code_rounded,
          },
          'Web Development': {
            'chapters': [
              'HTML/CSS',
              'JavaScript',
              'Frontend Frameworks',
              'Backend Development',
            ],
            'color': const Color(0xFF10B981),
            'icon': Icons.web_rounded,
          },
          'Software Engineering': {
            'chapters': [
              'System Design',
              'Software Architecture',
              'Testing',
              'DevOps',
            ],
            'color': const Color(0xFFFF6B6B),
            'icon': Icons.engineering_rounded,
          },
          'Industry Skills': {
            'chapters': [
              'Project Management',
              'Version Control',
              'Agile Methodology',
              'Communication',
            ],
            'color': const Color(0xFF8B5CF6),
            'icon': Icons.business_rounded,
          },
        };

      default:
        return {
          'Core Subjects': {
            'chapters': [
              'Fundamental Concepts',
              'Basic Principles',
              'Applications',
              'Practice Problems',
            ],
            'color': const Color(0xFF3B82F6),
            'icon': Icons.school_rounded,
          },
          'Practical Skills': {
            'chapters': [
              'Hands-on Learning',
              'Project Work',
              'Case Studies',
              'Real-world Applications',
            ],
            'color': const Color(0xFF10B981),
            'icon': Icons.handyman_rounded,
          },
          'General Knowledge': {
            'chapters': [
              'Current Affairs',
              'General Studies',
              'Basic Science',
              'History & Geography',
            ],
            'color': const Color(0xFFFF6B6B),
            'icon': Icons.quiz_rounded,
          },
          'Communication': {
            'chapters': [
              'Language Skills',
              'Presentation',
              'Writing',
              'Interview Preparation',
            ],
            'color': const Color(0xFF8B5CF6),
            'icon': Icons.chat_rounded,
          },
        };
    }
  }

  /// Get resource count for career path
  int _getResourceCountForPath(String? selectedPath) {
    switch (selectedPath?.toLowerCase()) {
      case '10th':
        return 150; // NCERT + Board prep + Khan Academy resources
      case '12th':
        return 200; // More advanced resources
      case 'neet':
        return 300; // Extensive medical entrance prep
      case 'jee':
        return 280; // Engineering entrance prep
      case 'govt':
      case 'government jobs':
        return 250; // Government job preparation
      case 'technology':
        return 400; // Programming and tech resources
      default:
        return 100; // General resources
    }
  }

  /// Get display name for career path
  String _getCareerPathDisplayName(String careerPath) {
    switch (careerPath.toLowerCase()) {
      case '10th':
        return '10th Grade';
      case '12th':
        return '12th Grade';
      case 'neet':
        return 'NEET';
      case 'jee':
        return 'JEE';
      case 'govt':
      case 'government jobs':
        return 'Government Jobs';
      case 'technology':
        return 'Technology & IT';
      default:
        return careerPath.toUpperCase();
    }
  }

  /// Build AI Mentor tab
  Widget _buildAIMentorTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.psychology_rounded,
                  color: Colors.white,
                  size: 64,
                ),
                const SizedBox(height: 16),
                const Text(
                  'AI Mentor',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Get instant help with your doubts and questions',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _showAIMentorChat(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF667EEA),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Start Chat',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Popular Questions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ..._getPopularQuestions().map(
            (question) => _buildQuestionCard(question),
          ),
        ],
      ),
    );
  }

  /// Build videos tab
  Widget _buildVideosTab(String careerPath) {
    final videos = _getVideosForCareerPath(careerPath);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Educational Videos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...videos.map((video) => _buildVideoCard(video)),
        ],
      ),
    );
  }

  // Helper methods for content generation

  List<Map<String, dynamic>> _getScholarshipsForCareerPath(String careerPath) {
    return [
      {
        'title': 'Merit Scholarship for ${careerPath.toUpperCase()}',
        'amount': '₹50,000',
        'deadline': '30 days left',
        'description': 'Merit-based scholarship for outstanding students',
        'eligibility': '80%+ marks required',
      },
      {
        'title': 'Need-based Financial Aid',
        'amount': '₹25,000',
        'deadline': '45 days left',
        'description': 'Financial assistance for economically weaker sections',
        'eligibility': 'Family income < 2.5 LPA',
      },
      {
        'title': 'Excellence Award',
        'amount': '₹75,000',
        'deadline': '60 days left',
        'description': 'For students with exceptional academic performance',
        'eligibility': '90%+ marks in previous exam',
      },
    ];
  }

  List<String> _getPopularQuestions() {
    return [
      'How to prepare for entrance exams effectively?',
      'What are the best study techniques for memorization?',
      'How to manage time during exams?',
      'Which books are best for my stream?',
      'How to handle exam stress and anxiety?',
    ];
  }

  List<Map<String, dynamic>> _getVideosForCareerPath(String careerPath) {
    return [
      {
        'title': 'Complete ${careerPath.toUpperCase()} Guide',
        'channel': 'Educational Hub',
        'duration': '45:30',
        'views': '1.2M views',
        'thumbnail': 'https://via.placeholder.com/300x200',
      },
      {
        'title': 'Study Tips and Tricks',
        'channel': 'Learning Academy',
        'duration': '25:15',
        'views': '850K views',
        'thumbnail': 'https://via.placeholder.com/300x200',
      },
      {
        'title': 'Exam Preparation Strategy',
        'channel': 'Success Stories',
        'duration': '35:45',
        'views': '2.1M views',
        'thumbnail': 'https://via.placeholder.com/300x200',
      },
    ];
  }

  // Widget builders for cards

  Widget _buildPhaseCard(
    Map<String, dynamic> phase,
    int index,
    int totalPhases,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              if (index < totalPhases - 1)
                Container(
                  width: 2,
                  height: 40,
                  color: Colors.grey.withOpacity(0.3),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Phase content
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    phase['title'] ?? 'Phase ${index + 1}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    phase['description'] ?? 'Learning phase description',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule_rounded,
                        size: 16,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${phase['duration_weeks'] ?? 4} weeks',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectCard(
    String subject,
    List<String> chapters,
    Color color,
    IconData icon,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 12),
              Text(
                subject,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => _showSubjectNotes(context, subject, chapters),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                child: const Text(
                  'View Notes',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Chapters: ${chapters.join(', ')}',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(String question) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.help_outline_rounded,
            color: Color(0xFF667EEA),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              question,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _askAIMentor(question),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF667EEA),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Ask',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoCard(Map<String, dynamic> video) {
    return GestureDetector(
      onTap: () async {
        if (video['url'] != null) {
          try {
            final Uri url = Uri.parse(video['url']);
            if (await canLaunchUrl(url)) {
              await launchUrl(url, mode: LaunchMode.externalApplication);
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Could not play ${video['title']}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error playing video: $e'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        } else {
          // Show demo message for videos without URLs
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Playing ${video['title']}...'),
                backgroundColor: AppColors.primary,
              ),
            );
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.play_circle_fill,
                    size: 32,
                    color: Colors.white,
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        video['duration'] ?? '0:00',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video['title'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    video['channel'],
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.visibility,
                        size: 12,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        video['views'] ?? '1K views',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textTertiary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.thumb_up,
                        size: 12,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        video['likes'] ?? '100',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.play_arrow, color: AppColors.primary, size: 24),
          ],
        ),
      ),
    );
  }

  // Action methods

  void _showAIMentorChat(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AI Mentor Chat'),
        content: const Text(
          'AI Mentor feature will be available soon! You can ask questions and get instant help with your studies.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _askAIMentor(String question) {
    // Implementation for AI mentor question
    print('Asking AI Mentor: $question');
  }

  void _showSubjectNotes(
    BuildContext context,
    String subject,
    List<String> chapters,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$subject Notes'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Available chapters:'),
            const SizedBox(height: 8),
            ...chapters.map((chapter) => Text('• $chapter')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Open subject notes
            },
            child: const Text('Open Notes'),
          ),
        ],
      ),
    );
  }

  /// Navigate to roadmap generation flow with comprehensive structure
  void _showRoadmapFlow(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final selectedPath = appProvider.selectedCareerPath;

    if (selectedPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a career path first'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Show duration selection dialog first (based on project memory)
    _showDurationSelectionDialog(context, selectedPath);
  }

  /// Show duration selection dialog for interactive planning
  void _showDurationSelectionDialog(BuildContext context, String careerPath) {
    final durationOptions = [
      {
        'id': '3M',
        'title': '3 Months',
        'subtitle': 'Intensive Bootcamp',
        'description':
            'Fast-track learning with core skills and immediate job readiness',
        'color': const Color(0xFFFF6B6B),
        'intensity': 'High',
        'hoursPerWeek': 25,
      },
      {
        'id': '6M',
        'title': '6 Months',
        'subtitle': 'Balanced Approach',
        'description':
            'Comprehensive learning with sustainable pace and deep understanding',
        'color': const Color(0xFF4ECDC4),
        'intensity': 'Moderate',
        'hoursPerWeek': 15,
      },
      {
        'id': '1Y',
        'title': '1 Year',
        'subtitle': 'Comprehensive Journey',
        'description':
            'Complete mastery with extensive practice and real-world projects',
        'color': const Color(0xFF45B7D1),
        'intensity': 'Comfortable',
        'hoursPerWeek': 10,
      },
      {
        'id': '2Y',
        'title': '2 Years',
        'subtitle': 'Mastery Path',
        'description':
            'Expert-level proficiency with specialization and advanced topics',
        'color': const Color(0xFF8B5CF6),
        'intensity': 'Flexible',
        'hoursPerWeek': 8,
      },
    ];

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: double.maxFinite,
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.schedule_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Choose Your Learning Duration',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Select the timeframe that fits your schedule',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ...durationOptions.map(
                (option) => Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: _buildDurationOptionCard(context, option, careerPath),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getCareerTitle(String careerPath) {
    final pathData = _careerPathData[careerPath];
    return pathData?['title'] ?? 'Career Path';
  }

  /// Build duration option card
  Widget _buildDurationOptionCard(
    BuildContext context,
    Map<String, dynamic> option,
    String careerPath,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        _generateAndShowStructuredRoadmap(context, careerPath, option);
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: (option['color'] as Color).withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: (option['color'] as Color).withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: option['color'] as Color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.timeline_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option['title'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        option['subtitle'],
                        style: TextStyle(
                          fontSize: 14,
                          color: option['color'] as Color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: option['color'] as Color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${option['hoursPerWeek']}h/week',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              option['description'],
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.speed_rounded,
                  size: 16,
                  color: option['color'] as Color,
                ),
                const SizedBox(width: 4),
                Text(
                  'Intensity: ${option['intensity']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: option['color'] as Color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: option['color'] as Color,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Generate and show comprehensive structured roadmap
  void _generateAndShowStructuredRoadmap(
    BuildContext context,
    String careerPath,
    Map<String, dynamic> durationOption,
  ) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: durationOption['color'] as Color,
              ),
              const SizedBox(height: 16),
              Text(
                'Generating Your ${durationOption['title']} Roadmap',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Creating comprehensive learning path...',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );

    try {
      // Generate comprehensive roadmap data
      final roadmapData = await _generateComprehensiveRoadmapData(
        careerPath,
        durationOption,
      );

      // Close loading dialog
      Navigator.of(context).pop();

      // Show structured roadmap
      _showStructuredRoadmapDialog(
        context,
        careerPath,
        durationOption,
        roadmapData,
      );
    } catch (e) {
      // Close loading dialog
      Navigator.of(context).pop();

      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to generate roadmap: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Convert duration roadmap service response to Roadmap model
  Roadmap _convertToRoadmapModel(
    Map<String, dynamic> roadmapData,
    String careerPath,
  ) {
    final phases = (roadmapData['phases'] as List<dynamic>? ?? [])
        .map(
          (phaseData) => RoadmapPhase(
            id:
                phaseData['id'] ??
                'phase_${DateTime.now().millisecondsSinceEpoch}',
            title: phaseData['title'] ?? 'Learning Phase',
            description: phaseData['description'] ?? 'Phase description',
            duration: phaseData['duration'] ?? 4,
            order: phaseData['order'] ?? 1,
            skills: List<String>.from(phaseData['skills'] ?? []),
            milestones: (phaseData['milestones'] as List<dynamic>? ?? [])
                .map(
                  (milestoneData) => RoadmapMilestone(
                    id:
                        milestoneData['id'] ??
                        'milestone_${DateTime.now().millisecondsSinceEpoch}',
                    title: milestoneData['title'] ?? 'Milestone',
                    description:
                        milestoneData['description'] ?? 'Milestone description',
                    type: MilestoneType.learning,
                    points: milestoneData['points'] ?? 10,
                    deliverables: List<String>.from(
                      milestoneData['deliverables'] ?? ['Complete phase tasks'],
                    ),
                  ),
                )
                .toList(),
            resources: (phaseData['resources'] as List<dynamic>? ?? [])
                .map(
                  (resourceData) => Resource(
                    id:
                        resourceData['id'] ??
                        'resource_${DateTime.now().millisecondsSinceEpoch}',
                    title: resourceData['title'] ?? 'Resource',
                    description:
                        resourceData['description'] ?? 'Resource description',
                    type: ResourceType.course,
                    url: resourceData['url'] ?? '',
                    provider: resourceData['provider'] ?? 'Unknown',
                    duration: resourceData['estimated_time'] ?? 30,
                  ),
                )
                .toList(),
          ),
        )
        .toList();

    return Roadmap(
      id:
          roadmapData['roadmap_id'] ??
          'roadmap_${DateTime.now().millisecondsSinceEpoch}',
      careerPath: careerPath,
      title:
          roadmapData['title'] ??
          '${_getCareerTitle(careerPath)} Learning Path',
      description:
          roadmapData['description'] ??
          'Comprehensive learning roadmap for ${_getCareerTitle(careerPath)}',
      estimatedDuration: _parseDurationToMonths(
        roadmapData['duration'] ?? '6M',
      ),
      difficultyLevel: 'Intermediate',
      phases: phases,
      prerequisites: List<String>.from(
        roadmapData['prerequisites'] ??
            ['Basic understanding', 'Internet access'],
      ),
      outcomes: List<String>.from(
        roadmapData['outcomes'] ??
            ['Master core concepts', 'Build practical skills'],
      ),
      certifications: List<String>.from(
        roadmapData['certifications'] ?? ['Completion Certificate'],
      ),
      averageSalary: (roadmapData['average_salary'] ?? 0).toDouble(),
      jobOutlook: roadmapData['job_outlook'] ?? 'Good prospects',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Generate comprehensive roadmap data based on career path and duration
  Future<Map<String, dynamic>> _generateComprehensiveRoadmapData(
    String careerPath,
    Map<String, dynamic> durationOption,
  ) async {
    // Use Duration Roadmap Service to generate structured data
    final roadmapData = await _durationRoadmapService
        .generateDurationBasedRoadmap(
          careerPath: careerPath,
          duration: durationOption['id'],
          currentLevel: 'beginner',
        );

    return roadmapData;
  }

  /// Show comprehensive structured roadmap dialog (like Botpress style)
  void _showStructuredRoadmapDialog(
    BuildContext context,
    String careerPath,
    Map<String, dynamic> durationOption,
    Map<String, dynamic> roadmapData,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height * 0.9,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: DefaultTabController(
            length: 3,
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        durationOption['color'] as Color,
                        (durationOption['color'] as Color).withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.route_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_getCareerTitle(careerPath)} Roadmap',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '${durationOption['title']} Learning Path',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildRoadmapQuickStats(roadmapData, durationOption),
                    ],
                  ),
                ),

                // Tab Bar
                Container(
                  color: Colors.white,
                  child: TabBar(
                    labelColor: durationOption['color'] as Color,
                    unselectedLabelColor: AppColors.textSecondary,
                    indicatorColor: durationOption['color'] as Color,
                    indicatorWeight: 3,
                    tabs: const [
                      Tab(
                        icon: Icon(Icons.dashboard_rounded, size: 20),
                        text: 'Overview',
                      ),
                      Tab(
                        icon: Icon(Icons.timeline_rounded, size: 20),
                        text: 'Phases',
                      ),
                      Tab(
                        icon: Icon(Icons.calendar_month_rounded, size: 20),
                        text: 'Timeline',
                      ),
                    ],
                  ),
                ),

                // Tab Content
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildOverviewTab(roadmapData, durationOption),
                      _buildPhasesTab(roadmapData, durationOption),
                      _buildTimelineTab(roadmapData, durationOption),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int _parseDurationToMonths(String duration) {
    if (duration.endsWith('M')) {
      return int.tryParse(duration.replaceAll('M', '')) ?? 6;
    } else if (duration.endsWith('Y')) {
      return (int.tryParse(duration.replaceAll('Y', '')) ?? 1) * 12;
    }
    return 6; // Default to 6 months
  }

  /// Build roadmap quick stats component
  Widget _buildRoadmapQuickStats(
    Map<String, dynamic> roadmapData,
    Map<String, dynamic> durationOption,
  ) {
    final phases = roadmapData['phases'] as List<dynamic>? ?? [];
    final totalWeeks = phases.fold<int>(
      0,
      (sum, phase) => sum + (phase['weeks'] as int? ?? 0),
    );
    final totalSkills = phases.fold<int>(0, (sum, phase) {
      final skills = phase['skills'] as List<dynamic>? ?? [];
      return sum + skills.length;
    });
    final totalProjects = phases.fold<int>(0, (sum, phase) {
      final projects = phase['projects'] as List<dynamic>? ?? [];
      return sum + projects.length;
    });

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            Icons.schedule_rounded,
            '$totalWeeks Weeks',
            'Duration',
            Colors.white,
          ),
          _buildStatItem(
            Icons.psychology_rounded,
            '$totalSkills Skills',
            'To Learn',
            Colors.white,
          ),
          _buildStatItem(
            Icons.code_rounded,
            '$totalProjects Projects',
            'To Build',
            Colors.white,
          ),
          _buildStatItem(
            Icons.trending_up_rounded,
            '${phases.length} Phases',
            'Learning Path',
            Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: color.withOpacity(0.8)),
        ),
      ],
    );
  }

  /// Build overview tab content
  Widget _buildOverviewTab(
    Map<String, dynamic> roadmapData,
    Map<String, dynamic> durationOption,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.withOpacity(0.1),
                  Colors.blue.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blue.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.info_outline_rounded,
                        color: Colors.blue,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'About This Roadmap',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  roadmapData['description'] ??
                      'A comprehensive learning path designed to help you master the skills needed for this career. This roadmap is structured to provide you with both theoretical knowledge and practical experience.',
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Prerequisites Section
          if (roadmapData['prerequisites'] != null &&
              (roadmapData['prerequisites'] as List).isNotEmpty) ...[
            _buildInfoSection(
              'Prerequisites',
              'What you should know before starting',
              Icons.school_rounded,
              Colors.orange,
              (roadmapData['prerequisites'] as List<dynamic>)
                  .map((prereq) => prereq.toString())
                  .toList(),
            ),
            const SizedBox(height: 20),
          ],

          // Learning Outcomes Section
          _buildInfoSection(
            'What You\'ll Learn',
            'Key skills and knowledge you\'ll gain',
            Icons.lightbulb_outline_rounded,
            Colors.green,
            (roadmapData['outcomes'] as List<dynamic>? ??
                    [
                      'Master core concepts and fundamentals',
                      'Build real-world projects and portfolio',
                      'Develop industry-relevant skills',
                      'Prepare for career opportunities',
                      'Learn best practices and modern techniques',
                    ])
                .map((outcome) => outcome.toString())
                .toList(),
          ),
          const SizedBox(height: 20),

          // Difficulty & Time Commitment
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Difficulty Level',
                  durationOption['intensity'] ?? 'Moderate',
                  Icons.trending_up_rounded,
                  Colors.purple,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricCard(
                  'Time Commitment',
                  '${durationOption['hours']} hrs/week',
                  Icons.access_time_rounded,
                  Colors.teal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    List<String> items,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 6, right: 12),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: AppColors.textSecondary,
                      ),
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

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Build phases tab content
  Widget _buildPhasesTab(
    Map<String, dynamic> roadmapData,
    Map<String, dynamic> durationOption,
  ) {
    final phases = roadmapData['phases'] as List<dynamic>? ?? [];

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: phases.length,
      itemBuilder: (context, index) {
        final phase = phases[index] as Map<String, dynamic>;
        final phaseColor = _getPhaseColor(index);

        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.all(20),
            childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [phaseColor, phaseColor.withOpacity(0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            title: Text(
              phase['title'] ?? 'Phase ${index + 1}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  Icon(Icons.schedule_rounded, size: 14, color: phaseColor),
                  const SizedBox(width: 4),
                  Text(
                    '${phase['weeks'] ?? 4} weeks',
                    style: TextStyle(
                      color: phaseColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.psychology_rounded,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${(phase['skills'] as List<dynamic>?)?.length ?? 0} skills',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            children: [
              if (phase['description'] != null) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    phase['description'],
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Skills Section
              if (phase['skills'] != null &&
                  (phase['skills'] as List).isNotEmpty) ...[
                _buildPhaseSection(
                  'Skills to Master',
                  Icons.psychology_rounded,
                  Colors.blue,
                  (phase['skills'] as List<dynamic>)
                      .map((skill) => skill.toString())
                      .toList(),
                  isSkills: true,
                ),
                const SizedBox(height: 16),
              ],

              // Projects Section
              if (phase['projects'] != null &&
                  (phase['projects'] as List).isNotEmpty) ...[
                _buildPhaseSection(
                  'Projects to Build',
                  Icons.code_rounded,
                  Colors.green,
                  (phase['projects'] as List<dynamic>)
                      .map((project) => project.toString())
                      .toList(),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildPhaseSection(
    String title,
    IconData icon,
    Color color,
    List<String> items, {
    bool isSkills = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (isSkills)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items
                .map(
                  (skill) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: color.withOpacity(0.3)),
                    ),
                    child: Text(
                      skill,
                      style: TextStyle(
                        fontSize: 12,
                        color: color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
                .toList(),
          )
        else
          ...items.map(
            (item) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: color.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.arrow_right_rounded, size: 16, color: color),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
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

  Color _getPhaseColor(int index) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.indigo,
    ];
    return colors[index % colors.length];
  }

  /// Build timeline tab content
  Widget _buildTimelineTab(
    Map<String, dynamic> roadmapData,
    Map<String, dynamic> durationOption,
  ) {
    final phases = roadmapData['phases'] as List<dynamic>? ?? [];

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: phases.length,
      itemBuilder: (context, index) {
        final phase = phases[index] as Map<String, dynamic>;
        final isLast = index == phases.length - 1;
        final phaseColor = _getPhaseColor(index);

        // Calculate timeline position
        int startWeek = 1;
        for (int i = 0; i < index; i++) {
          startWeek += (phases[i]['weeks'] as int? ?? 4);
        }
        int endWeek = startWeek + (phase['weeks'] as int? ?? 4) - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Timeline indicator
              SizedBox(
                width: 80,
                child: Column(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [phaseColor, phaseColor.withOpacity(0.7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: phaseColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                phaseColor.withOpacity(0.3),
                                _getPhaseColor(index + 1).withOpacity(0.3),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Phase content
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 24, left: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: phaseColor.withOpacity(0.2)),
                    boxShadow: [
                      BoxShadow(
                        color: phaseColor.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Phase header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              phase['title'] ?? 'Phase ${index + 1}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  phaseColor.withOpacity(0.1),
                                  phaseColor.withOpacity(0.05),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: phaseColor.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.schedule_rounded,
                                  size: 14,
                                  color: phaseColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Week $startWeek-$endWeek',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: phaseColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      if (phase['description'] != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          phase['description'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],

                      const SizedBox(height: 16),

                      // Key milestones
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: phaseColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: phaseColor.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.flag_rounded,
                                  size: 16,
                                  color: phaseColor,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Key Milestones',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: phaseColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Display top skills as milestones
                            if (phase['skills'] != null)
                              ...(phase['skills'] as List<dynamic>)
                                  .take(3)
                                  .map(
                                    (skill) => Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.check_circle_rounded,
                                            size: 14,
                                            color: Colors.green,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              skill.toString(),
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                            if (((phase['skills'] as List<dynamic>?)?.length ??
                                    0) >
                                3)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  '+${(phase['skills'] as List<dynamic>).length - 3} more skills to learn',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: phaseColor.withOpacity(0.7),
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Show scholarship dialog with gender-specific filtering
  void _showScholarshipDialog(BuildContext context) async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'Loading Scholarships...',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );

    try {
      // Show gender selection first
      Navigator.pop(context);
      _showGenderSelectionDialog(context);
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load scholarships: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Show gender selection dialog
  void _showGenderSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.card_giftcard_rounded,
              color: AppColors.primary,
              size: 28,
            ),
            const SizedBox(width: 12),
            const Text('Scholarship Finder'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select your gender to find the most relevant scholarships:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Gender selection buttons
            Row(
              children: [
                Expanded(
                  child: _buildGenderButton(
                    context,
                    'Female',
                    '♀️',
                    Colors.pink,
                    () => _loadScholarships(context, 'female'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildGenderButton(
                    context,
                    'Male',
                    '♂️',
                    Colors.blue,
                    () => _loadScholarships(context, 'male'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: _buildGenderButton(
                context,
                'All Scholarships',
                '👥',
                Colors.green,
                () => _loadScholarships(context, 'all'),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderButton(
    BuildContext context,
    String label,
    String emoji,
    Color color,
    VoidCallback onTap,
  ) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: color.withOpacity(0.3)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }

  /// Load and display scholarships with immediate fallback
  void _loadScholarships(BuildContext context, String gender) async {
    Navigator.pop(context); // Close gender selection

    // Show immediate mock data for better UX
    final immediateScholarships = _getImmediateScholarships(gender);
    _showScholarshipsList(
      context,
      immediateScholarships,
      gender,
      isLoading: true,
    );

    try {
      // Load real data in background
      final scholarships = await _scholarshipService.getScholarships(
        gender: gender,
        limit: 10,
      );

      // Update with real data
      Navigator.pop(context); // Close immediate results
      _showScholarshipsList(context, scholarships, gender, isLoading: false);
    } catch (e) {
      // If real data fails, the immediate mock data is already shown
      print('Failed to load real scholarships, showing mock data: $e');
    }
  }

  /// Get immediate mock scholarships for instant display
  List<Scholarship> _getImmediateScholarships(String gender) {
    return [
      Scholarship(
        id: 'loading_1',
        name: gender == 'female'
            ? 'Girls Education Scholarship'
            : gender == 'male'
            ? 'Boys Merit Scholarship'
            : 'General Merit Scholarship',
        description: 'Loading scholarship details...',
        provider: 'Government of India',
        amount: 25000.0,
        currency: 'INR',
        eligibility: ['Merit-based', 'Income criteria apply'],
        applicationDeadline: DateTime.now().add(const Duration(days: 30)),
        applicationUrl: 'https://scholarships.gov.in',
        category: 'Government',
        targetGender: gender,
        educationLevel: 'All levels',
        subjects: ['All subjects'],
        isActive: true,
        documents: ['Aadhar Card', 'Income Certificate', 'Academic Records'],
        benefits: ['Financial Support', 'Educational Assistance'],
      ),
      Scholarship(
        id: 'loading_2',
        name: 'Post Matric Scholarship',
        description: 'Loading more scholarships...',
        provider: 'Ministry of Education',
        amount: 15000.0,
        currency: 'INR',
        eligibility: ['Class 12 passed', 'Family income criteria'],
        applicationDeadline: DateTime.now().add(const Duration(days: 45)),
        applicationUrl: 'https://scholarships.gov.in',
        category: 'Government',
        targetGender: 'all',
        educationLevel: 'Post Matric',
        subjects: ['All subjects'],
        isActive: true,
        documents: [
          '10th Certificate',
          '12th Certificate',
          'Income Certificate',
        ],
        benefits: ['Educational Support', 'Monthly Stipend'],
      ),
    ];
  }

  /// Show scholarships list dialog with loading state
  void _showScholarshipsList(
    BuildContext context,
    List<Scholarship> scholarships,
    String gender, {
    bool isLoading = false,
  }) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    Icons.card_giftcard_rounded,
                    color: AppColors.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${gender == 'all'
                                  ? 'All'
                                  : gender == 'female'
                                  ? 'Girls'
                                  : 'Boys'} Scholarships',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            if (isLoading) ...[
                              const SizedBox(width: 8),
                              const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ],
                          ],
                        ),
                        Text(
                          isLoading
                              ? 'Loading latest scholarships...'
                              : '${scholarships.length} scholarships found',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Scholarships list
              Expanded(
                child: scholarships.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.sentiment_dissatisfied,
                              size: 64,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No scholarships found',
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: scholarships.length,
                        itemBuilder: (context, index) {
                          final scholarship = scholarships[index];
                          return _buildScholarshipCard(scholarship);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScholarshipCardFromMap(Map<String, dynamic> scholarship) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  scholarship['title'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B6B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  scholarship['deadline'],
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF6B6B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            scholarship['description'],
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'Amount: ${scholarship['amount']}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF10B981),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                child: const Text(
                  'Apply',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScholarshipCard(Scholarship scholarship) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Amount badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    scholarship.formattedAmount,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Gender icon
                Text(
                  scholarship.genderIcon,
                  style: const TextStyle(fontSize: 16),
                ),
                const Spacer(),
                // Days remaining
                if (scholarship.daysRemaining >= 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: scholarship.isDeadlineApproaching
                          ? Colors.orange.withOpacity(0.1)
                          : Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${scholarship.daysRemaining} days left',
                      style: TextStyle(
                        color: scholarship.isDeadlineApproaching
                            ? Colors.orange[700]
                            : Colors.green[700],
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Title and provider
            Text(
              scholarship.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              scholarship.provider,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 8),

            // Description
            Text(
              scholarship.description,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),

            // Action button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Open application URL or show details
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Opening ${scholarship.name} application...',
                      ),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Apply Now',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
