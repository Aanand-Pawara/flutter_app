import 'package:flutter/material.dart';
import 'package:flutter_app/UI.dart';
import 'package:flutter_app/apptheme.dart';
import 'package:flutter_app/component/dropdown.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SignUpScreen(),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String selectedLang = "English";

  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController confirmCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Center(
                    child: UIComponents.createText(
                      AppTheme.Slogan,
                      fontFamily: "Outfit",
                      withShadow: true,
                      gradient: AppTheme.primaryGradient,
                    ),
                  ),
                ),

                // RIGHT: form
                Expanded(flex: 3, child: _buildSignUpPanel()),
              ],
            ),

            // bottom-left language dropdown
            Positioned(
              left: 20,
              bottom: 20,
              child: LanguageDropdown(
                options: ["English", "हिन्दी", "मराठी", "اردو"],
                initialValue: selectedLang,
                onChanged: (value) {
                  setState(() {
                    selectedLang = value;
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpPanel() {
    bool termsAccepted = false; // move to State for actual toggle

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: Offset(4, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          UIComponents.createText(
            "Sign In",
            fontSize: 28,
            fontWeight: FontWeight.bold,
            withShadow: true,
            gradient: AppTheme.primaryGradient,
          ),
          const SizedBox(height: 16),
          UIComponents.buildGradientTextField(
            "Email",
            emailCtrl,
            Icons.email,
            borderGradient: AppTheme.primaryGradient,
            iconGradient: AppTheme.primaryGradient,
          ),
          const SizedBox(height: 12),
          UIComponents.buildGradientTextField(
            "Password",
            passwordCtrl,
            Icons.lock,
            borderGradient: AppTheme.primaryGradient,
            iconGradient: AppTheme.primaryGradient,
          ),
          const SizedBox(height: 12),
          UIComponents.buildGradientTextField(
            "Confirm Password",
            confirmCtrl,
            Icons.lock_outline,
            borderGradient: AppTheme.primaryGradient,
            iconGradient: AppTheme.primaryGradient,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              StatefulBuilder(
                builder: (context, setLocalState) {
                  return Checkbox(
                    value: termsAccepted,
                    onChanged: (val) {
                      setLocalState(() => termsAccepted = val!);
                    },
                    activeColor: Colors.deepPurple,
                  );
                },
              ),
              Expanded(
                child: Text(
                  "I accept the Terms and Conditions",
                  style: TextStyle(fontSize: 14, fontFamily: "Outfit"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: UIComponents.buildModernButton(
                  "Sign In",
                  bgGradient: AppTheme.primaryGradient,
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            "Google",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8),
                        Image.asset(
                          "assets/images/google_logo.png",
                          width: 24,
                          height: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
