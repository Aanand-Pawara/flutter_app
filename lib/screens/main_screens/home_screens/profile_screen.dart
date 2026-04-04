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
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                'Edit Profile',
                Icons.edit_rounded,
                AppColors.primary,
                () => _showEditProfileDialog(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                'Certificates',
                Icons.verified_rounded,
                AppColors.success,
                () => _showCertificates(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                'Share Profile',
                Icons.share_rounded,
                AppColors.accent,
                () => _shareProfile(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLearningProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Learning Progress',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'This Week',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '12 hours studied',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        const Text(
                          '3 courses completed',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CircularPercentIndicator(
                    radius: 40,
                    lineWidth: 8,
                    percent: 0.75,
                    center: const Text(
                      '75%',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    progressColor: Colors.white,
                    backgroundColor: Colors.white.withOpacity(0.3),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LinearPercentIndicator(
                lineHeight: 8,
                percent: 0.75,
                backgroundColor: Colors.white.withOpacity(0.3),
                progressColor: Colors.white,
                barRadius: const Radius.circular(4),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Weekly Goal: 16 hours',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const Text(
                    '4 hours left',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivity() {
    final activities = [
      {
        'title': 'Completed "Advanced Mathematics" course',
        'time': '2 hours ago',
        'icon': Icons.school_rounded,
        'color': AppColors.success,
      },
      {
        'title': 'Earned "Problem Solver" badge',
        'time': '1 day ago',
        'icon': Icons.star_rounded,
        'color': Colors.amber,
      },
      {
        'title': 'Started "Physics Fundamentals" course',
        'time': '2 days ago',
        'icon': Icons.play_circle_rounded,
        'color': AppColors.primary,
      },
      {
        'title': 'Submitted scholarship application',
        'time': '3 days ago',
        'icon': Icons.card_giftcard_rounded,
        'color': AppColors.accent,
      },
    ];

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
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppShadows.small,
          ),
          child: Column(
            children: activities.map((activity) => _buildActivityItem(activity)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (activity['color'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              activity['icon'] as IconData,
              color: activity['color'] as Color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['title'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  activity['time'] as String,
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

  Widget _buildGoalsSection() {
    final goals = [
      {
        'title': 'Complete 5 courses this month',
        'progress': 0.6,
        'current': 3,
        'target': 5,
        'color': AppColors.primary,
      },
      {
        'title': 'Study 20 hours per week',
        'progress': 0.75,
        'current': 15,
        'target': 20,
        'color': AppColors.success,
      },
      {
        'title': 'Earn 3 certificates',
        'progress': 0.33,
        'current': 1,
        'target': 3,
        'color': AppColors.accent,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'My Goals',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () => _showSetGoalsDialog(),
              child: const Text('Set Goals'),
            ),
          ],
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
            children: goals.map((goal) => _buildGoalItem(goal)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildGoalItem(Map<String, dynamic> goal) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  goal['title'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                '${goal['current']}/${goal['target']}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: goal['color'] as Color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearPercentIndicator(
            lineHeight: 8,
            percent: goal['progress'] as double,
            backgroundColor: AppColors.surfaceContainerHighest,
            progressColor: goal['color'] as Color,
            barRadius: const Radius.circular(4),
            animation: true,
            animationDuration: 1000,
          ),
        ],
      ),
    );
  }

  // Action methods
  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: const Text('Profile editing feature will be available soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showCertificates() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('My Certificates'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('You have earned the following certificates:'),
            const SizedBox(height: 16),
            _buildCertificateItem('Mathematics Excellence', 'Completed with 95% score'),
            _buildCertificateItem('Problem Solving Skills', 'Advanced level certification'),
            _buildCertificateItem('Study Management', 'Time management certification'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificateItem(String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.verified, color: AppColors.success, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  description,
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

  void _shareProfile() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share Profile'),
        content: const Text('Share your achievements and progress with friends!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement share functionality
            },
            child: const Text('Share'),
          ),
        ],
      ),
    );
  }

  void _showSetGoalsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set New Goals'),
        content: const Text('Goal setting feature will help you track your progress and stay motivated!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement goal setting
            },
            child: const Text('Set Goals'),
          ),
        ],
      ),
    );
  }