import 'package:flutter/material.dart';
import 'package:flutter_app/utils/app_theme.dart';
import 'package:flutter_app/screens/main_screens/roadmap_duration_screen.dart';

class GovernmentJobsSpecializationScreen extends StatefulWidget {
  const GovernmentJobsSpecializationScreen({super.key});

  @override
  State<GovernmentJobsSpecializationScreen> createState() => _GovernmentJobsSpecializationScreenState();
}

class _GovernmentJobsSpecializationScreenState extends State<GovernmentJobsSpecializationScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<GovJobOption> _govJobOptions = [
    GovJobOption(
      id: 'upsc',
      title: 'UPSC Civil Services',
      subtitle: 'IAS, IPS, IFS and other central services',
      description: 'Comprehensive preparation for UPSC Civil Services Examination covering Prelims, Mains, and Interview.',
      icon: Icons.account_balance,
      color: const Color(0xFF8B5CF6),
      gradient: const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)]),
      subjects: ['General Studies', 'Current Affairs', 'Optional Subject', 'Essay Writing', 'Ethics', 'CSAT'],
      examPattern: 'Prelims + Mains + Interview',
      eligibility: 'Graduation + Age 21-32 years',
      averageSalary: '₹56,100 - ₹2,25,000',
      posts: ['IAS', 'IPS', 'IFS', 'IRS', 'Other Group A & B Services'],
    ),
    GovJobOption(
      id: 'banking',
      title: 'Banking Sector',
      subtitle: 'IBPS, SBI, RBI and other banking exams',
      description: 'Complete banking exam preparation for Clerk, PO, and Specialist Officer positions.',
      icon: Icons.account_balance_wallet,
      color: const Color(0xFF059669),
      gradient: const LinearGradient(colors: [Color(0xFF059669), Color(0xFF047857)]),
      subjects: ['Quantitative Aptitude', 'Reasoning', 'English', 'General Awareness', 'Computer Knowledge'],
      examPattern: 'Prelims + Mains + Interview',
      eligibility: 'Graduation + Age 20-30 years',
      averageSalary: '₹23,700 - ₹59,170',
      posts: ['Bank PO', 'Bank Clerk', 'Specialist Officer', 'Assistant Manager'],
    ),
    GovJobOption(
      id: 'railway',
      title: 'Railway Recruitment',
      subtitle: 'RRB NTPC, Group D, JE, and other railway jobs',
      description: 'Railway job preparation covering technical and non-technical positions.',
      icon: Icons.train,
      color: const Color(0xFF3B82F6),
      gradient: const LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF2563EB)]),
      subjects: ['General Awareness', 'Arithmetic', 'General Intelligence', 'Technical Subjects'],
      examPattern: 'CBT + Skill Test/Physical Test',
      eligibility: '10th/12th/ITI/Graduation',
      averageSalary: '₹18,000 - ₹56,900',
      posts: ['Station Master', 'Ticket Collector', 'Junior Engineer', 'Assistant Loco Pilot'],
    ),
    GovJobOption(
      id: 'defense',
      title: 'Defense Services',
      subtitle: 'NDA, CDS, AFCAT and other defense exams',
      description: 'Defense services preparation for Army, Navy, Air Force officer and soldier positions.',
      icon: Icons.security,
      color: const Color(0xFFEF4444),
      gradient: const LinearGradient(colors: [Color(0xFFEF4444), Color(0xFFDC2626)]),
      subjects: ['Mathematics', 'General Ability', 'English', 'General Knowledge', 'Physical Fitness'],
      examPattern: 'Written + SSB Interview + Medical',
      eligibility: '12th/Graduation + Age 16-25 years',
      averageSalary: '₹56,100 - ₹2,25,000',
      posts: ['Army Officer', 'Navy Officer', 'Air Force Officer', 'Soldier'],
    ),
    GovJobOption(
      id: 'teaching',
      title: 'Teaching Jobs',
      subtitle: 'CTET, TET, KVS, NVS and school teaching',
      description: 'Teaching job preparation for government schools and educational institutions.',
      icon: Icons.school,
      color: const Color(0xFF06B6D4),
      gradient: const LinearGradient(colors: [Color(0xFF06B6D4), Color(0xFF0891B2)]),
      subjects: ['Child Development', 'Pedagogy', 'Subject Knowledge', 'Environmental Studies', 'Mathematics'],
      examPattern: 'Written Exam + Interview',
      eligibility: 'B.Ed/D.Ed + Subject Graduation',
      averageSalary: '₹35,400 - ₹1,12,400',
      posts: ['Primary Teacher', 'Secondary Teacher', 'Principal', 'Education Officer'],
    ),
    GovJobOption(
      id: 'police',
      title: 'Police & Law Enforcement',
      subtitle: 'State Police, Central Police Forces',
      description: 'Police recruitment preparation including constable, SI, and officer levels.',
      icon: Icons.local_police,
      color: const Color(0xFF7C3AED),
      gradient: const LinearGradient(colors: [Color(0xFF7C3AED), Color(0xFF6D28D9)]),
      subjects: ['General Knowledge', 'Reasoning', 'Numerical Ability', 'Current Affairs', 'Law & Order'],
      examPattern: 'Written + Physical + Medical',
      eligibility: '12th/Graduation + Physical Standards',
      averageSalary: '₹21,700 - ₹69,100',
      posts: ['Constable', 'Sub Inspector', 'Inspector', 'Deputy SP'],
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

  void _selectGovJobSpecialization(GovJobOption option) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RoadmapDurationScreen(
          careerPath: option.id,
          careerTitle: option.title,
        ),
      ),
    );
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
                  child: _buildSpecializationList(),
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
                child: Text(
                  'Government Job Specializations',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Choose your government sector and get a detailed preparation roadmap',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSpecializationList() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: List.generate(_govJobOptions.length, (index) {
          final option = _govJobOptions[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildSpecializationCard(option, index),
          );
        }),
      ),
    );
  }

  Widget _buildSpecializationCard(GovJobOption option, int index) {
    return GestureDetector(
      onTap: () => _selectGovJobSpecialization(option),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: option.color.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
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
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: option.gradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(option.icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        option.subtitle,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: option.color,
                  size: 16,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              option.description,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Exam Pattern', option.examPattern, Icons.quiz),
            const SizedBox(height: 8),
            _buildInfoRow('Eligibility', option.eligibility, Icons.person),
            const SizedBox(height: 8),
            _buildInfoRow('Salary Range', option.averageSalary, Icons.currency_rupee),
            const SizedBox(height: 16),
            Text(
              'Key Subjects:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: option.color,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: option.subjects.take(4).map((subject) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: option.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  subject,
                  style: TextStyle(
                    fontSize: 12,
                    color: option.color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )).toList(),
            ),
            if (option.subjects.length > 4) ...[
              const SizedBox(height: 8),
              Text(
                '+${option.subjects.length - 4} more subjects',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class GovJobOption {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;
  final Gradient gradient;
  final List<String> subjects;
  final String examPattern;
  final String eligibility;
  final String averageSalary;
  final List<String> posts;

  GovJobOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
    required this.gradient,
    required this.subjects,
    required this.examPattern,
    required this.eligibility,
    required this.averageSalary,
    required this.posts,
  });
}