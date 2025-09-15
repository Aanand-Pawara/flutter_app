import 'package:flutter/material.dart';

class ResponsiveUtils {
  // Screen size breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;
  
  // Get screen type
  static ScreenType getScreenType(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    
    if (width < mobileBreakpoint) {
      return ScreenType.mobile;
    } else if (width < tabletBreakpoint) {
      return ScreenType.tablet;
    } else {
      return ScreenType.desktop;
    }
  }
  
  // Responsive values
  static T responsive<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    ScreenType screenType = getScreenType(context);
    
    switch (screenType) {
      case ScreenType.mobile:
        return mobile;
      case ScreenType.tablet:
        return tablet ?? mobile;
      case ScreenType.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }
  
  // Responsive padding
  static EdgeInsets responsivePadding(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: responsive(
        context,
        mobile: 16.0,
        tablet: 24.0,
        desktop: 32.0,
      ),
      vertical: responsive(
        context,
        mobile: 12.0,
        tablet: 16.0,
        desktop: 20.0,
      ),
    );
  }
  
  // Responsive font sizes
  static double responsiveFontSize(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    return responsive(
      context,
      mobile: mobile,
      tablet: tablet ?? mobile * 1.1,
      desktop: desktop ?? mobile * 1.2,
    );
  }
  
  // Grid columns based on screen size
  static int getGridColumns(BuildContext context) {
    return responsive(
      context,
      mobile: 1,
      tablet: 2,
      desktop: 3,
    );
  }
  
  // Card width based on screen size
  static double getCardWidth(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return responsive(
      context,
      mobile: screenWidth - 32,
      tablet: (screenWidth - 64) / 2,
      desktop: (screenWidth - 96) / 3,
    );
  }
  
  // Maximum content width for readability
  static double getMaxContentWidth(BuildContext context) {
    return responsive(
      context,
      mobile: double.infinity,
      tablet: 800,
      desktop: 1200,
    );
  }
  
  // Responsive spacing
  static double getSpacing(BuildContext context, {double scale = 1.0}) {
    return responsive(
      context,
      mobile: 8.0 * scale,
      tablet: 12.0 * scale,
      desktop: 16.0 * scale,
    );
  }
  
  // Check if mobile
  static bool isMobile(BuildContext context) {
    return getScreenType(context) == ScreenType.mobile;
  }
  
  // Check if tablet
  static bool isTablet(BuildContext context) {
    return getScreenType(context) == ScreenType.tablet;
  }
  
  // Check if desktop
  static bool isDesktop(BuildContext context) {
    return getScreenType(context) == ScreenType.desktop;
  }
  
  // Responsive icon size
  static double getIconSize(BuildContext context) {
    return responsive(
      context,
      mobile: 24.0,
      tablet: 28.0,
      desktop: 32.0,
    );
  }
  
  // Responsive button height
  static double getButtonHeight(BuildContext context) {
    return responsive(
      context,
      mobile: 48.0,
      tablet: 52.0,
      desktop: 56.0,
    );
  }
  
  // Responsive card elevation
  static double getCardElevation(BuildContext context) {
    return responsive(
      context,
      mobile: 2.0,
      tablet: 4.0,
      desktop: 6.0,
    );
  }
  
  // Responsive border radius
  static double getBorderRadius(BuildContext context) {
    return responsive(
      context,
      mobile: 8.0,
      tablet: 12.0,
      desktop: 16.0,
    );
  }
}

enum ScreenType {
  mobile,
  tablet,
  desktop,
}

// Responsive widget wrapper
class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  
  const ResponsiveWidget({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });
  
  @override
  Widget build(BuildContext context) {
    return ResponsiveUtils.responsive(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }
}

// Responsive container with max width
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final bool centerContent;
  
  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.centerContent = true,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? ResponsiveUtils.responsivePadding(context),
      child: centerContent
          ? Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: ResponsiveUtils.getMaxContentWidth(context),
                ),
                child: child,
              ),
            )
          : child,
    );
  }
}

// Responsive grid view
class ResponsiveGridView extends StatelessWidget {
  final List<Widget> children;
  final double? spacing;
  final double? runSpacing;
  final EdgeInsets? padding;
  
  const ResponsiveGridView({
    super.key,
    required this.children,
    this.spacing,
    this.runSpacing,
    this.padding,
  });
  
  @override
  Widget build(BuildContext context) {
    int columns = ResponsiveUtils.getGridColumns(context);
    double defaultSpacing = ResponsiveUtils.getSpacing(context);
    
    return GridView.builder(
      padding: padding ?? ResponsiveUtils.responsivePadding(context),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: spacing ?? defaultSpacing,
        mainAxisSpacing: runSpacing ?? defaultSpacing,
        childAspectRatio: ResponsiveUtils.responsive(
          context,
          mobile: 1.2,
          tablet: 1.1,
          desktop: 1.0,
        ),
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}
