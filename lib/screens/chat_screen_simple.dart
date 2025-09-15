import 'package:flutter/material.dart';
import 'package:flutter_app/utils/app_theme.dart';
import 'package:flutter_app/utils/responsive_utils.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    setState(() {
      _messages.add(ChatMessage(
        text: "Hello! I'm OSCAR, your AI career assistant. How can I help you today?",
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final userMessage = _messageController.text.trim();
    setState(() {
      _messages.add(ChatMessage(
        text: userMessage,
        isUser: true,
        timestamp: DateTime.now(),
      ));
    });

    _messageController.clear();

    // Simulate AI response
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.add(ChatMessage(
          text: _generateAIResponse(userMessage),
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
    });
  }

  String _generateAIResponse(String userMessage) {
    final responses = [
      "That's a great question! Let me help you with that.",
      "I understand your concern. Here's what I recommend...",
      "Based on your query, I suggest exploring these options:",
      "That's an interesting career path! Here are some insights:",
      "I'm here to help you succeed. Let's work on this together.",
    ];
    return responses[DateTime.now().millisecond % responses.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('AI Career Assistant'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessagesList(),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return ListView.builder(
      padding: EdgeInsets.all(ResponsiveUtils.getSpacing(context)),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return _buildMessageBubble(message);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          bottom: ResponsiveUtils.getSpacing(context, scale: 0.5),
          left: message.isUser ? 50 : 0,
          right: message.isUser ? 0 : 50,
        ),
        padding: EdgeInsets.all(ResponsiveUtils.getSpacing(context, scale: 0.75)),
        decoration: BoxDecoration(
          color: message.isUser ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppShadows.small,
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser ? Colors.white : AppColors.textPrimary,
            fontSize: ResponsiveUtils.responsiveFontSize(context, mobile: 16, tablet: 18),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.getSpacing(context)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: const Color(0x1A2563EB),
            blurRadius: 4,
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
                  hintText: 'Ask me anything about your career...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AppColors.surfaceContainerHighest,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            SizedBox(width: ResponsiveUtils.getSpacing(context, scale: 0.5)),
            FloatingActionButton(
              onPressed: _sendMessage,
              backgroundColor: AppColors.primary,
              mini: true,
              child: const Icon(Icons.send, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
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
