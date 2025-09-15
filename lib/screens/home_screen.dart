import 'package:flutter/material.dart';
import 'package:flutter_app/utils/app_theme.dart';
import 'package:flutter_app/utils/responsive_utils.dart';
import 'dashboard_screen_simple.dart';
import 'resources_screen_simple.dart';
import 'chat_screen_simple.dart';
import 'resume_analysis_screen_simple.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabScaleAnimation;
  late Animation<double> _fabRotationAnimation;
  bool _isFabExpanded = false;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const ResumeAnalysisScreen(),
    const ChatScreen(),
    const ResourcesScreen(),
  ];

  final List<BottomNavigationBarItem> _navItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.dashboard_outlined),
      activeIcon: Icon(Icons.dashboard),
      label: 'Dashboard',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.description_outlined),
      activeIcon: Icon(Icons.description),
      label: 'Resume',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.chat_outlined),
      activeIcon: Icon(Icons.chat),
      label: 'AI Chat',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.library_books_outlined),
      activeIcon: Icon(Icons.library_books),
      label: 'Resources',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _fabAnimationController = AnimationController(
      duration: AppDurations.medium,
      vsync: this,
    );

    _fabScaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: AppCurves.easeInOut),
    );

    _fabRotationAnimation = Tween<double>(begin: 0.0, end: 0.125).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: AppCurves.easeInOut),
    );
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    // Add haptic feedback for better interaction
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      // HapticFeedback.lightImpact();
    }
  }

  void _toggleFab() {
    setState(() {
      _isFabExpanded = !_isFabExpanded;
    });
    
    if (_isFabExpanded) {
      _fabAnimationController.forward();
    } else {
      _fabAnimationController.reverse();
    }
  }

  void _openChat() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const ChatScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        transitionDuration: AppDurations.medium,
      ),
    );
    _toggleFab();
  }

  void _toggleAIHelper() {
    _openChat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildResponsiveBottomNav(context),
      floatingActionButton: _buildResponsiveFAB(context),
    );
  }
  
  Widget _buildResponsiveBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0x1A000000),
            blurRadius: ResponsiveUtils.getCardElevation(context) * 2,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: ResponsiveUtils.responsivePadding(context).copyWith(
            top: ResponsiveUtils.getSpacing(context, scale: 0.5),
            bottom: ResponsiveUtils.getSpacing(context, scale: 0.5),
          ),
          child: ResponsiveUtils.isMobile(context)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(Icons.dashboard, 'Dashboard', 0, context),
                    _buildNavItem(Icons.description, 'Resume', 1, context),
                    _buildNavItem(Icons.chat, 'AI Chat', 2, context),
                    _buildNavItem(Icons.school, 'Resources', 3, context),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildExtendedNavItem(Icons.dashboard, 'Dashboard', 0, context),
                    SizedBox(width: ResponsiveUtils.getSpacing(context)),
                    _buildExtendedNavItem(Icons.description, 'Resume Analysis', 1, context),
                    SizedBox(width: ResponsiveUtils.getSpacing(context)),
                    _buildExtendedNavItem(Icons.chat, 'AI Chat', 2, context),
                    SizedBox(width: ResponsiveUtils.getSpacing(context)),
                    _buildExtendedNavItem(Icons.school, 'Learning Resources', 3, context),
                  ],
                ),
        ),
      ),
    );
  }
  
  Widget _buildResponsiveFAB(BuildContext context) {
    return AnimatedBuilder(
      animation: _fabScaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _fabScaleAnimation.value,
          child: Transform.rotate(
            angle: _fabRotationAnimation.value,
            child: ResponsiveUtils.isDesktop(context)
                ? FloatingActionButton.extended(
                    onPressed: _toggleAIHelper,
                    backgroundColor: AppColors.primary,
                    elevation: ResponsiveUtils.getCardElevation(context) * 2,
                    icon: Icon(
                      _isFabExpanded ? Icons.close : Icons.smart_toy,
                      color: Colors.white,
                      size: ResponsiveUtils.getIconSize(context),
                    ),
                    label: Text(
                      _isFabExpanded ? 'Close AI Chat' : 'AI Assistant',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveUtils.responsiveFontSize(context, mobile: 14),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : FloatingActionButton(
                    onPressed: _toggleAIHelper,
                    backgroundColor: AppColors.primary,
                    elevation: ResponsiveUtils.getCardElevation(context) * 2,
                    child: Icon(
                      _isFabExpanded ? Icons.close : Icons.smart_toy,
                      color: Colors.white,
                      size: ResponsiveUtils.getIconSize(context),
                    ),
                  ),
          ),
        );
      },
    );
  }
  
  Widget _buildNavItem(IconData icon, String label, int index, BuildContext context) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.getSpacing(context),
          vertical: ResponsiveUtils.getSpacing(context, scale: 0.5),
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0x332563EB) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: const Color(0x4D2563EB)) : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.textSecondary,
                size: ResponsiveUtils.getIconSize(context) * 0.8,
              ),
            ),
            SizedBox(height: ResponsiveUtils.getSpacing(context, scale: 0.25)),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontSize: ResponsiveUtils.responsiveFontSize(context, mobile: 10),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildExtendedNavItem(IconData icon, String label, int index, BuildContext context) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        width: ResponsiveUtils.responsive(
          context,
          mobile: 120,
          tablet: 140,
          desktop: 160,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.getSpacing(context, scale: 0.75),
          vertical: ResponsiveUtils.getSpacing(context, scale: 0.5),
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outline,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : AppColors.textSecondary,
              size: ResponsiveUtils.getIconSize(context) * 0.8,
            ),
            SizedBox(width: ResponsiveUtils.getSpacing(context, scale: 0.5)),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontSize: ResponsiveUtils.responsiveFontSize(context, mobile: 12, tablet: 14),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
