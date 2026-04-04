import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_app/models/interview.dart';
import 'package:flutter_app/services/interview_service.dart';
import 'package:flutter_app/utils/app_theme.dart';
import 'package:flutter_app/screens/main_screens/home_screens/interview_report_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AvatarInterviewScreen extends StatefulWidget {
  final String category;
  final String level;
  final Interview? interview;

  const AvatarInterviewScreen({
    super.key,
    required this.category,
    required this.level,
    this.interview,
  });

  @override
  State<AvatarInterviewScreen> createState() => _AvatarInterviewScreenState();
}

class _AvatarInterviewScreenState extends State<AvatarInterviewScreen>
    with TickerProviderStateMixin {
  late AnimationController _avatarController;
  late AnimationController _waveController;
  late AnimationController _eyeBlinkController;
  late AnimationController _mouthController;
  late Animation<double> _avatarAnimation;
  late Animation<double> _waveAnimation;
  late Animation<double> _eyeBlinkAnimation;
  late Animation<double> _mouthAnimation;

  final InterviewService _interviewService = InterviewService();
  final TextEditingController _answerController = TextEditingController();

  // Enhanced Speech
  FlutterTts? _flutterTts;
  bool _isTtsInitialized = false;

  // Speech to text functionality
  final SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;
  String _spokenAnswer = '';
  bool _speechToTextAvailable = false;

  // Enhanced Interview state
  List<InterviewQuestion> _questions = [];
  int _currentQuestionIndex = 0;
  bool _isLoading = false;
  bool _isInterviewStarted = false;
  final bool _isAnswering = false;
  bool _isAvatarSpeaking = false;
  final bool _isAvatarThinking = false;
  Timer? _speakingTimer;
  Timer? _thinkingTimer;

  // Avatar personality states
  final String _avatarMood = 'friendly';
  String _currentAvatarExpression = 'neutral';

  // Speech quality metrics
  double _fluencyScore = 0.0;
  double _confidenceScore = 0.0;
  double _paceScore = 0.0;

  // Performance tracking
  final List<String> _userAnswers = [];
  final List<int> _answerTimes = [];
  DateTime? _questionStartTime;
  double _overallScore = 0.0;
  final List<String> _feedback = [];
  final List<double> _confidenceScores = [];

  // Question timing
  int _timeRemaining = 180; // 3 minutes per question
  Timer? _questionTimer;

  // Conversation context
  final List<String> _conversationHistory = [];
  final String _lastResponse = '';

  // AI Assistant functionality
  bool _isProcessing = false;
  String _aiFeedback = '';
  final String _openaiApiKey =
      'YOUR_OPENAI_API_KEY'; // This should be securely stored

  // Real-time voice assistant functionality
  bool _isConversationActive = false;
  bool _isBotListening =
      false; // Whether the bot is actively listening for user response
  bool _isBotThinking = false; // Whether the bot is thinking/processing
  bool _isBotSpeaking = false; // Whether the bot is currently speaking
  String _conversationTurn =
      'bot-speaking'; // 'bot-speaking', 'user-speaking', 'bot-thinking'

  // Audio streaming capabilities
  bool _supportsStreaming =
      false; // Will be set to true when streaming API is configured

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeTts();
    _initializeSpeech();
    _loadQuestions();
  }

  void _initializeAnimations() {
    _avatarController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _waveController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _eyeBlinkController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _mouthController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _avatarAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _avatarController, curve: Curves.easeInOut),
    );

    _waveAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
    );

    _eyeBlinkAnimation = Tween<double>(begin: 1.0, end: 0.1).animate(
      CurvedAnimation(parent: _eyeBlinkController, curve: Curves.easeInOut),
    );

    _mouthAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mouthController, curve: Curves.easeInOut),
    );

    _avatarController.repeat(reverse: true);
    _startRandomBlinking();
  }

  void _startRandomBlinking() {
    Timer.periodic(Duration(seconds: 3 + Random().nextInt(5)), (timer) {
      if (mounted) {
        _eyeBlinkController.forward().then((_) {
          _eyeBlinkController.reverse();
        });
      }
    });
  }

  Future<void> _initializeTts() async {
    try {
      _flutterTts = FlutterTts();
      await _flutterTts!.setLanguage('en-US');
      await _flutterTts!.setSpeechRate(0.6);
      await _flutterTts!.setVolume(0.9);
      await _flutterTts!.setPitch(1.0);

      _flutterTts!.setCompletionHandler(() {
        setState(() {
          _isAvatarSpeaking = false;
          _currentAvatarExpression = 'neutral';
        });
        _mouthController.reset();
      });

      setState(() {
        _isTtsInitialized = true;
      });
      print('TTS initialized successfully');
    } catch (e) {
      print('Error initializing TTS: $e');
      setState(() {
        _isTtsInitialized = false;
      });
    }
  }

  Future<void> _initializeSpeech() async {
    try {
      bool available = await _speechToText.initialize();
      setState(() {
        _speechToTextAvailable = available;
      });
      print('Speech recognition initialized: \$available');
    } catch (e) {
      print('Error initializing speech recognition: \$e');
      setState(() {
        _speechToTextAvailable = false;
      });
    }
  }

  Future<void> _loadQuestions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _questions = await _interviewService.generateInterviewQuestions(
        category: widget.category,
        level: widget.level,
        topics: ['General'],
        careerPath: widget.category,
        questionCount: 5,
      );

      if (_questions.isNotEmpty) {
        print('Loaded ${_questions.length} questions');
      } else {
        // Fallback questions
        _questions = [
          InterviewQuestion(
            id: '1',
            question: 'Tell me about yourself and your background.',
            type: widget.category,
            difficulty: widget.level,
          ),
          InterviewQuestion(
            id: '2',
            question: 'What interests you most about this field?',
            type: widget.category,
            difficulty: widget.level,
          ),
        ];
      }
    } catch (e) {
      print('Error loading questions: $e');
      // Use fallback questions
      _questions = [
        InterviewQuestion(
          id: '1',
          question: 'Tell me about yourself and your background.',
          type: widget.category,
          difficulty: widget.level,
        ),
      ];
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _toggleListening() async {
    if (!_speechToTextAvailable) return;

    if (_isListening) {
      await _speechToText.stop();
      setState(() {
        _isListening = false;
      });

      // Auto-submit if we have a spoken answer
      if (_spokenAnswer.isNotEmpty) {
        _processAnswer(_spokenAnswer);
      }
    } else {
      bool started = await _speechToText.listen(
        onResult: (result) {
          setState(() {
            _answerController.text = result.recognizedWords;
            _spokenAnswer = result.recognizedWords;

            // Update UI when in conversation mode
            if (_isConversationActive && _isBotListening) {
              // The user is speaking, we'll submit when they stop
            }
          });
        },
        listenMode: ListenMode.confirmation,
        cancelOnError: true,
        partialResults: true,
      );

      if (started) {
        setState(() {
          _isListening = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _avatarController.dispose();
    _waveController.dispose();
    _eyeBlinkController.dispose();
    _mouthController.dispose();
    _speakingTimer?.cancel();
    _questionTimer?.cancel();
    _thinkingTimer?.cancel();
    _answerController.dispose();
    _flutterTts?.stop();
    _speechToText.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('${widget.category} Interview'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          if (_isInterviewStarted)
            IconButton(
              onPressed: _showExitDialog,
              icon: const Icon(Icons.close),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildInterviewContent(),
    );
  }

  Widget _buildInterviewContent() {
    if (!_isInterviewStarted) {
      return _buildWelcomeScreen();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildAvatarSection(),
          const SizedBox(height: 24),
          _buildQuestionSection(),
          const SizedBox(height: 24),
          _buildAnswerSection(),
          const SizedBox(height: 24),
          _buildProgressSection(),
        ],
      ),
    );
  }

  Widget _buildWelcomeScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildAvatarSection(),
          const SizedBox(height: 40),
          Text(
            'Welcome to your AI Interview!',
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            'I\'m your AI interviewer. I\'ll ask you ${_questions.length} questions about ${widget.category}.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _startInterview,
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start Interview'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarSection() {
    return AnimatedBuilder(
      animation: _avatarAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _avatarAnimation.value,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Face
                Icon(Icons.face, size: 60, color: Colors.white),
                // Speaking waves
                if (_isAvatarSpeaking)
                  AnimatedBuilder(
                    animation: _waveAnimation,
                    builder: (context, child) {
                      return CustomPaint(
                        size: const Size(140, 140),
                        painter: WavesPainter(
                          waveAnimation: _waveAnimation.value,
                          color: AppColors.primary,
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuestionSection() {
    if (_currentQuestionIndex >= _questions.length) {
      return Container();
    }

    final question = _questions[_currentQuestionIndex];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.help_outline, color: AppColors.primary, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'Question \${_currentQuestionIndex + 1} of \${_questions.length}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _timeRemaining < 30 ? Colors.red : Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Time: \${_formatTime(_timeRemaining)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            question.question,
            style: const TextStyle(fontSize: 18, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Answer:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _answerController,
            maxLines: 6,
            readOnly:
                _isProcessing ||
                _isBotThinking, // Disable input when AI is processing or thinking
            decoration: InputDecoration(
              hintText: 'Type or speak your answer here...',
              border: const OutlineInputBorder(),
              suffixIcon: _isBotThinking
                  ? const CircularProgressIndicator(strokeWidth: 2)
                  : _isBotListening
                  ? IconButton(
                      icon: Icon(Icons.mic, color: Colors.red),
                      onPressed: _speechToTextAvailable
                          ? _toggleListening
                          : null,
                    )
                  : IconButton(
                      icon: Icon(Icons.mic_none, color: Colors.grey),
                      onPressed: _speechToTextAvailable
                          ? _toggleListening
                          : null,
                    ),
            ),
          ),
          const SizedBox(height: 16),
          if (_aiFeedback.isNotEmpty && !_isBotThinking)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.psychology, color: AppColors.primary, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _aiFeedback,
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
            ),
          if (_isBotThinking)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'AI Coach is thinking...',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          if (!_isBotThinking && (_fluencyScore > 0 || _confidenceScore > 0))
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Speech Quality Metrics:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildMetricBar('Fluency', _fluencyScore),
                  const SizedBox(height: 4),
                  _buildMetricBar('Confidence', _confidenceScore),
                  const SizedBox(height: 4),
                  _buildMetricBar('Pace', _paceScore),
                ],
              ),
            ),
          if (_isConversationActive)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _isBotListening ? Colors.green : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isBotListening
                        ? 'AI is listening... Speak now!'
                        : _isBotThinking
                        ? 'AI is thinking...'
                        : _isBotSpeaking
                        ? 'AI is speaking...'
                        : 'Ready for conversation',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          Row(
            children: [
              if (!_isConversationActive)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _startConversation,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start Conversation'),
                  ),
                ),
              if (_isConversationActive)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _endConversation,
                    icon: const Icon(Icons.stop),
                    label: const Text('End Conversation'),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    final progress = (_currentQuestionIndex + 1) / _questions.length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Progress:'),
              Text('${(_currentQuestionIndex)} / ${_questions.length}'),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ],
      ),
    );
  }

  void _startInterview() {
    setState(() {
      _isInterviewStarted = true;
      _currentQuestionIndex = 0;
      _timeRemaining = 180; // Set initial time
    });
    _startQuestionTimer();

    // Speak the first question
    final firstQuestion = _questions[_currentQuestionIndex];
    _speakMessage(
      'Perfect! Let\'s begin our interview. Here\'s your first question: \${firstQuestion.question}',
    );
  }

  void _submitAnswer() {
    final answer = _answerController.text.trim();
    if (answer.isEmpty) {
      // If no text answer but we have a spoken answer, use that
      if (_spokenAnswer.isNotEmpty) {
        _processAnswer(_spokenAnswer);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please provide an answer')),
        );
      }
      return;
    }

    _processAnswer(answer);
  }

  void _startConversation() {
    setState(() {
      _isConversationActive = true;
      _conversationTurn = 'bot-speaking';
    });

    // Start the conversation by having the bot ask the first question
    final firstQuestion = _questions[_currentQuestionIndex];
    _speakMessage(
      'Hello! I am your AI interview coach. Let me ask you the first question: \${firstQuestion.question}',
    );

    // Set a timer to transition to listening mode after the bot finishes speaking
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _conversationTurn = 'user-speaking';
          _isBotListening = true;
          _isBotSpeaking = false;
        });

        // Start listening for user response
        if (_speechToTextAvailable && !_isListening) {
          _toggleListening();
        }
      }
    });
  }

  void _endConversation() {
    setState(() {
      _isConversationActive = false;
      _isBotListening = false;
      _isBotThinking = false;
      _isBotSpeaking = false;
      _conversationTurn = 'bot-speaking';
    });

    // Stop any ongoing speech recognition
    if (_isListening) {
      _toggleListening();
    }

    _speakMessage('Thank you for the conversation! Your interview has ended.');
  }

  void _processAnswer(String answer) {
    _userAnswers.add(answer);
    _answerController.clear();

    // Stop the question timer
    _questionTimer?.cancel();

    // Get the current question for AI analysis
    final currentQuestion = _questions[_currentQuestionIndex];

    // Analyze the user's answer and provide feedback
    _analyzeAndRespond(answer, currentQuestion.question);

    // In real-time conversation mode, don't automatically advance to next question
    if (_isConversationActive) {
      // Wait for AI feedback before transitioning to bot thinking mode
      Timer(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isBotListening = false;
            _isBotThinking = true;
            _conversationTurn = 'bot-thinking';
          });

          // After thinking, the bot will speak again
          Timer(const Duration(seconds: 2), () {
            if (mounted) {
              setState(() {
                _isBotThinking = false;
                _isBotSpeaking = true;
                _conversationTurn = 'bot-speaking';
              });

              // Ask a follow-up question or continue the conversation
              if (_currentQuestionIndex < _questions.length - 1) {
                // Move to next question
                setState(() {
                  _currentQuestionIndex++;
                });

                final nextQuestion = _questions[_currentQuestionIndex];
                _speakMessage(
                  'Thanks for your answer. Now, let me ask you another question: \${nextQuestion.question}',
                );
              } else {
                // End of interview
                _speakMessage(
                  'Great conversation! That concludes our interview. Let me prepare your results.',
                );

                // End the conversation after a short delay
                Timer(const Duration(seconds: 2), () {
                  if (mounted) {
                    _finishInterview();
                  }
                });
              }
            }
          });
        }
      });
    } else {
      // Traditional interview flow
      if (_currentQuestionIndex < _questions.length - 1) {
        // Wait for AI feedback before moving to next question
        Timer(const Duration(seconds: 4), () {
          if (mounted) {
            setState(() {
              _currentQuestionIndex++;
              _timeRemaining = 180; // Reset timer for next question
            });
            _startQuestionTimer();

            // Speak the next question
            final nextQuestion = _questions[_currentQuestionIndex];
            _speakMessage(
              'Here\'s your next question: \${nextQuestion.question}',
            );
          }
        });
      } else {
        // Wait for AI feedback before finishing interview
        Timer(const Duration(seconds: 4), () {
          if (mounted) {
            _finishInterview();
          }
        });
      }
    }
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String formattedMinutes = minutes.toString().padLeft(2, '0');
    String formattedSeconds = remainingSeconds.toString().padLeft(2, '0');
    return '\$formattedMinutes:\$formattedSeconds';
  }

  void _startQuestionTimer() {
    _questionTimer?.cancel(); // Cancel any existing timer
    _timeRemaining = 180; // 3 minutes per question

    _questionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining > 0) {
        setState(() {
          _timeRemaining--;
        });

        // Alert user when time is running low
        if (_timeRemaining == 30) {
          _speakMessage('You have 30 seconds remaining for this question.');
        } else if (_timeRemaining == 0) {
          _submitAnswer(); // Automatically submit when time runs out
        }
      } else {
        timer.cancel();
      }
    });
  }

  void _finishInterview() {
    _calculateOverallScore();
    _speakMessage(
      'Congratulations! You\'ve completed the interview. Let me prepare your results.',
    );

    // Give some time for the final AI feedback to be processed if needed
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        _viewResults();
      }
    });
  }

  void _speakMessage(String message) {
    if (_isTtsInitialized && _flutterTts != null) {
      setState(() {
        _isAvatarSpeaking = true;
        _currentAvatarExpression = 'speaking';
      });
      _waveController.repeat();
      _mouthController.repeat(reverse: true);

      _flutterTts!.setCompletionHandler(() {
        if (mounted) {
          setState(() {
            _isAvatarSpeaking = false;
            _currentAvatarExpression = 'neutral';
          });
          _waveController.stop();
          _mouthController.stop();
        }
      });

      _flutterTts!.speak(message);
    }
  }

  void _calculateOverallScore() {
    double totalScore = 0;
    int validAnswers = 0;

    for (int i = 0; i < _userAnswers.length; i++) {
      if (_userAnswers[i].isNotEmpty) {
        double lengthScore = (_userAnswers[i].length / 250).clamp(0, 1) * 30;
        double timeScore = 25; // Default time score
        double confidenceScore = 25; // Default confidence score

        double questionScore = lengthScore + timeScore + confidenceScore;
        totalScore += questionScore;
        validAnswers++;
      }
    }

    _overallScore = validAnswers > 0 ? totalScore / validAnswers : 0;
    _overallScore = _overallScore.clamp(0, 100);
  }

  void _viewResults() {
    final completedInterview = Interview(
      id: 'interview_${DateTime.now().millisecondsSinceEpoch}',
      title: '${widget.category} Interview - ${widget.level}',
      type: 'ai',
      category: widget.category,
      level: widget.level,
      description: 'AI-powered interview session',
      duration: 30, // Default duration
      topics: widget.interview?.topics ?? ['General'],
      skills: widget.interview?.skills ?? ['Communication'],
      status: InterviewStatus.completed,
      score: _overallScore,
      feedback: 'Great job completing the interview!',
      questions: _questions,
      isRecorded: false,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => InterviewReportScreen(
          interview: completedInterview,
          userAnswers: _userAnswers,
          answerTimes: const [],
          detailedFeedback: const ['Great responses overall!'],
        ),
      ),
    );
  }

  // Method to analyze user response using AI and provide feedback
  Future<void> _analyzeAndRespond(String userAnswer, String question) async {
    // Update conversation state based on whether we're in active conversation mode
    setState(() {
      if (_isConversationActive) {
        _isBotThinking = true;
        _conversationTurn = 'bot-thinking';
      } else {
        _isProcessing = true;
      }
      _aiFeedback = 'Analyzing your response...';
    });

    // Analyze speech quality
    _analyzeSpeechQuality(userAnswer);

    try {
      // Prepare the conversation history for context
      String conversationContext = _conversationHistory.join('\n');

      // Create a prompt for the AI to analyze the response and provide feedback
      String prompt =
          '''
      You are an AI interview coach providing real-time feedback. Analyze this response to the question: "$question"
        
      User's answer: "$userAnswer"
        
      Previous conversation: "$conversationContext"
        
      Evaluate the response based on:
      - Content relevance to the question
      - Clarity and organization
      - Confidence level
      - Communication skills
        
      Provide brief, encouraging feedback focusing on:
      1. Strengths in their response
      2. Areas for improvement
      3. Suggestions for better answers
      4. Ask a follow-up question related to their answer if appropriate
        
      Keep your response under 30 seconds when spoken aloud. Be supportive and constructive.
      ''';

      // Make API call to OpenAI
      var response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer \$_openaiApiKey',
        },
        body: json.encode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are an AI interview coach providing helpful, encouraging feedback to candidates. Be supportive and constructive, focusing on communication skills, content, and delivery.',
            },
            {'role': 'user', 'content': prompt},
          ],
          'max_tokens': 200,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        String aiResponse = jsonResponse['choices'][0]['message']['content'];

        setState(() {
          _aiFeedback = aiResponse;
          _conversationHistory.add('Question: $question');
          _conversationHistory.add('User Response: $userAnswer');
          _conversationHistory.add('AI Feedback: $aiResponse');

          // Limit conversation history to last 10 exchanges to prevent it from growing too large
          if (_conversationHistory.length > 20) {
            _conversationHistory.removeRange(
              0,
              _conversationHistory.length - 20,
            );
          }
        });

        // Speak the AI feedback
        _speakMessage(aiResponse);
      } else {
        setState(() {
          _aiFeedback =
              'I had trouble processing your response, but it was good. Let\'s continue.';
        });
        _speakMessage(
          'I had trouble processing your response, but it was good. Let\'s continue.',
        );
      }
    } catch (e) {
      print('Error analyzing response: \$e');
      setState(() {
        _aiFeedback =
            'Thank you for your response. Let\'s move to the next question.';
      });
      _speakMessage(
        'Thank you for your response. Let\'s move to the next question.',
      );

      // Continue with interview flow
      if (_currentQuestionIndex < _questions.length - 1) {
        Timer(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _currentQuestionIndex++;
              _timeRemaining = 180; // Reset timer for next question
            });
            _startQuestionTimer();

            // Speak the next question
            final nextQuestion = _questions[_currentQuestionIndex];
            _speakMessage(
              'Here\'s your next question: \${nextQuestion.question}',
            );
          }
        });
      }
    } finally {
      setState(() {
        if (_isConversationActive) {
          _isBotThinking = false;
        } else {
          _isProcessing = false;
        }
      });
    }
  }

  // Method to analyze speech quality
  void _analyzeSpeechQuality(String answer) {
    // Calculate fluency based on answer length and complexity
    double lengthScore = (answer.length / 100).clamp(
      0.0,
      1.0,
    ); // Normalize to 0-1

    // Count pauses or filler words ("um", "uh", "like")
    int pauseCount = 0;
    List<String> fillers = [
      ' um ',
      ' uh ',
      ' like ',
      ' er ',
      ' erm ',
      ' basically ',
      ' literally ',
      ' actually ',
    ];
    for (String filler in fillers) {
      pauseCount += (answer.toLowerCase().split(filler).length - 1);
    }

    // Calculate fluency score (less pauses = higher score)
    double pausePenalty = (pauseCount * 0.1).clamp(0.0, 0.5);
    double calculatedFluency = (lengthScore - pausePenalty).clamp(0.0, 1.0);

    // Calculate confidence based on positive language
    List<String> confidentWords = [
      'definitely',
      'absolutely',
      'clearly',
      'certainly',
      'confidently',
      'without doubt',
      'strongly',
      'believe',
      'know',
      'understand',
    ];
    int confidentWordCount = 0;
    String lowerAnswer = answer.toLowerCase();
    for (String word in confidentWords) {
      confidentWordCount += (lowerAnswer.split(word).length - 1);
    }

    double calculatedConfidence = (confidentWordCount * 0.1 + 0.5).clamp(
      0.0,
      1.0,
    );

    // Calculate pace based on answer length and assumed time
    // Assuming a normal speaking rate of ~150 words per minute (2.5 words per second)
    int wordCount = answer.split(' ').length;
    double expectedTime = wordCount / 2.5;

    // We don't have actual time, so we'll base pace on word count density
    double calculatedPace = (wordCount > 0 && wordCount < 150)
        ? 0.8
        : (wordCount < 300)
        ? 0.9
        : 0.7;

    setState(() {
      _fluencyScore = calculatedFluency * 100;
      _confidenceScore = calculatedConfidence * 100;
      _paceScore = calculatedPace * 100;

      // Update avatar expression based on scores
      if (_confidenceScore > 70) {
        _currentAvatarExpression = 'impressed';
      } else if (_fluencyScore > 60) {
        _currentAvatarExpression = 'encouraging';
      } else {
        _currentAvatarExpression = 'supportive';
      }
    });
  }

  Widget _buildMetricBar(String label, double score) {
    Color barColor;
    if (score >= 70) {
      barColor = Colors.green;
    } else if (score >= 50) {
      barColor = Colors.orange;
    } else {
      barColor = Colors.red;
    }

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(label, style: const TextStyle(fontSize: 12)),
        ),
        Expanded(
          flex: 3,
          child: LinearProgressIndicator(
            value: score / 100,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            '${score.round()}%',
            style: TextStyle(fontSize: 12, color: barColor),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Interview'),
        content: const Text(
          'Are you sure you want to exit? Your progress will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }
}

// Custom painter for speaking wave animation
class WavesPainter extends CustomPainter {
  final double waveAnimation;
  final Color color;

  WavesPainter({required this.waveAnimation, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw multiple concentric circles with animated radius
    for (int i = 0; i < 3; i++) {
      final animatedRadius = radius * (0.5 + (waveAnimation + i * 0.3) % 1.0);
      final opacity = (1.0 - (waveAnimation + i * 0.3) % 1.0);

      paint.color = color.withOpacity(opacity * 0.6);
      canvas.drawCircle(center, animatedRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
