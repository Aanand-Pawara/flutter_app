import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_app/providers/app_provider.dart';

class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({super.key});

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  int _currentStep = 0;
  String? _selectedCareerPath;
  int _currentQuestion = 0;
  final PageController _pageController = PageController();

  final List<CareerPath> _careerPaths = [
    CareerPath('10th', '10th Standard', Icons.school, const Color(0xFF3B82F6)),
    CareerPath('12th', '12th Standard', Icons.school_outlined, const Color(0xFF10B981)),
    CareerPath('neet', 'NEET Preparation', Icons.medical_services, const Color(0xFFEF4444)),
    CareerPath('jee', 'JEE Preparation', Icons.calculate, const Color(0xFFF97316)),
    CareerPath('govt', 'Government Jobs', Icons.account_balance, const Color(0xFF8B5CF6)),
    CareerPath('ssc', 'SSC Preparation', Icons.assignment, const Color(0xFF14B8A6)),
    CareerPath('professional', 'Working Professional', Icons.work, Colors.indigo),
  ];

  final List<AssessmentQuestion> _questions = [
    AssessmentQuestion(
      'What type of activities do you enjoy most?',
      [
        'Working with people and helping them',
        'Analyzing data and solving problems',
        'Creating and designing things',
        'Leading teams and making decisions'
      ],
    ),
    AssessmentQuestion(
      'Which work environment appeals to you?',
      [
        'Office setting with regular hours',
        'Dynamic environment with travel',
        'Remote work with flexibility',
        'Hands-on workshop or lab'
      ],
    ),
    AssessmentQuestion(
      'What motivates you most in your career?',
      [
        'Making a positive impact on society',
        'Financial stability and growth',
        'Personal recognition and achievement',
        'Learning and skill development'
      ],
    ),
    AssessmentQuestion(
      'How do you prefer to learn new skills?',
      [
        'Structured courses and certifications',
        'Hands-on practice and experimentation',
        'Reading and self-study',
        'Mentorship and guidance'
      ],
    ),
    AssessmentQuestion(
      'What\'s your ideal work-life balance?',
      [
        'Clear separation between work and personal time',
        'Flexible hours based on project needs',
        'Work that feels like a passion',
        'Standard 9-5 with weekends off'
      ],
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _selectCareerPath(String pathId) {
    setState(() {
      _selectedCareerPath = pathId;
      _currentStep = 1;
    });
    Provider.of<AppProvider>(context, listen: false).setCareerPath(pathId);
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _answerQuestion(String answer) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.updateAssessmentAnswer(_currentQuestion.toString(), answer);
    
    if (_currentQuestion < _questions.length - 1) {
      setState(() {
        _currentQuestion++;
      });
      appProvider.updateAssessmentProgress(
        ((_currentQuestion + 1) / _questions.length * 100).round(),
      );
    } else {
      _completeAssessment();
    }
  }

  void _completeAssessment() {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.updateAssessmentProgress(100);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Assessment completed successfully!'),
        backgroundColor: const Color(0xFF10B981),
      ),
    );
    
    context.go('/dashboard');
  }

  void _skipQuestion() {
    if (_currentQuestion < _questions.length - 1) {
      setState(() {
        _currentQuestion++;
      });
    } else {
      _completeAssessment();
    }
  }

  void _previousQuestion() {
    if (_currentQuestion > 0) {
      setState(() {
        _currentQuestion--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Career Assessment'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_currentStep == 0) {
              context.go('/login');
            } else {
              setState(() {
                _currentStep = 0;
                _currentQuestion = 0;
              });
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildCareerPathSelection(),
          _buildQuestionnaireSection(),
        ],
      ),
    );
  }

  Widget _buildCareerPathSelection() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose Your Career Path',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select the path that best describes your current situation or goals',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemCount: _careerPaths.length,
              itemBuilder: (context, index) {
                final path = _careerPaths[index];
                return Card(
                  child: InkWell(
                    onTap: () => _selectCareerPath(path.id),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(26, careerPath.color.red, careerPath.color.green, careerPath.color.blue),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              careerPath.icon,
                              size: 32,
                              color: careerPath.color,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            careerPath.label,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionnaireSection() {
    final progress = (_currentQuestion + 1) / _questions.length;
    final currentQ = _questions[_currentQuestion];
    final selectedPath = _careerPaths.firstWhere((p) => p.id == _selectedCareerPath);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Question ${_currentQuestion + 1} of ${_questions.length}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                selectedPath.label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Progress Bar
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
            minHeight: 8,
          ),
          const SizedBox(height: 32),

          // Question Card
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentQ.question,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Expanded(
                      child: Consumer<AppProvider>(
                        builder: (context, appProvider, child) {
                          final selectedAnswer = appProvider.assessmentData.answers[_currentQuestion.toString()];
                          
                          return ListView.separated(
                            itemCount: currentQ.options.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final option = currentQ.options[index];
                              final isSelected = selectedAnswer == option;
                              
                              return Card(
                                elevation: isSelected ? 4 : 1,
                                color: _selectedCareerPath == selectedPath.id ? const Color(0x1A2563EB) : Colors.transparent,
                                child: InkWell(
                                  onTap: () => _answerQuestion(option),
                                  borderRadius: BorderRadius.circular(16),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        Radio<String>(
                                          value: option,
                                          groupValue: selectedAnswer,
                                          onChanged: (value) => _answerQuestion(value!),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            option,
                                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                              fontWeight: isSelected ? FontWeight.w600 : null,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Navigation Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton.icon(
                onPressed: _currentQuestion > 0 ? _previousQuestion : null,
                icon: const Icon(Icons.arrow_back),
                label: const Text('Previous'),
              ),
              TextButton(
                onPressed: _skipQuestion,
                child: const Text('Skip'),
              ),
              Consumer<AppProvider>(
                builder: (context, appProvider, child) {
                  final hasAnswer = appProvider.assessmentData.answers.containsKey(_currentQuestion.toString());
                  
                  return ElevatedButton.icon(
                    onPressed: hasAnswer ? () {
                      if (_currentQuestion < _questions.length - 1) {
                        setState(() {
                          _currentQuestion++;
                        });
                      } else {
                        _completeAssessment();
                      }
                    } : null,
                    icon: Icon(_currentQuestion == _questions.length - 1 ? Icons.check : Icons.arrow_forward),
                    label: Text(_currentQuestion == _questions.length - 1 ? 'Complete' : 'Next'),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CareerPath {
  final String id;
  final String label;
  final IconData icon;
  final Color color;

  CareerPath(this.id, this.label, this.icon, this.color);
}

class AssessmentQuestion {
  final String question;
  final List<String> options;

  AssessmentQuestion(this.question, this.options);
}
