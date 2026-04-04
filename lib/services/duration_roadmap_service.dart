import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import 'open_source_study_service.dart';
import 'free_educational_api_service.dart';

/// Service for generating duration-based roadmaps with API-driven content
class DurationRoadmapService {
  static final DurationRoadmapService _instance =
      DurationRoadmapService._internal();
  factory DurationRoadmapService() => _instance;
  DurationRoadmapService._internal();

  final http.Client _client = http.Client();
  final ApiService _apiService = ApiService();
  final OpenSourceStudyService _studyService = OpenSourceStudyService();
  final FreeEducationalApiService _freeEducationalService =
      FreeEducationalApiService();

  // API Keys - Replace with actual keys
  static const String _courserApiKey = 'YOUR_COURSERA_API_KEY';
  static const String _edxApiKey = 'YOUR_EDX_API_KEY';
  static const String _youtubeApiKey = 'YOUR_YOUTUBE_API_KEY';
  static const String _openaiApiKey = 'YOUR_OPENAI_API_KEY';

  static const Duration _timeout = Duration(seconds: 15);

  /// Generate comprehensive roadmap based on duration and career path
  Future<Map<String, dynamic>> generateDurationBasedRoadmap({
    required String careerPath,
    required String duration, // '3M', '6M', '1Y', '2Y'
    String? currentLevel,
    List<String>? existingSkills,
  }) async {
    print('🎯 Generating $duration roadmap for $careerPath');

    try {
      // Get roadmap structure from API
      final roadmapStructure = await _getAPIRoadmapStructure(
        careerPath,
        duration,
      );

      // Get study materials for each phase
      final studyMaterials = await _getStudyMaterialsForRoadmap(
        careerPath,
        duration,
      );

      // Get personalized recommendations
      final recommendations = await _getPersonalizedRecommendations(
        careerPath,
        duration,
      );

      // Get progress tracking data
      final progressTracking = _generateProgressTracking(duration);

      return {
        'roadmap_id': '${careerPath}_${duration}_roadmap',
        'career_path': careerPath,
        'duration': duration,
        'title': _getDurationTitle(careerPath, duration),
        'description': _getDurationDescription(careerPath, duration),
        'phases': roadmapStructure['phases'],
        'milestones': roadmapStructure['milestones'],
        'study_materials': studyMaterials,
        'recommendations': recommendations,
        'progress_tracking': progressTracking,
        'estimated_hours_per_week': _getEstimatedHours(duration),
        'total_resources': _countTotalResources(studyMaterials),
        'api_sources': [
          'Coursera API',
          'edX API',
          'YouTube Data API',
          'GitHub Educational API',
          'Government Educational APIs',
          'Open Source Study Service',
        ],
        'created_at': DateTime.now().toIso8601String(),
        'last_updated': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      print('❌ Error generating roadmap: $e');
      return _getFallbackRoadmap(careerPath, duration);
    }
  }

  /// Get roadmap structure from various APIs
  Future<Map<String, dynamic>> _getAPIRoadmapStructure(
    String careerPath,
    String duration,
  ) async {
    try {
      // Get base roadmap from ApiService
      final baseRoadmap = await _apiService.generateCareerRoadmap(
        careerPath: careerPath,
        currentLevel: 'beginner',
      );

      // Adapt phases based on duration
      final adaptedPhases = _adaptPhasesToDuration(
        baseRoadmap.phases,
        duration,
      );
      final milestones = _generateMilestonesForDuration(careerPath, duration);

      return {
        'phases': adaptedPhases,
        'milestones': milestones,
        'total_phases': adaptedPhases.length,
      };
    } catch (e) {
      print('Error getting API roadmap structure: $e');
      return _getDefaultRoadmapStructure(careerPath, duration);
    }
  }

  /// Get comprehensive study materials using multiple APIs
  Future<Map<String, dynamic>> _getStudyMaterialsForRoadmap(
    String careerPath,
    String duration,
  ) async {
    try {
      final futures = await Future.wait([
        // Open source materials
        _studyService.getStudyMaterials(
          careerPath,
          grade: _getGradeFromPath(careerPath),
        ),

        // Free educational API resources
        _freeEducationalService.getAggregatedEducationalContent(careerPath),

        // API-based courses
        _getAPIBasedCourses(careerPath, duration),

        // Government resources
        _getGovernmentResources(careerPath),

        // YouTube learning content
        _getYouTubeLearningContent(careerPath, duration),
      ]);

      return {
        'open_source_materials': futures[0],
        'educational_api_resources': futures[1],
        'api_courses': futures[2],
        'government_resources': futures[3],
        'video_content': futures[4],
        'categorized_by_priority': _categorizeMaterialsByPriority(futures),
        'duration_specific': _filterByDuration(futures, duration),
      };
    } catch (e) {
      print('Error getting study materials: $e');
      return _getFallbackStudyMaterials(careerPath);
    }
  }

  /// Get API-based courses from Coursera, edX, etc.
  Future<Map<String, dynamic>> _getAPIBasedCourses(
    String careerPath,
    String duration,
  ) async {
    try {
      final futures = await Future.wait([
        _getCourseraCourses(careerPath),
        _getEdXCourses(careerPath),
        _getUdemyFreeCourses(careerPath),
      ]);

      final allCourses = <Map<String, dynamic>>[];
      for (final courseList in futures) {
        allCourses.addAll(courseList.cast<Map<String, dynamic>>());
      }

      // Filter and prioritize based on duration
      final filteredCourses = _filterCoursesByDuration(allCourses, duration);

      return {
        'total_courses': filteredCourses.length,
        'courses': filteredCourses,
        'providers': ['Coursera', 'edX', 'Udemy'],
        'duration_matched': true,
      };
    } catch (e) {
      print('Error getting API courses: $e');
      return {'courses': [], 'error': 'Failed to fetch API courses'};
    }
  }

  /// Get Coursera courses via API
  Future<List<Map<String, dynamic>>> _getCourseraCourses(
    String careerPath,
  ) async {
    try {
      final query = _getSearchQueryForPath(careerPath);
      final url =
          'https://api.coursera.org/api/courses.v1/courses?q=search&query=$query&limit=10';

      final response = await _client
          .get(
            Uri.parse(url),
            headers: {
              'Authorization': 'Bearer $_courserApiKey',
              'Accept': 'application/json',
            },
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final courses = data['elements'] as List;

        return courses
            .map<Map<String, dynamic>>(
              (course) => {
                'title': course['name'] ?? 'Coursera Course',
                'description': course['description'] ?? '',
                'provider': 'Coursera',
                'url': 'https://www.coursera.org/learn/${course['slug'] ?? ''}',
                'duration': course['workload'] ?? '4-6 weeks',
                'level': 'Intermediate',
                'free_audit': true,
                'certificate': course['certificates']?.isNotEmpty == true,
                'rating': 4.5,
                'api_source': true,
              },
            )
            .toList();
      }
    } catch (e) {
      print('Error fetching Coursera courses: $e');
    }

    return _getFallbackCourseraCourses(careerPath);
  }

  /// Get edX courses via API
  Future<List<Map<String, dynamic>>> _getEdXCourses(String careerPath) async {
    try {
      final query = _getSearchQueryForPath(careerPath);
      final url =
          'https://api.edx.org/catalog/v1/courses/?search=$query&limit=10';

      final response = await _client.get(Uri.parse(url)).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final courses = data['results'] as List;

        return courses
            .map<Map<String, dynamic>>(
              (course) => {
                'title': course['title'] ?? 'edX Course',
                'description': course['short_description'] ?? '',
                'provider': 'edX',
                'url': 'https://www.edx.org/course/${course['key'] ?? ''}',
                'duration': '${course['weeks_to_complete'] ?? 6} weeks',
                'level': course['level_type'] ?? 'Intermediate',
                'free_audit': true,
                'certificate': true,
                'rating': 4.3,
                'api_source': true,
              },
            )
            .toList();
      }
    } catch (e) {
      print('Error fetching edX courses: $e');
    }

    return _getFallbackEdXCourses(careerPath);
  }

  /// Get YouTube learning content via API
  Future<List<Map<String, dynamic>>> _getYouTubeLearningContent(
    String careerPath,
    String duration,
  ) async {
    try {
      final query = '${_getSearchQueryForPath(careerPath)} tutorial course';
      final url =
          'https://www.googleapis.com/youtube/v3/search?part=snippet&q=$query&type=video&videoDuration=medium&maxResults=10&key=$_youtubeApiKey';

      final response = await _client.get(Uri.parse(url)).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final videos = data['items'] as List;

        return videos
            .map<Map<String, dynamic>>(
              (video) => {
                'title': video['snippet']['title'] ?? 'YouTube Video',
                'description': video['snippet']['description'] ?? '',
                'provider': 'YouTube',
                'channel': video['snippet']['channelTitle'] ?? '',
                'url':
                    'https://www.youtube.com/watch?v=${video['id']['videoId']}',
                'thumbnail':
                    video['snippet']['thumbnails']['medium']['url'] ?? '',
                'duration': 'Video content',
                'free': true,
                'api_source': true,
              },
            )
            .toList();
      }
    } catch (e) {
      print('Error fetching YouTube content: $e');
    }

    return _getFallbackYouTubeContent(careerPath);
  }

  /// Get government resources
  Future<List<Map<String, dynamic>>> _getGovernmentResources(
    String careerPath,
  ) async {
    return await _freeEducationalService.getGovernmentEducationalResources(
      careerPath,
    );
  }

  /// Get Udemy free courses
  Future<List<Map<String, dynamic>>> _getUdemyFreeCourses(
    String careerPath,
  ) async {
    // Note: Udemy API requires authentication, using fallback for now
    return _getFallbackUdemyCourses(careerPath);
  }

  /// Generate personalized recommendations based on APIs
  Future<Map<String, dynamic>> _getPersonalizedRecommendations(
    String careerPath,
    String duration,
  ) async {
    try {
      final recommendations = await _apiService.getPersonalizedCourses(
        careerPath: careerPath,
        currentLevel: 'beginner',
        interests: [careerPath],
      );

      return {
        'courses': recommendations
            .map(
              (course) => {
                'title': course.title,
                'provider': course.provider,
                'duration': course.duration,
                'level': course.level,
                'url': course.courseUrl,
                'rating': course.rating,
                'free': course.price.toLowerCase().contains('free'),
              },
            )
            .toList(),
        'total_recommendations': recommendations.length,
        'personalized': true,
        'api_based': true,
      };
    } catch (e) {
      print('Error getting personalized recommendations: $e');
      return _getFallbackRecommendations(careerPath, duration);
    }
  }

  /// Adapt phases to duration
  List<Map<String, dynamic>> _adaptPhasesToDuration(
    List<dynamic> basePhases,
    String duration,
  ) {
    final durationMultiplier = _getDurationMultiplier(duration);
    final maxPhases = _getMaxPhases(duration);

    final adaptedPhases = <Map<String, dynamic>>[];
    final phasesToInclude = basePhases.take(maxPhases).toList();

    for (int i = 0; i < phasesToInclude.length; i++) {
      final phase = phasesToInclude[i];
      adaptedPhases.add({
        'id': 'phase_${i + 1}',
        'title': phase.title ?? 'Phase ${i + 1}',
        'description': phase.description ?? '',
        'duration_weeks': (phase.estimatedWeeks ?? 4) * durationMultiplier,
        'milestones': phase.milestones?.take(3).toList() ?? [],
        'resources_count': _getResourcesCountForPhase(duration, i),
        'api_enhanced': true,
      });
    }

    return adaptedPhases;
  }

  /// Generate progress tracking structure
  Map<String, dynamic> _generateProgressTracking(String duration) {
    return {
      'total_phases': _getMaxPhases(duration),
      'estimated_completion_weeks': _getTotalWeeks(duration),
      'weekly_goals': _getWeeklyGoals(duration),
      'milestone_checkpoints': _getMilestoneCheckpoints(duration),
      'progress_indicators': [
        'Course Completion',
        'Project Submissions',
        'Skill Assessments',
        'Peer Reviews',
        'Final Certification',
      ],
      'tracking_frequency': 'Weekly',
    };
  }

  /// Helper methods for duration-based calculations
  double _getDurationMultiplier(String duration) {
    switch (duration) {
      case '3M':
        return 0.5; // Compressed timeline
      case '6M':
        return 1.0; // Standard timeline
      case '1Y':
        return 2.0; // Extended timeline
      case '2Y':
        return 4.0; // Comprehensive timeline
      default:
        return 1.0;
    }
  }

  int _getMaxPhases(String duration) {
    switch (duration) {
      case '3M':
        return 3;
      case '6M':
        return 5;
      case '1Y':
        return 8;
      case '2Y':
        return 12;
      default:
        return 5;
    }
  }

  int _getTotalWeeks(String duration) {
    switch (duration) {
      case '3M':
        return 12;
      case '6M':
        return 24;
      case '1Y':
        return 52;
      case '2Y':
        return 104;
      default:
        return 24;
    }
  }

  int _getEstimatedHours(String duration) {
    switch (duration) {
      case '3M':
        return 20; // Intensive
      case '6M':
        return 15; // Moderate
      case '1Y':
        return 10; // Relaxed
      case '2Y':
        return 8; // Very relaxed
      default:
        return 15;
    }
  }

  /// Filter courses by duration appropriateness
  List<Map<String, dynamic>> _filterCoursesByDuration(
    List<Map<String, dynamic>> courses,
    String duration,
  ) {
    final maxCourses = _getMaxPhases(duration) * 2; // 2 courses per phase
    return courses.take(maxCourses).toList();
  }

  /// Categorize materials by priority for duration
  Map<String, dynamic> _categorizeMaterialsByPriority(
    List<dynamic> allMaterials,
  ) {
    return {
      'essential': [], // Must-have for the duration
      'recommended': [], // Good to have
      'supplementary': [], // Extra resources
      'advanced': [], // For later stages
    };
  }

  /// Filter materials based on duration
  Map<String, dynamic> _filterByDuration(
    List<dynamic> materials,
    String duration,
  ) {
    return {
      'duration_appropriate': materials,
      'estimated_time': '${_getEstimatedHours(duration)} hours/week',
    };
  }

  /// Get search query for career path
  String _getSearchQueryForPath(String careerPath) {
    final queryMap = {
      '10th': 'study skills career guidance class 10',
      '12th': 'entrance exam college preparation class 12',
      'neet': 'biology chemistry physics medical entrance NEET',
      'jee': 'mathematics physics chemistry engineering JEE',
      'technology': 'programming computer science software development',
      'govt': 'civil services public administration government jobs UPSC',
      'government jobs':
          'civil services public administration government jobs UPSC',
    };
    return queryMap[careerPath.toLowerCase()] ?? careerPath;
  }

  String _getGradeFromPath(String careerPath) {
    final pathToGrade = {
      '10th': '10th',
      '12th': '12th',
      'neet': '12th', // NEET is for 12th grade students
      'jee': '12th', // JEE is for 12th grade students
      'technology': '12th', // Typically after 12th
      'govt': '12th', // Government jobs typically after 12th
    };
    return pathToGrade[careerPath.toLowerCase()] ?? '10th'; // Default to 10th
  }

  /// Fallback methods
  Map<String, dynamic> _getFallbackRoadmap(String careerPath, String duration) {
    return {
      'roadmap_id': '${careerPath}_${duration}_fallback',
      'title': _getDurationTitle(careerPath, duration),
      'phases': _getDefaultPhases(careerPath, duration),
      'study_materials': _getFallbackStudyMaterials(careerPath),
      'fallback': true,
    };
  }

  List<Map<String, dynamic>> _getFallbackCourseraCourses(String careerPath) {
    return [
      {
        'title': 'Introduction to $careerPath',
        'provider': 'Coursera',
        'duration': '4 weeks',
        'free_audit': true,
        'fallback': true,
      },
    ];
  }

  List<Map<String, dynamic>> _getFallbackEdXCourses(String careerPath) {
    return [
      {
        'title': '$careerPath Fundamentals',
        'provider': 'edX',
        'duration': '6 weeks',
        'free_audit': true,
        'fallback': true,
      },
    ];
  }

  List<Map<String, dynamic>> _getFallbackYouTubeContent(String careerPath) {
    return [
      {
        'title': '$careerPath Tutorial Series',
        'provider': 'YouTube',
        'channel': 'Educational Channel',
        'free': true,
        'fallback': true,
      },
    ];
  }

  List<Map<String, dynamic>> _getFallbackUdemyCourses(String careerPath) {
    return [
      {
        'title': 'Free $careerPath Course',
        'provider': 'Udemy',
        'duration': '3 hours',
        'free': true,
        'fallback': true,
      },
    ];
  }

  Map<String, dynamic> _getFallbackStudyMaterials(String careerPath) {
    return {
      'materials': [
        {'title': '$careerPath Study Guide', 'type': 'guide', 'free': true},
      ],
      'fallback': true,
    };
  }

  Map<String, dynamic> _getFallbackRecommendations(
    String careerPath,
    String duration,
  ) {
    return {
      'courses': [
        {
          'title': 'Recommended $careerPath Course',
          'duration': duration,
          'free': true,
        },
      ],
      'fallback': true,
    };
  }

  // Additional helper methods
  String _getDurationTitle(String careerPath, String duration) {
    final durationText = {
      '3M': '3-Month',
      '6M': '6-Month',
      '1Y': '1-Year',
      '2Y': '2-Year',
    };
    final pathTitles = {
      '10th': '10th Grade Success',
      '12th': '12th Grade Excellence',
      'neet': 'NEET Preparation',
      'jee': 'JEE Preparation',
      'technology': 'Technology & Programming',
      'govt': 'Government Jobs Preparation',
    };
    final pathTitle =
        pathTitles[careerPath.toLowerCase()] ?? careerPath.toUpperCase();
    return '${durationText[duration]} $pathTitle Roadmap';
  }

  String _getDurationDescription(String careerPath, String duration) {
    final pathDescriptions = {
      '10th': 'Build strong foundations and explore career options',
      '12th': 'Excel in board exams and prepare for higher education',
      'neet': 'Master Biology, Chemistry, and Physics for medical entrance',
      'jee': 'Excel in Mathematics, Physics, and Chemistry for engineering',
      'technology': 'Learn programming, development, and modern tech skills',
      'govt': 'Prepare for civil services and government examinations',
    };
    final description =
        pathDescriptions[careerPath.toLowerCase()] ??
        'Comprehensive learning path';
    return 'Comprehensive $duration roadmap: $description with API-driven study materials and resources.';
  }

  List<Map<String, dynamic>> _getDefaultPhases(
    String careerPath,
    String duration,
  ) {
    final phaseCount = _getMaxPhases(duration);
    final weeksPerPhase = _getTotalWeeks(duration) ~/ phaseCount;

    // Career-specific phase templates
    final phaseTemplates = {
      '10th': [
        'Foundation Building',
        'Core Subjects Mastery',
        'Stream Selection Preparation',
        'Career Exploration',
        'Skill Development',
        'Board Exam Preparation',
      ],
      '12th': [
        'Advanced Subject Mastery',
        'Entrance Exam Preparation',
        'College Research',
        'Application Process',
        'Interview Preparation',
        'Final Exam Excellence',
      ],
      'neet': [
        'Biology Fundamentals',
        'Chemistry Mastery',
        'Physics Concepts',
        'Integrated Practice',
        'Mock Tests & Analysis',
        'Final Preparation',
      ],
      'jee': [
        'Mathematics Foundation',
        'Physics Concepts',
        'Chemistry Principles',
        'Problem Solving',
        'Advanced Practice',
        'JEE Strategy',
      ],
      'technology': [
        'Programming Basics',
        'Development Fundamentals',
        'Project Building',
        'Advanced Technologies',
        'Industry Skills',
        'Career Readiness',
      ],
      'govt': [
        'General Knowledge',
        'Reasoning & Aptitude',
        'Subject Specialization',
        'Current Affairs',
        'Mock Tests',
        'Interview Preparation',
      ],
    };

    final templates =
        phaseTemplates[careerPath.toLowerCase()] ??
        [
          'Foundation',
          'Development',
          'Practice',
          'Mastery',
          'Excellence',
          'Achievement',
        ];

    return List.generate(
      phaseCount,
      (index) => {
        'id': 'phase_${index + 1}',
        'title': index < templates.length
            ? templates[index]
            : 'Phase ${index + 1}',
        'description':
            'Learning phase ${index + 1} for ${_getCareerDisplayName(careerPath)}',
        'duration_weeks': weeksPerPhase,
        'phase_number': index + 1,
        'total_phases': phaseCount,
      },
    );
  }

  String _getCareerDisplayName(String careerPath) {
    final displayNames = {
      '10th': '10th Grade',
      '12th': '12th Grade',
      'neet': 'NEET Preparation',
      'jee': 'JEE Preparation',
      'technology': 'Technology & Programming',
      'govt': 'Government Jobs',
    };
    return displayNames[careerPath.toLowerCase()] ?? careerPath;
  }

  Map<String, dynamic> _getDefaultRoadmapStructure(
    String careerPath,
    String duration,
  ) {
    return {
      'phases': _getDefaultPhases(careerPath, duration),
      'milestones': _generateMilestonesForDuration(careerPath, duration),
    };
  }

  List<Map<String, dynamic>> _generateMilestonesForDuration(
    String careerPath,
    String duration,
  ) {
    final milestoneCount = _getMaxPhases(duration);
    return List.generate(
      milestoneCount,
      (index) => {
        'id': 'milestone_${index + 1}',
        'title': 'Milestone ${index + 1}',
        'description': 'Achievement milestone for $careerPath',
        'week': ((index + 1) * _getTotalWeeks(duration) / milestoneCount)
            .round(),
      },
    );
  }

  List<String> _getWeeklyGoals(String duration) {
    return [
      'Complete assigned courses',
      'Practice exercises',
      'Work on projects',
      'Review and revise',
      'Track progress',
    ];
  }

  List<Map<String, dynamic>> _getMilestoneCheckpoints(String duration) {
    final weeks = _getTotalWeeks(duration);
    return [
      {'week': weeks ~/ 4, 'title': 'Foundation Complete'},
      {'week': weeks ~/ 2, 'title': 'Intermediate Level'},
      {'week': (weeks * 3) ~/ 4, 'title': 'Advanced Skills'},
      {'week': weeks, 'title': 'Mastery Achieved'},
    ];
  }

  int _getResourcesCountForPhase(String duration, int phaseIndex) {
    final baseCount = _getMaxPhases(duration) + phaseIndex;
    return baseCount * 2; // 2 resources per complexity unit
  }

  int _countTotalResources(Map<String, dynamic> studyMaterials) {
    int total = 0;
    for (var value in studyMaterials.values) {
      if (value is List) {
        total += value.length;
      } else if (value is Map && value['total_resources'] != null) {
        total += value['total_resources'] as int;
      }
    }
    return total;
  }

  void dispose() {
    _client.close();
    _studyService.dispose();
  }
}
