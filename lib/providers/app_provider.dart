import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/firebase_service.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String? profileImage;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
  });
}

class InterviewPrepData {
  final Map<String, String> answers;
  final String? focusArea;
  final int progress;
  final bool completed;
  final List<String> completedTopics;
  final List<String> practiceQuestions;

  InterviewPrepData({
    required this.answers,
    this.focusArea,
    required this.progress,
    required this.completed,
    required this.completedTopics,
    required this.practiceQuestions,
  });
}

class ResumeAnalysis {
  final String? filePath;
  final int atsScore;
  final List<String> skillGaps;
  final List<String> recommendations;
  final List<String> strengths;

  ResumeAnalysis({
    this.filePath,
    required this.atsScore,
    required this.skillGaps,
    required this.recommendations,
    required this.strengths,
  });
}

class AppProvider extends ChangeNotifier {
  User? _user;
  bool _isAuthenticated = false;
  bool _hasSeenOnboarding = false;
  InterviewPrepData _interviewPrepData = InterviewPrepData(
    answers: {},
    progress: 0,
    completed: false,
    completedTopics: [],
    practiceQuestions: [],
  );
  ResumeAnalysis _resumeAnalysis = ResumeAnalysis(
    atsScore: 0,
    skillGaps: [],
    recommendations: [],
    strengths: [],
  );
  final List<String> _bookmarkedResources = [];
  final List<String> _completedResources = [];
  final List<String> _inProgressResources = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  User? get user => _user;
  bool get isAuthenticated => _isAuthenticated;
  bool get hasSeenOnboarding => _hasSeenOnboarding;
  InterviewPrepData get interviewPrepData => _interviewPrepData;
  ResumeAnalysis get resumeAnalysis => _resumeAnalysis;
  List<String> get bookmarkedResources => _bookmarkedResources;
  List<String> get completedResources => _completedResources;
  List<String> get inProgressResources => _inProgressResources;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Authentication methods
  Future<void> login(String email, String password) async {
    setLoading(true);
    try {
      // Mock authentication
      await FirebaseService.instance.signIn(email: email, password: password);
      String UserName = await FirebaseService.instance.getUserName();
      String Uid = FirebaseService.instance.getUserId();
      _user = User(id: Uid, name: UserName, email: email);
      _isAuthenticated = true;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Login failed: ${e.toString()}';
    } finally {
      setLoading(false);
    }
  }

  Future<void> register(String name, String email, String password) async {
    setLoading(true);
    try {
      await FirebaseService.instance.signUp(
        email: email,
        password: password,
        username: name,
      );

      String Uid = FirebaseService.instance.getUserId();
      _user = User(id: Uid, name: name, email: email);

      _isAuthenticated = true;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Registration failed: ${e.toString()}';
    } finally {
      setLoading(false);
    }
  }
  // Add this method to your AppProvider class:

  Future<void> resetPassword(String email) async {
    try {
      // Implement your password reset logic here
      await FirebaseService.instance.sendPasswordResetEmail(
        email,
      ); // Simulated API call
      print('Password reset email sent to: $email');
    } catch (e) {
      print('Error sending password reset email: $e');
      throw 'Failed to send password reset email. Please try again.';
    }
  }

  void logout() {
    _user = null;
    _isAuthenticated = false;
    _interviewPrepData = InterviewPrepData(
      answers: {},
      progress: 0,
      completed: false,
      completedTopics: [],
      practiceQuestions: [],
    );
    _resumeAnalysis = ResumeAnalysis(
      atsScore: 0,
      skillGaps: [],
      recommendations: [],
      strengths: [],
    );
    _bookmarkedResources.clear();
    _completedResources.clear();
    _inProgressResources.clear();
    notifyListeners();
  }

  // Interview preparation methods
  void updateInterviewAnswer(String questionId, String answer) {
    final updatedAnswers = Map<String, String>.from(_interviewPrepData.answers);
    updatedAnswers[questionId] = answer;
    _interviewPrepData = InterviewPrepData(
      answers: updatedAnswers,
      focusArea: _interviewPrepData.focusArea,
      progress: _interviewPrepData.progress,
      completed: _interviewPrepData.completed,
      completedTopics: _interviewPrepData.completedTopics,
      practiceQuestions: _interviewPrepData.practiceQuestions,
    );
    notifyListeners();
  }

  void setInterviewFocusArea(String focusArea) {
    _interviewPrepData = InterviewPrepData(
      answers: _interviewPrepData.answers,
      focusArea: focusArea,
      progress: _interviewPrepData.progress,
      completed: _interviewPrepData.completed,
      completedTopics: _interviewPrepData.completedTopics,
      practiceQuestions: _interviewPrepData.practiceQuestions,
    );
    notifyListeners();
  }

  void updateInterviewProgress(int progress) {
    _interviewPrepData = InterviewPrepData(
      answers: _interviewPrepData.answers,
      focusArea: _interviewPrepData.focusArea,
      progress: progress,
      completed: progress >= 100,
      completedTopics: _interviewPrepData.completedTopics,
      practiceQuestions: _interviewPrepData.practiceQuestions,
    );
    notifyListeners();
  }

  void completeInterviewTopic(String topic) {
    if (!_interviewPrepData.completedTopics.contains(topic)) {
      final updatedTopics = List<String>.from(
        _interviewPrepData.completedTopics,
      );
      updatedTopics.add(topic);
      _interviewPrepData = InterviewPrepData(
        answers: _interviewPrepData.answers,
        focusArea: _interviewPrepData.focusArea,
        progress: _interviewPrepData.progress,
        completed: _interviewPrepData.completed,
        completedTopics: updatedTopics,
        practiceQuestions: _interviewPrepData.practiceQuestions,
      );
      notifyListeners();
    }
  }

  void addPracticeQuestion(String question) {
    if (!_interviewPrepData.practiceQuestions.contains(question)) {
      final updatedQuestions = List<String>.from(
        _interviewPrepData.practiceQuestions,
      );
      updatedQuestions.add(question);
      _interviewPrepData = InterviewPrepData(
        answers: _interviewPrepData.answers,
        focusArea: _interviewPrepData.focusArea,
        progress: _interviewPrepData.progress,
        completed: _interviewPrepData.completed,
        completedTopics: _interviewPrepData.completedTopics,
        practiceQuestions: updatedQuestions,
      );
      notifyListeners();
    }
  }

  // Resume analysis methods
  Future<void> analyzeResume(String filePath, String targetRole) async {
    setLoading(true);
    try {
      // Mock resume analysis
      await Future.delayed(const Duration(seconds: 3));
      _resumeAnalysis = ResumeAnalysis(
        filePath: filePath,
        atsScore: 78,
        skillGaps: [
          'Machine Learning',
          'Cloud Computing (AWS)',
          'Project Management',
          'Data Visualization',
        ],
        recommendations: [
          'Add more quantified achievements',
          'Include relevant keywords for ATS',
          'Improve formatting consistency',
          'Add technical skills section',
        ],
        strengths: [
          'Strong educational background',
          'Relevant work experience',
          'Good use of action verbs',
          'Clear contact information',
        ],
      );
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Resume analysis failed: ${e.toString()}';
    } finally {
      setLoading(false);
    }
  }

  // Resource management methods
  void bookmarkResource(String resourceId) {
    if (!_bookmarkedResources.contains(resourceId)) {
      _bookmarkedResources.add(resourceId);
      notifyListeners();
    }
  }

  void unbookmarkResource(String resourceId) {
    _bookmarkedResources.remove(resourceId);
    notifyListeners();
  }

  void startResource(String resourceId) {
    if (!_inProgressResources.contains(resourceId)) {
      _inProgressResources.add(resourceId);
      notifyListeners();
    }
  }

  void completeResource(String resourceId) {
    _inProgressResources.remove(resourceId);
    if (!_completedResources.contains(resourceId)) {
      _completedResources.add(resourceId);
      notifyListeners();
    }
  }

  // Utility methods
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Onboarding methods
  void completeOnboarding() {
    _hasSeenOnboarding = true;
    notifyListeners();
  }

  // User profile methods
  String? _selectedCareerPath;
  String? _userType;
  String? _experienceLevel;

  String? get selectedCareerPath => _selectedCareerPath;
  String? get userType => _userType;
  String? get experienceLevel => _experienceLevel;

  void setCareerPath(String careerPath) {
    _selectedCareerPath = careerPath;
    notifyListeners();
  }

  void updateUserProfile({
    required String userType,
    required String careerPath,
    required String experienceLevel,
  }) {
    _userType = userType;
    _selectedCareerPath = careerPath;
    _experienceLevel = experienceLevel;
    notifyListeners();
  }
}
