import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service for fetching open source study materials and resources
class OpenSourceStudyService {
  static const Duration _timeout = Duration(seconds: 10);
  final http.Client _client = http.Client();

  /// Get comprehensive study materials for a specific subject or career path
  Future<Map<String, dynamic>> getStudyMaterials(String subject, {String? stream, String? grade}) async {
    print('📚 Fetching open source study materials for $subject');
    
    try {
      // Priority 1: Government-approved resources (NCERT, DIKSHA)
      final governmentResources = await _getGovernmentResources(subject, grade: grade);
      
      // Priority 2: Open source educational platforms
      final openSourceResources = await _getOpenSourcePlatforms(subject, stream: stream);
      
      // Priority 3: Free video content
      final videoResources = await _getVideoResources(subject);
      
      // Priority 4: GitHub educational repositories
      final githubResources = await _getGitHubEducationalRepos(subject);
      
      return {
        'government_resources': governmentResources,
        'open_source_platforms': openSourceResources,
        'video_resources': videoResources,
        'github_resources': githubResources,
        'total_resources': _countTotalResources([
          governmentResources,
          openSourceResources,
          videoResources,
          githubResources,
        ]),
        'last_updated': DateTime.now().toIso8601String(),
        'data_sources': [
          'NCERT Official',
          'DIKSHA Platform',
          'Khan Academy',
          'MIT OpenCourseWare',
          'FreeCodeCamp',
          'GitHub Educational',
          'Wikipedia',
          'Coursera (Free)',
          'edX (Free)',
        ],
      };
    } catch (e) {
      print('❌ Error fetching study materials: $e');
      return _getFallbackStudyMaterials(subject);
    }
  }

  /// Get government-approved educational resources (NCERT, DIKSHA)
  Future<List<Map<String, dynamic>>> _getGovernmentResources(String subject, {String? grade}) async {
    print('🏛️ Fetching government resources for $subject');
    
    final resources = <Map<String, dynamic>>[];
    
    // NCERT Resources
    final ncertResources = _getNCERTResources(subject, grade);
    resources.addAll(ncertResources);
    
    // DIKSHA Platform Resources
    final dikshaResources = _getDIKSHAResources(subject, grade);
    resources.addAll(dikshaResources);
    
    // Other Government Resources
    final otherGovResources = _getOtherGovernmentResources(subject);
    resources.addAll(otherGovResources);
    
    return resources;
  }

  List<Map<String, dynamic>> _getNCERTResources(String subject, String? grade) {
    final gradeLevel = grade ?? '10th';
    final subjectLower = subject.toLowerCase();
    
    final ncertMap = {
      'mathematics': {
        'url': 'https://ncert.nic.in/textbook.php?kemh1=0-16',
        'chapters': ['Real Numbers', 'Polynomials', 'Linear Equations', 'Quadratic Equations'],
      },
      'science': {
        'url': 'https://ncert.nic.in/textbook.php?jess1=0-10',
        'chapters': ['Light', 'Electricity', 'Metals and Non-metals', 'Life Processes'],
      },
      'physics': {
        'url': 'https://ncert.nic.in/textbook.php?leph1=0-15',
        'chapters': ['Mechanics', 'Thermodynamics', 'Optics', 'Electricity'],
      },
      'chemistry': {
        'url': 'https://ncert.nic.in/textbook.php?lech1=0-16',
        'chapters': ['Periodic Table', 'Chemical Bonding', 'Acids and Bases', 'Organic Chemistry'],
      },
      'biology': {
        'url': 'https://ncert.nic.in/textbook.php?lebo1=0-22',
        'chapters': ['Life Processes', 'Heredity', 'Natural Resources', 'Evolution'],
      },
      'history': {
        'url': 'https://ncert.nic.in/textbook.php?jess2=0-10',
        'chapters': ['Ancient India', 'Medieval India', 'Modern India', 'World History'],
      },
      'economics': {
        'url': 'https://ncert.nic.in/textbook.php?leel1=0-8',
        'chapters': ['Development', 'Money and Credit', 'Globalization', 'Consumer Rights'],
      },
    };
    
    final subjectData = ncertMap[subjectLower];
    if (subjectData == null) return [];
    
    return [
      {
        'title': 'NCERT ${subject.substring(0, 1).toUpperCase()}${subject.substring(1)} Textbook',
        'description': 'Official NCERT textbook for $gradeLevel $subject',
        'url': subjectData['url'],
        'type': 'textbook',
        'provider': 'NCERT',
        'language': 'English/Hindi',
        'chapters': subjectData['chapters'],
        'grade': gradeLevel,
        'free': true,
        'verified': true,
        'rating': 4.8,
      }
    ];
  }

  List<Map<String, dynamic>> _getDIKSHAResources(String subject, String? grade) {
    return [
      {
        'title': 'DIKSHA $subject Resources',
        'description': 'Digital learning content from Government of India',
        'url': 'https://diksha.gov.in/explore-course',
        'type': 'digital_content',
        'provider': 'DIKSHA - Ministry of Education',
        'language': 'Multiple Indian Languages',
        'features': ['Video Lessons', 'Interactive Content', 'Assessments', 'Offline Access'],
        'grade': grade ?? 'All',
        'free': true,
        'verified': true,
        'rating': 4.6,
      }
    ];
  }

  List<Map<String, dynamic>> _getOtherGovernmentResources(String subject) {
    return [
      {
        'title': 'SWAYAM Online Courses',
        'description': 'Free online courses by Government of India',
        'url': 'https://swayam.gov.in',
        'type': 'online_course',
        'provider': 'Ministry of Education, Govt of India',
        'language': 'English/Hindi',
        'features': ['Certificate Courses', 'Credit Transfer', 'Expert Faculty'],
        'free': true,
        'verified': true,
        'rating': 4.5,
      },
      {
        'title': 'e-PG Pathshala',
        'description': 'Postgraduate level e-content in multiple subjects',
        'url': 'https://epgp.inflibnet.ac.in',
        'type': 'academic_content',
        'provider': 'UGC',
        'language': 'English',
        'features': ['Research Papers', 'Video Lectures', 'Study Materials'],
        'free': true,
        'verified': true,
        'rating': 4.4,
      }
    ];
  }

  /// Get open source educational platforms
  Future<List<Map<String, dynamic>>> _getOpenSourcePlatforms(String subject, {String? stream}) async {
    print('🌍 Fetching open source platform resources for $subject');
    
    final platforms = <Map<String, dynamic>>[];
    
    // Khan Academy
    platforms.addAll(_getKhanAcademyResources(subject));
    
    // MIT OpenCourseWare
    platforms.addAll(_getMITOpenCourseWareResources(subject));
    
    // FreeCodeCamp (for technology subjects)
    if (_isTechnologySubject(subject)) {
      platforms.addAll(_getFreeCodeCampResources(subject));
    }
    
    // Coursera Free Courses
    platforms.addAll(_getCourseraFreeResources(subject));
    
    // edX Free Courses
    platforms.addAll(_getEdXFreeResources(subject));
    
    return platforms;
  }

  List<Map<String, dynamic>> _getKhanAcademyResources(String subject) {
    final khanMap = {
      'mathematics': {
        'url': 'https://www.khanacademy.org/math',
        'description': 'Comprehensive mathematics from basic arithmetic to calculus',
        'topics': ['Algebra', 'Geometry', 'Trigonometry', 'Calculus', 'Statistics'],
      },
      'science': {
        'url': 'https://www.khanacademy.org/science',
        'description': 'Physics, Chemistry, Biology with interactive exercises',
        'topics': ['Physics', 'Chemistry', 'Biology', 'Earth Science'],
      },
      'physics': {
        'url': 'https://www.khanacademy.org/science/physics',
        'description': 'Physics concepts from mechanics to quantum physics',
        'topics': ['Mechanics', 'Thermodynamics', 'Waves', 'Electricity', 'Modern Physics'],
      },
      'chemistry': {
        'url': 'https://www.khanacademy.org/science/chemistry',
        'description': 'Chemistry from basic atoms to organic chemistry',
        'topics': ['Atoms', 'Periodic Table', 'Chemical Bonds', 'Reactions', 'Organic Chemistry'],
      },
      'biology': {
        'url': 'https://www.khanacademy.org/science/biology',
        'description': 'Biology from cell structure to ecology',
        'topics': ['Cell Biology', 'Genetics', 'Evolution', 'Ecology', 'Human Biology'],
      },
      'economics': {
        'url': 'https://www.khanacademy.org/economics-finance-domain',
        'description': 'Economics and finance fundamentals',
        'topics': ['Microeconomics', 'Macroeconomics', 'Finance', 'Entrepreneurship'],
      },
    };
    
    final subjectData = khanMap[subject.toLowerCase()];
    if (subjectData == null) return [];
    
    return [
      {
        'title': 'Khan Academy ${subject.substring(0, 1).toUpperCase()}${subject.substring(1)}',
        'description': subjectData['description'],
        'url': subjectData['url'],
        'type': 'interactive_course',
        'provider': 'Khan Academy',
        'language': 'English (Hindi subtitles available)',
        'topics': subjectData['topics'],
        'features': ['Video Lessons', 'Practice Exercises', 'Progress Tracking', 'Mastery Learning'],
        'free': true,
        'rating': 4.9,
      }
    ];
  }

  List<Map<String, dynamic>> _getMITOpenCourseWareResources(String subject) {
    final mitMap = {
      'mathematics': 'https://ocw.mit.edu/courses/mathematics/',
      'physics': 'https://ocw.mit.edu/courses/physics/',
      'chemistry': 'https://ocw.mit.edu/courses/chemistry/',
      'biology': 'https://ocw.mit.edu/courses/biology/',
      'computer_science': 'https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/',
      'economics': 'https://ocw.mit.edu/courses/economics/',
    };
    
    final url = mitMap[subject.toLowerCase()];
    if (url == null) return [];
    
    return [
      {
        'title': 'MIT OpenCourseWare - ${subject.substring(0, 1).toUpperCase()}${subject.substring(1)}',
        'description': 'Free MIT course materials and lecture notes',
        'url': url,
        'type': 'university_course',
        'provider': 'MIT',
        'language': 'English',
        'features': ['Lecture Notes', 'Problem Sets', 'Exams', 'Video Lectures'],
        'level': 'Advanced',
        'free': true,
        'rating': 4.8,
      }
    ];
  }

  List<Map<String, dynamic>> _getFreeCodeCampResources(String subject) {
    if (!_isTechnologySubject(subject)) return [];
    
    return [
      {
        'title': 'FreeCodeCamp - ${subject.substring(0, 1).toUpperCase()}${subject.substring(1)}',
        'description': 'Free coding bootcamp with hands-on projects',
        'url': 'https://www.freecodecamp.org/learn',
        'type': 'coding_bootcamp',
        'provider': 'FreeCodeCamp',
        'language': 'English',
        'features': ['Interactive Coding', 'Projects', 'Certifications', 'Community Support'],
        'topics': ['HTML/CSS', 'JavaScript', 'Python', 'Data Science', 'Machine Learning'],
        'free': true,
        'rating': 4.7,
      }
    ];
  }

  List<Map<String, dynamic>> _getCourseraFreeResources(String subject) {
    return [
      {
        'title': 'Coursera Free Courses - $subject',
        'description': 'Audit university courses for free',
        'url': 'https://www.coursera.org/courses?query=$subject',
        'type': 'university_course',
        'provider': 'Coursera (Multiple Universities)',
        'language': 'English (Subtitles available)',
        'features': ['Video Lectures', 'Reading Materials', 'Quizzes', 'Peer Discussions'],
        'note': 'Certificate requires payment, but content is free to audit',
        'free': true,
        'rating': 4.6,
      }
    ];
  }

  List<Map<String, dynamic>> _getEdXFreeResources(String subject) {
    return [
      {
        'title': 'edX Free Courses - $subject',
        'description': 'University-level courses from top institutions',
        'url': 'https://www.edx.org/search?q=$subject',
        'type': 'university_course',
        'provider': 'edX (Harvard, MIT, Berkeley)',
        'language': 'English',
        'features': ['Video Lectures', 'Interactive Labs', 'Assignments', 'Discussion Forums'],
        'note': 'Verified certificate requires payment, but content is free',
        'free': true,
        'rating': 4.7,
      }
    ];
  }

  /// Get video resources from multiple platforms
  Future<List<Map<String, dynamic>>> _getVideoResources(String subject) async {
    print('📹 Fetching video resources for $subject');
    
    return [
      {
        'title': 'YouTube Educational Channels - $subject',
        'description': 'Curated educational YouTube channels',
        'url': 'https://www.youtube.com/results?search_query=$subject+education',
        'type': 'video_content',
        'provider': 'YouTube',
        'language': 'Multiple',
        'channels': _getRecommendedYouTubeChannels(subject),
        'features': ['Free Access', 'Multiple Languages', 'Offline Download', 'Captions'],
        'free': true,
        'rating': 4.5,
      },
      {
        'title': 'TED-Ed $subject Videos',
        'description': 'Educational animated videos by TED-Ed',
        'url': 'https://ed.ted.com/lessons?category=subject-$subject',
        'type': 'educational_videos',
        'provider': 'TED-Ed',
        'language': 'English (Multiple subtitle languages)',
        'features': ['Animated Lessons', 'Quizzes', 'Discussion Questions', 'Lesson Plans'],
        'free': true,
        'rating': 4.8,
      }
    ];
  }

  List<String> _getRecommendedYouTubeChannels(String subject) {
    final channelMap = {
      'mathematics': ['3Blue1Brown', 'Khan Academy', 'Professor Leonard', 'PatrickJMT'],
      'physics': ['MinutePhysics', 'Physics Videos by Eugene', 'Michel van Biezen', 'Khan Academy'],
      'chemistry': ['Crash Course Chemistry', 'Professor Dave Explains', 'Khan Academy'],
      'biology': ['Crash Course Biology', 'Amoeba Sisters', 'Khan Academy', 'Bozeman Science'],
      'computer_science': ['CS50', 'freeCodeCamp', 'Traversy Media', 'The Net Ninja'],
      'economics': ['Marginal Revolution University', 'Khan Academy', 'Crash Course Economics'],
    };
    
    return channelMap[subject.toLowerCase()] ?? ['Khan Academy', 'Crash Course'];
  }

  /// Get GitHub educational repositories
  Future<List<Map<String, dynamic>>> _getGitHubEducationalRepos(String subject) async {
    print('📂 Fetching GitHub educational repositories for $subject');
    
    try {
      final response = await _client.get(
        Uri.parse('https://api.github.com/search/repositories?q=$subject+education+awesome+OR+curriculum+OR+course+sort:stars'),
        headers: {'Accept': 'application/vnd.github.v3+json'},
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final repos = data['items'] as List<dynamic>;
        
        return repos.take(5).map<Map<String, dynamic>>((repo) => {
          'title': repo['name'] ?? 'GitHub Repository',
          'description': repo['description'] ?? 'Educational repository for $subject',
          'url': repo['html_url'],
          'type': 'github_repository',
          'provider': 'GitHub',
          'language': 'Various',
          'stars': repo['stargazers_count'] ?? 0,
          'topics': repo['topics'] ?? [],
          'last_updated': repo['updated_at'],
          'free': true,
          'open_source': true,
        }).toList();
      }
    } catch (e) {
      print('Error fetching GitHub repos: $e');
    }
    
    return _getFallbackGitHubRepos(subject);
  }

  List<Map<String, dynamic>> _getFallbackGitHubRepos(String subject) {
    final repoMap = {
      'mathematics': [
        {
          'title': 'awesome-math',
          'description': 'Curated list of awesome mathematics resources',
          'url': 'https://github.com/rossant/awesome-math',
          'stars': 8000,
        }
      ],
      'computer_science': [
        {
          'title': 'computer-science',
          'description': 'Path to a free self-taught education in Computer Science',
          'url': 'https://github.com/ossu/computer-science',
          'stars': 170000,
        }
      ],
      'physics': [
        {
          'title': 'awesome-physics',
          'description': 'Curated list of awesome physics resources',
          'url': 'https://github.com/wbierbower/awesome-physics',
          'stars': 4000,
        }
      ],
    };
    
    final repos = repoMap[subject.toLowerCase()] ?? [];
    return repos.map<Map<String, dynamic>>((repo) => {
      ...repo,
      'type': 'github_repository',
      'provider': 'GitHub',
      'language': 'Various',
      'free': true,
      'open_source': true,
    }).toList();
  }

  bool _isTechnologySubject(String subject) {
    final techSubjects = ['computer_science', 'programming', 'technology', 'coding', 'software'];
    return techSubjects.contains(subject.toLowerCase());
  }

  int _countTotalResources(List<List<Map<String, dynamic>>> resourceLists) {
    return resourceLists.fold(0, (sum, list) => sum + list.length);
  }

  Map<String, dynamic> _getFallbackStudyMaterials(String subject) {
    return {
      'government_resources': _getNCERTResources(subject, '10th'),
      'open_source_platforms': _getKhanAcademyResources(subject),
      'video_resources': [],
      'github_resources': [],
      'total_resources': 2,
      'last_updated': DateTime.now().toIso8601String(),
      'note': 'Limited resources available - showing fallback content',
    };
  }

  void dispose() {
    _client.close();
  }
}