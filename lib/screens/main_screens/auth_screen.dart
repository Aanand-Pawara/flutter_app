import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/screens/main_screens/home_screens/enhanced_dashboard_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/providers/app_provider.dart';
import 'package:flutter_app/utils/app_theme.dart';
import 'career_selection_screen.dart';
import '../home_screen.dart';

/// Enhanced language provider with 4 languages
class LanguageProvider extends ChangeNotifier {
  String _locale = 'en';
  String get locale => _locale;

  void setLocale(String newLocale) {
    _locale = newLocale;
    notifyListeners();
  }

  String get languageName {
    switch (_locale) {
      case 'en':
        return 'English';
      case 'hi':
        return 'हिन्दी';
      case 'mr':
        return 'मराठी';
      case 'ur':
        return 'اردو';
      default:
        return 'English';
    }
  }

  bool get isRTL => _locale == 'ur';

  String t(String key) {
    final translations = {
      'en': {
        'title': 'Sign In',
        'subtitle': 'Your career journey starts here.',
        'welcomeTitle': 'Dream. Discover. Decide.',
        'welcomeSubtitle':
            'Transform your career aspirations into reality with personalized guidance and insights.',
        'email': 'Email Address',
        'password': 'Password',
        'name': 'Full Name',
        'confirm': 'Confirm Password',
        'terms': 'I accept the terms and conditions',
        'signin': 'Sign In',
        'signup': 'Sign Up',
        'createAccount': 'Create Account',
        'toggleToSignUp': "Don't have an account? Sign Up",
        'toggleToSignIn': "Already have an account? Sign In",
        'forgotPassword': 'Forgot Password?',
        'orContinueWith': 'Or continue with',
        'enterName': 'Please enter your name',
        'enterEmail': 'Please enter your email',
        'invalidEmail': 'Please enter a valid email',
        'enterPassword': 'Please enter your password',
        'passwordTooShort': 'Password must be at least 6 characters',
        'passwordsDontMatch': 'Passwords do not match',
        'acceptTerms': 'Please accept terms and conditions',
        'feature1': 'AI-Powered Career Insights',
        'feature2': 'Personalized Growth Tracking',
        'feature3': 'Expert Community Access',
      },
      'hi': {
        'title': 'साइन इन',
        'subtitle': 'आपकी करियर यात्रा यहाँ से शुरू होती है।',
        'welcomeTitle': 'सपना देखें. खोजें. निर्णय लें.',
        'welcomeSubtitle':
            'व्यक्तिगत मार्गदर्शन और अंतर्दृष्टि के साथ अपनी करियर आकांक्षाओं को वास्तविकता में बदलें।',
        'email': 'ईमेल पता',
        'password': 'पासवर्ड',
        'name': 'पूरा नाम',
        'confirm': 'पासवर्ड की पुष्टि करें',
        'terms': 'मैं नियम और शर्तों को स्वीकार करता हूँ',
        'signin': 'साइन इन',
        'signup': 'साइन अप',
        'createAccount': 'खाता बनाएं',
        'toggleToSignUp': "खाता नहीं है? साइन अप करें",
        'toggleToSignIn': "पहले से खाता है? साइन इन करें",
        'forgotPassword': 'पासवर्ड भूल गए?',
        'orContinueWith': 'या इसके साथ जारी रखें',
        'enterName': 'कृपया अपना नाम दर्ज करें',
        'enterEmail': 'कृपया अपना ईमेल दर्ज करें',
        'invalidEmail': 'कृपया वैध ईमेल दर्ज करें',
        'enterPassword': 'कृपया अपना पासवर्ड दर्ज करें',
        'passwordTooShort': 'पासवर्ड कम से कम 6 अक्षर का होना चाहिए',
        'passwordsDontMatch': 'पासवर्ड मेल नहीं खाते',
        'acceptTerms': 'कृपया नियम और शर्तों को स्वीकार करें',
        'feature1': 'एआई-संचालित करियर अंतर्दृष्टि',
        'feature2': 'व्यक्तिगत विकास ट्रैकिंग',
        'feature3': 'विशेषज्ञ समुदाय पहुंच',
      },
      'mr': {
        'title': 'साइन इन',
        'subtitle': 'तुमचा करिअर प्रवास इथून सुरू होतो.',
        'welcomeTitle': 'स्वप्न पहा. शोधा. निर्णय घ्या.',
        'welcomeSubtitle':
            'व्यक्तिशः मार्गदर्शन आणि अंतर्दृष्टीसह तुमच्या करिअर आकांक्षांना वास्तवात रूपांतरित करा.',
        'email': 'ईमेल पत्ता',
        'password': 'पासवर्ड',
        'name': 'पूर्ण नाव',
        'confirm': 'पासवर्डची पुष्टी करा',
        'terms': 'मी अटी व शर्ती स्वीकारतो',
        'signin': 'साइन इन',
        'signup': 'साइन अप',
        'createAccount': 'खाते तयार करा',
        'toggleToSignUp': "खाते नाही? साइन अप करा",
        'toggleToSignIn': "आधीच खाते आहे? साइन इन करा",
        'forgotPassword': 'पासवर्ड विसरलात?',
        'orContinueWith': 'किंवा यासह सुरू ठेवा',
        'enterName': 'कृपया तुमचे नाव टाका',
        'enterEmail': 'कृपया तुमचा ईमेल टाका',
        'invalidEmail': 'कृपया वैध ईमेल टाका',
        'enterPassword': 'कृपया तुमचा पासवर्ड टाका',
        'passwordTooShort': 'पासवर्ड किमान 6 अक्षरांचा असावा',
        'passwordsDontMatch': 'पासवर्ड जुळत नाहीत',
        'acceptTerms': 'कृपया अटी व शर्ती स्वीकारा',
        'feature1': 'AI-चालित करिअर अंतर्दृष्टी',
        'feature2': 'वैयक्तिक वाढ ट्रॅकिंग',
        'feature3': 'तज्ञ समुदाय प्रवेश',
      },
      'ur': {
        'title': 'سائن ان',
        'subtitle': 'آپ کے کریئر کا سفر یہاں سے شروع ہوتا ہے۔',
        'welcomeTitle': 'خواب دیکھیں۔ دریافت کریں۔ فیصلہ کریں۔',
        'welcomeSubtitle':
            'ذاتی رہنمائی اور بصیرت کے ساتھ اپنی کریئر کی خواہشات کو حقیقت میں تبدیل کریں۔',
        'email': 'ای میل ایڈریس',
        'password': 'پاس ورڈ',
        'name': 'پورا نام',
        'confirm': 'پاس ورڈ کی تصدیق',
        'terms': 'میں شرائط و ضوابط کو قبول کرتا ہوں',
        'signin': 'سائن ان',
        'signup': 'سائن اپ',
        'createAccount': 'اکاؤنٹ بنائیں',
        'toggleToSignUp': "اکاؤنٹ نہیں ہے؟ سائن اپ کریں",
        'toggleToSignIn': "پہلے سے اکاؤنٹ ہے؟ سائن ان کریں",
        'forgotPassword': 'پاس ورڈ بھول گئے؟',
        'orContinueWith': 'یا اس کے ساتھ جاری رکھیں',
        'enterName': 'برائے کرم اپنا نام درج کریں',
        'enterEmail': 'برائے کرم اپنا ای میل درج کریں',
        'invalidEmail': 'برائے کرم درست ای میل درج کریں',
        'enterPassword': 'برائے کرم اپنا پاس ورڈ درج کریں',
        'passwordTooShort': 'پاس ورڈ کم از کم 6 حروف کا ہونا چاہیے',
        'passwordsDontMatch': 'پاس ورڈ میل نہیں کھاتے',
        'acceptTerms': 'برائے کرم شرائط و ضوابط کو قبول کریں',
        'feature1': 'AI سے چلنے والی کریئر بصیرت',
        'feature2': 'ذاتی نمو کی ٹریکنگ',
        'feature3': 'ماہر کمیونٹی رسائی',
      },
    };

    return translations[_locale]?[key] ?? key;
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  bool _isLogin = true;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _acceptTerms = false;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _confirmController = TextEditingController();

  late AnimationController _gradientController;
  late AnimationController _slideController;
  late AnimationController _fadeController;

  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _gradientController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _slideController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _gradientController.dispose();
    _slideController.dispose();
    _fadeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _toggleAuthMode() {
    setState(() => _isLogin = !_isLogin);
    _slideController.reset();
    _slideController.forward();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_isLogin && !_acceptTerms) {
      final lang = Provider.of<LanguageProvider>(context, listen: false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(lang.t('acceptTerms')),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    final appProvider = Provider.of<AppProvider>(context, listen: false);

    try {
      if (_isLogin) {
        await appProvider.login(
          _emailController.text.trim(),
          _passwordController.text,
        );
      } else {
        await appProvider.register(
          _nameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text,
        );
      }

      if (appProvider.isAuthenticated && mounted) {
        final nextScreen = appProvider.selectedCareerPath == null
            ? const CareerSelectionScreen()
            : const MainDashboard();

        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, _) => nextScreen,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(appProvider.error ?? 'Authentication failed'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    final screenSize = MediaQuery.of(context).size;
    final isWideScreen = screenSize.width > 900;
    final isTablet = screenSize.width > 600 && screenSize.width <= 900;

    return Directionality(
      textDirection: lang.isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: AnimatedBuilder(
          animation: _gradientController,
          builder: (context, _) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary,
                    Color.lerp(
                      AppColors.primary,
                      AppColors.accent,
                      _gradientController.value,
                    )!,
                    Color.lerp(
                      AppColors.accent,
                      AppColors.primaryDark,
                      (_gradientController.value + 0.3).clamp(0.0, 1.0),
                    )!,
                    AppColors.primaryDark,
                  ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                ),
              ),
              child: SafeArea(
                child: _buildResponsiveLayout(lang, isWideScreen, isTablet),
              ),
            );
          },
        ),
        // bottomNavigationBar: _buildLanguageSelector(context),
      ),
    );
  }

  Widget _buildResponsiveLayout(
    LanguageProvider lang,
    bool isWideScreen,
    bool isTablet,
  ) {
    Widget mainContent;

    if (isWideScreen) {
      mainContent = Row(
        children: [
          Expanded(flex: 5, child: _buildWelcomePanel(lang)),
          Expanded(flex: 4, child: _buildAuthCard(lang)),
        ],
      );
    } else {
      mainContent = Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isTablet ? 32 : 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!isTablet) ...[
                _buildCompactWelcomeSection(lang),
                const SizedBox(height: 40),
              ],
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isTablet ? 500 : 420),
                child: _buildAuthCard(lang),
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        mainContent,
        Align(
          alignment: isTablet ? Alignment.bottomCenter : Alignment.bottomLeft,
          child: Padding(
            padding: EdgeInsets.all(0), // distance from edges
            child: _buildLanguageSelector(context),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomePanel(LanguageProvider lang) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    lang.t('welcomeTitle'),
                    style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.1,
                      letterSpacing: -0.5,
                      shadows: [
                        Shadow(
                          blurRadius: 20,
                          color: Colors.black.withOpacity(0.3),
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-0.3, 0),
                end: Offset.zero,
              ).animate(_slideAnimation),
              child: Text(
                lang.t('welcomeSubtitle'),
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white.withOpacity(0.9),
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 40),
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-0.5, 0),
                end: Offset.zero,
              ).animate(_slideAnimation),
              child: _buildFeaturesList(lang),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactWelcomeSection(LanguageProvider lang) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          Text(
            lang.t('welcomeTitle'),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 20,
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            lang.t('welcomeSubtitle'),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesList(LanguageProvider lang) {
    final features = [
      {'icon': Icons.psychology, 'text': lang.t('feature1')},
      {'icon': Icons.trending_up, 'text': lang.t('feature2')},
      {'icon': Icons.group, 'text': lang.t('feature3')},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: features.asMap().entries.map((entry) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 600 + (entry.key * 200)),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset((1 - value) * -50, 0),
              child: Opacity(
                opacity: value,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          entry.value['icon'] as IconData,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Flexible(
                        child: Text(
                          entry.value['text'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildAuthCard(LanguageProvider lang) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.3, 0),
        end: Offset.zero,
      ).animate(_slideAnimation),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 30,
                offset: const Offset(0, 15),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _isLogin ? lang.t('title') : lang.t('createAccount'),
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  lang.t('subtitle'),
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),

                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: Column(
                    children: [
                      if (!_isLogin) ...[
                        _buildTextField(
                          controller: _nameController,
                          label: lang.t('name'),
                          icon: Icons.person_outline,
                          validator: (v) => (v?.trim().isEmpty ?? true)
                              ? lang.t('enterName')
                              : null,
                        ),
                        const SizedBox(height: 20),
                      ],

                      _buildTextField(
                        controller: _emailController,
                        label: lang.t('email'),
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v?.trim().isEmpty ?? true)
                            return lang.t('enterEmail');
                          if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(v!.trim())) {
                            return lang.t('invalidEmail');
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      _buildTextField(
                        controller: _passwordController,
                        label: lang.t('password'),
                        icon: Icons.lock_outline,
                        obscureText: !_isPasswordVisible,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textSecondary,
                          ),
                          onPressed: () => setState(
                            () => _isPasswordVisible = !_isPasswordVisible,
                          ),
                        ),
                        validator: (v) {
                          if (v?.isEmpty ?? true)
                            return lang.t('enterPassword');
                          if ((v?.length ?? 0) < 6)
                            return lang.t('passwordTooShort');
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      if (!_isLogin) ...[
                        _buildTextField(
                          controller: _confirmController,
                          label: lang.t('confirm'),
                          icon: Icons.lock_outline,
                          obscureText: !_isConfirmPasswordVisible,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isConfirmPasswordVisible
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textSecondary,
                            ),
                            onPressed: () => setState(
                              () => _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible,
                            ),
                          ),
                          validator: (v) => v != _passwordController.text
                              ? lang.t('passwordsDontMatch')
                              : null,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ],
                  ),
                ),

                if (_isLogin) ...[
                  Align(
                    alignment: lang.isRTL
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        lang.t('forgotPassword'),
                        style: TextStyle(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  Row(
                    children: [
                      Checkbox(
                        value: _acceptTerms,
                        onChanged: (value) =>
                            setState(() => _acceptTerms = value ?? false),
                        activeColor: AppColors.accent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          lang.t('terms'),
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            _isLogin ? lang.t('signin') : lang.t('signup'),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 24),

                TextButton(
                  onPressed: _toggleAuthMode,
                  child: Text(
                    _isLogin
                        ? lang.t('toggleToSignUp')
                        : lang.t('toggleToSignIn'),
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(fontSize: 16, color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 22),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.accent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black.withOpacity(0)],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.language, color: Colors.white.withOpacity(0.8), size: 20),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: lang.locale,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white.withOpacity(0.8),
                  size: 20,
                ),
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(12),
                elevation: 8,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                items: [
                  DropdownMenuItem(
                    value: 'en',
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('🇺🇸', style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 8),
                        Text(
                          'English',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'hi',
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('🇮🇳', style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 8),
                        Text(
                          'हिन्दी',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'mr',
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('🇮🇳', style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 8),
                        Text(
                          'मराठी',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'ur',
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('💩', style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 8),
                        Text(
                          'اردو',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    lang.setLocale(value);
                    // Add haptic feedback for better UX
                    // HapticFeedback.lightImpact();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
