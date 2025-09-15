import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/providers/app_provider.dart';
import 'package:flutter_app/utils/app_theme.dart';
import 'home_screen.dart';

class CareerSelectionScreen extends StatefulWidget {
  const CareerSelectionScreen({super.key});

  @override
  State<CareerSelectionScreen> createState() => _CareerSelectionScreenState();
}

class _CareerSelectionScreenState extends State<CareerSelectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  String? _selectedCareerPath;

  final List<CareerOption> _careerOptions = [
    CareerOption(
      id: '10th',
      title: '10th Standard',
      subtitle: 'Explore career paths after 10th grade',
      description: 'Discover various streams and career opportunities available after completing your 10th standard.',
      icon: Icons.school,
      color: AppColors.primary,
      gradient: AppColors.primaryGradient,
      opportunities: ['Science Stream', 'Commerce Stream', 'Arts Stream', 'Vocational Courses'],
    ),
    CareerOption(
      id: '12th',
      title: '12th Standard',
      subtitle: 'Plan your next step after 12th',
      description: 'Find the perfect college course and career path based on your 12th standard background.',
      icon: Icons.school_outlined,
      color: AppColors.accent,
      gradient: AppColors.accentGradient,
      opportunities: ['Engineering', 'Medical', 'Commerce', 'Arts & Humanities'],
    ),
    CareerOption(
      id: 'neet',
      title: 'NEET Preparation',
      subtitle: 'Medical entrance exam guidance',
      description: 'Comprehensive preparation strategy and career guidance for NEET and medical field.',
      icon: Icons.medical_services,
      color: const Color(0xFFEF4444),
      gradient: const LinearGradient(colors: [Color(0xFFEF4444), Color(0xFFDC2626)]),
      opportunities: ['MBBS', 'BDS', 'AYUSH', 'Veterinary Science'],
    ),
    CareerOption(
      id: 'jee',
      title: 'JEE Preparation',
      subtitle: 'Engineering entrance exam guidance',
      description: 'Strategic preparation for JEE and comprehensive engineering career guidance.',
      icon: Icons.calculate,
      color: AppColors.secondary,
      gradient: AppColors.secondaryGradient,
      opportunities: ['Computer Science', 'Mechanical', 'Electrical', 'Civil Engineering'],
    ),
    CareerOption(
      id: 'govt',
      title: 'Government Jobs',
      subtitle: 'Public sector career opportunities',
      description: 'Explore various government job opportunities and preparation strategies.',
      icon: Icons.account_balance,
      color: const Color(0xFF8B5CF6),
      gradient: const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)]),
      opportunities: ['UPSC', 'Banking', 'Railway', 'Defense Services'],
    ),
    CareerOption(
      id: 'ssc',
      title: 'SSC Preparation',
      subtitle: 'Staff Selection Commission exams',
      description: 'Complete guidance for SSC exams and related career opportunities.',
      icon: Icons.assignment,
      color: const Color(0xFF06B6D4),
      gradient: const LinearGradient(colors: [Color(0xFF06B6D4), Color(0xFF0891B2)]),
      opportunities: ['SSC CGL', 'SSC CHSL', 'SSC MTS', 'SSC JE'],
    ),
    CareerOption(
      id: 'professional',
      title: 'Working Professional',
      subtitle: 'Career advancement & upskilling',
      description: 'Enhance your career with new skills and advancement opportunities.',
      icon: Icons.work,
      color: const Color(0xFF059669),
      gradient: const LinearGradient(colors: [Color(0xFF059669), Color(0xFF047857)]),
      opportunities: ['Skill Development', 'Career Switch', 'Leadership', 'Entrepreneurship'],
    ),
    CareerOption(
      id: 'technology',
      title: 'Technology & IT',
      subtitle: 'Tech career paths & skills',
      description: 'Explore cutting-edge technology careers and required skill development.',
      icon: Icons.computer,
      color: const Color(0xFF3B82F6),
      gradient: const LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF2563EB)]),
      opportunities: ['Software Development', 'Data Science', 'AI/ML', 'Cybersecurity'],
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

  void _selectCareerPath(String careerPath) {
    setState(() {
      _selectedCareerPath = careerPath;
    });

    final appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.setCareerPath(careerPath);

    // Navigate to home screen after selection
    Future.delayed(AppDurations.medium, () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: _buildHeader(),
                ),
                
                // Career Options Grid
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.85,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return _buildCareerCard(_careerOptions[index], index);
                      },
                      childCount: _careerOptions.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final user = Provider.of<AppProvider>(context).user;
    
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome, ${user?.name ?? 'User'}! 👋',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Choose your career path to get personalized guidance',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          
          const SizedBox(height: 24),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppShadows.medium,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.lightbulb_outline,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Select the path that best matches your current situation or goals',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCareerCard(CareerOption option, int index) {
    final isSelected = _selectedCareerPath == option.id;
    
    return AnimatedContainer(
      duration: AppDurations.fast,
      child: TweenAnimationBuilder<double>(
        duration: Duration(milliseconds: 200 + (index * 100)),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Transform.scale(
            scale: 0.8 + (0.2 * value),
            child: Opacity(
              opacity: value,
              child: GestureDetector(
                onTap: () => _selectCareerPath(option.id),
                child: AnimatedContainer(
                  duration: AppDurations.fast,
                  transform: Matrix4.identity()..scale(isSelected ? 0.95 : 1.0),
                  decoration: BoxDecoration(
                    gradient: isSelected ? option.gradient : null,
                    color: isSelected ? null : AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: isSelected ? AppShadows.large : AppShadows.small,
                    border: isSelected ? null : Border.all(
                      color: const Color(0x1A2563EB),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon and Selection Indicator
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: isSelected 
                                  ? Colors.white.withOpacity(0.2)
                                  : option.color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                option.icon,
                                color: isSelected ? Colors.white : option.color,
                                size: 24,
                              ),
                            ),
                            if (isSelected)
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.check,
                                  color: option.color,
                                  size: 16,
                                ),
                              ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Title
                        Text(
                          option.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                        
                        const SizedBox(height: 4),
                        
                        // Subtitle
                        Text(
                          option.subtitle,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isSelected 
                              ? Colors.white.withOpacity(0.8)
                              : AppColors.textSecondary,
                          ),
                        ),
                        
                        const Spacer(),
                        
                        // Opportunities Count
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isSelected 
                              ? Colors.white.withOpacity(0.2)
                              : option.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${option.opportunities.length} opportunities',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isSelected ? Colors.white : option.color,
                              fontWeight: FontWeight.w500,
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
      ),
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
  final List<String> opportunities;

  CareerOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
    required this.gradient,
    required this.opportunities,
  });
}
