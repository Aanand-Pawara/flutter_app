import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/models/interview.dart';
import 'package:flutter_app/services/interview_service.dart';
import 'package:flutter_app/providers/app_provider.dart';
import 'package:flutter_app/utils/app_theme.dart';
import 'package:flutter_app/screens/main_screens/home_screens/avatar_interview_screen.dart';
import 'package:flutter_app/screens/main_screens/home_screens/interview_report_screen.dart';

class InterviewPreparationScreen extends StatefulWidget {
  const InterviewPreparationScreen({super.key});

  @override
  State<InterviewPreparationScreen> createState() =>
      _InterviewPreparationScreenState();
}

class _InterviewPreparationScreenState extends State<InterviewPreparationScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final InterviewService _interviewService = InterviewService();

  List<Interview> _mockInterviews = [];
  final List<Interview> _liveInterviews = [];
  List<Interview> _completedInterviews = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadInterviews();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadInterviews() async {
    setState(() => _isLoading = true);
    try {
      _mockInterviews = await _interviewService.getMockInterviews();
      // Load completed interviews from storage
      _completedInterviews = [
        // Example completed interview
        Interview(
          id: 'completed_1',
          title: 'Technical Interview - Completed',
          type: 'mock',
          category: 'technical',
          level: 'intermediate',
          description: 'Completed technical interview session',
          duration: 45,
          topics: ['Data Structures', 'Algorithms'],
          skills: ['Problem Solving', 'Programming'],
          status: InterviewStatus.completed,
          score: 85.5,
          feedback:
              'Good performance overall. Focus on optimization techniques.',
          isRecorded: false,
        ),
      ];
    } catch (e) {
      print('Error loading interviews: $e');
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAvatarInterviewTab(),
                _buildMockInterviewsTab(),
                _buildLiveInterviewsTab(),
                _buildReportsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Interview Preparation',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Practice with AI Avatar & Get Expert Feedback',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.psychology,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildStatsOverview(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsOverview() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Sessions',
            '${_completedInterviews.length}',
            Icons.quiz,
            AppColors.success,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Avg Score',
            '${_getAverageScore().toStringAsFixed(1)}%',
            Icons.trending_up,
            AppColors.accent,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'AI Sessions',
            '${_mockInterviews.length}',
            Icons.smart_toy,
            AppColors.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  double _getAverageScore() {
    if (_completedInterviews.isEmpty) return 0.0;
    final totalScore = _completedInterviews
        .where((interview) => interview.score != null)
        .fold(0.0, (sum, interview) => sum + (interview.score ?? 0));
    return totalScore / _completedInterviews.length;
  }

  Widget _buildTabBar() {
    return Container(
      color: AppColors.surface,
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.primary,
        tabs: const [
          Tab(icon: Icon(Icons.smart_toy), text: 'AI Avatar'),
          Tab(icon: Icon(Icons.quiz), text: 'Mock Tests'),
          Tab(icon: Icon(Icons.video_call), text: 'Live Interview'),
          Tab(icon: Icon(Icons.assessment), text: 'Reports'),
        ],
      ),
    );
  }

  Widget _buildAvatarInterviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInteractiveAvatarCard(),
          const SizedBox(height: 24),
          _buildQuickStartSection(),
          const SizedBox(height: 24),
          _buildInterviewCategoriesGrid(),
        ],
      ),
    );
  }

  Widget _buildInteractiveAvatarCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
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
      child: Column(
        children: [
          // Avatar Animation
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(Icons.smart_toy, size: 60, color: Colors.white),
                ),
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.circle,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Meet OSCAR AI Interviewer',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Practice with our AI-powered interviewer that adapts to your responses and provides real-time feedback',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _startAvatarInterview(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.play_arrow, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Start AI Interview',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStartSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Start Options',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildQuickStartCard(
                'Technical',
                'Programming & Problem Solving',
                Icons.code,
                AppColors.primary,
                () => _startQuickInterview('technical'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickStartCard(
                'Behavioral',
                'Communication & Soft Skills',
                Icons.psychology,
                AppColors.accent,
                () => _startQuickInterview('behavioral'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickStartCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
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
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInterviewCategoriesGrid() {
    final categories = [
      {
        'title': 'Software Development',
        'icon': Icons.computer,
        'color': AppColors.primary,
        'topics': ['DSA', 'System Design', 'Database'],
      },
      {
        'title': 'Government Jobs',
        'icon': Icons.account_balance,
        'color': AppColors.success,
        'topics': ['Current Affairs', 'GK', 'Aptitude'],
      },
      {
        'title': 'Banking & Finance',
        'icon': Icons.account_balance_wallet,
        'color': AppColors.accent,
        'topics': ['Financial Analysis', 'Economics', 'Banking'],
      },
      {
        'title': 'Healthcare',
        'icon': Icons.local_hospital,
        'color': AppColors.secondary,
        'topics': ['Medical Knowledge', 'Patient Care', 'Ethics'],
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Interview Categories',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return _buildCategoryCard(category);
          },
        ),
      ],
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return GestureDetector(
      onTap: () => _startCategoryInterview(category['title']),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: (category['color'] as Color).withOpacity(0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: (category['color'] as Color).withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: (category['color'] as Color).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(category['icon'], color: category['color'], size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              category['title'],
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 4,
              children: (category['topics'] as List<String>).take(2).map((
                topic,
              ) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: (category['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    topic,
                    style: TextStyle(
                      fontSize: 10,
                      color: category['color'],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMockInterviewsTab() {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _mockInterviews.length,
            itemBuilder: (context, index) {
              return _buildInterviewCard(_mockInterviews[index]);
            },
          );
  }

  Widget _buildLiveInterviewsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLiveInterviewBooking(),
          const SizedBox(height: 24),
          _buildUpcomingInterviews(),
        ],
      ),
    );
  }

  Widget _buildReportsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _completedInterviews.length,
      itemBuilder: (context, index) {
        return _buildReportCard(_completedInterviews[index]);
      },
    );
  }

  Widget _buildInterviewCard(Interview interview) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.small,
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
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.quiz, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      interview.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      interview.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildInfoChip('${interview.duration} min', Icons.schedule),
              const SizedBox(width: 8),
              _buildInfoChip(interview.level, Icons.signal_cellular_alt),
              const SizedBox(width: 8),
              _buildInfoChip(interview.category, Icons.category),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _startInterview(interview),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Start Interview',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.textTertiary),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveInterviewBooking() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.accent.withOpacity(0.1),
            AppColors.primary.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Book Live Interview',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Practice with real industry experts',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _bookLiveInterview(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Book Now',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingInterviews() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upcoming Interviews',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        Center(
          child: Text(
            'No upcoming interviews scheduled',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }

  Widget _buildReportCard(Interview interview) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.small,
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
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.assessment,
                  color: AppColors.success,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      interview.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Score: ${interview.score?.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => _viewReport(interview),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'View Report',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          if (interview.feedback != null) ...[
            const SizedBox(height: 12),
            Text(
              interview.feedback!,
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
          ],
        ],
      ),
    );
  }

  void _startAvatarInterview() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AvatarInterviewScreen(
          category: 'general',
          level: 'intermediate',
        ),
      ),
    );
  }

  void _startQuickInterview(String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AvatarInterviewScreen(category: category, level: 'intermediate'),
      ),
    );
  }

  void _startCategoryInterview(String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AvatarInterviewScreen(
          category: category.toLowerCase(),
          level: 'intermediate',
        ),
      ),
    );
  }

  void _startInterview(Interview interview) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AvatarInterviewScreen(
          category: interview.category,
          level: interview.level,
          interview: interview,
        ),
      ),
    );
  }

  void _bookLiveInterview() {
    // Show booking dialog or navigate to booking screen
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Book Live Interview'),
        content: const Text('Live interview booking will be available soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _viewReport(Interview interview) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InterviewReportScreen(interview: interview),
      ),
    );
  }
}
