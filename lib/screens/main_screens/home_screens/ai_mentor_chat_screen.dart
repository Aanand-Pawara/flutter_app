import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/providers/app_provider.dart';
import 'package:flutter_app/utils/app_theme.dart';

class AIMentorChatScreen extends StatefulWidget {
  const AIMentorChatScreen({super.key});

  @override
  State<AIMentorChatScreen> createState() => _AIMentorChatScreenState();
}

class _AIMentorChatScreenState extends State<AIMentorChatScreen> 
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  String _selectedLanguage = 'English';
  bool _isTyping = false;
  
  final Map<String, Map<String, String>> _translations = {
    'English': {
      'title': 'AI Career Mentor',
      'subtitle': 'Your personalized career guidance assistant',
      'typeMessage': 'Type your message here...',
      'send': 'Send',
      'thinking': 'OSCAR is thinking...',
      'welcomeMessage': 'Hello! I\'m OSCAR, your AI career mentor. I\'m here to help you with career guidance, study tips, and answering your questions. How can I assist you today?',
      'quickQuestion1': 'What career suits me?',
      'quickQuestion2': 'Study tips for my path',
      'quickQuestion3': 'Scholarship opportunities',
      'quickQuestion4': 'Interview preparation',
    },
    'हिंदी': {
      'title': 'AI करियर मेंटर',
      'subtitle': 'आपका व्यक्तिगत करियर मार्गदर्शन सहायक',
      'typeMessage': 'यहाँ अपना संदेश टाइप करें...',
      'send': 'भेजें',
      'thinking': 'OSCAR सोच रहा है...',
      'welcomeMessage': 'नमस्ते! मैं OSCAR हूँ, आपका AI करियर मेंटर। मैं यहाँ करियर मार्गदर्शन, पढ़ाई की युक्तियाँ, और आपके सवालों का जवाब देने के लिए हूँ। आज मैं आपकी कैसे मदद कर सकता हूँ?',
      'quickQuestion1': 'मुझे कौन सा करियर सूट करता है?',
      'quickQuestion2': 'मेरे रास्ते के लिए पढ़ाई की टिप्स',
      'quickQuestion3': 'छात्रवृत्ति के अवसर',
      'quickQuestion4': 'इंटरव्यू की तैयारी',
    },
  };

  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _addWelcomeMessage();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: AppDurations.slow,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: AppCurves.easeInOut),
    );

    _animationController.forward();
  }

  void _addWelcomeMessage() {
    setState(() {
      _messages.add(ChatMessage(
        text: _translate('welcomeMessage'),
        isUser: false,
        timestamp: DateTime.now(),
        language: _selectedLanguage,
      ));
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  String _translate(String key) {
    return _translations[_selectedLanguage]?[key] ?? key;
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
        language: _selectedLanguage,
      ));
      _isTyping = true;
    });

    _messageController.clear();
    _scrollToBottom();

    // Simulate AI response
    _simulateAIResponse(text);
  }

  void _simulateAIResponse(String userMessage) {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add(ChatMessage(
            text: _generateAIResponse(userMessage),
            isUser: false,
            timestamp: DateTime.now(),
            language: _selectedLanguage,
          ));
        });
        _scrollToBottom();
      }
    });
  }

  String _generateAIResponse(String userMessage) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final selectedPath = appProvider.selectedCareerPath;
    
    // Simple response generation based on keywords and selected career path
    final message = userMessage.toLowerCase();
    
    if (_selectedLanguage == 'हिंदी') {
      if (message.contains('करियर') || message.contains('career')) {
        return _getCareerAdviceHindi(selectedPath);
      } else if (message.contains('पढ़ाई') || message.contains('study')) {
        return _getStudyTipsHindi(selectedPath);
      } else if (message.contains('छात्रवृत्ति') || message.contains('scholarship')) {
        return _getScholarshipInfoHindi(selectedPath);
      } else {
        return 'मैं आपकी मदद करने के लिए यहाँ हूँ! कृपया अपना सवाल स्पष्ट रूप से पूछें। आप करियर मार्गदर्शन, पढ़ाई की युक्तियाँ, या छात्रवृत्ति के बारे में पूछ सकते हैं।';
      }
    } else {
      if (message.contains('career') || message.contains('job')) {
        return _getCareerAdviceEnglish(selectedPath);
      } else if (message.contains('study') || message.contains('learn')) {
        return _getStudyTipsEnglish(selectedPath);
      } else if (message.contains('scholarship') || message.contains('funding')) {
        return _getScholarshipInfoEnglish(selectedPath);
      } else if (message.contains('interview')) {
        return _getInterviewTipsEnglish();
      } else {
        return 'I\'m here to help you! Please feel free to ask me about career guidance, study tips, scholarships, or any other questions related to your career path.';
      }
    }
  }

  String _getCareerAdviceEnglish(String? path) {
    switch (path) {
      case '10th':
        return 'For 10th standard students, focus on understanding your interests and strengths. Consider Science stream for engineering/medical, Commerce for business/finance, or Arts for creative fields. Take career assessment tests and talk to professionals in different fields.';
      case '12th':
        return 'As a 12th student, research colleges and courses thoroughly. Prepare for entrance exams early, maintain good grades, and start building your resume with extracurricular activities. Consider both academic and skill-based career paths.';
      case 'neet':
        return 'For NEET preparation, focus on NCERT books as your foundation, especially Biology. Practice previous year questions, take regular mock tests, and maintain a consistent study schedule. Biology should get 40% of your time, Physics and Chemistry 30% each.';
      case 'jee':
        return 'JEE preparation requires strong foundations in Mathematics, Physics, and Chemistry. Focus on conceptual understanding, solve plenty of problems, and take regular mock tests. Mathematics is crucial - practice daily and master calculus and algebra.';
      case 'govt':
        return 'Government job preparation requires consistency and current affairs knowledge. Focus on your chosen exam pattern, practice previous papers, and stay updated with news. Consider coaching if needed and maintain a study schedule.';
      case 'technology':
        return 'Technology careers are diverse and growing. Choose a programming language to start with (Python/Java recommended), build projects, contribute to open source, and get relevant certifications. Practice coding daily and stay updated with industry trends.';
      default:
        return 'Career success comes from aligning your interests, skills, and market opportunities. Identify your strengths, research different fields, gain relevant experience through internships or projects, and never stop learning.';
    }
  }

  String _getCareerAdviceHindi(String? path) {
    switch (path) {
      case '10th':
        return '10वीं के छात्रों के लिए, अपनी रुचियों और क्षमताओं को समझना महत्वपूर्ण है। इंजीनियरिंग/मेडिकल के लिए साइंस, बिजनेस/फाइनेंस के लिए कॉमर्स, या क्रिएटिव फील्ड के लिए आर्ट्स चुनें। करियर असेसमेंट टेस्ट लें और विभिन्न क्षेत्रों के प्रोफेशनल्स से बात करें।';
      case '12th':
        return '12वीं के छात्र के रूप में, कॉलेजों और कोर्सों की अच्छी रिसर्च करें। प्रवेश परीक्षाओं की तैयारी जल्दी शुरू करें, अच्छे अंक बनाए रखें, और एक्स्ट्राकरिकुलर एक्टिविटीज के साथ अपना रिज्यूमे बनाना शुरू करें।';
      case 'neet':
        return 'NEET की तैयारी के लिए NCERT किताबों पर फोकस करें, खासकर बायोलॉजी पर। पिछले साल के प्रश्न पत्रों का अभ्यास करें, नियमित मॉक टेस्ट लें। बायोलॉजी को 40% समय दें, फिजिक्स और केमिस्ट्री को 30-30% समय दें।';
      case 'jee':
        return 'JEE की तैयारी के लिए मैथ्स, फिजिक्स और केमिस्ट्री की मजबूत बुनियाद चाहिए। कॉन्सेप्चुअल समझ पर फोकस करें, बहुत सारे प्रॉब्लम सॉल्व करें। मैथ्स सबसे महत्वपूर्ण है - रोज प्रैक्टिस करें।';
      case 'govt':
        return 'सरकारी नौकरी की तैयारी के लिए निरंतरता और करेंट अफेयर्स का ज्ञान जरूरी है। अपने चुने गए एग्जाम पैटर्न पर फोकस करें, पिछले पेपर्स प्रैक्टिस करें, और न्यूज अपडेट रहें।';
      case 'technology':
        return 'टेक्नोलॉजी करियर विविध और बढ़ते हुए हैं। एक प्रोग्रामिंग लैंग्वेज से शुरुआत करें (Python/Java सुझाया गया), प्रोजेक्ट्स बनाएं, ओपन सोर्स में कंट्रिब्यूट करें, और रेलेवेंट सर्टिफिकेशन लें।';
      default:
        return 'करियर की सफलता आपकी रुचियों, स्किल्स और बाजार के अवसरों को मिलाने से आती है। अपनी ताकत पहचानें, अलग-अलग फील्ड्स की रिसर्च करें, और सीखना कभी न रोकें।';
    }
  }

  String _getStudyTipsEnglish(String? path) {
    switch (path) {
      case 'neet':
        return 'NEET Study Tips: 1) Start with NCERT thoroughly 2) Make notes for quick revision 3) Practice MCQs daily 4) Take weekly mock tests 5) Focus on Biology diagrams 6) Maintain error log 7) Revise regularly.';
      case 'jee':
        return 'JEE Study Tips: 1) Master Mathematics fundamentals 2) Solve HC Verma for Physics 3) Practice numerical problems daily 4) Time management in exams 5) Regular mock tests 6) Analyze mistakes 7) Stay consistent.';
      case 'govt':
        return 'Government Exam Tips: 1) Read newspapers daily 2) Practice quantitative aptitude 3) Improve general knowledge 4) Time management 5) Previous year papers 6) Current affairs monthly magazine 7) Mock tests.';
      default:
        return 'General Study Tips: 1) Create a study schedule 2) Take regular breaks 3) Practice active recall 4) Use spaced repetition 5) Join study groups 6) Stay healthy 7) Get enough sleep.';
    }
  }

  String _getStudyTipsHindi(String? path) {
    switch (path) {
      case 'neet':
        return 'NEET पढ़ाई टिप्स: 1) NCERT को अच्छे से पढ़ें 2) त्वरित रिवीजन के लिए नोट्स बनाएं 3) रोज MCQs प्रैक्टिस करें 4) साप्ताहिक मॉक टेस्ट लें 5) बायोलॉजी डायग्राम पर फोकस करें 6) गलती लॉग बनाए रखें।';
      case 'jee':
        return 'JEE पढ़ाई टिप्स: 1) गणित की बुनियाद मजबूत करें 2) फिजिक्स के लिए HC Verma सॉल्व करें 3) रोज न्यूमेरिकल प्रॉब्लम सॉल्व करें 4) परीक्षा में समय प्रबंधन 5) नियमित मॉक टेस्ट।';
      case 'govt':
        return 'सरकारी परीक्षा टिप्स: 1) रोज अखबार पढ़ें 2) क्वांटिटेटिव एप्टीट्यूड प्रैक्टिस करें 3) सामान्य ज्ञान सुधारें 4) समय प्रबंधन 5) पिछले साल के पेपर्स 6) करेंट अफेयर्स मैगजीन।';
      default:
        return 'सामान्य पढ़ाई टिप्स: 1) पढ़ाई का शेड्यूल बनाएं 2) नियमित ब्रेक लें 3) एक्टिव रिकॉल का अभ्यास करें 4) स्पेस्ड रिपीटिशन का उपयोग करें 5) स्टडी ग्रुप ज्वाइन करें।';
    }
  }

  String _getScholarshipInfoEnglish(String? path) {
    return 'Scholarship opportunities for your path:\n\n1) Merit-based scholarships from government\n2) Need-based financial aid\n3) Institution-specific scholarships\n4) Private foundation grants\n5) Online course scholarships\n\nTip: Apply early, maintain good grades, and prepare strong application essays. Check deadlines regularly!';
  }

  String _getScholarshipInfoHindi(String? path) {
    return 'आपके पथ के लिए छात्रवृत्ति के अवसर:\n\n1) सरकार से मेधा-आधारित छात्रवृत्ति\n2) आवश्यकता-आधारित वित्तीय सहायता\n3) संस्थान-विशिष्ट छात्रवृत्ति\n4) निजी फाउंडेशन अनुदान\n5) ऑनलाइन कोर्स छात्रवृत्ति\n\nटिप: जल्दी आवेदन करें, अच्छे अंक बनाए रखें, और मजबूत आवेदन निबंध तैयार करें।';
  }

  String _getInterviewTipsEnglish() {
    return 'Interview Preparation Tips:\n\n1) Research the company/organization\n2) Practice common questions\n3) Prepare your introduction\n4) Dress professionally\n5) Be punctual\n6) Ask thoughtful questions\n7) Follow up after interview\n\nRemember: Confidence and authenticity are key!';
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: _buildChatArea(),
              ),
              _buildQuickQuestions(),
              _buildMessageInput(),
            ],
          ),
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
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.psychology,
                  color: Colors.white,
                  size: 28,
                ),
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
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedLanguage = newValue;
                // Update welcome message in new language
                if (_messages.isNotEmpty) {
                  _messages[0] = ChatMessage(
                    text: _translate('welcomeMessage'),
                    isUser: false,
                    timestamp: _messages[0].timestamp,
                    language: _selectedLanguage,
                  );
                }
              });
            }
          },
          dropdownColor: AppColors.primary,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  Widget _buildChatArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _messages.length + (_isTyping ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _messages.length && _isTyping) {
            return _buildTypingIndicator();
          }
          return _buildMessageBubble(_messages[index]);
        },
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: message.isUser 
            ? MainAxisAlignment.end 
            : MainAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary,
              child: const Icon(
                Icons.psychology,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.isUser 
                    ? AppColors.primary 
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppShadows.small,
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser 
                      ? Colors.white 
                      : AppColors.textPrimary,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.accent,
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primary,
            child: const Icon(
              Icons.psychology,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppShadows.small,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _translate('thinking'),
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
        ],
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
        label: Text(
          question,
          style: const TextStyle(fontSize: 12),
        ),
        onPressed: () {
          _sendMessage(question);
        },
        backgroundColor: AppColors.surfaceContainerHighest,
        side: BorderSide(color: AppColors.primary.withOpacity(0.3)),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: AppShadows.small,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: _translate('typeMessage'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.surfaceContainerHighest,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              onSubmitted: _sendMessage,
              textInputAction: TextInputAction.send,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => _sendMessage(_messageController.text),
              icon: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String language;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    required this.language,
  });
}