class Interview {
  final String id;
  final String title;
  final String type; // 'mock', 'live', 'group', 'ai'
  final String category; // 'technical', 'hr', 'behavioral', 'domain-specific'
  final String level; // 'beginner', 'intermediate', 'advanced'
  final String description;
  final int duration; // minutes
  final DateTime? scheduledDate;
  final String? interviewerName;
  final String? companyName;
  final List<String> topics;
  final List<String> skills;
  final String? meetingUrl;
  final String? meetingId;
  final String? passcode;
  final InterviewStatus status;
  final double? rating;
  final String? feedback;
  final List<InterviewQuestion>? questions;
  final Map<String, dynamic>? metrics; // performance metrics
  final bool isRecorded;
  final String? recordingUrl;
  final double? score;
  final String? certificateUrl;

  Interview({
    required this.id,
    required this.title,
    required this.type,
    required this.category,
    required this.level,
    required this.description,
    required this.duration,
    this.scheduledDate,
    this.interviewerName,
    this.companyName,
    required this.topics,
    required this.skills,
    this.meetingUrl,
    this.meetingId,
    this.passcode,
    required this.status,
    this.rating,
    this.feedback,
    this.questions,
    this.metrics,
    this.isRecorded = false,
    this.recordingUrl,
    this.score,
    this.certificateUrl,
  });

  factory Interview.fromJson(Map<String, dynamic> json) {
    return Interview(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      type: json['type'] ?? 'mock',
      category: json['category'] ?? 'technical',
      level: json['level'] ?? 'beginner',
      description: json['description'] ?? '',
      duration: json['duration'] ?? 30,
      scheduledDate: json['scheduledDate'] != null 
          ? DateTime.parse(json['scheduledDate']) 
          : null,
      interviewerName: json['interviewerName'],
      companyName: json['companyName'],
      topics: List<String>.from(json['topics'] ?? []),
      skills: List<String>.from(json['skills'] ?? []),
      meetingUrl: json['meetingUrl'],
      meetingId: json['meetingId'],
      passcode: json['passcode'],
      status: InterviewStatus.values.firstWhere(
        (e) => e.toString().split('.').last == (json['status'] ?? 'scheduled'),
        orElse: () => InterviewStatus.scheduled,
      ),
      rating: json['rating']?.toDouble(),
      feedback: json['feedback'],
      questions: json['questions'] != null
          ? (json['questions'] as List)
              .map((q) => InterviewQuestion.fromJson(q))
              .toList()
          : null,
      metrics: json['metrics'],
      isRecorded: json['isRecorded'] ?? false,
      recordingUrl: json['recordingUrl'],
      score: json['score']?.toDouble(),
      certificateUrl: json['certificateUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'category': category,
      'level': level,
      'description': description,
      'duration': duration,
      'scheduledDate': scheduledDate?.toIso8601String(),
      'interviewerName': interviewerName,
      'companyName': companyName,
      'topics': topics,
      'skills': skills,
      'meetingUrl': meetingUrl,
      'meetingId': meetingId,
      'passcode': passcode,
      'status': status.toString().split('.').last,
      'rating': rating,
      'feedback': feedback,
      'questions': questions?.map((q) => q.toJson()).toList(),
      'metrics': metrics,
      'isRecorded': isRecorded,
      'recordingUrl': recordingUrl,
      'score': score,
      'certificateUrl': certificateUrl,
    };
  }
}

class InterviewQuestion {
  final String id;
  final String question;
  final String type; // 'technical', 'behavioral', 'coding', 'scenario'
  final String? expectedAnswer;
  final List<String>? options; // for multiple choice
  final String? userAnswer;
  final int? timeSpent; // seconds
  final double? score;
  final String? feedback;
  final String? difficulty;

  InterviewQuestion({
    required this.id,
    required this.question,
    required this.type,
    this.expectedAnswer,
    this.options,
    this.userAnswer,
    this.timeSpent,
    this.score,
    this.feedback,
    this.difficulty,
  });

  factory InterviewQuestion.fromJson(Map<String, dynamic> json) {
    return InterviewQuestion(
      id: json['id'].toString(),
      question: json['question'] ?? '',
      type: json['type'] ?? 'technical',
      expectedAnswer: json['expectedAnswer'],
      options: json['options'] != null 
          ? List<String>.from(json['options']) 
          : null,
      userAnswer: json['userAnswer'],
      timeSpent: json['timeSpent'],
      score: json['score']?.toDouble(),
      feedback: json['feedback'],
      difficulty: json['difficulty'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'type': type,
      'expectedAnswer': expectedAnswer,
      'options': options,
      'userAnswer': userAnswer,
      'timeSpent': timeSpent,
      'score': score,
      'feedback': feedback,
      'difficulty': difficulty,
    };
  }
}

enum InterviewStatus {
  scheduled,
  inProgress,
  completed,
  cancelled,
  noShow,
  rescheduled
}

class LiveInterviewSession {
  final String sessionId;
  final String roomId;
  final String token;
  final Map<String, dynamic> config;
  final DateTime startTime;
  final DateTime? endTime;
  final List<String> participants;
  final bool isActive;

  LiveInterviewSession({
    required this.sessionId,
    required this.roomId,
    required this.token,
    required this.config,
    required this.startTime,
    this.endTime,
    required this.participants,
    this.isActive = true,
  });

  factory LiveInterviewSession.fromJson(Map<String, dynamic> json) {
    return LiveInterviewSession(
      sessionId: json['sessionId'],
      roomId: json['roomId'],
      token: json['token'],
      config: json['config'] ?? {},
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      participants: List<String>.from(json['participants'] ?? []),
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'roomId': roomId,
      'token': token,
      'config': config,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'participants': participants,
      'isActive': isActive,
    };
  }
}