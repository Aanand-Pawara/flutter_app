import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/utils/app_theme.dart';
import 'package:flutter_app/utils/responsive_utils.dart';
import 'package:flutter_app/providers/app_provider.dart';
import 'dashboard_screen_simple.dart';
import 'auth_screen.dart';

class UserSelectionScreen extends StatefulWidget {
  const UserSelectionScreen({super.key});

  @override
  State<UserSelectionScreen> createState() => _UserSelectionScreenState();
}

class _UserSelectionScreenState extends State<UserSelectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  String? _selectedUserType;
  String? _selectedCareerPath;
  String? _selectedExperience;

  final List<UserTypeOption> _userTypes = [
    UserTypeOption(
      id: 'student',
      title: 'Student',
      subtitle: 'High school or college student',
      icon: Icons.school,
      color: AppColors.primary,
    ),
    UserTypeOption(
      id: 'graduate',
      title: 'Fresh Graduate',
      subtitle: 'Recently completed degree',
      icon: Icons.school,
      color: AppColors.success,
    ),
    UserTypeOption(
      id: 'professional',
      title: 'Working Professional',
      subtitle: 'Looking for career change',
      icon: Icons.work,
      color: AppColors.accent,
    ),
    UserTypeOption(
      id: 'entrepreneur',
      title: 'Aspiring Entrepreneur',
      subtitle: 'Want to start own business',
      icon: Icons.lightbulb,
      color: AppColors.warning,
    ),
  ];

  final List<CareerPathOption> _careerPaths = [
    CareerPathOption(
      id: 'technology',
      title: 'Technology & IT',
      subtitle: 'Software, AI, Data Science',
      icon: Icons.computer,
      gradient: AppColors.primaryGradient,
    ),
    CareerPathOption(
      id: 'business',
      title: 'Business & Management',
      subtitle: 'Marketing, Finance, Operations',
      icon: Icons.business,
      gradient: AppColors.accentGradient,
    ),
    CareerPathOption(
      id: 'healthcare',
      title: 'Healthcare & Medicine',
      subtitle: 'Medical, Nursing, Research',
      icon: Icons.local_hospital,
      gradient: AppColors.successGradient,
    ),
    CareerPathOption(
      id: 'creative',
      title: 'Creative & Design',
      subtitle: 'Art, Design, Media',
      icon: Icons.palette,
      gradient: LinearGradient(
        colors: [Colors.purple, Colors.pink],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    CareerPathOption(
      id: 'engineering',
      title: 'Engineering',
      subtitle: 'Mechanical, Civil, Electrical',
      icon: Icons.engineering,
      gradient: LinearGradient(
        colors: [const Color(0xFFF97316), const Color(0xFFEF4444)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    CareerPathOption(
      id: 'education',
      title: 'Education & Research',
      subtitle: 'Teaching, Academia, Research',
      icon: Icons.menu_book,
      gradient: LinearGradient(
        colors: [const Color(0xFF14B8A6), const Color(0xFF10B981)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  ];

  final List<ExperienceOption> _experienceLevels = [
    ExperienceOption(
      id: 'beginner',
      title: 'Beginner',
      subtitle: '0-1 years experience',
      icon: Icons.star_border,
    ),
    ExperienceOption(
      id: 'intermediate',
      title: 'Intermediate',
      subtitle: '1-3 years experience',
      icon: Icons.star_half,
    ),
    ExperienceOption(
      id: 'advanced',
      title: 'Advanced',
      subtitle: '3+ years experience',
      icon: Icons.star,
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
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _proceedToDashboard() {
    if (_selectedUserType != null && _selectedCareerPath != null && _selectedExperience != null) {
      // Save user selections to provider
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      appProvider.updateUserProfile(
        userType: _selectedUserType!,
        careerPath: _selectedCareerPath!,
        experienceLevel: _selectedExperience!,
      );

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const DashboardScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
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
            child: SingleChildScrollView(
              child: Padding(
                padding: ResponsiveUtils.responsivePadding(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: ResponsiveUtils.getSpacing(context)),
                    
                    // Header
                    _buildHeader(),
                    
                    SizedBox(height: ResponsiveUtils.getSpacing(context, scale: 2)),
                    
                    // User Type Selection
                    _buildSectionTitle('What describes you best?'),
                    SizedBox(height: ResponsiveUtils.getSpacing(context)),
                    _buildUserTypeSelection(),
                    
                    SizedBox(height: ResponsiveUtils.getSpacing(context, scale: 2)),
                    
                    // Career Path Selection
                    _buildSectionTitle('Which career path interests you?'),
                    SizedBox(height: ResponsiveUtils.getSpacing(context)),
                    _buildCareerPathSelection(),
                    
                    SizedBox(height: ResponsiveUtils.getSpacing(context, scale: 2)),
                    
                    // Experience Level Selection
                    _buildSectionTitle('What\'s your experience level?'),
                    SizedBox(height: ResponsiveUtils.getSpacing(context)),
                    _buildExperienceSelection(),
                    
                    SizedBox(height: ResponsiveUtils.getSpacing(context, scale: 3)),
                    
                    // Continue Button
                    _buildContinueButton(),
                    
                    SizedBox(height: ResponsiveUtils.getSpacing(context)),
                    
                    // Skip Button
                    _buildSkipButton(),
                    
                    SizedBox(height: ResponsiveUtils.getSpacing(context, scale: 2)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Let\'s personalize your experience',
          style: TextStyle(
            fontSize: ResponsiveUtils.responsiveFontSize(context, mobile: 32, tablet: 36, desktop: 40),
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: ResponsiveUtils.getSpacing(context, scale: 0.5)),
        Text(
          'Help us understand your goals so we can provide the best guidance for your career journey.',
          style: TextStyle(
            fontSize: ResponsiveUtils.responsiveFontSize(context, mobile: 16, tablet: 18, desktop: 20),
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: ResponsiveUtils.responsiveFontSize(context, mobile: 20, tablet: 22, desktop: 24),
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildUserTypeSelection() {
    return ResponsiveUtils.isMobile(context)
        ? Column(
            children: _userTypes.map((userType) => Padding(
              padding: EdgeInsets.only(bottom: ResponsiveUtils.getSpacing(context, scale: 0.75)),
              child: _buildUserTypeCard(userType),
            )).toList(),
          )
        : GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: ResponsiveUtils.getGridColumns(context),
              crossAxisSpacing: ResponsiveUtils.getSpacing(context),
              mainAxisSpacing: ResponsiveUtils.getSpacing(context),
              childAspectRatio: 1.2,
            ),
            itemCount: _userTypes.length,
            itemBuilder: (context, index) => _buildUserTypeCard(_userTypes[index]),
          );
  }

  Widget _buildUserTypeCard(UserTypeOption userType) {
    final isSelected = _selectedUserType == userType.id;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedUserType = userType.id;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: ResponsiveUtils.responsivePadding(context),
        decoration: BoxDecoration(
          color: isSelected ? Color.fromARGB(26, userType.color.red, userType.color.green, userType.color.blue) : AppColors.surface,
          borderRadius: BorderRadius.circular(ResponsiveUtils.getBorderRadius(context)),
          border: Border.all(
            color: isSelected ? userType.color : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: Color.fromARGB(51, userType.color.red, userType.color.green, userType.color.blue),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ] : AppShadows.small,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: ResponsiveUtils.getIconSize(context) * 1.5,
              height: ResponsiveUtils.getIconSize(context) * 1.5,
              decoration: BoxDecoration(
                color: Color.fromARGB(51, userType.color.red, userType.color.green, userType.color.blue),
                borderRadius: BorderRadius.circular(ResponsiveUtils.getBorderRadius(context)),
              ),
              child: Icon(
                userType.icon,
                color: userType.color,
                size: ResponsiveUtils.getIconSize(context),
              ),
            ),
            SizedBox(height: ResponsiveUtils.getSpacing(context)),
            Text(
              userType.title,
              style: TextStyle(
                fontSize: ResponsiveUtils.responsiveFontSize(context, mobile: 18),
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: ResponsiveUtils.getSpacing(context, scale: 0.25)),
            Text(
              userType.subtitle,
              style: TextStyle(
                fontSize: ResponsiveUtils.responsiveFontSize(context, mobile: 14),
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCareerPathSelection() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveUtils.responsive(context, mobile: 1, tablet: 2, desktop: 3),
        crossAxisSpacing: ResponsiveUtils.getSpacing(context),
        mainAxisSpacing: ResponsiveUtils.getSpacing(context),
        childAspectRatio: ResponsiveUtils.responsive(context, mobile: 2.5, tablet: 1.8, desktop: 1.5),
      ),
      itemCount: _careerPaths.length,
      itemBuilder: (context, index) => _buildCareerPathCard(_careerPaths[index]),
    );
  }

  Widget _buildCareerPathCard(CareerPathOption careerPath) {
    final isSelected = _selectedCareerPath == careerPath.id;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCareerPath = careerPath.id;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          gradient: isSelected ? careerPath.gradient : null,
          color: !isSelected ? AppColors.surface : null,
          borderRadius: BorderRadius.circular(ResponsiveUtils.getBorderRadius(context)),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppColors.border,
            width: 1,
          ),
          boxShadow: isSelected ? AppShadows.medium : AppShadows.small,
        ),
        child: Padding(
          padding: ResponsiveUtils.responsivePadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                careerPath.icon,
                color: isSelected ? Colors.white : AppColors.textSecondary,
                size: ResponsiveUtils.getIconSize(context),
              ),
              SizedBox(height: ResponsiveUtils.getSpacing(context)),
              Text(
                careerPath.title,
                style: TextStyle(
                  fontSize: ResponsiveUtils.responsiveFontSize(context, mobile: 16),
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                ),
              ),
              SizedBox(height: ResponsiveUtils.getSpacing(context, scale: 0.25)),
              Text(
                careerPath.subtitle,
                style: TextStyle(
                  fontSize: ResponsiveUtils.responsiveFontSize(context, mobile: 12),
                  color: isSelected ? const Color(0xE6FFFFFF) : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExperienceSelection() {
    return Row(
      children: _experienceLevels.map((experience) {
        final isSelected = _selectedExperience == experience.id;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.getSpacing(context, scale: 0.25)),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedExperience = experience.id;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: ResponsiveUtils.responsivePadding(context),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0x1A2563EB) : AppColors.surface,
                  borderRadius: BorderRadius.circular(ResponsiveUtils.getBorderRadius(context)),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      experience.icon,
                      color: isSelected ? AppColors.primary : AppColors.textSecondary,
                      size: ResponsiveUtils.getIconSize(context),
                    ),
                    SizedBox(height: ResponsiveUtils.getSpacing(context, scale: 0.5)),
                    Text(
                      experience.title,
                      style: TextStyle(
                        fontSize: ResponsiveUtils.responsiveFontSize(context, mobile: 14),
                        fontWeight: FontWeight.w600,
                        color: isSelected ? AppColors.primary : AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: ResponsiveUtils.getSpacing(context, scale: 0.25)),
                    Text(
                      experience.subtitle,
                      style: TextStyle(
                        fontSize: ResponsiveUtils.responsiveFontSize(context, mobile: 12),
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildContinueButton() {
    final isEnabled = _selectedUserType != null && _selectedCareerPath != null && _selectedExperience != null;
    
    return SizedBox(
      width: double.infinity,
      height: ResponsiveUtils.getButtonHeight(context),
      child: ElevatedButton(
        onPressed: isEnabled ? _proceedToDashboard : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: isEnabled ? 8 : 0,
          shadowColor: const Color(0x662563EB),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveUtils.getBorderRadius(context)),
          ),
        ),
        child: Text(
          'Continue to Dashboard',
          style: TextStyle(
            fontSize: ResponsiveUtils.responsiveFontSize(context, mobile: 16),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSkipButton() {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AuthScreen()),
          );
        },
        child: Text(
          'Skip and login instead',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: ResponsiveUtils.responsiveFontSize(context, mobile: 14),
          ),
        ),
      ),
    );
  }
}

class UserTypeOption {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  UserTypeOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}

class CareerPathOption {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final LinearGradient gradient;

  CareerPathOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
  });
}

class ExperienceOption {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;

  ExperienceOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}
