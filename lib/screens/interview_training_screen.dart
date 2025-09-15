import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter_app/utils/app_theme.dart';
import 'package:flutter_app/providers/app_provider.dart';

class InterviewTrainingScreen extends StatefulWidget {
  const InterviewTrainingScreen({super.key});

  @override
  State<InterviewTrainingScreen> createState() =>
      _InterviewTrainingScreenState();
}

class _InterviewTrainingScreenState extends State<InterviewTrainingScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentQuestionIndex = 0;
  bool _isRecording = false;
  bool _hasAnswered = false;
  String _selectedDifficulty = 'Beginner';
  String _selectedCategory = 'Technical';
  int _recordingSeconds = 0;
  Timer? _recordingTimer;
  List<String> _userAnswers = [];
  double _confidenceScore = 0.0;
  Map<String, int> _practiceStats = {
    'questionsAnswered': 8,
    'timeSpent': 25,
    'streak': 5,
  };

  final List<Map<String, dynamic>> _interviewQuestions = [
    {
      'category': 'Technical',
      'difficulty': 'Beginner',
      'question':
          'What is the difference between var, let, and const in JavaScript?',
      'tips': 'Focus on scope, hoisting, and mutability differences',
      'timeLimit': 120,
    },
    {
      'category': 'Technical',
      'difficulty': 'Intermediate',
      'question':
          'Explain the concept of closures in programming and provide an example.',
      'tips': 'Mention lexical scoping and practical use cases',
      'timeLimit': 180,
    },
    {
      'category': 'Behavioral',
      'difficulty': 'Beginner',
      'question': 'Tell me about a time when you had to work under pressure.',
      'tips': 'Use the STAR method (Situation, Task, Action, Result)',
      'timeLimit': 150,
    },
    {
      'category': 'Behavioral',
      'difficulty': 'Intermediate',
      'question':
          'Describe a situation where you had to learn a new technology quickly.',
      'tips': 'Show adaptability and learning methodology',
      'timeLimit': 180,
    },
    {
      'category': 'System Design',
      'difficulty': 'Advanced',
      'question': 'How would you design a URL shortening service like bit.ly?',
      'tips': 'Cover scalability, database design, and caching',
      'timeLimit': 300,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredQuestions {
    return _interviewQuestions
        .where(
          (q) =>
              q['category'] == _selectedCategory &&
              q['difficulty'] == _selectedDifficulty,
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Interview Training'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Practice'),
            Tab(text: 'Mock Interview'),
            Tab(text: 'Progress'),
            Tab(text: 'Tips'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPracticeTab(),
          _buildMockInterviewTab(),
          _buildProgressTab(),
          _buildTipsTab(),
        ],
      ),
    );
  }

  Widget _buildPracticeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSelectionFilters(),
          const SizedBox(height: 24),
          _buildQuestionCard(),
          const SizedBox(height: 24),
          _buildPracticeStats(),
        ],
      ),
    );
  }

  Widget _buildSelectionFilters() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.small,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Customize Your Practice',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Category',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      items:
                          [
                                'Technical',
                                'Behavioral',
                                'System Design',
                                'HR Questions',
                              ]
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(category),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                          _currentQuestionIndex = 0;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Difficulty',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedDifficulty,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      items: ['Beginner', 'Intermediate', 'Advanced']
                          .map(
                            (difficulty) => DropdownMenuItem(
                              value: difficulty,
                              child: Text(difficulty),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedDifficulty = value!;
                          _currentQuestionIndex = 0;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard() {
    if (_filteredQuestions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppShadows.small,
        ),
        child: const Center(
          child: Text(
            'No questions available for this combination.\nTry different filters.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
          ),
        ),
      );
    }

    final question = _filteredQuestions[_currentQuestionIndex];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0x1A2563EB), const Color(0x1A06B6D4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x332563EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${question['category']} • ${question['difficulty']}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                'Question ${_currentQuestionIndex + 1}/${_filteredQuestions.length}',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            question['question'],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.warning.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: AppColors.warning,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Tip: ${question['tips']}',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (_isRecording)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.error.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.fiber_manual_record,
                    color: AppColors.error,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Recording: ${_recordingSeconds}s',
                    style: TextStyle(
                      color: AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  const Text('🎤 Speak clearly...'),
                ],
              ),
            ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isRecording ? _stopRecording : _startRecording,
                  icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                  label: Text(
                    _isRecording ? 'Stop Recording' : 'Start Recording',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isRecording
                        ? AppColors.error
                        : AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _nextQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMockInterviewTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Icon(Icons.videocam, color: Colors.white, size: 48),
                const SizedBox(height: 16),
                const Text(
                  'Full Mock Interview',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Experience a complete interview simulation with AI feedback',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _startMockInterview(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Start Mock Interview',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildInterviewModes(),
        ],
      ),
    );
  }

  Widget _buildInterviewModes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Interview Modes',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        _buildModeCard(
          'Technical Interview',
          'Focus on coding and technical concepts',
          Icons.code,
          AppColors.primary,
          '45 min',
        ),
        const SizedBox(height: 12),
        _buildModeCard(
          'Behavioral Interview',
          'Practice soft skills and experience questions',
          Icons.psychology,
          AppColors.accent,
          '30 min',
        ),
        const SizedBox(height: 12),
        _buildModeCard(
          'System Design',
          'Design scalable systems and architecture',
          Icons.architecture,
          AppColors.success,
          '60 min',
        ),
      ],
    );
  }

  Widget _buildModeCard(
    String title,
    String description,
    IconData icon,
    Color color,
    String duration,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppShadows.small,
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
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
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
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
          Column(
            children: [
              Text(
                duration,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
              const SizedBox(height: 8),
              Icon(Icons.arrow_forward_ios, color: color, size: 16),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProgressStats(),
          const SizedBox(height: 24),
          _buildRecentSessions(),
          const SizedBox(height: 24),
          _buildSkillsProgress(),
        ],
      ),
    );
  }

  Widget _buildProgressStats() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.small,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Progress',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Sessions',
                  '23',
                  Icons.play_circle,
                  AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Hours',
                  '12.5',
                  Icons.schedule,
                  AppColors.accent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Score',
                  '78%',
                  Icons.trending_up,
                  AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
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
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSessions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.small,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Sessions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildSessionItem(
            'Technical Interview',
            '85%',
            '2 hours ago',
            AppColors.success,
          ),
          _buildSessionItem(
            'Behavioral Questions',
            '72%',
            '1 day ago',
            AppColors.warning,
          ),
          _buildSessionItem(
            'System Design',
            '90%',
            '3 days ago',
            AppColors.success,
          ),
        ],
      ),
    );
  }

  Widget _buildSessionItem(
    String type,
    String score,
    String time,
    Color scoreColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: scoreColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.quiz, color: scoreColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            score,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: scoreColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsProgress() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.small,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Skills Progress',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildSkillBar('Communication', 0.8, AppColors.primary),
          _buildSkillBar('Technical Knowledge', 0.7, AppColors.accent),
          _buildSkillBar('Problem Solving', 0.9, AppColors.success),
          _buildSkillBar('Confidence', 0.6, AppColors.warning),
        ],
      ),
    );
  }

  Widget _buildSkillBar(String skill, double progress, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                skill,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTipCard(
            'Before the Interview',
            [
              'Research the company and role thoroughly',
              'Practice your elevator pitch',
              'Prepare specific examples using STAR method',
              'Test your technology setup',
              'Plan your outfit and arrive early',
            ],
            Icons.schedule,
            AppColors.primary,
          ),
          const SizedBox(height: 16),
          _buildTipCard(
            'During the Interview',
            [
              'Maintain good eye contact and posture',
              'Listen carefully to questions',
              'Ask clarifying questions if needed',
              'Provide specific examples',
              'Show enthusiasm and interest',
            ],
            Icons.person,
            AppColors.accent,
          ),
          const SizedBox(height: 16),
          _buildTipCard(
            'Technical Questions',
            [
              'Think out loud during problem solving',
              'Start with a simple solution, then optimize',
              'Consider edge cases and constraints',
              'Write clean, readable code',
              'Test your solution with examples',
            ],
            Icons.code,
            AppColors.success,
          ),
          const SizedBox(height: 16),
          _buildTipCard(
            'After the Interview',
            [
              'Send a thank-you email within 24 hours',
              'Reflect on what went well and areas to improve',
              'Follow up appropriately if you don\'t hear back',
              'Continue practicing for future opportunities',
              'Update your notes and preparation materials',
            ],
            Icons.email,
            AppColors.warning,
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard(
    String title,
    List<String> tips,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.small,
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
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...tips.map(
            (tip) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
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
                      tip,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.4,
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

  Widget _buildPracticeStats() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.small,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Today\'s Practice',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildQuickStat(
                  'Questions',
                  '8',
                  Icons.quiz,
                  AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickStat(
                  'Time',
                  '25m',
                  Icons.timer,
                  AppColors.accent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickStat(
                  'Streak',
                  '5 days',
                  Icons.local_fire_department,
                  AppColors.warning,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    // Use real stats from practice
    String displayValue = value;
    if (label == 'Questions') {
      displayValue = _practiceStats['questionsAnswered'].toString();
    } else if (label == 'Time') {
      displayValue = '${_practiceStats['timeSpent']}m';
    } else if (label == 'Streak') {
      displayValue = '${_practiceStats['streak']} days';
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            displayValue,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _recordingSeconds = 0;
    });

    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordingSeconds++;
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🎤 Recording started... Speak your answer!'),
        backgroundColor: const Color(0xFF10B981),
      ),
    );
  }

  void _stopRecording() {
    _recordingTimer?.cancel();
    setState(() {
      _isRecording = false;
      _hasAnswered = true;
      _confidenceScore =
          0.7 + (Random().nextDouble() * 0.3); // Simulate AI analysis
    });

    // Simulate saving answer
    _userAnswers.add('User answer for question ${_currentQuestionIndex + 1}');

    // Update practice stats
    setState(() {
      _practiceStats['questionsAnswered'] =
          (_practiceStats['questionsAnswered'] ?? 0) + 1;
      _practiceStats['timeSpent'] =
          (_practiceStats['timeSpent'] ?? 0) + (_recordingSeconds ~/ 60);
    });

    _showAnswerFeedback();
  }

  void _nextQuestion() {
    setState(() {
      if (_currentQuestionIndex < _filteredQuestions.length - 1) {
        _currentQuestionIndex++;
      } else {
        _currentQuestionIndex = 0;
      }
      _hasAnswered = false;
      _recordingSeconds = 0;
      _confidenceScore = 0.0;
    });
  }

  void _startMockInterview() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start Mock Interview'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('This will start a full mock interview session with:'),
            const SizedBox(height: 12),
            const Text('• 5-7 questions from selected category'),
            const Text('• Real-time feedback and scoring'),
            const Text('• Detailed performance analysis'),
            const Text('• Improvement recommendations'),
            const SizedBox(height: 16),
            const Text(
              'Are you ready to begin?',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _startFullMockInterview();
            },
            child: const Text('Start Interview'),
          ),
        ],
      ),
    );
  }

  void _startFullMockInterview() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.videocam, color: Color(0xFFEF4444)),
            const SizedBox(width: 8),
            const Text('Mock Interview in Progress'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text('Preparing interview environment...'),
            const SizedBox(height: 8),
            Text('Questions: ${_filteredQuestions.length}'),
            Text('Category: $_selectedCategory'),
            Text('Difficulty: $_selectedDifficulty'),
          ],
        ),
      ),
    );

    // Simulate interview preparation
    Timer(const Duration(seconds: 3), () {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            '🎯 Mock interview completed! Check Progress tab for results.',
          ),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 3),
        ),
      );

      // Update stats after mock interview
      setState(() {
        _practiceStats['questionsAnswered'] =
            (_practiceStats['questionsAnswered'] ?? 0) + 5;
        _practiceStats['timeSpent'] = (_practiceStats['timeSpent'] ?? 0) + 45;
      });
    });
  }

  void _showAnswerFeedback() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Answer Analysis'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Confidence Score: '),
                Text(
                  '${(_confidenceScore * 100).toInt()}%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _confidenceScore > 0.8
                        ? AppColors.success
                        : _confidenceScore > 0.6
                        ? AppColors.warning
                        : AppColors.error,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Recording Duration: ${_recordingSeconds}s'),
            const SizedBox(height: 12),
            const Text(
              'Feedback:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              _confidenceScore > 0.8
                  ? '✅ Excellent answer! Good structure and confidence.'
                  : _confidenceScore > 0.6
                  ? '👍 Good answer. Consider adding more specific examples.'
                  : '💡 Room for improvement. Practice explaining concepts clearly.',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}
