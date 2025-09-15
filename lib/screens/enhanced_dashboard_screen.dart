import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/providers/app_provider.dart';
import 'package:flutter_app/utils/app_theme.dart';
import 'package:percent_indicator/percent_indicator.dart';

class EnhancedDashboardScreen extends StatefulWidget {
  const EnhancedDashboardScreen({super.key});

  @override
  State<EnhancedDashboardScreen> createState() => _EnhancedDashboardScreenState();
}

class _EnhancedDashboardScreenState extends State<EnhancedDashboardScreen> 
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final Map<String, Map<String, dynamic>> _careerPathData = {
    '10th': {
      'title': '10th Standard Path',
      'color': AppColors.primary,
      'gradient': AppColors.primaryGradient,
      'icon': Icons.school,
      'resources': ['Stream Selection Guide', 'Career Exploration', 'Study Tips', 'Board Exam Prep'],
      'nextSteps': ['Choose your stream (Science/Commerce/Arts)', 'Research career options', 'Plan 11th-12th subjects'],
      'scholarships': 3,
      'opportunities': 12,
    },
    '12th': {
      'title': '12th Standard Path',
      'color': AppColors.accent,
      'gradient': AppColors.accentGradient,
      'icon': Icons.school_outlined,
      'resources': ['College Selection', 'Entrance Exam Prep', 'Application Guide', 'Career Counseling'],
      'nextSteps': ['Prepare for entrance exams', 'Apply to colleges', 'Choose your course'],
      'scholarships': 8,
      'opportunities': 25,
    },
    'neet': {
      'title': 'NEET Preparation',
      'color': AppColors.error,
      'gradient': LinearGradient(colors: [AppColors.error, Color(0xFFDC2626)]),
      'icon': Icons.medical_services,
      'resources': ['NEET Study Material', 'Mock Tests', 'Previous Papers', 'Biology Focus'],
      'nextSteps': ['Complete syllabus', 'Practice mock tests', 'Revision strategy'],
      'scholarships': 5,
      'opportunities': 15,
    },
    'jee': {
      'title': 'JEE Preparation',
      'color': AppColors.secondary,
      'gradient': AppColors.secondaryGradient,
      'icon': Icons.calculate,
      'resources': ['JEE Study Plan', 'Mathematics Focus', 'Physics Labs', 'Chemistry Notes'],
      'nextSteps': ['Master mathematics', 'Practice problem solving', 'Mock test series'],
      'scholarships': 6,
      'opportunities': 20,
    },
    'govt': {
      'title': 'Government Jobs',
      'color': Color(0xFF8B5CF6),
      'gradient': LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)]),
      'icon': Icons.account_balance,
      'resources': ['UPSC Guide', 'Current Affairs', 'Mock Tests', 'Interview Prep'],
      'nextSteps': ['Choose exam category', 'Start preparation', 'Join study groups'],
      'scholarships': 4,
      'opportunities': 18,
    },
    'technology': {
      'title': 'Technology & IT',
      'color': Color(0xFF3B82F6),
      'gradient': LinearGradient(colors: [Color(0xFF3B82F6), AppColors.primary]),
      'icon': Icons.computer,
      'resources': ['Programming Courses', 'Project Ideas', 'Industry Trends', 'Certification Guide'],
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

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: AppCurves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
              // App Bar
              _buildAppBar(),
              
              // Main Content
              SliverToBoxAdapter(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildWelcomeSection(),
                        const SizedBox(height: 24),
                        _buildCareerPathCard(),
                        const SizedBox(height: 24),
                        _buildQuickStats(),
                        const SizedBox(height: 24),
                        _buildQuickActions(),
                        const SizedBox(height: 24),
                        _buildProgressSection(),
                        const SizedBox(height: 24),
                        _buildRecentActivity(),
                      ],
                    ),
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
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return SliverAppBar(
          floating: true,
          snap: true,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          title: Text(
            'OSCAR Dashboard',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                // Open notifications
              },
              icon: Stack(
                children: [
                  const Icon(Icons.notifications_outlined),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
          ],
        );
      },
    );
  }

  Widget _buildWelcomeSection() {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final user = appProvider.user;
        final timeOfDay = DateTime.now().hour;
        String greeting = timeOfDay < 12 
            ? 'Good Morning' 
            : timeOfDay < 17 
                ? 'Good Afternoon' 
                : 'Good Evening';

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: AppShadows.medium,
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
                          '$greeting, ${user?.name ?? 'Student'}! 👋',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Ready to advance your career today?',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.trending_up,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCareerPathCard() {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final selectedPath = appProvider.selectedCareerPath;
        if (selectedPath == null) return const SizedBox.shrink();
        
        final pathData = _careerPathData[selectedPath];
        if (pathData == null) return const SizedBox.shrink();

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: pathData['gradient'] as LinearGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: AppShadows.medium,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
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
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Your personalized career path',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Next Steps:',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              ...((pathData['nextSteps'] as List<String>).take(2).map(
                (step) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 16,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          step,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickStats() {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final selectedPath = appProvider.selectedCareerPath;
        final pathData = selectedPath != null ? _careerPathData[selectedPath] : null;
        
        return Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Available Scholarships',
                '${pathData?['scholarships'] ?? 10}',
                Icons.card_giftcard,
                AppColors.success,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Career Opportunities',
                '${pathData?['opportunities'] ?? 50}+',
                Icons.work_outline,
                AppColors.accent,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.small,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: [
            _buildActionCard(
              'AI Mentor Chat',
              Icons.psychology,
              AppColors.primary,
              () {
                // Navigate to AI chat
              },
            ),
            _buildActionCard(
              'Resume Analysis',
              Icons.description,
              AppColors.accent,
              () {
                // Navigate to resume analysis
              },
            ),
            _buildActionCard(
              'Find Resources',
              Icons.library_books,
              AppColors.success,
              () {
                // Navigate to resources
              },
            ),
            _buildActionCard(
              'View Roadmap',
              Icons.route,
              AppColors.secondary,
              () {
                // Navigate to roadmap
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
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
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
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

  Widget _buildProgressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Progress',
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
            children: [
              _buildProgressItem('Profile Completion', 0.8, AppColors.primary),
              const SizedBox(height: 16),
              _buildProgressItem('Skills Assessment', 0.6, AppColors.accent),
              const SizedBox(height: 16),
              _buildProgressItem('Career Planning', 0.4, AppColors.success),
              const SizedBox(height: 16),
              _buildProgressItem('Resource Completion', 0.3, AppColors.secondary),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressItem(String title, double progress, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearPercentIndicator(
          lineHeight: 8,
          percent: progress,
          backgroundColor: AppColors.surfaceContainerHighest,
          progressColor: color,
          barRadius: const Radius.circular(4),
          animation: true,
          animationDuration: 1000,
        ),
      ],
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppShadows.small,
          ),
          child: Column(
            children: [
              _buildActivityItem(
                'Completed AI Career Assessment',
                '2 hours ago',
                Icons.check_circle,
                AppColors.success,
              ),
              _buildActivityItem(
                'Downloaded Study Material',
                '1 day ago',
                Icons.download,
                AppColors.primary,
              ),
              _buildActivityItem(
                'Started NEET Preparation Course',
                '3 days ago',
                Icons.play_circle,
                AppColors.accent,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(String title, String time, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}