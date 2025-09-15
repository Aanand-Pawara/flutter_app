import 'dart:convert';
import 'package:http/http.dart' as http;

class HuggingFaceService {
  static const String _apiKey = 'YOUR_HUGGINGFACE_API_KEY';
  static const String _baseUrl = 'https://api-inference.huggingface.co/models';
  
  static final HuggingFaceService _instance = HuggingFaceService._internal();
  factory HuggingFaceService() => _instance;
  HuggingFaceService._internal();

  final http.Client _client = http.Client();
  static const Duration _timeout = Duration(seconds: 30);

  // ============ MULTILINGUAL CHAT MODELS ============
  
  /// Generates AI responses using multilingual models
  Future<String> generateChatResponse(String userMessage, {String language = 'en'}) async {
    try {
      // Use different models based on language
      String modelName = _getModelForLanguage(language);
      
      final response = await _client.post(
        Uri.parse('$_baseUrl/$modelName'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'inputs': _formatChatPrompt(userMessage, language),
          'parameters': {
            'max_new_tokens': 150,
            'temperature': 0.7,
            'do_sample': true,
            'return_full_text': false,
          },
        }),
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List && data.isNotEmpty) {
          return data[0]['generated_text']?.toString().trim() ?? _getFallbackResponse(userMessage, language);
        }
      }
      
      return _getFallbackResponse(userMessage, language);
    } catch (e) {
      // Error generating chat response
      return _getFallbackResponse(userMessage, language);
    }
  }

  /// Analyzes career-related queries and provides structured responses
  Future<Map<String, dynamic>> analyzeCareerQuery(String query) async {
    try {
      const String modelName = 'microsoft/DialoGPT-medium';
      
      final response = await _client.post(
        Uri.parse('$_baseUrl/$modelName'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'inputs': _formatCareerPrompt(query),
          'parameters': {
            'max_new_tokens': 200,
            'temperature': 0.6,
          },
        }),
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _parseCareerResponse(data[0]['generated_text']);
      }
      
      return _getFallbackCareerAnalysis(query);
    } catch (e) {
      // Error analyzing career query
      return _getFallbackCareerAnalysis(query);
    }
  }

  /// Performs sentiment analysis on user messages
  Future<Map<String, dynamic>> analyzeSentiment(String text) async {
    try {
      const String modelName = 'cardiffnlp/twitter-roberta-base-sentiment-latest';
      
      final response = await _client.post(
        Uri.parse('$_baseUrl/$modelName'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'inputs': text,
        }),
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List && data.isNotEmpty) {
          return {
            'sentiment': data[0][0]['label'].toLowerCase(),
            'confidence': data[0][0]['score'],
          };
        }
      }
      
      return {'sentiment': 'neutral', 'confidence': 0.5};
    } catch (e) {
      // Error analyzing sentiment
      return {'sentiment': 'neutral', 'confidence': 0.5};
    }
  }

  /// Extracts key skills and topics from text
  Future<List<String>> extractSkills(String text) async {
    try {
      const String modelName = 'dbmdz/bert-large-cased-finetuned-conll03-english';
      
      final response = await _client.post(
        Uri.parse('$_baseUrl/$modelName'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'inputs': text,
        }),
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          return data
              .where((entity) => entity['entity_group'] == 'MISC' || entity['entity_group'] == 'ORG')
              .map((entity) => entity['word'].toString())
              .toList();
        }
      }
      
      return _extractSkillsFallback(text);
    } catch (e) {
      // Error extracting skills
      return _extractSkillsFallback(text);
    }
  }

  /// Generates interview questions based on job role
  Future<List<String>> generateInterviewQuestions(String jobRole, String experience) async {
    try {
      const String modelName = 'microsoft/DialoGPT-large';
      
      final prompt = '''Generate 5 interview questions for a $jobRole position requiring $experience experience level. 
      Focus on technical skills, problem-solving, and role-specific competencies.
      Format: Return only the questions, one per line.''';
      
      final response = await _client.post(
        Uri.parse('$_baseUrl/$modelName'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'inputs': prompt,
          'parameters': {
            'max_new_tokens': 300,
            'temperature': 0.8,
          },
        }),
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        String generatedText = data[0]['generated_text'];
        return generatedText.split('\n')
            .where((line) => line.trim().isNotEmpty && line.contains('?'))
            .take(5)
            .toList();
      }
      
      return _getFallbackInterviewQuestions(jobRole);
    } catch (e) {
      // Error generating interview questions
      return _getFallbackInterviewQuestions(jobRole);
    }
  }

  /// Analyzes resume content and provides feedback
  Future<Map<String, dynamic>> analyzeResume(String resumeText) async {
    try {
      const String modelName = 'facebook/bart-large-mnli';
      
      final categories = [
        'technical skills',
        'soft skills', 
        'work experience',
        'education',
        'achievements',
        'contact information'
      ];
      
      Map<String, dynamic> analysis = {
        'sections': {},
        'missing_sections': [],
        'suggestions': [],
      };
      
      for (String category in categories) {
        final response = await _client.post(
          Uri.parse('$_baseUrl/$modelName'),
          headers: {
            'Authorization': 'Bearer $_apiKey',
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'inputs': {
              'sequence_to_classify': resumeText,
              'candidate_labels': [category, 'not relevant'],
            },
          }),
        ).timeout(_timeout);

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          double score = data['scores'][0];
          
          if (score > 0.5) {
            analysis['sections'][category] = score;
          } else {
            analysis['missing_sections'].add(category);
          }
        }
      }
      
      // Generate suggestions based on analysis
      analysis['suggestions'] = _generateResumeSuggestions(analysis);
      
      return analysis;
    } catch (e) {
      // Error analyzing resume
      return _getFallbackResumeAnalysis();
    }
  }

  // ============ HELPER METHODS ============
  
  String _getModelForLanguage(String language) {
    switch (language.toLowerCase()) {
      case 'hi':
      case 'hindi':
        return 'microsoft/DialoGPT-medium'; // Supports some Hindi
      case 'ta':
      case 'tamil':
        return 'microsoft/DialoGPT-medium';
      case 'te':
      case 'telugu':
        return 'microsoft/DialoGPT-medium';
      case 'bn':
      case 'bengali':
        return 'microsoft/DialoGPT-medium';
      default:
        return 'microsoft/DialoGPT-large';
    }
  }
  
  String _formatChatPrompt(String message, String language) {
    String prompt = '''You are OSCAR, an AI career advisor for Indian students and professionals. 
    Respond helpfully and professionally to career-related questions.
    
    User: $message
    OSCAR:''';
    
    if (language != 'en') {
      prompt = '''You are OSCAR, an AI career advisor. Respond in $language language.
      
      User: $message
      OSCAR:''';
    }
    
    return prompt;
  }
  
  String _formatCareerPrompt(String query) {
    return '''Analyze this career-related query and provide structured advice:
    
    Query: $query
    
    Please provide:
    1. Career field identification
    2. Relevant skills needed
    3. Educational requirements
    4. Job prospects
    5. Actionable next steps
    
    Response:''';
  }
  
  Map<String, dynamic> _parseCareerResponse(String response) {
    // Simple parsing logic - in production, use more sophisticated NLP
    return {
      'field': _extractField(response),
      'skills': _extractSkillsFromResponse(response),
      'education': _extractEducation(response),
      'prospects': _extractProspects(response),
      'next_steps': _extractNextSteps(response),
    };
  }
  
  String _extractField(String response) {
    // Extract career field from response
    final fieldKeywords = ['engineering', 'medicine', 'business', 'technology', 'design'];
    for (String keyword in fieldKeywords) {
      if (response.toLowerCase().contains(keyword)) {
        return keyword;
      }
    }
    return 'general';
  }
  
  List<String> _extractSkillsFromResponse(String response) {
    final skillKeywords = [
      'programming', 'communication', 'leadership', 'analysis', 'design',
      'management', 'technical', 'creative', 'problem-solving'
    ];
    
    return skillKeywords
        .where((skill) => response.toLowerCase().contains(skill))
        .toList();
  }
  
  String _extractEducation(String response) {
    if (response.toLowerCase().contains('bachelor')) return 'Bachelor\'s degree';
    if (response.toLowerCase().contains('master')) return 'Master\'s degree';
    if (response.toLowerCase().contains('diploma')) return 'Diploma';
    return 'Relevant education';
  }
  
  String _extractProspects(String response) {
    if (response.toLowerCase().contains('good') || response.toLowerCase().contains('positive')) {
      return 'Good job prospects';
    }
    return 'Stable job prospects';
  }
  
  List<String> _extractNextSteps(String response) {
    return [
      'Develop relevant skills',
      'Gain practical experience',
      'Build a portfolio',
      'Network with professionals',
      'Apply for relevant positions'
    ];
  }
  
  List<String> _extractSkillsFallback(String text) {
    final commonSkills = [
      'communication', 'leadership', 'teamwork', 'problem-solving',
      'programming', 'analysis', 'design', 'management', 'creativity'
    ];
    
    return commonSkills
        .where((skill) => text.toLowerCase().contains(skill))
        .toList();
  }
  
  String _getFallbackResponse(String message, String language) {
    final responses = {
      'en': {
        'interview': 'I can help you prepare for interviews. What specific area would you like to focus on?',
        'career': 'Career planning is important. What field are you interested in exploring?',
        'resume': 'I can help you improve your resume. What specific feedback are you looking for?',
        'skills': 'Skill development is key to career growth. What skills would you like to develop?',
        'job': 'Job searching can be challenging. What type of roles are you targeting?',
        'default': 'I\'m here to help with your career questions. How can I assist you today?',
      },
      'hi': {
        'interview': 'मैं आपको इंटरव्यू की तैयारी में मदद कर सकता हूं। आप किस विशिष्ट क्षेत्र पर ध्यान देना चाहते हैं?',
        'career': 'करियर प्लानिंग महत्वपूर्ण है। आप किस क्षेत्र में रुचि रखते हैं?',
        'default': 'मैं आपके करियर संबंधी सवालों में मदद के लिए यहां हूं।',
      },
    };
    
    final langResponses = responses[language] ?? responses['en']!;
    final messageKey = _categorizeMessage(message);
    
    return langResponses[messageKey] ?? langResponses['default']!;
  }
  
  String _categorizeMessage(String message) {
    final lowerMessage = message.toLowerCase();
    
    if (lowerMessage.contains('interview')) return 'interview';
    if (lowerMessage.contains('career')) return 'career';
    if (lowerMessage.contains('resume')) return 'resume';
    if (lowerMessage.contains('skill')) return 'skills';
    if (lowerMessage.contains('job')) return 'job';
    
    return 'default';
  }
  
  Map<String, dynamic> _getFallbackCareerAnalysis(String query) {
    return {
      'field': 'technology',
      'skills': ['communication', 'problem-solving', 'technical skills'],
      'education': 'Bachelor\'s degree',
      'prospects': 'Good job prospects',
      'next_steps': [
        'Develop relevant skills',
        'Gain practical experience',
        'Build a portfolio'
      ],
    };
  }
  
  List<String> _getFallbackInterviewQuestions(String jobRole) {
    return [
      'Tell me about yourself and your background.',
      'Why are you interested in this $jobRole position?',
      'What are your greatest strengths and weaknesses?',
      'Describe a challenging situation you faced and how you handled it.',
      'Where do you see yourself in 5 years?',
    ];
  }
  
  Map<String, dynamic> _getFallbackResumeAnalysis() {
    return {
      'sections': {
        'technical skills': 0.8,
        'work experience': 0.7,
        'education': 0.9,
      },
      'missing_sections': ['soft skills', 'achievements'],
      'suggestions': [
        'Add more technical skills',
        'Include measurable achievements',
        'Improve formatting and structure',
      ],
    };
  }
  
  List<String> _generateResumeSuggestions(Map<String, dynamic> analysis) {
    List<String> suggestions = [];
    
    if (analysis['missing_sections'].contains('technical skills')) {
      suggestions.add('Add a technical skills section with relevant technologies');
    }
    
    if (analysis['missing_sections'].contains('achievements')) {
      suggestions.add('Include quantifiable achievements and accomplishments');
    }
    
    if (analysis['missing_sections'].contains('soft skills')) {
      suggestions.add('Highlight soft skills like leadership and communication');
    }
    
    return suggestions;
  }
  
  void dispose() {
    _client.close();
  }
}
