import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter_app/utils/app_theme.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  late AnimationController _animationController;
  
  final List<String> _quickReplies = [
    'Help me with interview prep',
    'Career guidance advice',
    'Resume improvement tips',
    'Skill development plan',
    'Job search strategies',
  ];
  
  final Map<String, List<String>> _aiResponses = {
    'interview': [
      'Great! I can help you prepare for interviews. What type of interview are you preparing for - technical, behavioral, or general?',
      'For interview preparation, I recommend: 1) Research the company thoroughly, 2) Practice common questions, 3) Prepare your own questions, 4) Mock interview sessions. Which area would you like to focus on?',
    ],
    'career': [
      'I\'d be happy to provide career guidance! What specific area are you looking for advice on - career transition, skill development, or growth opportunities?',
      'Career development is a journey. Let me help you create a personalized roadmap. What\'s your current role and where do you see yourself in 2-3 years?',
    ],
    'resume': [
      'Resume improvement is crucial for job success! I can help you with: 1) ATS optimization, 2) Content structure, 3) Keyword enhancement, 4) Format improvements. What\'s your main concern?',
      'A strong resume should highlight your achievements with quantifiable results. Have you uploaded your resume for analysis yet?',
    ],
    'skills': [
      'Skill development is key to career growth! Based on current market trends, I recommend focusing on: 1) Technical skills relevant to your field, 2) Soft skills like communication, 3) Digital literacy. What area interests you most?',
      'Let me create a personalized learning path for you. What\'s your current skill level and what role are you targeting?',
    ],
    'job': [
      'Job searching can be challenging, but with the right strategy, you\'ll succeed! Key areas include: 1) Optimizing your online presence, 2) Networking effectively, 3) Tailoring applications, 4) Interview preparation. Where should we start?',
      'The job market is competitive, but opportunities exist for well-prepared candidates. What type of roles are you targeting and what\'s your experience level?',
    ],
    'default': [
      'That\'s an interesting question! I\'m here to help with your career development. Could you provide more details about what you\'re looking for?',
      'I\'m your AI career advisor, specialized in helping with interviews, resumes, skill development, and job search strategies. How can I assist you today?',
      'I understand you\'re looking for guidance. Let me help you with career-related questions. What specific challenge are you facing?',
    ],
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppDurations.medium,
      vsync: this,
    );
    _addWelcomeMessage();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _addWelcomeMessage() {
    setState(() {
      _messages.add(ChatMessage(
        text: "👋 Hi! I'm OSCAR, your AI career advisor. I'm here to help you with:\n\n🎯 Interview preparation\n📝 Resume optimization\n🚀 Career guidance\n📚 Skill development\n💼 Job search strategies\n\nHow can I assist you today?",
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    
    // Add user message
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
    });
    
    _messageController.clear();
    _scrollToBottom();
    
    // Show typing indicator
    setState(() {
      _isTyping = true;
    });
    
    // Simulate AI response delay
    Timer(Duration(milliseconds: 1000 + Random().nextInt(2000)), () {
      _generateAIResponse(text);
    });
  }
  
  void _generateAIResponse(String userMessage) {
    String category = _categorizeMessage(userMessage);
    List<String> responses = _aiResponses[category] ?? _aiResponses['default']!;
    String response = responses[Random().nextInt(responses.length)];
    
    setState(() {
      _isTyping = false;
      _messages.add(ChatMessage(
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });
    
    _scrollToBottom();
  }
  
  String _categorizeMessage(String message) {
    String lowerMessage = message.toLowerCase();
    
    if (lowerMessage.contains('interview') || lowerMessage.contains('prep')) {
      return 'interview';
    } else if (lowerMessage.contains('career') || lowerMessage.contains('guidance')) {
      return 'career';
    } else if (lowerMessage.contains('resume') || lowerMessage.contains('cv')) {
      return 'resume';
    } else if (lowerMessage.contains('skill') || lowerMessage.contains('learn')) {
      return 'skills';
    } else if (lowerMessage.contains('job') || lowerMessage.contains('search')) {
      return 'job';
    } else {
      return 'default';
    }
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
  
  void _sendQuickReply(String reply) {
    _messageController.text = reply;
    _sendMessage();

    setState(() {
      _isTyping = false;
    });

    _scrollToBottom();

    // Simulate AI response
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isTyping = false;
      });
      _scrollToBottom();
    });
  }

  String _generateAIResponse(String userMessage) {
    // Simple mock responses
    if (userMessage.toLowerCase().contains('career')) {
      return "I'd be happy to help with your career questions! What specific area are you interested in exploring?";
    } else if (userMessage.toLowerCase().contains('resume')) {
      return "Great! I can help you improve your resume. Have you tried our resume analysis feature? It provides detailed feedback on ATS compatibility.";
    } else if (userMessage.toLowerCase().contains('skills')) {
      return "Skill development is crucial for career growth. Based on your profile, I recommend focusing on technical skills in your field. Would you like specific recommendations?";
    } else {
      return "That's an interesting question! I'm here to help with career guidance, skill development, and job search strategies. What would you like to know more about?";
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: AppDurations.fast,
          curve: AppCurves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.smart_toy,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Career Advisor',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  'Online',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return _buildTypingIndicator();
                }
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.smart_toy,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(20).copyWith(
                  bottomLeft: message.isUser
                      ? const Radius.circular(20)
                      : const Radius.circular(4),
                  bottomRight: message.isUser
                      ? const Radius.circular(4)
                      : const Radius.circular(20),
                ),
                boxShadow: AppShadows.small,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: message.isUser
                          ? Colors.white
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: message.isUser
                          ? Colors.white.withOpacity(0.7)
                          : AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.person,
                color: AppColors.textSecondary,
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
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.smart_toy,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20).copyWith(
                bottomLeft: const Radius.circular(4),
              ),
              boxShadow: AppShadows.small,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(0),
                const SizedBox(width: 4),
                _buildTypingDot(1),
                const SizedBox(width: 4),
                _buildTypingDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final animationValue = (_animationController.value + index * 0.2) % 1.0;
        return Transform.translate(
          offset: Offset(0, -4 * (1 - (animationValue * 2 - 1).abs())),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.textTertiary,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: const Color(0x1A2563EB),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type your message...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AppColors.background,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(24),
              ),
              child: IconButton(
                onPressed: _sendMessage,
                icon: const Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
