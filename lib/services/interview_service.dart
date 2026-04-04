import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_app/models/interview.dart';

class InterviewService {
  static const String _zoomApiKey = 'YOUR_ZOOM_API_KEY';
  static const String _zoomApiSecret = 'YOUR_ZOOM_API_SECRET';
  static const String _openaiApiKey = 'YOUR_OPENAI_API_KEY';
  static const String _dailyCoApiKey = 'YOUR_DAILY_CO_API_KEY';
  static const String _calendlyApiKey = 'YOUR_CALENDLY_API_KEY';

  static final InterviewService _instance = InterviewService._internal();
  factory InterviewService() => _instance;
  InterviewService._internal();

  final http.Client _client = http.Client();
  static const Duration _timeout = Duration(seconds: 30);

  // ============ LIVE INTERVIEW SERVICES ============

  /// Schedule a live interview using Calendly API
  Future<Interview> scheduleLiveInterview({
    required String title,
    required String category,
    required String level,
    required DateTime scheduledDate,
    required List<String> topics,
    String? interviewerEmail,
    String? companyName,
    int duration = 60,
  }) async {
    try {
      final response = await _scheduleCalendlyMeeting(
        title: title,
        startTime: scheduledDate,
        duration: duration,
        attendeeEmail: interviewerEmail,
      );

      if (response != null) {
        return Interview(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          type: 'live',
          category: category,
          level: level,
          description: 'Live interview session with industry expert',
          duration: duration,
          scheduledDate: scheduledDate,
          interviewerName: interviewerEmail?.split('@').first ?? 'Expert Interviewer',
          companyName: companyName,
          topics: topics,
          skills: _getSkillsFromTopics(topics),
          meetingUrl: response['join_url'],
          meetingId: response['id'].toString(),
          status: InterviewStatus.scheduled,
          isRecorded: true,
        );
      }

      return _getFallbackLiveInterview(title, category, level, scheduledDate, topics);
    } catch (e) {
      print('Error scheduling live interview: $e');
      return _getFallbackLiveInterview(title, category, level, scheduledDate, topics);
    }
  }

  /// Create live interview room using Daily.co API
  Future<LiveInterviewSession?> createInterviewRoom({
    required String interviewId,
    required int duration,
    bool isPrivate = true,
  }) async {
    try {
      final headers = {
        'Authorization': 'Bearer $_dailyCoApiKey',
        'Content-Type': 'application/json',
      };

      final body = json.encode({
        'name': 'interview-$interviewId',
        'privacy': isPrivate ? 'private' : 'public',
        'properties': {
          'max_participants': 5,
          'enable_screenshare': true,
          'enable_chat': true,
          'enable_knocking': true,
          'exp': (DateTime.now().millisecondsSinceEpoch ~/ 1000) + (duration * 60),
        },
      });

      final response = await _client
          .post(
            Uri.parse('https://api.daily.co/v1/rooms'),
            headers: headers,
            body: body,
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return LiveInterviewSession(
          sessionId: interviewId,
          roomId: data['name'],
          token: data['url'],
          config: data['config'] ?? {},
          startTime: DateTime.now(),
          participants: [],
        );
      }

      return null;
    } catch (e) {
      print('Error creating interview room: $e');
      return null;
    }
  }

  /// Generate interview questions using OpenAI API
  Future<List<InterviewQuestion>> generateInterviewQuestions({
    required String category,
    required String level,
    required List<String> topics,
    required String careerPath,
    int questionCount = 10,
  }) async {
    try {
      final prompt = _buildQuestionPrompt(category, level, topics, careerPath, questionCount);
      
      final headers = {
        'Authorization': 'Bearer $_openaiApiKey',
        'Content-Type': 'application/json',
      };

      final body = json.encode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {
            'role': 'system',
            'content': 'You are an expert interviewer. Generate realistic interview questions with expected answers.'
          },
          {
            'role': 'user',
            'content': prompt,
          }
        ],
        'max_tokens': 2000,
        'temperature': 0.7,
      });

      final response = await _client
          .post(
            Uri.parse('https://api.openai.com/v1/chat/completions'),
            headers: headers,
            body: body,
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final content = data['choices'][0]['message']['content'];
        return _parseQuestionsFromResponse(content, category);
      }

      return _getFallbackQuestions(category, level, topics);
    } catch (e) {
      print('Error generating questions: $e');
      return _getFallbackQuestions(category, level, topics);
    }
  }

  /// Get mock interview sessions
  Future<List<Interview>> getMockInterviews({
    String? category,
    String? level,
  }) async {
    // Return predefined mock interviews
    return [
      Interview(
        id: 'mock_1',
        title: 'Technical Interview - Software Developer',
        type: 'mock',
        category: 'technical',
        level: 'intermediate',
        description: 'Practice technical questions for software development roles',
        duration: 45,
        topics: ['Data Structures', 'Algorithms', 'System Design', 'Coding'],
        skills: ['Problem Solving', 'Programming', 'System Architecture'],
        status: InterviewStatus.scheduled,
        isRecorded: false,
        questions: await generateInterviewQuestions(
          category: 'technical',
          level: 'intermediate',
          topics: ['Data Structures', 'Algorithms'],
          careerPath: 'technology',
        ),
      ),
      Interview(
        id: 'mock_2',
        title: 'HR Interview - Behavioral Questions',
        type: 'mock',
        category: 'hr',
        level: 'beginner',
        description: 'Practice common HR and behavioral interview questions',
        duration: 30,
        topics: ['Communication', 'Teamwork', 'Leadership', 'Problem Solving'],
        skills: ['Communication', 'Interpersonal Skills', 'Self Awareness'],
        status: InterviewStatus.scheduled,
        isRecorded: false,
        questions: await generateInterviewQuestions(
          category: 'behavioral',
          level: 'beginner',
          topics: ['Communication', 'Teamwork'],
          careerPath: 'general',
        ),
      ),
      Interview(
        id: 'mock_3',
        title: 'Domain Interview - Government Jobs',
        type: 'mock',
        category: 'domain-specific',
        level: 'intermediate',
        description: 'Practice questions specific to government job interviews',
        duration: 60,
        topics: ['Current Affairs', 'General Knowledge', 'Aptitude', 'Reasoning'],
        skills: ['Analytical Thinking', 'General Awareness', 'Logical Reasoning'],
        status: InterviewStatus.scheduled,
        isRecorded: false,
        questions: await generateInterviewQuestions(
          category: 'domain-specific',
          level: 'intermediate',
          topics: ['Current Affairs', 'General Knowledge'],
          careerPath: 'government',
        ),
      ),
    ];
  }

  /// Book a live interview session
  Future<Interview> bookLiveInterview({
    required String slotId,
    required String category,
    required String level,
    required List<String> topics,
    String? preferredInterviewer,
  }) async {
    try {
      // Simulate booking process
      final scheduledDate = DateTime.now().add(Duration(days: 2));
      
      return Interview(
        id: 'live_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Live Interview - $category',
        type: 'live',
        category: category,
        level: level,
        description: 'Live interview session with industry expert',
        duration: 60,
        scheduledDate: scheduledDate,
        interviewerName: preferredInterviewer ?? 'Industry Expert',
        topics: topics,
        skills: _getSkillsFromTopics(topics),
        meetingUrl: 'https://meet.google.com/interview-${DateTime.now().millisecondsSinceEpoch}',
        meetingId: 'interview-${DateTime.now().millisecondsSinceEpoch}',
        status: InterviewStatus.scheduled,
        isRecorded: true,
      );
    } catch (e) {
      throw Exception('Failed to book live interview: $e');
    }
  }

  /// Get available interview slots
  Future<List<Map<String, dynamic>>> getAvailableSlots({
    String? category,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    // Simulate available slots
    final slots = <Map<String, dynamic>>[];
    final now = DateTime.now();
    
    for (int i = 1; i <= 7; i++) {
      final date = now.add(Duration(days: i));
      slots.addAll([
        {
          'id': 'slot_${date.day}_10',
          'date': date.copyWith(hour: 10, minute: 0),
          'interviewer': 'Sarah Johnson',
          'expertise': ['Technical', 'System Design'],
          'available': true,
        },
        {
          'id': 'slot_${date.day}_14',
          'date': date.copyWith(hour: 14, minute: 0),
          'interviewer': 'Michael Chen',
          'expertise': ['Behavioral', 'Leadership'],
          'available': true,
        },
        {
          'id': 'slot_${date.day}_16',
          'date': date.copyWith(hour: 16, minute: 0),
          'interviewer': 'Priya Sharma',
          'expertise': ['Domain Specific', 'Government'],
          'available': i % 2 == 0, // Some slots unavailable
        },
      ]);
    }
    
    return slots;
  }

  // ============ HELPER METHODS ============

  Future<Map<String, dynamic>?> _scheduleCalendlyMeeting({
    required String title,
    required DateTime startTime,
    required int duration,
    String? attendeeEmail,
  }) async {
    // Simulate Calendly API response
    return {
      'id': DateTime.now().millisecondsSinceEpoch,
      'join_url': 'https://calendly.com/interview-${DateTime.now().millisecondsSinceEpoch}',
      'start_time': startTime.toIso8601String(),
      'duration': duration,
    };
  }

  List<String> _getSkillsFromTopics(List<String> topics) {
    final skillMap = {
      'Data Structures': ['Problem Solving', 'Programming'],
      'Algorithms': ['Logical Thinking', 'Problem Solving'],
      'System Design': ['System Architecture', 'Scalability'],
      'Communication': ['Interpersonal Skills', 'Presentation'],
      'Teamwork': ['Collaboration', 'Leadership'],
      'Current Affairs': ['General Awareness', 'Critical Thinking'],
    };

    final skills = <String>{};
    for (final topic in topics) {
      skills.addAll(skillMap[topic] ?? [topic]);
    }
    return skills.toList();
  }

  String _buildQuestionPrompt(String category, String level, List<String> topics, String careerPath, int count) {
    return '''
Generate $count interview questions for a $level level $category interview in the $careerPath field.
Topics to focus on: ${topics.join(', ')}

For each question, provide:
1. The question text
2. Expected answer/approach
3. Difficulty level
4. Type (technical/behavioral/scenario)

Format as JSON array with objects containing: question, expectedAnswer, difficulty, type
''';
  }

  List<InterviewQuestion> _parseQuestionsFromResponse(String response, String category) {
    try {
      final data = json.decode(response);
      if (data is List) {
        return data.map((q) => InterviewQuestion(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          question: q['question'] ?? '',
          type: q['type'] ?? category,
          expectedAnswer: q['expectedAnswer'],
          difficulty: q['difficulty'] ?? 'medium',
        )).toList();
      }
    } catch (e) {
      print('Error parsing questions: $e');
    }
    return _getFallbackQuestions(category, 'intermediate', []);
  }

  List<InterviewQuestion> _getFallbackQuestions(String category, String level, List<String> topics) {
    final questions = <InterviewQuestion>[];
    
    if (category == 'technical') {
      questions.addAll([
        InterviewQuestion(
          id: '1',
          question: 'Explain the difference between Array and Linked List.',
          type: 'technical',
          expectedAnswer: 'Arrays store elements in contiguous memory while linked lists use pointers.',
          difficulty: 'medium',
        ),
        InterviewQuestion(
          id: '2',
          question: 'What is the time complexity of binary search?',
          type: 'technical',
          expectedAnswer: 'O(log n) because we eliminate half the search space in each iteration.',
          difficulty: 'easy',
        ),
      ]);
    } else if (category == 'behavioral' || category == 'hr') {
      questions.addAll([
        InterviewQuestion(
          id: '3',
          question: 'Tell me about a time when you had to work under pressure.',
          type: 'behavioral',
          expectedAnswer: 'Use STAR method: Situation, Task, Action, Result.',
          difficulty: 'medium',
        ),
        InterviewQuestion(
          id: '4',
          question: 'Why do you want to work for our company?',
          type: 'behavioral',
          expectedAnswer: 'Research the company and align your goals with their mission.',
          difficulty: 'easy',
        ),
      ]);
    }

    return questions;
  }

  Interview _getFallbackLiveInterview(String title, String category, String level, DateTime scheduledDate, List<String> topics) {
    return Interview(
      id: 'fallback_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      type: 'live',
      category: category,
      level: level,
      description: 'Live interview session (fallback)',
      duration: 60,
      scheduledDate: scheduledDate,
      interviewerName: 'Interview Expert',
      topics: topics,
      skills: _getSkillsFromTopics(topics),
      meetingUrl: 'https://meet.google.com/fallback-meeting',
      status: InterviewStatus.scheduled,
      isRecorded: false,
    );
  }
}