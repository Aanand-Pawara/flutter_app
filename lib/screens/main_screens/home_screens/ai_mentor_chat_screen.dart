import 'package:flutter/material.dart';
import 'package:flutter_app/utils/app_theme.dart';

import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:webview_flutter_web/webview_flutter_web.dart';

class AIMentorChatScreen extends StatefulWidget {
  const AIMentorChatScreen({super.key});

  @override
  State<AIMentorChatScreen> createState() => _AIMentorChatScreenState();
}

class _AIMentorChatScreenState extends State<AIMentorChatScreen> {
  String _selectedLanguage = 'English';
  late final PlatformWebViewController _controller;
  final Map<String, Map<String, String>> _translations = {
    'English': {
      'title': 'AI Career Mentor',
      'subtitle': 'Your personalized career guidance assistant',
      'quickQuestion1': 'What career suits me?',
      'quickQuestion2': 'Study tips for my path',
      'quickQuestion3': 'Scholarship opportunities',
      'quickQuestion4': 'Interview preparation',
    },
    'हिंदी': {
      'title': 'AI करियर मेंटर',
      'subtitle': 'आपका व्यक्तिगत करियर मार्गदर्शन सहायक',
      'quickQuestion1': 'मुझे कौन सा करियर सूट करता है?',
      'quickQuestion2': 'मेरे रास्ते के लिए पढ़ाई की टिप्स',
      'quickQuestion3': 'छात्रवृत्ति के अवसर',
      'quickQuestion4': 'इंटरव्यू की तैयारी',
    },
  };

  @override
  void initState() {
    WebViewPlatform.instance = WebWebViewPlatform();

    // Create the controller and load Botpress chat
    _controller =
        PlatformWebViewController(
          const PlatformWebViewControllerCreationParams(),
        )..loadRequest(
          LoadRequestParams(
            uri: Uri.parse(
              "https://cdn.botpress.cloud/webchat/v3.2/shareable.html?configUrl=https://files.bpcontent.cloud/2025/09/13/11/20250913112159-Y2S3IPVO.json",
            ), // 🔥 Replace with your Botpress webchat URL
          ),
        );
    super.initState();
  }

  String _translate(String key) {
    return _translations[_selectedLanguage]?[key] ?? key;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // AppColors.background if you defined it
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: PlatformWebViewWidget(
                PlatformWebViewWidgetCreationParams(controller: _controller),
              ).build(context),
            ),
            _buildQuickQuestions(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        boxShadow: AppShadows.small,
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(Icons.psychology, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _translate('title'),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  _translate('subtitle'),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          _buildLanguageSelector(),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedLanguage,
          items: _translations.keys.map((String language) {
            return DropdownMenuItem<String>(
              value: language,
              child: Text(
                language,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedLanguage = newValue;
              });
            }
          },
          dropdownColor: AppColors.primary,
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildQuickQuestions() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildQuickQuestionChip(_translate('quickQuestion1')),
          _buildQuickQuestionChip(_translate('quickQuestion2')),
          _buildQuickQuestionChip(_translate('quickQuestion3')),
          _buildQuickQuestionChip(_translate('quickQuestion4')),
        ],
      ),
    );
  }

  Widget _buildQuickQuestionChip(String question) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(question, style: const TextStyle(fontSize: 12)),
        onPressed: () {},
        backgroundColor: AppColors.surfaceContainerHighest,
        side: BorderSide(color: AppColors.primary.withOpacity(0.3)),
      ),
    );
  }
}
