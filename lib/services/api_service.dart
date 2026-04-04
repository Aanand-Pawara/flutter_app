import 'dart:convert';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:flutter_app/models/scholarship.dart';
import 'package:flutter_app/models/job.dart';
import 'package:flutter_app/models/course.dart';
import 'package:flutter_app/models/career_data.dart';
import 'package:flutter_app/models/roadmap.dart';
import 'package:flutter_app/models/interview.dart';

class ApiService {
  // ============ REAL API KEYS ============
  // Replace these with your actual API keys
  static const String _adzunaApiKey =
      'YOUR_ADZUNA_API_KEY'; // Free tier: 50 requests/day
  static const String _adzunaAppId = 'YOUR_ADZUNA_APP_ID';
  static const String _youtubeApiKey =
      'YOUR_YOUTUBE_API_KEY'; // Free tier: 10,000 requests/day
  static const String _courseraApiKey = 'YOUR_COURSERA_API_KEY';
  static const String _edxApiKey = 'YOUR_EDX_API_KEY';
  static const String _udemyApiKey = 'YOUR_UDEMY_API_KEY';
  static const String _openaiApiKey = 'YOUR_OPENAI_API_KEY'; // Paid service
  static const String _rapidApiKey = 'YOUR_RAPIDAPI_KEY'; // Multiple APIs
  static const String _scholarshipApiKey = 'YOUR_SCHOLARSHIP_API_KEY';
  static const String _googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';
  static const String _newsApiKey = 'YOUR_NEWS_API_KEY'; // For current affairs
  static const String _huggingFaceApiKey = 'YOUR_HUGGINGFACE_API_KEY';
  static const String _freecodeApiKey = 'YOUR_FREECODE_API_KEY';

  // Base URLs for different services
  static const String _courseraCatalogUrl =
      'https://api.coursera.org/api/courses.v1';
  static const String _edxCatalogUrl = 'https://api.edx.org/catalog/v1';
  static const String _udemyApiUrl = 'https://www.udemy.com/api-2.0';
  static const String _youtubeApiUrl = 'https://www.googleapis.com/youtube/v3';
  static const String _scholarshipUrl = 'https://api.scholarships.com/v1';
  static const String _jobsApiUrl = 'https://api.adzuna.com/v1/api/jobs/in';
  static const String _openaiApiUrl = 'https://api.openai.com/v1';
  static const String _rapidApiUrl = 'https://rapidapi.com/hub';

  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final http.Client _client = http.Client();
  static const Duration _timeout = Duration(seconds: 30);

  // ============ SCHOLARSHIP SERVICES ============

  /// Scrapes National Scholarship Portal for active scholarships
  Future<List<Scholarship>> getNSPScholarships({
    String? category,
    String? state,
    int page = 1,
  }) async {
    try {
      const String nspUrl = 'https://scholarships.gov.in/schemeFullDetails.do';
      final response = await _client.get(Uri.parse(nspUrl)).timeout(_timeout);

      if (response.statusCode == 200) {
        final document = html_parser.parse(response.body);
        final scholarshipElements = document.querySelectorAll(
          '.scholarship-card',
        );

        return scholarshipElements.map((element) {
          final title =
              element.querySelector('.scheme-name')?.text.trim() ?? '';
          final description =
              element.querySelector('.scheme-desc')?.text.trim() ?? '';
          final deadline =
              element.querySelector('.deadline')?.text.trim() ?? '';
          final amount = element.querySelector('.amount')?.text.trim() ?? '';
          final eligibility =
              element.querySelector('.eligibility')?.text.trim() ?? '';

          return Scholarship(
            id: title.hashCode.toString(),
            name: title,
            description: description,
            provider: 'National Scholarship Portal',
            amount: _parseAmount(amount),
            currency: 'INR',
            eligibility: eligibility.split(',').map((e) => e.trim()).toList(),
            applicationDeadline: _parseDate(deadline),
            applicationUrl:
                'https://scholarships.gov.in/fresh/newstdRegfrmInstruction',
            category: category ?? 'General',
            targetGender: 'all',
            educationLevel: 'Any',
            subjects: [],
            isActive: true,
            documents: [],
            benefits: [],
          );
        }).toList();
      }

      return _getFallbackScholarships();
    } catch (e) {
      // Error scraping NSP scholarships
      return _getFallbackScholarships();
    }
  }

  // ============ JOB SERVICES ============

  /// Fetches jobs from National Career Service (NCS)
  Future<List<Job>> getNCSJobs({
    String? location,
    String? category,
    int page = 1,
  }) async {
    try {
      const String ncsUrl = 'https://www.ncs.gov.in/Pages/default.aspx';
      final response = await _client.get(Uri.parse(ncsUrl)).timeout(_timeout);

      if (response.statusCode == 200) {
        final document = html_parser.parse(response.body);
        final jobElements = document.querySelectorAll('.job-listing');

        return jobElements.map((element) {
          final title = element.querySelector('.job-title')?.text.trim() ?? '';
          final company =
              element.querySelector('.company-name')?.text.trim() ?? '';
          final jobLocation =
              element.querySelector('.location')?.text.trim() ?? '';
          final salary = element.querySelector('.salary')?.text.trim() ?? '';
          final experience =
              element.querySelector('.experience')?.text.trim() ?? '';

          return Job(
            id: title.hashCode.toString(),
            title: title,
            company: company,
            location: jobLocation,
            salary: salary,
            experience: experience,
            description:
                'Government job opportunity through National Career Service',
            requirements: [],
            postedDate: DateTime.now(),
            applicationUrl: 'https://www.ncs.gov.in/',
            source: 'National Career Service',
            jobType: 'Government',
          );
        }).toList();
      }

      return _getFallbackJobs();
    } catch (e) {
      // Error fetching NCS jobs
      return _getFallbackJobs();
    }
  }

  /// Fetches jobs from Adzuna API (50 requests/day free)
  Future<List<Job>> getAdzunaJobs({
    String? location = 'india',
    String? category,
    int page = 1,
  }) async {
    try {
      final queryParams = {
        'app_id': _adzunaAppId,
        'app_key': _adzunaApiKey,
        'results_per_page': '20',
        'page': page.toString(),
        'where': location ?? 'india',
      };

      if (category != null) {
        queryParams['what'] = category;
      }

      final uri = Uri.https(
        'api.adzuna.com',
        '/v1/api/jobs/in/search/$page',
        queryParams,
      );

      final response = await _client.get(uri).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;

        return results.map((jobData) {
          return Job(
            id: jobData['id'].toString(),
            title: jobData['title'] ?? '',
            company: jobData['company']['display_name'] ?? '',
            location: jobData['location']['display_name'] ?? '',
            salary: jobData['salary_min'] != null
                ? '₹${jobData['salary_min']} - ₹${jobData['salary_max'] ?? jobData['salary_min']}'
                : 'Not specified',
            experience: 'As per requirement',
            description: jobData['description'] ?? '',
            requirements: [],
            postedDate: DateTime.parse(jobData['created']),
            applicationUrl: jobData['redirect_url'] ?? '',
            source: 'Adzuna',
            jobType: jobData['category']['label'] ?? 'Full-time',
          );
        }).toList();
      }

      return _getFallbackJobs();
    } catch (e) {
      // Error fetching Adzuna jobs
      return _getFallbackJobs();
    }
  }

  // ============ COURSE SERVICES ============

  /// Fetches courses from Coursera Catalog API
  Future<List<Course>> getCourseraCourses({
    String? category,
    String? level,
    int page = 1,
  }) async {
    try {
      final queryParams = {
        'start': ((page - 1) * 20).toString(),
        'limit': '20',
        'fields':
            'name,description,photoUrl,instructors,partners,workload,certificates',
      };

      if (category != null) {
        queryParams['q'] = 'search';
        queryParams['query'] = category;
      }

      final uri = Uri.https(
        'api.coursera.org',
        '/api/courses.v1/courses',
        queryParams,
      );

      final response = await _client.get(uri).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final courses = data['elements'] as List;

        return courses.map((courseData) {
          return Course(
            id: courseData['id'].toString(),
            title: courseData['name'] ?? '',
            description: courseData['description'] ?? '',
            provider: 'Coursera',
            instructor: courseData['instructors']?.isNotEmpty == true
                ? courseData['instructors'][0]['fullName'] ??
                      'Coursera Instructor'
                : 'Coursera Instructor',
            duration: courseData['workload'] ?? '4-6 weeks',
            level: level ?? 'Beginner',
            rating: 4.5,
            enrolledCount: 10000,
            price: 'Free to audit',
            imageUrl: courseData['photoUrl'] ?? '',
            skills: [],
            category: category ?? 'Technology',
            certificateAvailable:
                courseData['certificates']?.isNotEmpty == true,
            courseUrl:
                'https://www.coursera.org/learn/${courseData['slug'] ?? ''}',
          );
        }).toList();
      }

      return _getFallbackCourses();
    } catch (e) {
      // Error fetching Coursera courses
      return _getFallbackCourses();
    }
  }

  /// Fetches courses from edX Catalog API
  Future<List<Course>> getEdXCourses({
    String? category,
    String? level,
    int page = 1,
  }) async {
    try {
      final queryParams = {'page': page.toString(), 'page_size': '20'};

      if (category != null) {
        queryParams['search'] = category;
      }

      final uri = Uri.https('api.edx.org', '/catalog/v1/courses/', queryParams);

      final response = await _client.get(uri).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final courses = data['results'] as List;

        return courses.map((courseData) {
          return Course(
            id: courseData['key'].toString(),
            title: courseData['title'] ?? '',
            description: courseData['short_description'] ?? '',
            provider: 'edX',
            instructor: courseData['owners']?.isNotEmpty == true
                ? courseData['owners'][0]['name'] ?? 'edX Instructor'
                : 'edX Instructor',
            duration: '6-8 weeks',
            level: courseData['level_type'] ?? level ?? 'Intermediate',
            rating: 4.3,
            enrolledCount: 5000,
            price: 'Free (Certificate fee applies)',
            imageUrl: courseData['image']?['src'] ?? '',
            skills:
                (courseData['subjects'] as List?)
                    ?.map((s) => s['name'].toString())
                    .toList() ??
                [],
            category: category ?? 'Education',
            certificateAvailable: true,
            courseUrl: 'https://www.edx.org/course/${courseData['key']}',
          );
        }).toList();
      }

      return _getFallbackCourses();
    } catch (e) {
      // Error fetching edX courses
      return _getFallbackCourses();
    }
  }

  /// Fetches learning videos from YouTube Data API
  Future<List<Course>> getYouTubeLearningContent({
    required String query,
    int maxResults = 20,
  }) async {
    try {
      final queryParams = {
        'part': 'snippet,statistics',
        'q': '$query tutorial learning course',
        'type': 'video',
        'maxResults': maxResults.toString(),
        'order': 'relevance',
        'videoDuration': 'medium',
        'key': _youtubeApiKey,
      };

      final uri = Uri.https(
        'www.googleapis.com',
        '/youtube/v3/search',
        queryParams,
      );

      final response = await _client.get(uri).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final videos = data['items'] as List;

        return videos.map((videoData) {
          final snippet = videoData['snippet'];
          return Course(
            id: videoData['id']['videoId'].toString(),
            title: snippet['title'] ?? '',
            description: snippet['description'] ?? '',
            provider: 'YouTube',
            instructor: snippet['channelTitle'] ?? 'YouTube Creator',
            duration: 'Video content',
            level: 'All levels',
            rating: 4.0,
            enrolledCount: 1000,
            price: 'Free',
            imageUrl: snippet['thumbnails']['medium']['url'] ?? '',
            skills: [query],
            category: 'Video Learning',
            certificateAvailable: false,
            courseUrl:
                'https://www.youtube.com/watch?v=${videoData['id']['videoId']}',
          );
        }).toList();
      }

      return [];
    } catch (e) {
      // Error fetching YouTube content
      return [];
    }
  }

  /// Fetches courses from Udemy API
  Future<List<Course>> getUdemyCourses({
    String? category,
    String? level,
    int page = 1,
    String? language = 'en',
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'page_size': '20',
        'language': language ?? 'en',
        'ordering': 'relevance',
      };

      if (category != null) {
        queryParams['search'] = category;
      }

      if (level != null) {
        queryParams['instructional_level'] = level;
      }

      final uri = Uri.https('www.udemy.com', '/api-2.0/courses/', queryParams);

      final response = await _client
          .get(
            uri,
            headers: {
              'Authorization':
                  'Basic ${base64Encode(utf8.encode('$_udemyApiKey:'))}',
              'Accept': 'application/json',
            },
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final courses = data['results'] as List;

        return courses.map((courseData) {
          return Course(
            id: courseData['id'].toString(),
            title: courseData['title'] ?? '',
            description: courseData['headline'] ?? '',
            provider: 'Udemy',
            instructor: courseData['visible_instructors']?.isNotEmpty == true
                ? courseData['visible_instructors'][0]['display_name'] ??
                      'Udemy Instructor'
                : 'Udemy Instructor',
            duration: '${courseData['content_info_short'] ?? 'Self-paced'}',
            level:
                courseData['instructional_level_simple'] ??
                level ??
                'All Levels',
            rating: (courseData['rating'] ?? 4.0).toDouble(),
            enrolledCount: courseData['num_subscribers'] ?? 1000,
            price: courseData['is_paid'] == true
                ? '₹${courseData['price'] ?? 'Paid'}'
                : 'Free',
            imageUrl: courseData['image_480x270'] ?? '',
            skills: [],
            category: category ?? 'General',
            certificateAvailable: courseData['has_certificate'] ?? false,
            courseUrl: 'https://www.udemy.com${courseData['url'] ?? ''}',
            language: courseData['locale']['english_title'] ?? 'English',
          );
        }).toList();
      }

      return _getFallbackCourses();
    } catch (e) {
      print('Error fetching Udemy courses: $e');
      return _getFallbackCourses();
    }
  }

  /// Enhanced course search across multiple platforms
  Future<List<Course>> searchCourses({
    required String query,
    String? level,
    String? category,
    List<String>? providers,
    bool freeOnly = false,
    int limit = 50,
  }) async {
    final allCourses = <Course>[];
    final futures = <Future<List<Course>>>[];

    // Search across multiple platforms
    if (providers == null || providers.contains('coursera')) {
      futures.add(getCourseraCourses(category: query, level: level));
    }
    if (providers == null || providers.contains('edx')) {
      futures.add(getEdXCourses(category: query, level: level));
    }
    if (providers == null || providers.contains('udemy')) {
      futures.add(getUdemyCourses(category: query, level: level));
    }
    if (providers == null || providers.contains('youtube')) {
      futures.add(getYouTubeLearningContent(query: query));
    }

    try {
      final results = await Future.wait(futures);
      for (final courseList in results) {
        allCourses.addAll(courseList);
      }

      // Filter by free courses if requested
      if (freeOnly) {
        allCourses.removeWhere(
          (course) => !course.price.toLowerCase().contains('free'),
        );
      }

      // Sort by rating and limit results
      allCourses.sort((a, b) => b.rating.compareTo(a.rating));
      return allCourses.take(limit).toList();
    } catch (e) {
      print('Error searching courses: $e');
      return _getFallbackCourses();
    }
  }

  /// Get personalized course recommendations
  Future<List<Course>> getPersonalizedCourses({
    required String careerPath,
    required String currentLevel,
    List<String>? completedCourses,
    List<String>? interests,
  }) async {
    try {
      // Create recommendation based on career path and level
      final recommendations = _getCourseRecommendations(
        careerPath,
        currentLevel,
      );
      final futures = <Future<List<Course>>>[];

      for (final recommendation in recommendations) {
        futures.add(
          searchCourses(
            query: recommendation['query']!,
            level: recommendation['level'],
            category: recommendation['category'],
            limit: 5,
          ),
        );
      }

      final results = await Future.wait(futures);
      final allCourses = <Course>[];
      for (final courseList in results) {
        allCourses.addAll(courseList);
      }

      // Remove already completed courses
      if (completedCourses != null) {
        allCourses.removeWhere(
          (course) => completedCourses.contains(course.id),
        );
      }

      return allCourses.take(20).toList();
    } catch (e) {
      print('Error getting personalized courses: $e');
      return _getFallbackCourses();
    }
  }

  /// Get course recommendations based on career path
  List<Map<String, String>> _getCourseRecommendations(
    String careerPath,
    String level,
  ) {
    final recommendations = {
      '10th': [
        {'query': 'study skills', 'level': 'beginner', 'category': 'education'},
        {'query': 'career guidance', 'level': 'beginner', 'category': 'career'},
        {
          'query': 'stream selection',
          'level': 'beginner',
          'category': 'guidance',
        },
      ],
      '12th': [
        {
          'query': 'entrance exam preparation',
          'level': 'intermediate',
          'category': 'exam',
        },
        {
          'query': 'college applications',
          'level': 'intermediate',
          'category': 'guidance',
        },
        {
          'query': 'competitive exams',
          'level': 'intermediate',
          'category': 'exam',
        },
      ],
      'technology': [
        {
          'query': 'programming fundamentals',
          'level': level,
          'category': 'programming',
        },
        {'query': 'web development', 'level': level, 'category': 'technology'},
        {
          'query': 'data structures',
          'level': level,
          'category': 'computer science',
        },
        {
          'query': 'software engineering',
          'level': level,
          'category': 'technology',
        },
      ],
      'neet': [
        {
          'query': 'biology for neet',
          'level': 'intermediate',
          'category': 'science',
        },
        {
          'query': 'chemistry for neet',
          'level': 'intermediate',
          'category': 'science',
        },
        {
          'query': 'physics for neet',
          'level': 'intermediate',
          'category': 'science',
        },
        {
          'query': 'neet exam strategy',
          'level': 'intermediate',
          'category': 'exam',
        },
      ],
      'jee': [
        {
          'query': 'jee mathematics',
          'level': 'advanced',
          'category': 'mathematics',
        },
        {'query': 'jee physics', 'level': 'advanced', 'category': 'physics'},
        {
          'query': 'jee chemistry',
          'level': 'advanced',
          'category': 'chemistry',
        },
        {
          'query': 'jee preparation strategy',
          'level': 'advanced',
          'category': 'exam',
        },
      ],
      'govt': [
        {
          'query': 'upsc preparation',
          'level': 'intermediate',
          'category': 'government',
        },
        {
          'query': 'current affairs',
          'level': 'beginner',
          'category': 'general knowledge',
        },
        {
          'query': 'public administration',
          'level': 'intermediate',
          'category': 'government',
        },
        {
          'query': 'indian polity',
          'level': 'intermediate',
          'category': 'civics',
        },
      ],
    };

    return recommendations[careerPath] ??
        [
          {
            'query': 'general skills',
            'level': 'beginner',
            'category': 'general',
          },
          {
            'query': 'communication skills',
            'level': 'beginner',
            'category': 'soft skills',
          },
        ];
  }

  // ============ ROADMAP SERVICES ============

  /// Generates a personalized career roadmap based on user's career path
  Future<Roadmap> generateCareerRoadmap({
    required String careerPath,
    String? currentLevel,
    List<String>? existingSkills,
    String? preferredLearningStyle,
    int? timeCommitment, // hours per week
  }) async {
    try {
      // Try to get roadmap from Hugging Face API or create a structured one
      final roadmap = await _getAIGeneratedRoadmap(
        careerPath: careerPath,
        currentLevel: currentLevel ?? 'beginner',
        existingSkills: existingSkills ?? [],
        preferredLearningStyle: preferredLearningStyle ?? 'mixed',
        timeCommitment: timeCommitment ?? 10,
      );

      if (roadmap != null) {
        return roadmap;
      }

      // Fallback to predefined roadmaps
      return _getPredefinedRoadmap(careerPath);
    } catch (e) {
      print('Error generating roadmap: $e');
      return _getPredefinedRoadmap(careerPath);
    }
  }

  /// Gets AI-generated roadmap using Hugging Face API
  Future<Roadmap?> _getAIGeneratedRoadmap({
    required String careerPath,
    required String currentLevel,
    required List<String> existingSkills,
    required String preferredLearningStyle,
    required int timeCommitment,
  }) async {
    try {
      final prompt =
          '''
Create a detailed career roadmap for: $careerPath
Current Level: $currentLevel
Existing Skills: ${existingSkills.join(', ')}
Learning Style: $preferredLearningStyle
Time Commitment: $timeCommitment hours/week

Provide a structured roadmap with phases, milestones, and resources.
''';

      final response = await _client
          .post(
            Uri.parse(
              'https://api-inference.huggingface.co/models/microsoft/DialoGPT-medium',
            ),
            headers: {
              'Authorization':
                  'Bearer $_huggingFaceApiKey', // Use proper Hugging Face API key
              'Content-Type': 'application/json',
            },
            body: json.encode({
              'inputs': prompt,
              'parameters': {'max_length': 1000, 'temperature': 0.7},
            }),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Parse AI response and convert to structured roadmap
        return _parseAIResponseToRoadmap(data, careerPath);
      }

      return null;
    } catch (e) {
      print('Error with AI roadmap generation: $e');
      return null;
    }
  }

  /// Parse AI response to structured roadmap
  Roadmap _parseAIResponseToRoadmap(dynamic aiResponse, String careerPath) {
    // This would normally parse the AI response
    // For now, return a structured fallback
    return _getPredefinedRoadmap(careerPath);
  }

  /// Gets predefined roadmap based on career path
  Roadmap _getPredefinedRoadmap(String careerPath) {
    final roadmaps = _getRoadmapTemplates();
    return roadmaps[careerPath] ?? roadmaps['default']!;
  }

  /// Get all available roadmap templates
  Map<String, Roadmap> _getRoadmapTemplates() {
    return {
      '10th': _create10thStandardRoadmap(),
      '12th': _create10thStandardRoadmap().copyWith(
        id: '12th_roadmap',
        careerPath: '12th',
        title: '12th Standard Career Roadmap',
        description:
            'Advanced 12th grade curriculum with specialization focus.',
      ),
      'neet': _create10thStandardRoadmap().copyWith(
        id: 'neet_roadmap',
        careerPath: 'neet',
        title: 'NEET Preparation Roadmap',
        description:
            'Medical entrance exam preparation with Biology, Chemistry, and Physics.',
      ),
      'jee': _create10thStandardRoadmap().copyWith(
        id: 'jee_roadmap',
        careerPath: 'jee',
        title: 'JEE Preparation Roadmap',
        description:
            'Engineering entrance exam preparation with Mathematics, Physics, and Chemistry.',
      ),
      'govt': _createDefaultRoadmap().copyWith(
        id: 'govt_roadmap',
        careerPath: 'govt',
        title: 'Government Jobs Roadmap',
        description:
            'Comprehensive preparation for government job examinations.',
      ),
      'ssc': _createDefaultRoadmap().copyWith(
        id: 'ssc_roadmap',
        careerPath: 'ssc',
        title: 'SSC Preparation Roadmap',
        description: 'Staff Selection Commission exam preparation.',
      ),
      'professional': _createDefaultRoadmap().copyWith(
        id: 'professional_roadmap',
        careerPath: 'professional',
        title: 'Professional Development Roadmap',
        description: 'Career advancement for working professionals.',
      ),
      'technology': _createTechnologyRoadmap(),
      'default': _createDefaultRoadmap(),
    };
  }

  /// Updates user's roadmap progress
  Future<RoadmapProgress> updateRoadmapProgress({
    required String userId,
    required String roadmapId,
    required String phaseId,
    required String milestoneId,
    required bool isCompleted,
  }) async {
    try {
      // In a real app, this would call your backend API
      // For now, return mock progress
      return RoadmapProgress(
        userId: userId,
        roadmapId: roadmapId,
        completionPercentage: 25.0,
        completedPhases: [phaseId],
        completedMilestones: [milestoneId],
        totalPoints: 100,
        startedAt: DateTime.now().subtract(const Duration(days: 7)),
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to update roadmap progress: $e');
    }
  }

  /// Gets user's roadmap progress
  Future<RoadmapProgress?> getRoadmapProgress(
    String userId,
    String roadmapId,
  ) async {
    try {
      // In a real app, this would fetch from your backend
      // For now, return mock data
      return RoadmapProgress(
        userId: userId,
        roadmapId: roadmapId,
        completionPercentage: 15.0,
        completedPhases: [],
        completedMilestones: [],
        totalPoints: 50,
        startedAt: DateTime.now().subtract(const Duration(days: 3)),
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      print('Error fetching roadmap progress: $e');
      return null;
    }
  }

  /// Fetches career data from O*NET Web Services
  Future<CareerData> getONetCareerData(String occupation) async {
    try {
      final uri = Uri.https(
        'services.onetcenter.org',
        '/ws/online/occupations/$occupation/summary',
      );

      final response = await _client.get(uri).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        return CareerData(
          title: data['title'] ?? occupation,
          description: data['description'] ?? '',
          skills:
              (data['skills'] as List?)?.map((s) => s.toString()).toList() ??
              [],
          averageSalary:
              data['median_wages']?['annual']?.toString() ?? 'Not available',
          jobOutlook: data['job_outlook'] ?? 'Stable',
          education: data['education'] ?? 'Bachelor\'s degree',
          workEnvironment: data['work_environment'] ?? 'Office setting',
          relatedOccupations:
              (data['related_occupations'] as List?)
                  ?.map((o) => o.toString())
                  .toList() ??
              [],
        );
      }

      return _getFallbackCareerData(occupation);
    } catch (e) {
      // Error fetching O*NET career data
      return _getFallbackCareerData(occupation);
    }
  }

  // ============ MARKET TRENDS SERVICES ============

  /// Fetches employment data from World Bank API
  Future<Map<String, dynamic>> getEmploymentTrends(String countryCode) async {
    try {
      final uri = Uri.https(
        'api.worldbank.org',
        '/v2/country/$countryCode/indicator/SL.UEM.TOTL.ZS',
        {'format': 'json', 'date': '2020:2023'},
      );

      final response = await _client.get(uri).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List && data.length > 1) {
          final trends = data[1] as List;
          return {
            'unemployment_rate': trends.isNotEmpty ? trends[0]['value'] : 'N/A',
            'year': trends.isNotEmpty ? trends[0]['date'] : '2023',
            'country': countryCode,
          };
        }
      }

      return {
        'unemployment_rate': '7.5',
        'year': '2023',
        'country': countryCode,
      };
    } catch (e) {
      // Error fetching employment trends
      return {
        'unemployment_rate': '7.5',
        'year': '2023',
        'country': countryCode,
      };
    }
  }

  // ============ TRANSLATION SERVICES ============

  /// Translates text using LibreTranslate
  Future<String> translateText(String text, String targetLanguage) async {
    try {
      final response = await _client
          .post(
            Uri.parse('https://libretranslate.de/translate'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'q': text,
              'source': 'en',
              'target': targetLanguage,
              'format': 'text',
            }),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['translatedText'] ?? text;
      }

      return text;
    } catch (e) {
      // Error translating text
      return text;
    }
  }

  // ============ LOCATION SERVICES ============

  /// Finds colleges near a location using Google Maps Places API
  Future<List<Map<String, dynamic>>> findNearbyColleges({
    required double latitude,
    required double longitude,
    int radius = 50000, // 50km
  }) async {
    try {
      final queryParams = {
        'location': '$latitude,$longitude',
        'radius': radius.toString(),
        'type': 'university',
        'key': _googleMapsApiKey,
      };

      final uri = Uri.https(
        'maps.googleapis.com',
        '/maps/api/place/nearbysearch/json',
        queryParams,
      );

      final response = await _client.get(uri).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;

        return results
            .map(
              (place) => {
                'name': place['name'],
                'rating': place['rating'],
                'vicinity': place['vicinity'],
                'place_id': place['place_id'],
                'types': place['types'],
              },
            )
            .toList();
      }

      return [];
    } catch (e) {
      // Error finding nearby colleges
      return [];
    }
  }

  // ============ HELPER METHODS ============

  double _parseAmount(String amountText) {
    final regex = RegExp(r'[\d,]+');
    final match = regex.firstMatch(amountText);
    final amountStr = match?.group(0)?.replaceAll(',', '') ?? '0';
    return double.tryParse(amountStr) ?? 0.0;
  }

  DateTime _parseDate(String dateText) {
    try {
      // Try to parse common date formats
      final cleanDate = dateText.replaceAll(RegExp(r'[^\d\-\/]'), '');
      return DateTime.parse(cleanDate);
    } catch (e) {
      return DateTime.now().add(const Duration(days: 30));
    }
  }

  List<Scholarship> _getFallbackScholarships() {
    return [
      Scholarship(
        id: '1',
        name: 'Merit-cum-Means Scholarship',
        description:
            'For economically weaker sections with good academic performance',
        provider: 'National Scholarship Portal',
        amount: 12000.0,
        currency: 'INR',
        eligibility: ['Income < 2.5 LPA', 'Minimum 60% marks'],
        applicationDeadline: DateTime.now().add(const Duration(days: 45)),
        applicationUrl: 'https://scholarships.gov.in',
        category: 'Merit',
        targetGender: 'all',
        educationLevel: 'Any',
        subjects: [],
        isActive: true,
        documents: [],
        benefits: [],
      ),
    ];
  }

  List<Job> _getFallbackJobs() {
    return [
      Job(
        id: '1',
        title: 'Software Developer',
        company: 'Government of India',
        location: 'New Delhi',
        salary: '₹40,000 - ₹60,000',
        experience: '2-5 years',
        description: 'Develop software solutions for government departments',
        requirements: ['B.Tech/MCA', 'Programming skills'],
        postedDate: DateTime.now(),
        applicationUrl: 'https://www.ncs.gov.in',
        source: 'NCS Fallback',
        jobType: 'Government',
      ),
    ];
  }

  List<Course> _getFallbackCourses() {
    return [
      Course(
        id: '1',
        title: 'Introduction to Programming',
        description: 'Learn programming fundamentals',
        provider: 'Coursera',
        instructor: 'Tech Expert',
        duration: '6 weeks',
        level: 'Beginner',
        rating: 4.5,
        enrolledCount: 10000,
        price: 'Free',
        imageUrl: '',
        skills: ['Programming', 'Logic'],
        category: 'Technology',
        certificateAvailable: true,
        courseUrl: 'https://coursera.org',
      ),
    ];
  }

  CareerData _getFallbackCareerData(String occupation) {
    return CareerData(
      title: occupation,
      description: 'Career information for $occupation',
      skills: ['Communication', 'Problem Solving'],
      averageSalary: '₹5,00,000',
      jobOutlook: 'Growing',
      education: 'Bachelor\'s degree',
      workEnvironment: 'Office',
      relatedOccupations: [],
    );
  }

  // ============ ROADMAP TEMPLATES ============

  Roadmap _create10thStandardRoadmap() {
    return Roadmap(
      id: '10th_roadmap',
      careerPath: '10th',
      title: '10th Standard Career Roadmap',
      description:
          'Complete guidance for students after 10th standard to choose the right stream and career path.',
      estimatedDuration: 24, // months
      difficultyLevel: 'Beginner',
      prerequisites: ['Basic Mathematics', 'English Communication'],
      outcomes: [
        'Stream Selection Clarity',
        'Career Path Understanding',
        'College Admission Preparation',
        'Skill Development Foundation',
      ],
      certifications: [
        'Stream Selection Certificate',
        'Career Aptitude Assessment',
        'Basic Skill Certification',
      ],
      averageSalary: 300000.0, // Starting salary after completion
      jobOutlook: 'Excellent - Multiple paths available',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      phases: [
        RoadmapPhase(
          id: 'phase_1',
          title: 'Self Assessment & Stream Selection',
          description:
              'Understand your interests, aptitudes, and choose the right stream.',
          duration: 8, // weeks
          order: 1,
          skills: ['Self-awareness', 'Decision Making', 'Research Skills'],
          milestones: [
            RoadmapMilestone(
              id: 'milestone_1_1',
              title: 'Complete Aptitude Test',
              description:
                  'Take comprehensive aptitude and interest assessment.',
              type: MilestoneType.assessment,
              points: 20,
              deliverables: [
                'Aptitude Test Results',
                'Interest Analysis Report',
              ],
            ),
            RoadmapMilestone(
              id: 'milestone_1_2',
              title: 'Stream Research',
              description:
                  'Research Science, Commerce, and Arts streams thoroughly.',
              type: MilestoneType.learning,
              points: 15,
              deliverables: ['Stream Comparison Chart', 'Career Options List'],
            ),
          ],
          resources: [
            Resource(
              id: 'resource_1_1',
              title: 'Career Aptitude Test',
              description: 'Free online aptitude test for stream selection',
              type: ResourceType.assessment,
              url: 'https://www.careerguide.com/aptitude-test',
              provider: 'CareerGuide',
              isFree: true,
            ),
          ],
        ),
        // Add more phases...
      ],
    );
  }

  Roadmap _createTechnologyRoadmap() {
    return Roadmap(
      id: 'tech_roadmap',
      careerPath: 'technology',
      title: 'Technology & IT Career Roadmap',
      description:
          'Comprehensive path to become a successful technology professional.',
      estimatedDuration: 36, // months
      difficultyLevel: 'Intermediate',
      prerequisites: [
        'Basic Computer Knowledge',
        'English Proficiency',
        'Logical Thinking',
      ],
      outcomes: [
        'Programming Proficiency',
        'Software Development Skills',
        'Industry-Ready Portfolio',
        'Job Placement Assistance',
      ],
      certifications: [
        'Full Stack Development Certificate',
        'Cloud Computing Certification',
        'Data Science Certificate',
        'Cybersecurity Fundamentals',
      ],
      averageSalary: 800000.0,
      jobOutlook: 'Excellent - High demand in market',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      phases: [
        RoadmapPhase(
          id: 'tech_phase_1',
          title: 'Programming Fundamentals',
          description: 'Master the basics of programming and computer science.',
          duration: 12, // weeks
          order: 1,
          skills: [
            'Programming Logic',
            'Data Structures',
            'Algorithms',
            'Problem Solving',
          ],
          milestones: [
            RoadmapMilestone(
              id: 'tech_milestone_1_1',
              title: 'Choose Programming Language',
              description:
                  'Select and master your first programming language (Python/Java/JavaScript).',
              type: MilestoneType.learning,
              points: 25,
              deliverables: [
                'Language Fundamentals',
                'Basic Programs Portfolio',
              ],
            ),
            RoadmapMilestone(
              id: 'tech_milestone_1_2',
              title: 'Data Structures & Algorithms',
              description: 'Learn essential data structures and algorithms.',
              type: MilestoneType.learning,
              points: 30,
              deliverables: ['DSA Problem Solutions', 'Complexity Analysis'],
            ),
            RoadmapMilestone(
              id: 'tech_milestone_1_3',
              title: 'First Project',
              description: 'Build your first complete programming project.',
              type: MilestoneType.project,
              points: 40,
              deliverables: [
                'Working Application',
                'Source Code',
                'Documentation',
              ],
            ),
          ],
          resources: [
            Resource(
              id: 'tech_resource_1_1',
              title: 'Python for Beginners',
              description: 'Complete Python programming course for beginners',
              type: ResourceType.course,
              url: 'https://www.coursera.org/learn/python',
              provider: 'Coursera',
              isFree: false,
              price: 49.0,
              duration: 40,
              rating: 4.7,
            ),
            Resource(
              id: 'tech_resource_1_2',
              title: 'Data Structures and Algorithms',
              description: 'Comprehensive DSA course with practical examples',
              type: ResourceType.course,
              url: 'https://www.edx.org/course/data-structures-algorithms',
              provider: 'edX',
              isFree: true,
              duration: 60,
              rating: 4.5,
            ),
          ],
        ),
        RoadmapPhase(
          id: 'tech_phase_2',
          title: 'Web Development',
          description:
              'Learn frontend and backend web development technologies.',
          duration: 16, // weeks
          order: 2,
          skills: ['HTML/CSS', 'JavaScript', 'React', 'Node.js', 'Databases'],
          milestones: [
            RoadmapMilestone(
              id: 'tech_milestone_2_1',
              title: 'Frontend Development',
              description:
                  'Master HTML, CSS, JavaScript, and a modern framework.',
              type: MilestoneType.learning,
              points: 35,
              deliverables: ['Responsive Website', 'Interactive Web App'],
            ),
            RoadmapMilestone(
              id: 'tech_milestone_2_2',
              title: 'Backend Development',
              description:
                  'Learn server-side programming and database management.',
              type: MilestoneType.learning,
              points: 35,
              deliverables: ['RESTful API', 'Database Design'],
            ),
            RoadmapMilestone(
              id: 'tech_milestone_2_3',
              title: 'Full Stack Project',
              description:
                  'Build a complete web application with frontend and backend.',
              type: MilestoneType.project,
              points: 50,
              deliverables: [
                'Complete Web Application',
                'Deployment',
                'User Testing',
              ],
            ),
          ],
          resources: [
            Resource(
              id: 'tech_resource_2_1',
              title: 'The Complete Web Developer Course',
              description: 'Full stack web development from scratch',
              type: ResourceType.course,
              url:
                  'https://www.udemy.com/course/the-complete-web-development-bootcamp/',
              provider: 'Udemy',
              isFree: false,
              price: 84.99,
              duration: 65,
              rating: 4.6,
            ),
          ],
        ),
        // Add more phases for specializations like Mobile Dev, Data Science, etc.
      ],
    );
  }

  Roadmap _createDefaultRoadmap() {
    return Roadmap(
      id: 'default_roadmap',
      careerPath: 'general',
      title: 'General Career Development Roadmap',
      description:
          'A flexible roadmap for general career development and skill building.',
      estimatedDuration: 18,
      difficultyLevel: 'Beginner',
      prerequisites: ['Basic Education', 'Willingness to Learn'],
      outcomes: ['Skill Development', 'Career Clarity', 'Professional Growth'],
      certifications: ['Professional Development Certificate'],
      averageSalary: 400000.0,
      jobOutlook: 'Good - Depends on chosen specialization',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      phases: [
        RoadmapPhase(
          id: 'default_phase_1',
          title: 'Career Exploration',
          description:
              'Explore different career options and find your passion.',
          duration: 6,
          order: 1,
          skills: ['Self-assessment', 'Research', 'Decision Making'],
          milestones: [
            RoadmapMilestone(
              id: 'default_milestone_1',
              title: 'Career Assessment',
              description: 'Complete comprehensive career assessment.',
              type: MilestoneType.assessment,
              points: 20,
              deliverables: ['Assessment Results', 'Career Options List'],
            ),
          ],
          resources: [
            Resource(
              id: 'default_resource_1',
              title: 'Career Exploration Guide',
              description: 'Complete guide to exploring career options',
              type: ResourceType.article,
              url: 'https://www.careerexploration.com/guide',
              provider: 'Career Explorer',
              isFree: true,
            ),
          ],
        ),
      ],
    );
  }

  void dispose() {
    _client.close();
  }
}
