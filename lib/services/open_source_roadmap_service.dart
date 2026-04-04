import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_app/models/roadmap.dart';
import 'package:flutter_app/services/free_educational_api_service.dart';

class OpenSourceRoadmapService {
  static final OpenSourceRoadmapService _instance = OpenSourceRoadmapService._internal();
  factory OpenSourceRoadmapService() => _instance;
  OpenSourceRoadmapService._internal();

  final http.Client _client = http.Client();
  final FreeEducationalApiService _educationalApiService = FreeEducationalApiService();
  static const Duration _timeout = Duration(seconds: 30);

  // Open Source Educational APIs (Free)
  static const String _githubApiUrl = 'https://api.github.com';
  static const String _freeCodeCampUrl = 'https://www.freecodecamp.org/api';
  static const String _khanAcademyUrl = 'https://www.khanacademy.org/api/v1';

  /// Gets roadmap from GitHub open source repositories
  Future<Roadmap> getOpenSourceRoadmap(String careerPath, int durationMonths) async {
    print('🔄 Fetching open source roadmap for $careerPath ($durationMonths months)');
    
    try {
      // Try to fetch from developer-roadmap repository
      final githubRoadmap = await _fetchGitHubRoadmap(careerPath, durationMonths);
      if (githubRoadmap != null) {
        print('✅ Successfully fetched GitHub roadmap');
        return githubRoadmap;
      }

      // Fallback to curated open source curriculum
      print('📚 Using curated open source curriculum');
      return _getOpenSourceCurriculum(careerPath, durationMonths);
    } catch (e) {
      print('❌ Error fetching open source roadmap: $e');
      return _getOpenSourceCurriculum(careerPath, durationMonths);
    }
  }

  /// Fetches roadmap from GitHub developer-roadmap repository
  Future<Roadmap?> _fetchGitHubRoadmap(String careerPath, int durationMonths) async {
    try {
      // Map career paths to GitHub roadmap types
      final roadmapMapping = {
        'technology': 'frontend',
        '10th': 'backend', // Structured learning
        '12th': 'fullstack',
        'jee': 'backend',
        'neet': 'qa', // Systematic approach
        'govt': 'devops', // Process-oriented
        'ssc': 'qa',
        'upsc': 'devops',
        'banking': 'backend',
        'railway': 'devops',
        'defense': 'devops',
        'teaching': 'frontend',
        'police': 'qa',
        'professional': 'fullstack',
      };

      final roadmapType = roadmapMapping[careerPath] ?? 'frontend';
      
      // Fetch from kamranahmedse/developer-roadmap (most popular roadmap repo)
      final response = await _client.get(
        Uri.parse('$_githubApiUrl/repos/kamranahmedse/developer-roadmap/contents/src/data/roadmaps/$roadmapType/$roadmapType.md'),
        headers: {'Accept': 'application/vnd.github.v3+json'},
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final content = utf8.decode(base64.decode(data['content']));
        return _parseGitHubContent(content, careerPath, durationMonths);
      }
    } catch (e) {
      print('GitHub API error: $e');
    }
    
    return null;
  }

  /// Parses GitHub markdown content into roadmap
  Roadmap _parseGitHubContent(String content, String careerPath, int durationMonths) {
    final lines = content.split('\n');
    final phases = <RoadmapPhase>[];
    
    String currentPhase = '';
    List<String> currentSkills = [];
    int phaseIndex = 0;

    for (final line in lines) {
      if (line.startsWith('##') && !line.startsWith('###')) {
        // New phase found
        if (currentPhase.isNotEmpty && currentSkills.isNotEmpty) {
          phases.add(_createPhase(currentPhase, currentSkills, phaseIndex, durationMonths));
          phaseIndex++;
        }
        currentPhase = line.replaceAll(RegExp(r'^##\s*'), '').trim();
        currentSkills = [];
      } else if (line.startsWith('-') || line.startsWith('*')) {
        // Skill item
        final skill = line.replaceAll(RegExp(r'^[-*]\s*'), '').trim();
        if (skill.isNotEmpty && !skill.startsWith('[')) {
          currentSkills.add(skill);
        }
      }
    }

    // Add final phase
    if (currentPhase.isNotEmpty && currentSkills.isNotEmpty) {
      phases.add(_createPhase(currentPhase, currentSkills, phaseIndex, durationMonths));
    }

    // Limit phases based on duration
    final maxPhases = _getMaxPhases(durationMonths);
    final finalPhases = phases.take(maxPhases).toList();

    return _createRoadmap(finalPhases, careerPath, durationMonths);
  }

  /// Creates a phase from parsed data
  RoadmapPhase _createPhase(String title, List<String> skills, int index, int durationMonths) {
    final maxPhases = _getMaxPhases(durationMonths);
    final weeksPerPhase = (durationMonths * 4.33 / maxPhases).round().clamp(2, 12);
    
    return RoadmapPhase(
      id: 'github_phase_${index + 1}',
      title: _cleanTitle(title),
      description: 'Master ${_cleanTitle(title)} concepts and implementation',
      duration: weeksPerPhase,
      order: index + 1,
      milestones: _generateMilestones(skills.take(4).toList(), title),
      skills: skills.take(8).toList(),
      resources: _generateResources(title),
    );
  }

  /// Gets curated open source curriculum when APIs fail
  Roadmap _getOpenSourceCurriculum(String careerPath, int durationMonths) {
    print('📖 Generating curriculum for $careerPath');
    
    final curriculumData = _getCurriculumData(careerPath);
    final phases = <RoadmapPhase>[];
    final maxPhases = _getMaxPhases(durationMonths);
    final weeksPerPhase = (durationMonths * 4.33 / maxPhases).round().clamp(2, 12);

    for (int i = 0; i < curriculumData.length && i < maxPhases; i++) {
      final phaseData = curriculumData[i];
      phases.add(RoadmapPhase(
        id: 'curriculum_phase_${i + 1}',
        title: phaseData['title'] as String,
        description: phaseData['description'] as String,
        duration: weeksPerPhase,
        order: i + 1,
        milestones: _generateMilestones(phaseData['skills'] as List<String>, phaseData['title'] as String),
        skills: phaseData['skills'] as List<String>,
        resources: _generateResources(phaseData['title'] as String),
      ));
    }

    return _createRoadmap(phases, careerPath, durationMonths);
  }

  /// Gets curriculum data for different career paths
  List<Map<String, dynamic>> _getCurriculumData(String careerPath) {
    final curriculums = {
      '10th': [
        {
          'title': 'Mathematics Mastery',
          'description': 'Complete 10th Mathematics following NCERT curriculum',
          'skills': ['Real Numbers', 'Polynomials', 'Linear Equations', 'Quadratic Equations', 'Arithmetic Progressions', 'Coordinate Geometry', 'Trigonometry', 'Statistics']
        },
        {
          'title': 'Science Foundation',
          'description': 'Physics, Chemistry, and Biology concepts',
          'skills': ['Light Reflection Refraction', 'Electricity', 'Acids Bases Salts', 'Metals Non-metals', 'Life Processes', 'Heredity Evolution']
        },
        {
          'title': 'Language & Communication',
          'description': 'English language skills and literature',
          'skills': ['Reading Comprehension', 'Grammar Usage', 'Writing Skills', 'Literature Analysis', 'Vocabulary Building']
        },
        {
          'title': 'Social Studies',
          'description': 'History, Geography, Political Science and Economics',
          'skills': ['Nationalism in Europe', 'Resources Development', 'Power Sharing', 'Development Economics']
        }
      ],
      'technology': [
        {
          'title': 'Programming Fundamentals',
          'description': 'Core programming concepts and syntax',
          'skills': ['Variables Data Types', 'Control Structures', 'Functions', 'Object Oriented Programming', 'Data Structures', 'Algorithms']
        },
        {
          'title': 'Web Development',
          'description': 'Frontend and backend web technologies',
          'skills': ['HTML CSS', 'JavaScript', 'React Vue Angular', 'Node.js', 'Express', 'Database Integration']
        },
        {
          'title': 'Software Engineering',
          'description': 'Professional development practices',
          'skills': ['Version Control Git', 'Testing', 'API Development', 'Authentication', 'Security', 'Performance Optimization']
        },
        {
          'title': 'DevOps & Deployment',
          'description': 'Deployment and infrastructure management',
          'skills': ['Cloud Services AWS Azure', 'Docker Containers', 'CI CD Pipelines', 'Monitoring', 'Scaling']
        }
      ],
      'jee': [
        {
          'title': 'Mathematics Excellence',
          'description': 'Advanced mathematics for JEE',
          'skills': ['Algebra', 'Trigonometry', 'Coordinate Geometry', 'Calculus', 'Vectors', '3D Geometry', 'Probability Statistics']
        },
        {
          'title': 'Physics Mastery',
          'description': 'Complete physics syllabus',
          'skills': ['Mechanics', 'Thermodynamics', 'Waves Oscillations', 'Electromagnetism', 'Optics', 'Modern Physics']
        },
        {
          'title': 'Chemistry Proficiency',
          'description': 'Organic, Inorganic, and Physical chemistry',
          'skills': ['Physical Chemistry', 'Organic Chemistry', 'Inorganic Chemistry', 'Chemical Bonding', 'Thermodynamics']
        }
      ],
      'upsc': [
        {
          'title': 'General Studies Foundation',
          'description': 'Comprehensive GS preparation',
          'skills': ['Ancient History', 'Medieval History', 'Modern History', 'Indian Geography', 'World Geography', 'Indian Polity', 'Economics']
        },
        {
          'title': 'Current Affairs & Analysis',
          'description': 'Current events and analysis',
          'skills': ['National Issues', 'International Relations', 'Government Schemes', 'Economic Survey', 'Monthly Current Affairs']
        },
        {
          'title': 'Mains Preparation',
          'description': 'Answer writing and essay skills',
          'skills': ['Essay Writing', 'Answer Writing', 'Ethics Case Studies', 'Optional Subject', 'Previous Year Analysis']
        }
      ]
    };

    // Use technology as default if career path not found
    return curriculums[careerPath] ?? curriculums['technology']!;
  }

  // Helper methods
  int _getMaxPhases(int durationMonths) {
    if (durationMonths <= 3) return 3;
    if (durationMonths <= 6) return 4;
    if (durationMonths <= 12) return 6;
    return 8;
  }

  String _cleanTitle(String title) {
    return title.replaceAll(RegExp(r'[^\w\s]'), '').trim();
  }

  List<RoadmapMilestone> _generateMilestones(List<String> skills, String phaseTitle) {
    return skills.take(3).map((skill) => RoadmapMilestone(
      id: 'milestone_${skill.hashCode.abs()}',
      title: 'Complete $skill',
      description: 'Master $skill concepts and practical implementation',
      type: MilestoneType.learning,
      points: 15,
      deliverables: ['Theory Understanding', 'Practical Exercises', 'Project Implementation'],
    )).toList();
  }

  List<Resource> _generateResources(String phaseTitle) {
    return [
      Resource(
        id: 'fcc_${phaseTitle.hashCode.abs()}',
        title: 'FreeCodeCamp - $phaseTitle',
        description: 'Free interactive coding tutorials and projects',
        type: ResourceType.course,
        url: 'https://www.freecodecamp.org/',
        provider: 'FreeCodeCamp',
        isFree: true,
        rating: 4.8,
      ),
      Resource(
        id: 'khan_${phaseTitle.hashCode.abs()}',
        title: 'Khan Academy - $phaseTitle',
        description: 'Free educational videos and exercises',
        type: ResourceType.video,
        url: 'https://www.khanacademy.org/',
        provider: 'Khan Academy',
        isFree: true,
        rating: 4.7,
      ),
      Resource(
        id: 'github_${phaseTitle.hashCode.abs()}',
        title: 'GitHub Learning Resources',
        description: 'Open source projects and learning materials',
        type: ResourceType.practice,
        url: 'https://github.com/topics/${phaseTitle.toLowerCase().replaceAll(' ', '-')}',
        provider: 'GitHub Community',
        isFree: true,
        rating: 4.6,
      ),
      Resource(
        id: 'edx_${phaseTitle.hashCode.abs()}',
        title: 'edX Free Courses - $phaseTitle',
        description: 'University-level free courses',
        type: ResourceType.course,
        url: 'https://www.edx.org/search?q=${phaseTitle.toLowerCase()}',
        provider: 'edX',
        isFree: true,
        rating: 4.5,
      ),
      Resource(
        id: 'mit_${phaseTitle.hashCode.abs()}',
        title: 'MIT OpenCourseWare - $phaseTitle',
        description: 'Free MIT course materials and lectures',
        type: ResourceType.course,
        url: 'https://ocw.mit.edu/',
        provider: 'MIT',
        isFree: true,
        rating: 4.9,
      ),
    ];
  }

  Roadmap _createRoadmap(List<RoadmapPhase> phases, String careerPath, int durationMonths) {
    final now = DateTime.now();
    
    return Roadmap(
      id: 'opensource_${careerPath}_${durationMonths}m_${now.millisecondsSinceEpoch}',
      careerPath: careerPath,
      title: _getTitle(careerPath, durationMonths),
      description: _getDescription(careerPath),
      estimatedDuration: durationMonths,
      difficultyLevel: _getDifficulty(durationMonths),
      phases: phases,
      prerequisites: _getPrerequisites(careerPath),
      outcomes: _getOutcomes(careerPath),
      certifications: _getCertifications(careerPath),
      averageSalary: _getSalary(careerPath),
      jobOutlook: _getJobOutlook(careerPath),
      createdAt: now,
      updatedAt: now,
    );
  }

  String _getTitle(String careerPath, int durationMonths) {
    final titles = {
      '10th': '10th Board Exam Complete Preparation',
      'technology': 'Full-Stack Developer Roadmap',
      'jee': 'JEE Main & Advanced Preparation',
      'upsc': 'UPSC Civil Services Complete Guide',
    };
    return '${titles[careerPath] ?? 'Career Development Path'} - $durationMonths Month Plan';
  }

  String _getDescription(String careerPath) {
    final descriptions = {
      '10th': 'Comprehensive NCERT-based curriculum with board exam focus using open source educational resources.',
      'technology': 'Complete technology learning path using FreeCodeCamp, GitHub, and open source projects.',
      'jee': 'JEE preparation using Khan Academy, open source study materials, and practice resources.',
      'upsc': 'UPSC Civil Services preparation using government resources and open educational content.',
    };
    return descriptions[careerPath] ?? 'Structured learning path using open source educational resources and community-driven content.';
  }

  String _getDifficulty(int months) => months <= 3 ? 'Intensive' : months <= 6 ? 'Moderate' : 'Comprehensive';
  
  List<String> _getPrerequisites(String path) => ['Basic knowledge', 'Internet access', 'Learning commitment'];
  
  List<String> _getOutcomes(String path) => ['Industry readiness', 'Practical skills', 'Project portfolio'];
  
  List<String> _getCertifications(String path) => ['Completion certificates', 'Portfolio projects'];
  
  double _getSalary(String path) => 50000.0;
  
  String _getJobOutlook(String path) => 'Good growth prospects';
}