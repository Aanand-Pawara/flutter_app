import 'package:flutter/material.dart';

class InterviewPrepPage extends StatefulWidget {
  const InterviewPrepPage({super.key});

  @override
  State<InterviewPrepPage> createState() => _InterviewPrepPageState();
}

class _InterviewPrepPageState extends State<InterviewPrepPage> {
  final List<String> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _isInterviewMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Interview Preparation',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2563EB),
              ),
            ),
            const SizedBox(height: 20),
            
            if (!_isInterviewMode) ..._buildPrepOptions() else ..._buildInterviewChat(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPrepOptions() {
    return [
      // Interview Types
      const Text(
        'Choose Interview Type',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 16),
      
      GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
        children: [
          _buildInterviewTypeCard(
            'Technical Interview',
            Icons.code,
            'Practice coding questions and technical concepts',
            Colors.blue,
          ),
          _buildInterviewTypeCard(
            'Behavioral Interview',
            Icons.psychology,
            'Work on soft skills and behavioral questions',
            Colors.green,
          ),
          _buildInterviewTypeCard(
            'System Design',
            Icons.architecture,
            'Practice system design and architecture',
            Colors.orange,
          ),
          _buildInterviewTypeCard(
            'HR Round',
            Icons.people,
            'Prepare for HR and general questions',
            Colors.purple,
          ),
        ],
      ),
      
      const SizedBox(height: 24),
      
      // Quick Tips
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(33, 150, 243, 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color.fromRGBO(33, 150, 243, 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.lightbulb, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Quick Tips',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '• Practice the STAR method for behavioral questions\n• Research the company thoroughly\n• Prepare questions to ask the interviewer\n• Practice coding on a whiteboard',
              style: TextStyle(color: Colors.blue[800]),
            ),
          ],
        ),
      ),
    ];
  }

  Widget _buildInterviewTypeCard(String title, IconData icon, String description, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          setState(() {
            _isInterviewMode = true;
            _messages.clear();
            _messages.add('AI Interviewer: Hello! I\'m your virtual interviewer. Let\'s start with a $title session. Are you ready?');
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(color.red, color.green, color.blue, 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 11,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildInterviewChat() {
    return [
      // Chat Header
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2563EB),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.smart_toy, color: Colors.white),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Live Interview Session',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _isInterviewMode = false;
                  _messages.clear();
                });
              },
              icon: const Icon(Icons.close, color: Colors.white),
            ),
          ],
        ),
      ),
      
      const SizedBox(height: 16),
      
      // Chat Messages
      Expanded(
        child: _messages.isEmpty
            ? const Center(
                child: Text('Start your interview preparation!'),
              )
            : ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final isAI = _messages[index].startsWith('AI Interviewer:');
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      mainAxisAlignment: isAI ? MainAxisAlignment.start : MainAxisAlignment.end,
                      children: [
                        if (isAI) ...[
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Icons.smart_toy, color: Colors.white, size: 18),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isAI ? Colors.grey[100] : const Color(0xFF2563EB),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromRGBO(158, 158, 158, 0.1),
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              _messages[index],
                              style: TextStyle(
                                color: isAI ? Colors.black87 : Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        if (!isAI) ...[
                          const SizedBox(width: 8),
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(Icons.person, color: Colors.grey[600], size: 18),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
      ),
      
      // Input Field
      Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type your answer...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _sendMessage,
            icon: const Icon(Icons.send),
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    ];
  }

  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      setState(() {
        _messages.add('You: ${_controller.text}');
        
        // Simulate AI response
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            _messages.add('AI Interviewer: That\'s a great answer! Let me ask you another question...');
          });
        });
        
        _controller.clear();
      });
    }
  }
}
