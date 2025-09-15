import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/providers/app_provider.dart';
import 'package:flutter_app/utils/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLogin = true;
  bool _obscurePassword = true;
  bool _rememberMe = false;
  String _selectedLanguage = 'English';
  
  late AnimationController _animationController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  final Map<String, Map<String, String>> _translations = {
    'English': {
      'welcome': 'Welcome to OSCAR',
      'subtitle': 'AI-powered career guidance for rural students',
      'login': 'Login',
      'signup': 'Sign Up',
      'fullName': 'Full Name',
      'email': 'Email Address',
      'password': 'Password',
      'rememberMe': 'Remember me',
      'forgotPassword': 'Forgot Password?',
      'loginButton': 'Sign In',
      'signupButton': 'Create Account',
      'orContinue': 'Or continue with',
      'google': 'Google',
      'facebook': 'Facebook',
      'hasAccount': 'Already have an account?',
      'noAccount': "Don't have an account?",
      'terms': 'By signing up, you agree to our Terms of Service and Privacy Policy',
      'motto': 'Empowering rural students with technology knowledge',
    },
    'हिंदी': {
      'welcome': 'OSCAR में आपका स्वागत है',
      'subtitle': 'ग्रामीण छात्रों के लिए AI-संचालित करियर मार्गदर्शन',
      'login': 'लॉगिन',
      'signup': 'साइन अप',
      'fullName': 'पूरा नाम',
      'email': 'ईमेल पता',
      'password': 'पासवर्ड',
      'rememberMe': 'मुझे याद रखें',
      'forgotPassword': 'पासवर्ड भूल गए?',
      'loginButton': 'साइन इन करें',
      'signupButton': 'खाता बनाएं',
      'orContinue': 'या जारी रखें',
      'google': 'गूगल',
      'facebook': 'फेसबुक',
      'hasAccount': 'पहले से खाता है?',
      'noAccount': 'कोई खाता नहीं है?',
      'terms': 'साइन अप करके, आप हमारी सेवा की शर्तों और गोपनीयता नीति से सहमत हैं',
      'motto': 'तकनीकी ज्ञान के साथ ग्रामीण छात्रों को सशक्त बनाना',
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
    
    _slideController = AnimationController(
      duration: AppDurations.medium,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: AppCurves.easeInOut),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: AppCurves.easeOut),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: AppCurves.elasticOut),
    );

    _animationController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _animationController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  String _translate(String key) {
    return _translations[_selectedLanguage]?[key] ?? key;
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final appProvider = Provider.of<AppProvider>(context, listen: false);
    
    try {
      if (_isLogin) {
        await appProvider.login(_emailController.text, _passwordController.text);
      } else {
        await appProvider.register(
          _nameController.text,
          _emailController.text,
          _passwordController.text,
        );
      }
      
      if (appProvider.isAuthenticated && mounted) {
        context.go('/assessment');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(appProvider.error ?? 'An error occurred'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _handleSocialLogin(String provider) async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    await appProvider.login('user@$provider.com', 'password');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.primaryDark,
              const Color(0xFF1E40AF),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  
                  // Language Selector
                  _buildLanguageSelector(),
                  
                  const SizedBox(height: 30),
                  
                  // Logo and title
                  SlideTransition(
                    position: _slideAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: _buildHeader(),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Auth form
                  SlideTransition(
                    position: _slideAnimation,
                    child: _buildAuthForm(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }SnackBar(
          SnackBar(
            content: Text(appProvider.error ?? 'An error occurred'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    }
  }

  void _handleSocialLogin(String provider) async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    await appProvider.login('user@$provider.com', 'password');
    
    if (appProvider.isAuthenticated && mounted) {
      context.go('/assessment');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: Text(_isLogin ? 'Welcome Back!' : 'Create Account'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                
                // Header
                Text(
                  _isLogin ? 'Sign in to continue' : 'Join OSCAR today',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  _isLogin 
                    ? "Don't have an account? " 
                    : "Already have an account? ",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                  child: Text(_isLogin ? 'Create account' : 'Sign in'),
                ),
                const SizedBox(height: 32),

                // Form Fields
                if (!_isLogin) ...[
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      if (value.length < 2) {
                        return 'Name must be at least 2 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Remember Me / Forgot Password
                if (_isLogin) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value ?? false;
                              });
                            },
                          ),
                          const Text('Remember me'),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          // Handle forgot password
                        },
                        child: const Text('Forgot password?'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],

                // Submit Button
                Consumer<AppProvider>(
                  builder: (context, appProvider, child) {
                    return ElevatedButton(
                      onPressed: appProvider.isLoading ? null : _handleSubmit,
                      child: appProvider.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(_isLogin ? 'Sign In' : 'Create Account'),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Divider
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Or continue with',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 24),

                // Social Login Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _handleSocialLogin('Google'),
                        icon: const Icon(Icons.g_mobiledata, color: Color(0xFFEF4444)),
                        label: const Text('Google'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _handleSocialLogin('LinkedIn'),
                        icon: const Icon(Icons.business, color: Color(0xFF3B82F6)),
                        label: const Text('LinkedIn'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Terms and Privacy
                if (!_isLogin) ...[
                  Text(
                    'By creating an account, you agree to our Terms of Service and Privacy Policy.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
