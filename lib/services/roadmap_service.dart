import 'package:flutter_app/models/roadmap.dart';
import 'package:flutter_app/services/api_service.dart';
import 'package:flutter_app/services/open_source_roadmap_service.dart';
import 'package:flutter_app/services/enhanced_roadmap_service.dart';

class RoadmapService {
  static final RoadmapService _instance = RoadmapService._internal();
  factory RoadmapService() => _instance;
  RoadmapService._internal();

  final ApiService _apiService = ApiService();
  final OpenSourceRoadmapService _openSourceService =
      OpenSourceRoadmapService();
  final EnhancedRoadmapService _enhancedService = EnhancedRoadmapService();
  final Map<String, Roadmap> _cachedRoadmaps = {};
  final Map<String, RoadmapProgress> _userProgress = {};

  /// Gets a personalized roadmap for the user's career path with duration-specific structure
  Future<Roadmap> getRoadmapForCareerPath({
    required String careerPath,
    String? userId,
    String? currentLevel,
    List<String>? existingSkills,
    String? preferredLearningStyle,
    int? timeCommitment,
    int? durationMonths,
  }) async {
    // Check cache first
    final cacheKey =
        '${careerPath}_${currentLevel ?? 'beginner'}_${durationMonths ?? 12}';
    if (_cachedRoadmaps.containsKey(cacheKey)) {
      return _cachedRoadmaps[cacheKey]!;
    }

    try {
      // First try the enhanced roadmap service for comprehensive structure
      print('🚀 Generating enhanced comprehensive roadmap for $careerPath');
      final enhancedRoadmap = await _enhancedService
          .generateComprehensiveRoadmap(
            careerPath: careerPath,
            durationMonths: durationMonths ?? 12,
            currentLevel: currentLevel,
            existingSkills: existingSkills,
            timeCommitment: timeCommitment,
          );

      // Cache the enhanced roadmap
      _cachedRoadmaps[cacheKey] = enhancedRoadmap;
      print(
        '✅ Successfully generated enhanced comprehensive roadmap for $careerPath',
      );
      return enhancedRoadmap;
    } catch (enhancedError) {
      print('⚠️ Enhanced service failed for $careerPath: $enhancedError');

      // Fallback to open source APIs
      try {
        print('🌐 Fetching roadmap from open source APIs for $careerPath');
        final openSourceRoadmap = await _openSourceService.getOpenSourceRoadmap(
          careerPath,
          durationMonths ?? 12,
        );

        // Cache the roadmap
        _cachedRoadmaps[cacheKey] = openSourceRoadmap;
        print('✅ Successfully generated open source roadmap for $careerPath');
        return openSourceRoadmap;
      } catch (e) {
        print(
          '⚠️ Open source API failed for $careerPath, trying API fallback: $e',
        );

        // Fallback to API service if open source fails
        try {
          print('🔄 Trying API service fallback for $careerPath');
          final roadmap = durationMonths != null
              ? await _generateDurationSpecificRoadmap(
                  careerPath: careerPath,
                  durationMonths: durationMonths,
                  currentLevel: currentLevel,
                  existingSkills: existingSkills,
                  timeCommitment: timeCommitment,
                )
              : await _apiService.generateCareerRoadmap(
                  careerPath: careerPath,
                  currentLevel: currentLevel,
                  existingSkills: existingSkills,
                  preferredLearningStyle: preferredLearningStyle,
                  timeCommitment: timeCommitment,
                );

          // Cache the roadmap
          _cachedRoadmaps[cacheKey] = roadmap;
          print('✅ Successfully generated API service roadmap for $careerPath');
          return roadmap;
        } catch (apiError) {
          print('❌ API service also failed for $careerPath: $apiError');
          // Final fallback to local generation
          print('🔧 Using local fallback generation for $careerPath');
          final fallbackRoadmap = _generateFallbackRoadmap(
            careerPath,
            durationMonths ?? 12,
          );
          _cachedRoadmaps[cacheKey] = fallbackRoadmap;
          return fallbackRoadmap;
        }
      }
    }
  }

  /// Updates user's progress on a roadmap
  Future<RoadmapProgress> updateProgress({
    required String userId,
    required String roadmapId,
    required String phaseId,
    required String milestoneId,
    required bool isCompleted,
  }) async {
    try {
      final progress = await _apiService.updateRoadmapProgress(
        userId: userId,
        roadmapId: roadmapId,
        phaseId: phaseId,
        milestoneId: milestoneId,
        isCompleted: isCompleted,
      );

      // Cache the progress
      _userProgress['${userId}_$roadmapId'] = progress;
      return progress;
    } catch (e) {
      throw Exception('Failed to update progress: $e');
    }
  }

  /// Gets user's current progress on a roadmap
  Future<RoadmapProgress?> getUserProgress(
    String userId,
    String roadmapId,
  ) async {
    // Check cache first
    final cacheKey = '${userId}_$roadmapId';
    if (_userProgress.containsKey(cacheKey)) {
      return _userProgress[cacheKey];
    }

    try {
      final progress = await _apiService.getRoadmapProgress(userId, roadmapId);
      if (progress != null) {
        _userProgress[cacheKey] = progress;
      }
      return progress;
    } catch (e) {
      print('Failed to get user progress: $e');
      return null;
    }
  }

  /// Starts a roadmap for a user
  Future<RoadmapProgress> startRoadmap(String userId, String roadmapId) async {
    try {
      final progress = RoadmapProgress(
        userId: userId,
        roadmapId: roadmapId,
        completionPercentage: 0.0,
        completedPhases: [],
        completedMilestones: [],
        totalPoints: 0,
        startedAt: DateTime.now(),
        lastUpdated: DateTime.now(),
      );

      _userProgress['${userId}_$roadmapId'] = progress;
      return progress;
    } catch (e) {
      throw Exception('Failed to start roadmap: $e');
    }
  }

  /// Gets recommended next steps for user
  List<RoadmapMilestone> getNextSteps(
    Roadmap roadmap,
    RoadmapProgress? progress,
  ) {
    if (progress == null || progress.completedPhases.isEmpty) {
      // Return first phase milestones
      return roadmap.phases.isNotEmpty ? roadmap.phases.first.milestones : [];
    }

    // Find next incomplete phase
    for (final phase in roadmap.phases) {
      if (!progress.completedPhases.contains(phase.id)) {
        // Return uncompleted milestones from this phase
        return phase.milestones
            .where(
              (milestone) =>
                  !progress.completedMilestones.contains(milestone.id),
            )
            .toList();
      }
    }

    return []; // All phases completed
  }

  /// Gets roadmap statistics
  Map<String, dynamic> getRoadmapStats(
    Roadmap roadmap,
    RoadmapProgress? progress,
  ) {
    final totalPhases = roadmap.phases.length;
    final totalMilestones = roadmap.phases
        .expand((phase) => phase.milestones)
        .length;
    final totalPoints = roadmap.phases
        .expand((phase) => phase.milestones)
        .map((milestone) => milestone.points)
        .fold(0, (sum, points) => sum + points);

    final completedPhases = progress?.completedPhases.length ?? 0;
    final completedMilestones = progress?.completedMilestones.length ?? 0;
    final earnedPoints = progress?.totalPoints ?? 0;

    return {
      'totalPhases': totalPhases,
      'completedPhases': completedPhases,
      'totalMilestones': totalMilestones,
      'completedMilestones': completedMilestones,
      'totalPoints': totalPoints,
      'earnedPoints': earnedPoints,
      'completionPercentage': progress?.completionPercentage ?? 0.0,
      'estimatedTimeRemaining': _calculateTimeRemaining(roadmap, progress),
    };
  }

  int _calculateTimeRemaining(Roadmap roadmap, RoadmapProgress? progress) {
    if (progress == null) return roadmap.estimatedDuration;

    final completionRate = progress.completionPercentage / 100;
    final remainingWork = 1.0 - completionRate;
    return (roadmap.estimatedDuration * remainingWork).round();
  }

  /// Clears cache
  void clearCache() {
    _cachedRoadmaps.clear();
    _userProgress.clear();
  }

  /// Gets all available career paths with roadmaps
  List<String> getAvailableCareerPaths() {
    return [
      '10th',
      '12th',
      'neet',
      'jee',
      'govt',
      'ssc',
      'professional',
      'technology',
    ];
  }

  /// Generates a duration-specific roadmap structure
  Future<Roadmap> _generateDurationSpecificRoadmap({
    required String careerPath,
    required int durationMonths,
    String? currentLevel,
    List<String>? existingSkills,
    int? timeCommitment,
  }) async {
    // This would typically call an AI service, but for now we'll generate structured content
    return _generateFallbackRoadmap(careerPath, durationMonths);
  }

  /// Generates a fallback roadmap with proper structure based on duration
  Roadmap _generateFallbackRoadmap(String careerPath, int durationMonths) {
    final now = DateTime.now();
    final roadmapData = _getRoadmapDataForPath(careerPath);

    // Adjust phases based on duration
    final phases = _generatePhasesForDuration(
      careerPath,
      durationMonths,
      roadmapData,
    );

    return Roadmap(
      id: 'roadmap_${careerPath}_${durationMonths}m_${now.millisecondsSinceEpoch}',
      careerPath: careerPath,
      title: '${roadmapData['title']} - $durationMonths Month Path',
      description: roadmapData['description'],
      estimatedDuration: durationMonths,
      difficultyLevel: _getDifficultyForDuration(durationMonths),
      phases: phases,
      prerequisites: roadmapData['prerequisites'],
      outcomes: roadmapData['outcomes'],
      certifications: roadmapData['certifications'],
      averageSalary: roadmapData['averageSalary'],
      jobOutlook: roadmapData['jobOutlook'],
      createdAt: now,
      updatedAt: now,
    );
  }

  Map<String, dynamic> _getRoadmapDataForPath(String careerPath) {
    switch (careerPath) {
      case '10th':
        return {
          'title': '10th Standard Complete Curriculum',
          'description':
              'Comprehensive 10th grade syllabus covering all major subjects with exam preparation strategies.',
          'prerequisites': [
            '9th grade completion',
            'Basic study habits',
            'Regular attendance',
          ],
          'outcomes': [
            'Complete 10th board exam preparation',
            'Strong foundation in Mathematics and Science',
            'English language proficiency',
            'Social Science understanding',
            'Stream selection readiness for 11th',
            'Study skills and time management',
          ],
          'certifications': [
            '10th Board Certificate',
            'Subject-wise competency',
          ],
          'averageSalary': 0.0,
          'jobOutlook': 'Foundation for higher education',
        };
      case '12th':
        return {
          'title': '12th Standard Complete Curriculum',
          'description':
              'Advanced 12th grade syllabus with specialization in chosen stream and college preparation.',
          'prerequisites': [
            '10th grade completion',
            'Stream selection',
            'Advanced study skills',
          ],
          'outcomes': [
            'Board exam excellence',
            'College entrance exam readiness',
            'Specialized subject mastery',
            'Career pathway clarity',
            'Critical thinking skills',
            'Research and analysis abilities',
          ],
          'certifications': ['12th Board Certificate', 'Stream specialization'],
          'averageSalary': 0.0,
          'jobOutlook': 'Gateway to higher education and careers',
        };
      case 'technology':
        return {
          'title': 'Technology & Software Development',
          'description':
              'Comprehensive technology career path covering programming, software development, and emerging technologies.',
          'prerequisites': [
            'Basic computer knowledge',
            'Problem-solving mindset',
            'Logical thinking',
          ],
          'outcomes': [
            'Full-stack development capabilities',
            'Understanding of software architecture',
            'Problem-solving and debugging skills',
            'Industry-ready portfolio',
            'Technical communication skills',
          ],
          'certifications': [
            'AWS Certified Developer',
            'Google Cloud Professional',
            'Microsoft Azure Fundamentals',
          ],
          'averageSalary': 75000.0,
          'jobOutlook': 'Excellent - 22% growth expected',
        };
      case 'jee':
        return {
          'title': 'JEE Preparation & Engineering',
          'description':
              'Strategic preparation for JEE exams with comprehensive Physics, Chemistry, and Mathematics coverage.',
          'prerequisites': [
            '12th Science (PCM)',
            'Strong mathematics foundation',
            'Physics and Chemistry basics',
          ],
          'outcomes': [
            'JEE Main and Advanced readiness',
            'Engineering entrance exam mastery',
            'Problem-solving techniques',
            'Time management in exams',
            'Top engineering college admission',
            'Engineering career foundation',
          ],
          'certifications': [
            'JEE Main Qualification',
            'JEE Advanced Qualification',
            'Engineering College Admission',
          ],
          'averageSalary': 60000.0,
          'jobOutlook': 'Excellent - High demand for engineers',
        };
      case 'neet':
        return {
          'title': 'NEET Preparation & Medical Career',
          'description':
              'Comprehensive NEET preparation covering Physics, Chemistry, and Biology for medical entrance.',
          'prerequisites': [
            '12th Science (PCB)',
            'Biology foundation',
            'Chemistry and Physics basics',
          ],
          'outcomes': [
            'NEET qualification and high score',
            'Medical college admission',
            'MBBS/BDS entrance readiness',
            'Medical career foundation',
            'Healthcare sector understanding',
            'Patient care awareness',
          ],
          'certifications': [
            'NEET Qualification',
            'Medical College Admission',
            'Pre-medical Foundation',
          ],
          'averageSalary': 80000.0,
          'jobOutlook': 'Excellent - Healthcare sector growth',
        };
      case 'upsc':
        return {
          'title': 'UPSC Civil Services Preparation',
          'description':
              'Comprehensive preparation for UPSC Civil Services covering Prelims, Mains, and Personality Test.',
          'prerequisites': [
            'Graduation',
            'Age 21-32 years',
            'General awareness',
            'Analytical thinking',
          ],
          'outcomes': [
            'UPSC Prelims qualification',
            'Mains examination mastery',
            'Interview and personality development',
            'Administrative service readiness',
            'Policy understanding and implementation',
            'Leadership and governance skills',
          ],
          'certifications': [
            'UPSC Civil Services',
            'IAS/IPS/IFS Selection',
            'Central Government Service',
          ],
          'averageSalary': 100000.0,
          'jobOutlook': 'Excellent - Prestigious government positions',
        };
      case 'banking':
        return {
          'title': 'Banking Sector Examination Preparation',
          'description':
              'Complete preparation for IBPS, SBI, RBI and other banking examinations.',
          'prerequisites': [
            'Graduation',
            'Age 20-30 years',
            'Basic mathematics',
            'Computer knowledge',
          ],
          'outcomes': [
            'Banking exam qualification',
            'Financial sector understanding',
            'Customer service excellence',
            'Banking operations mastery',
            'Risk assessment skills',
            'Digital banking proficiency',
          ],
          'certifications': [
            'Bank PO',
            'Bank Clerk',
            'Specialist Officer',
            'Banking Certification',
          ],
          'averageSalary': 45000.0,
          'jobOutlook': 'Good - Stable banking sector growth',
        };
      case 'railway':
        return {
          'title': 'Railway Recruitment Board Preparation',
          'description':
              'Comprehensive preparation for RRB NTPC, Group D, JE and other railway examinations.',
          'prerequisites': [
            '10th/12th/ITI/Graduation as per post',
            'Physical fitness',
            'Technical aptitude',
          ],
          'outcomes': [
            'Railway exam qualification',
            'Technical railway knowledge',
            'Safety and operations understanding',
            'Railway service readiness',
            'Infrastructure management skills',
            'Transportation sector expertise',
          ],
          'certifications': [
            'RRB NTPC',
            'Railway Group D',
            'Junior Engineer',
            'Railway Service',
          ],
          'averageSalary': 35000.0,
          'jobOutlook': 'Good - Railway expansion and modernization',
        };
      case 'defense':
        return {
          'title': 'Defense Services Preparation',
          'description':
              'Complete preparation for NDA, CDS, AFCAT and other defense service examinations.',
          'prerequisites': [
            '12th/Graduation',
            'Age 16-25 years',
            'Physical fitness',
            'Leadership qualities',
          ],
          'outcomes': [
            'Defense entrance exam qualification',
            'Military training readiness',
            'Leadership and discipline',
            'National service commitment',
            'Strategic thinking skills',
            'Defense sector expertise',
          ],
          'certifications': ['NDA', 'CDS', 'AFCAT', 'Defense Commission'],
          'averageSalary': 75000.0,
          'jobOutlook': 'Excellent - Honor and national service',
        };
      case 'teaching':
        return {
          'title': 'Government Teaching Jobs Preparation',
          'description':
              'Preparation for CTET, TET, KVS, NVS and other government teaching positions.',
          'prerequisites': [
            'B.Ed/D.Ed',
            'Subject graduation',
            'Teaching aptitude',
            'Child psychology understanding',
          ],
          'outcomes': [
            'Teaching eligibility test qualification',
            'Classroom management skills',
            'Curriculum development expertise',
            'Educational technology proficiency',
            'Student assessment abilities',
            'Educational leadership',
          ],
          'certifications': [
            'CTET',
            'State TET',
            'KVS/NVS Selection',
            'Teaching License',
          ],
          'averageSalary': 40000.0,
          'jobOutlook': 'Good - Educational sector growth',
        };
      case 'police':
        return {
          'title': 'Police and Law Enforcement Preparation',
          'description':
              'Comprehensive preparation for state police and central police force recruitments.',
          'prerequisites': [
            '12th/Graduation',
            'Physical standards',
            'Medical fitness',
            'Character verification',
          ],
          'outcomes': [
            'Police recruitment selection',
            'Law enforcement training',
            'Public safety expertise',
            'Crime investigation skills',
            'Community policing abilities',
            'Legal procedure knowledge',
          ],
          'certifications': [
            'Police Constable',
            'Sub Inspector',
            'Police Service',
            'Law Enforcement',
          ],
          'averageSalary': 35000.0,
          'jobOutlook': 'Good - Public safety and security needs',
        };
      case 'ssc':
        return {
          'title': 'SSC Examination Preparation',
          'description':
              'Focused preparation for Staff Selection Commission exams including CGL, CHSL, MTS, and JE.',
          'prerequisites': [
            '10th/12th/Graduation as per exam',
            'Basic mathematics',
            'English proficiency',
          ],
          'outcomes': [
            'SSC exam qualification',
            'Central government job selection',
            'Quantitative aptitude mastery',
            'English language proficiency',
            'General awareness excellence',
            'Reasoning ability development',
          ],
          'certifications': [
            'SSC CGL/CHSL/MTS Qualification',
            'Central Government Job',
            'Tier-1 and Tier-2 Clearance',
          ],
          'averageSalary': 35000.0,
          'jobOutlook': 'Good - Regular SSC recruitments',
        };
      case 'professional':
        return {
          'title': 'Professional Development & Career Growth',
          'description':
              'Career advancement strategies for working professionals including skill development and leadership.',
          'prerequisites': [
            'Work experience',
            'Professional qualification',
            'Career growth mindset',
          ],
          'outcomes': [
            'Advanced professional skills',
            'Leadership and management abilities',
            'Industry expertise',
            'Career advancement opportunities',
            'Professional networking',
            'Continuous learning mindset',
          ],
          'certifications': [
            'Professional Certifications',
            'Industry Recognition',
            'Leadership Credentials',
          ],
          'averageSalary': 65000.0,
          'jobOutlook': 'Good - Skill-based career growth',
        };
      default:
        return {
          'title': 'Career Development Path',
          'description':
              'Structured learning path for career advancement and skill development.',
          'prerequisites': [
            'Basic education',
            'Willingness to learn',
            'Commitment to growth',
          ],
          'outcomes': [
            'Industry-relevant skills',
            'Professional competency',
            'Career advancement opportunities',
            'Networking and connections',
            'Continuous learning mindset',
          ],
          'certifications': [
            'Professional Certification',
            'Industry Recognition',
          ],
          'averageSalary': 50000.0,
          'jobOutlook': 'Varies by specialization',
        };
    }
  }

  String _getDifficultyForDuration(int durationMonths) {
    if (durationMonths <= 3) return 'Intensive';
    if (durationMonths <= 6) return 'Moderate';
    if (durationMonths <= 12) return 'Comprehensive';
    return 'Mastery';
  }

  List<RoadmapPhase> _generatePhasesForDuration(
    String careerPath,
    int durationMonths,
    Map<String, dynamic> roadmapData,
  ) {
    final phaseTemplates = _getPhaseTemplatesForPath(careerPath);
    final phasesNeeded = _calculatePhasesForDuration(durationMonths);

    return List.generate(phasesNeeded, (index) {
      final template = phaseTemplates[index % phaseTemplates.length];
      final weeksPerPhase = (durationMonths * 4.33 / phasesNeeded).round();

      return RoadmapPhase(
        id: 'phase_${index + 1}',
        title: template['title'],
        description: template['description'],
        duration: weeksPerPhase,
        order: index + 1,
        milestones: _generateMilestonesForPhase(template, weeksPerPhase),
        skills: List<String>.from(template['skills']),
        resources: _generateResourcesForPhase(template),
      );
    });
  }

  int _calculatePhasesForDuration(int durationMonths) {
    if (durationMonths <= 3) return 3;
    if (durationMonths <= 6) return 4;
    if (durationMonths <= 12) return 6;
    return 8;
  }

  List<Map<String, dynamic>> _getPhaseTemplatesForPath(String careerPath) {
    switch (careerPath) {
      case '10th':
        return [
          {
            'title': 'Mathematics Foundation',
            'description':
                'Complete 10th Mathematics syllabus with problem-solving techniques',
            'skills': [
              'Real Numbers',
              'Polynomials',
              'Linear Equations',
              'Quadratic Equations',
              'Arithmetic Progressions',
              'Triangles',
              'Coordinate Geometry',
              'Trigonometry',
              'Circles',
              'Areas and Volumes',
              'Statistics',
              'Probability',
            ],
          },
          {
            'title': 'Science Mastery',
            'description':
                'Physics, Chemistry, and Biology concepts with practical applications',
            'skills': [
              'Light - Reflection & Refraction',
              'Human Eye',
              'Electricity',
              'Magnetic Effects',
              'Acids Bases Salts',
              'Metals and Non-metals',
              'Carbon Compounds',
              'Life Processes',
              'Control and Coordination',
              'Reproduction',
              'Heredity and Evolution',
              'Natural Resource Management',
            ],
          },
          {
            'title': 'Language & Literature',
            'description':
                'English language skills and literature comprehension',
            'skills': [
              'Reading Comprehension',
              'Writing Skills',
              'Grammar and Usage',
              'Literature Analysis',
              'Poetry Appreciation',
              'Story Writing',
              'Letter and Essay Writing',
              'Vocabulary Building',
            ],
          },
          {
            'title': 'Social Science',
            'description':
                'History, Geography, Political Science, and Economics',
            'skills': [
              'The Rise of Nationalism in Europe',
              'Nationalism in India',
              'The Making of Global World',
              'The Age of Industrialisation',
              'Resources and Development',
              'Forest and Wildlife',
              'Water Resources',
              'Agriculture',
              'Power Sharing',
              'Federalism',
              'Democracy and Diversity',
              'Development',
              'Sectors of Economy',
              'Money and Credit',
            ],
          },
          {
            'title': 'Exam Preparation & Revision',
            'description':
                'Board exam strategies, time management, and comprehensive revision',
            'skills': [
              'Time Management',
              'Exam Strategy',
              'Previous Year Analysis',
              'Mock Tests',
              'Stress Management',
              'Answer Writing Techniques',
              'Subject Integration',
              'Final Revision',
            ],
          },
        ];
      case '12th':
        return [
          {
            'title': 'Core Subject Mastery',
            'description': 'Advanced concepts in chosen stream subjects',
            'skills': [
              'Advanced Mathematics/Physics/Chemistry',
              'Biology/Economics/Accountancy',
              'Subject-specific Problem Solving',
              'Conceptual Understanding',
            ],
          },
          {
            'title': 'Board Exam Excellence',
            'description':
                'Board examination strategies and high-scoring techniques',
            'skills': [
              'Board Pattern Analysis',
              'High-Scoring Techniques',
              'Time Management',
              'Answer Presentation Skills',
            ],
          },
          {
            'title': 'Entrance Exam Preparation',
            'description': 'Preparation for competitive entrance examinations',
            'skills': [
              'JEE/NEET/Other Entrance Exams',
              'Mock Test Analysis',
              'Speed and Accuracy',
              'Exam Psychology',
            ],
          },
          {
            'title': 'Career Planning & College Preparation',
            'description': 'Career guidance and college admission process',
            'skills': [
              'Career Counseling',
              'College Research',
              'Application Process',
              'Interview Skills',
            ],
          },
        ];
      case 'jee':
        return [
          {
            'title': 'Mathematics Mastery',
            'description':
                'Advanced mathematics for JEE with problem-solving techniques',
            'skills': [
              'Algebra',
              'Trigonometry',
              'Coordinate Geometry',
              'Calculus',
              'Vectors',
              '3D Geometry',
              'Probability & Statistics',
              'Complex Numbers',
            ],
          },
          {
            'title': 'Physics Excellence',
            'description': 'Complete physics syllabus with conceptual clarity',
            'skills': [
              'Mechanics',
              'Thermodynamics',
              'Waves and Oscillations',
              'Electrostatics',
              'Current Electricity',
              'Magnetism',
              'Electromagnetic Induction',
              'Optics',
              'Modern Physics',
            ],
          },
          {
            'title': 'Chemistry Proficiency',
            'description': 'Organic, inorganic, and physical chemistry mastery',
            'skills': [
              'Physical Chemistry',
              'Organic Chemistry',
              'Inorganic Chemistry',
              'Chemical Bonding',
              'Thermodynamics',
              'Electrochemistry',
              'Chemical Kinetics',
            ],
          },
          {
            'title': 'JEE Strategy & Practice',
            'description':
                'JEE-specific strategies, mock tests, and time management',
            'skills': [
              'JEE Main Strategy',
              'JEE Advanced Preparation',
              'Mock Test Analysis',
              'Time Management',
              'Negative Marking Strategy',
              'Revision Techniques',
            ],
          },
        ];
      case 'neet':
        return [
          {
            'title': 'Physics for NEET',
            'description': 'NEET Physics syllabus with medical applications',
            'skills': [
              'Mechanics',
              'Thermodynamics',
              'Waves',
              'Electricity & Magnetism',
              'Optics',
              'Modern Physics',
              'Medical Physics Applications',
            ],
          },
          {
            'title': 'Chemistry Excellence',
            'description':
                'Complete chemistry with focus on organic and biochemistry',
            'skills': [
              'Physical Chemistry',
              'Inorganic Chemistry',
              'Organic Chemistry',
              'Biomolecules',
              'Chemical Coordination',
              'Environmental Chemistry',
            ],
          },
          {
            'title': 'Biology Mastery',
            'description': 'Comprehensive biology covering all NEET topics',
            'skills': [
              'Cell Biology',
              'Genetics',
              'Evolution',
              'Plant Physiology',
              'Human Physiology',
              'Reproduction',
              'Ecology',
              'Biotechnology',
              'Human Health and Disease',
            ],
          },
          {
            'title': 'NEET Strategy & Medical Awareness',
            'description': 'NEET exam strategy and medical career preparation',
            'skills': [
              'NEET Exam Strategy',
              'Mock Test Analysis',
              'Medical College Research',
              'MBBS/BDS Career Paths',
              'Medical Ethics',
              'Healthcare Awareness',
            ],
          },
        ];
      case 'upsc':
        return [
          {
            'title': 'Prelims Foundation',
            'description':
                'UPSC Prelims preparation with NCERT foundation and basic concepts',
            'skills': [
              'Ancient History',
              'Medieval History',
              'Modern History',
              'Indian Geography',
              'World Geography',
              'Indian Polity',
              'Constitution',
              'Economics Basics',
              'Environment & Ecology',
              'Science & Technology',
            ],
          },
          {
            'title': 'Current Affairs & GS',
            'description':
                'Current affairs integration with General Studies preparation',
            'skills': [
              'Monthly Current Affairs',
              'Yearly Compilations',
              'Government Schemes',
              'International Relations',
              'Internal Security',
              'Disaster Management',
              'Social Issues',
              'Economic Survey',
            ],
          },
          {
            'title': 'Mains Preparation',
            'description':
                'UPSC Mains comprehensive preparation with answer writing',
            'skills': [
              'Essay Writing',
              'GS Paper 1-4',
              'Optional Subject',
              'Ethics & Integrity',
              'Answer Writing Skills',
              'Case Studies',
              'Previous Year Analysis',
            ],
          },
          {
            'title': 'Interview & Personality Test',
            'description':
                'UPSC Interview preparation and personality development',
            'skills': [
              'Interview Skills',
              'Personality Development',
              'Current Issues Discussion',
              'Mock Interviews',
              'Body Language',
              'Communication Skills',
              'Leadership Qualities',
            ],
          },
        ];
      case 'banking':
        return [
          {
            'title': 'Quantitative Aptitude',
            'description':
                'Mathematics and quantitative reasoning for banking exams',
            'skills': [
              'Number System',
              'Simplification',
              'Percentage',
              'Ratio & Proportion',
              'Average',
              'Time & Work',
              'Time & Distance',
              'Simple & Compound Interest',
              'Profit & Loss',
              'Data Interpretation',
            ],
          },
          {
            'title': 'Reasoning Ability',
            'description': 'Logical and analytical reasoning for banking exams',
            'skills': [
              'Logical Reasoning',
              'Analytical Reasoning',
              'Verbal Reasoning',
              'Non-Verbal Reasoning',
              'Puzzles & Seating Arrangement',
              'Blood Relations',
              'Direction Test',
              'Coding-Decoding',
            ],
          },
          {
            'title': 'English Language',
            'description': 'English grammar, vocabulary and comprehension',
            'skills': [
              'Grammar',
              'Vocabulary',
              'Reading Comprehension',
              'Sentence Correction',
              'Fill in the Blanks',
              'Cloze Test',
              'Para Jumbles',
              'Error Detection',
            ],
          },
          {
            'title': 'Banking & Financial Awareness',
            'description': 'Banking knowledge and financial awareness',
            'skills': [
              'Banking Basics',
              'Financial Markets',
              'RBI Functions',
              'Monetary Policy',
              'Banking Regulations',
              'Insurance',
              'Current Banking Affairs',
              'Economic Concepts',
            ],
          },
        ];
      case 'railway':
        return [
          {
            'title': 'General Awareness',
            'description':
                'General knowledge and current affairs for railway exams',
            'skills': [
              'Indian History',
              'Geography',
              'Polity',
              'Economics',
              'General Science',
              'Current Affairs',
              'Sports',
              'Railway-specific GK',
            ],
          },
          {
            'title': 'Mathematics & Reasoning',
            'description': 'Quantitative aptitude and logical reasoning',
            'skills': [
              'Arithmetic',
              'Algebra',
              'Geometry',
              'Logical Reasoning',
              'Analytical Reasoning',
              'Puzzles',
              'Data Interpretation',
              'Number Series',
            ],
          },
          {
            'title': 'Technical Knowledge',
            'description':
                'Technical subjects for engineering and technical posts',
            'skills': [
              'Basic Engineering',
              'Electrical',
              'Mechanical',
              'Civil Engineering',
              'Electronics',
              'Computer Science',
              'Railway Technology',
              'Safety Procedures',
            ],
          },
          {
            'title': 'Physical & Skill Tests',
            'description': 'Physical fitness and practical skill assessments',
            'skills': [
              'Physical Fitness',
              'Skill Tests',
              'Trade Tests',
              'Document Verification',
              'Medical Examination',
              'Railway Operations',
              'Safety Training',
            ],
          },
        ];
      case 'defense':
        return [
          {
            'title': 'Mathematics & Physics',
            'description':
                'Mathematical and physical science concepts for defense exams',
            'skills': [
              'Advanced Mathematics',
              'Physics',
              'Chemistry',
              'Mathematical Reasoning',
              'Scientific Aptitude',
              'Problem Solving',
              'Analytical Skills',
            ],
          },
          {
            'title': 'General Ability & English',
            'description': 'General knowledge and English language skills',
            'skills': [
              'General Knowledge',
              'Current Affairs',
              'History',
              'Geography',
              'Polity',
              'English Grammar',
              'Vocabulary',
              'Comprehension',
            ],
          },
          {
            'title': 'SSB Interview Preparation',
            'description':
                'Services Selection Board interview and personality tests',
            'skills': [
              'Leadership Qualities',
              'Group Discussions',
              'Personal Interview',
              'Psychological Tests',
              'Group Tasks',
              'Command Tasks',
              'Confidence Building',
            ],
          },
          {
            'title': 'Physical & Medical Fitness',
            'description': 'Physical training and medical fitness preparation',
            'skills': [
              'Physical Training',
              'Endurance Building',
              'Medical Fitness',
              'Health Awareness',
              'Military Discipline',
              'Team Work',
              'National Service Mindset',
            ],
          },
        ];
      case 'teaching':
        return [
          {
            'title': 'Child Development & Pedagogy',
            'description':
                'Understanding child psychology and teaching methods',
            'skills': [
              'Child Development',
              'Learning Theories',
              'Teaching Methods',
              'Classroom Management',
              'Assessment Techniques',
              'Individual Differences',
              'Inclusive Education',
            ],
          },
          {
            'title': 'Subject Knowledge',
            'description': 'Mastery of teaching subjects and curriculum',
            'skills': [
              'Mathematics Concepts',
              'Science Understanding',
              'Social Studies',
              'Language Skills',
              'Environmental Studies',
              'Curriculum Framework',
              'Subject Pedagogy',
            ],
          },
          {
            'title': 'Educational Technology',
            'description': 'Modern teaching tools and digital education',
            'skills': [
              'Digital Teaching Tools',
              'Educational Software',
              'Online Teaching',
              'Multimedia Resources',
              'Interactive Learning',
              'Assessment Apps',
              'E-Learning Platforms',
            ],
          },
          {
            'title': 'Professional Development',
            'description': 'Teacher training and professional growth',
            'skills': [
              'Teacher Training',
              'Professional Ethics',
              'Continuous Learning',
              'Research in Education',
              'School Administration',
              'Parent-Teacher Relations',
              'Educational Leadership',
            ],
          },
        ];
      case 'police':
        return [
          {
            'title': 'General Knowledge & Current Affairs',
            'description': 'Comprehensive general knowledge for police exams',
            'skills': [
              'Indian History',
              'Geography',
              'Polity',
              'Current Affairs',
              'General Science',
              'Sports',
              'Awards',
              'Law & Order Issues',
            ],
          },
          {
            'title': 'Reasoning & Mathematics',
            'description': 'Logical reasoning and numerical ability',
            'skills': [
              'Logical Reasoning',
              'Mathematical Aptitude',
              'Analytical Reasoning',
              'Data Interpretation',
              'Number Series',
              'Puzzles',
              'Problem Solving',
            ],
          },
          {
            'title': 'Legal Knowledge',
            'description': 'Basic legal knowledge and criminal law',
            'skills': [
              'Indian Penal Code',
              'Criminal Procedure Code',
              'Evidence Act',
              'Police Manual',
              'Constitutional Law',
              'Human Rights',
              'Cyber Crime Laws',
            ],
          },
          {
            'title': 'Physical & Interview',
            'description': 'Physical fitness and interview preparation',
            'skills': [
              'Physical Training',
              'Endurance Tests',
              'Interview Skills',
              'Communication',
              'Leadership Qualities',
              'Integrity',
              'Public Service Mindset',
            ],
          },
        ];
      case 'ssc':
        return [
          {
            'title': 'Quantitative Aptitude',
            'description':
                'Mathematics for SSC exams with shortcuts and techniques',
            'skills': [
              'Number System',
              'Percentage',
              'Ratio & Proportion',
              'Average',
              'Time & Work',
              'Time & Distance',
              'Simple & Compound Interest',
              'Profit & Loss',
              'Algebra',
              'Geometry',
              'Trigonometry',
              'Statistics',
            ],
          },
          {
            'title': 'English Language',
            'description': 'English grammar and comprehension for SSC',
            'skills': [
              'Grammar Rules',
              'Vocabulary',
              'Synonyms & Antonyms',
              'Reading Comprehension',
              'Sentence Correction',
              'Fill in the Blanks',
              'Cloze Test',
              'Error Detection',
            ],
          },
          {
            'title': 'General Intelligence & Reasoning',
            'description': 'Logical and analytical reasoning for SSC',
            'skills': [
              'Analogies',
              'Classification',
              'Series Completion',
              'Coding-Decoding',
              'Blood Relations',
              'Direction Sense',
              'Logical Venn Diagrams',
              'Non-Verbal Reasoning',
            ],
          },
          {
            'title': 'General Awareness',
            'description': 'General knowledge and current affairs for SSC',
            'skills': [
              'Indian History',
              'Geography',
              'Polity',
              'Economics',
              'General Science',
              'Current Affairs',
              'Sports',
              'Awards & Honors',
              'Books & Authors',
            ],
          },
        ];
      case 'technology':
        return [
          {
            'title': 'Programming Fundamentals',
            'description': 'Learn core programming concepts and basic syntax',
            'skills': [
              'Variables & Data Types',
              'Control Structures',
              'Functions',
              'Basic Algorithms',
              'Object-Oriented Programming',
            ],
          },
          {
            'title': 'Web Development',
            'description': 'Build web applications with modern technologies',
            'skills': [
              'HTML/CSS',
              'JavaScript',
              'React/Angular',
              'Node.js',
              'Database Integration',
              'Responsive Design',
            ],
          },
          {
            'title': 'Backend & Database',
            'description': 'Server-side programming and database management',
            'skills': [
              'Server Programming',
              'Database Design',
              'APIs',
              'Authentication',
              'Cloud Services',
              'DevOps Basics',
            ],
          },
          {
            'title': 'Full-Stack Projects',
            'description': 'Build complete applications and deploy them',
            'skills': [
              'Project Architecture',
              'Testing',
              'Deployment',
              'Performance Optimization',
              'Security',
              'Portfolio Development',
            ],
          },
        ];
      case 'professional':
        return [
          {
            'title': 'Leadership & Management',
            'description': 'Develop leadership and management capabilities',
            'skills': [
              'Team Leadership',
              'Project Management',
              'Strategic Planning',
              'Decision Making',
              'Conflict Resolution',
            ],
          },
          {
            'title': 'Communication & Networking',
            'description': 'Enhance professional communication and networking',
            'skills': [
              'Professional Communication',
              'Presentation Skills',
              'Networking',
              'Personal Branding',
              'Public Speaking',
            ],
          },
          {
            'title': 'Industry Expertise',
            'description': 'Deepen knowledge in your industry domain',
            'skills': [
              'Industry Trends',
              'Technical Skills',
              'Innovation',
              'Best Practices',
              'Continuous Learning',
            ],
          },
          {
            'title': 'Career Advancement',
            'description': 'Plan and execute career growth strategies',
            'skills': [
              'Career Planning',
              'Performance Management',
              'Mentoring',
              'Professional Development',
              'Work-Life Balance',
            ],
          },
        ];
      default:
        return [
          {
            'title': 'Foundation Building',
            'description': 'Establish core knowledge and skills',
            'skills': [
              'Basic Concepts',
              'Core Principles',
              'Fundamental Tools',
              'Learning Methods',
            ],
          },
          {
            'title': 'Skill Development',
            'description': 'Develop practical and applicable skills',
            'skills': [
              'Applied Knowledge',
              'Practical Skills',
              'Tool Proficiency',
              'Problem Solving',
            ],
          },
          {
            'title': 'Advanced Applications',
            'description': 'Apply skills in real-world scenarios',
            'skills': [
              'Advanced Techniques',
              'Real Projects',
              'Industry Practices',
              'Professional Skills',
            ],
          },
        ];
    }
  }

  List<RoadmapMilestone> _generateMilestonesForPhase(
    Map<String, dynamic> template,
    int weeks,
  ) {
    final milestonesPerWeek = (weeks / 2).round().clamp(1, 4);

    return List.generate(
      milestonesPerWeek,
      (index) => RoadmapMilestone(
        id: 'milestone_${template['title']}_${index + 1}',
        title: '${template['title']} Milestone ${index + 1}',
        description: 'Complete key objectives for ${template['title']}',
        type: index == milestonesPerWeek - 1
            ? MilestoneType.project
            : MilestoneType.learning,
        points: (index + 1) * 10,
        deliverables: [
          'Practical exercises',
          'Knowledge assessment',
          if (index == milestonesPerWeek - 1) 'Project submission',
        ],
      ),
    );
  }

  List<Resource> _generateResourcesForPhase(Map<String, dynamic> template) {
    return [
      Resource(
        id: 'resource_1',
        title: '${template['title']} Course',
        description: 'Comprehensive course covering ${template['title']}',
        type: ResourceType.course,
        url: 'https://example.com/course',
        provider: 'Learning Platform',
        isFree: true,
        duration: 40,
        rating: 4.5,
      ),
      Resource(
        id: 'resource_2',
        title: '${template['title']} Documentation',
        description: 'Official documentation and guides',
        type: ResourceType.documentation,
        url: 'https://example.com/docs',
        provider: 'Official Docs',
        isFree: true,
      ),
    ];
  }
}
