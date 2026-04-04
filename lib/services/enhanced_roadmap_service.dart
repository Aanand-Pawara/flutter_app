import 'package:flutter_app/models/roadmap.dart';

/// Enhanced Roadmap Service that generates comprehensive, ChatGPT-like structured roadmaps
class EnhancedRoadmapService {
  static final EnhancedRoadmapService _instance =
      EnhancedRoadmapService._internal();
  factory EnhancedRoadmapService() => _instance;
  EnhancedRoadmapService._internal();

  /// Generates a comprehensive, well-structured roadmap similar to ChatGPT responses
  Future<Roadmap> generateComprehensiveRoadmap({
    required String careerPath,
    required int durationMonths,
    String? currentLevel,
    List<String>? existingSkills,
    int? timeCommitment,
  }) async {
    print(
      '🎯 Generating comprehensive ${careerPath.toUpperCase()} roadmap for $durationMonths months',
    );

    final roadmapData = _getComprehensiveRoadmapData(careerPath);
    final phases = _generateComprehensivePhases(
      careerPath,
      durationMonths,
      roadmapData,
    );

    return Roadmap(
      id: 'enhanced_${careerPath}_${durationMonths}m_${DateTime.now().millisecondsSinceEpoch}',
      careerPath: careerPath,
      title: _getDurationSpecificTitle(
        roadmapData['title'] as String,
        durationMonths,
      ),
      description: _getDurationSpecificDescription(
        roadmapData['description'] as String,
        durationMonths,
      ),
      estimatedDuration: durationMonths,
      difficultyLevel: _getDifficultyLevel(durationMonths),
      phases: phases,
      prerequisites: _getDurationSpecificPrerequisites(
        List<String>.from(roadmapData['prerequisites']),
        durationMonths,
      ),
      outcomes: _getDurationSpecificOutcomes(
        List<String>.from(roadmapData['outcomes']),
        durationMonths,
      ),
      certifications: List<String>.from(roadmapData['certifications']),
      averageSalary: roadmapData['averageSalary'] as double,
      jobOutlook: roadmapData['jobOutlook'] as String,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> _getComprehensiveRoadmapData(String careerPath) {
    switch (careerPath.toLowerCase()) {
      case '10th':
        return {
          'title': '10th Standard Complete Academic Excellence Program',
          'description': '''
A comprehensive and systematic approach to mastering the 10th standard curriculum. This roadmap covers all NCERT subjects with detailed study plans, exam strategies, and skill development activities. Designed to ensure not just board exam success but also strong foundation building for future academic pursuits.

📚 **What This Program Covers:**
• Complete NCERT curriculum across all subjects
• Advanced problem-solving techniques and shortcuts
• Board exam specific preparation and strategy
• Stream selection guidance and career counseling
• Study skills and time management techniques
• Mock tests and performance analysis

🎯 **Learning Methodology:**
This program follows a progressive learning approach with regular assessments, practical applications, and concept reinforcement through varied teaching methods including visual aids, interactive sessions, and peer learning.
          ''',
          'prerequisites': [
            '9th grade completion with basic understanding',
            'Regular study schedule of 4-6 hours daily',
            'Access to NCERT textbooks and study materials',
            'Basic computer knowledge for online resources',
            'Commitment to consistent practice and revision',
          ],
          'outcomes': [
            'Score 90%+ in board examinations across all subjects',
            'Master advanced problem-solving techniques in Mathematics and Science',
            'Develop excellent English communication and writing skills',
            'Gain comprehensive understanding of Social Science concepts',
            'Build strong analytical and critical thinking abilities',
            'Acquire effective study habits and time management skills',
            'Make informed decisions about stream selection for 11th grade',
            'Develop confidence for competitive exam preparations',
            'Create a strong academic foundation for higher studies',
            'Enhance presentation and project work capabilities',
          ],
          'certifications': [
            'CBSE 10th Board Certificate with Distinction',
            'Subject-wise Excellence Certificates',
            'Study Skills Proficiency Certificate',
            'Career Guidance Completion Certificate',
          ],
          'averageSalary': 0.0,
          'jobOutlook':
              'Gateway to Science, Commerce, or Arts streams with multiple career opportunities',
        };

      case 'technology':
        return {
          'title': 'Complete Full-Stack Technology Mastery Program',
          'description': '''
A comprehensive technology career roadmap designed to transform you from a beginner to an industry-ready full-stack developer. This program covers modern web technologies, software engineering principles, and practical project development.

🚀 **Program Highlights:**
• Master both frontend and backend development
• Learn industry-standard tools and frameworks
• Build a professional portfolio with real projects
• Understand software engineering best practices
• Get hands-on experience with cloud technologies
• Develop problem-solving and algorithmic thinking

💡 **Learning Approach:**
Project-based learning with hands-on coding, code reviews, and industry mentorship. Each phase includes theoretical concepts, practical implementation, and real-world project development.

🏆 **Career Preparation:**
Interview preparation, resume building, and job placement assistance included.
          ''',
          'prerequisites': [
            'Basic computer literacy and internet access',
            'High school mathematics understanding',
            'Logical thinking and problem-solving interest',
            '20-25 hours per week time commitment',
            'Willingness to learn and adapt to new technologies',
          ],
          'outcomes': [
            'Build modern, responsive web applications from scratch',
            'Master JavaScript, React, Node.js, and database technologies',
            'Understand software architecture and design patterns',
            'Develop RESTful APIs and integrate third-party services',
            'Implement authentication, security, and performance optimization',
            'Use version control (Git) and collaboration tools effectively',
            'Deploy applications to cloud platforms (AWS, Heroku, Netlify)',
            'Write clean, maintainable, and well-documented code',
            'Build a professional portfolio showcasing diverse projects',
            'Prepare for technical interviews and coding challenges',
            'Network with industry professionals and potential employers',
            'Contribute to open-source projects and tech communities',
          ],
          'certifications': [
            'Full-Stack Web Developer Certificate',
            'AWS Cloud Practitioner Certification',
            'Google Analytics Certified',
            'MongoDB Developer Certificate',
            'GitHub Portfolio Completion Badge',
          ],
          'averageSalary': 800000.0,
          'jobOutlook':
              'Excellent - 22% growth expected in software development roles',
        };

      case 'jee':
        return {
          'title': 'JEE Main & Advanced Complete Mastery Program',
          'description': '''
A strategic and comprehensive preparation program for JEE Main and Advanced examinations. This roadmap is designed by analyzing successful student patterns and includes advanced problem-solving techniques, time management strategies, and mental preparation.

🎯 **Program Structure:**
• Systematic coverage of Physics, Chemistry, and Mathematics
• Advanced problem-solving techniques and shortcuts
• Regular mock tests with detailed analysis
• Doubt clearing sessions and concept reinforcement
• Stress management and exam psychology preparation

📈 **Success Strategy:**
Focus on conceptual clarity, regular practice, and strategic exam approach. Includes previous year analysis, trend identification, and rank prediction strategies.

🏅 **Target Achievement:**
Secure admission in top IITs, NITs, and premier engineering colleges.
          ''',
          'prerequisites': [
            '12th Science (PCM) with strong mathematical foundation',
            'Basic understanding of Physics and Chemistry concepts',
            'Minimum 6-8 hours daily study commitment',
            'Access to standard JEE preparation books and materials',
            'Mental preparedness for intensive study schedule',
          ],
          'outcomes': [
            'Score 250+ in JEE Main and qualify for JEE Advanced',
            'Master advanced concepts in Calculus, Algebra, and Geometry',
            'Solve complex Physics problems with conceptual clarity',
            'Excel in Organic, Inorganic, and Physical Chemistry',
            'Develop time management skills for competitive exams',
            'Build problem-solving speed and accuracy',
            'Secure admission in top-tier engineering colleges',
            'Gain strong foundation for engineering studies',
            'Develop analytical and logical reasoning abilities',
            'Master exam strategies and psychological preparation',
          ],
          'certifications': [
            'JEE Main Qualification Certificate',
            'JEE Advanced Rank Certificate',
            'Engineering College Admission Letter',
            'Mathematics Olympiad Participation',
            'Physics and Chemistry Excellence Awards',
          ],
          'averageSalary': 1200000.0,
          'jobOutlook':
              'Excellent - High demand for engineering graduates from premier institutes',
        };

      case 'neet':
        return {
          'title': 'NEET Complete Medical Entrance Mastery Program',
          'description': '''
Comprehensive NEET preparation program designed for medical aspirants. This roadmap covers Physics, Chemistry, and Biology with special emphasis on conceptual understanding and application-based problem solving.

🏥 **Medical Career Focus:**
• Complete NCERT-based preparation with advanced concepts
• Medical terminology and application-based learning
• Regular practice with NEET-pattern questions
• Biology focus with detailed diagrams and case studies
• Current medical research and healthcare awareness

🧬 **Scientific Approach:**
Emphasis on understanding biological processes, chemical reactions, and physical principles as they apply to medical science and human body systems.

🎖️ **Achievement Goal:**
Secure MBBS/BDS admission in government medical colleges.
          ''',
          'prerequisites': [
            '12th Science (PCB) with Biology as main subject',
            'Strong foundation in Chemistry and Physics',
            'Interest in medical sciences and healthcare',
            '8-10 hours daily dedicated study time',
            'Access to NCERT textbooks and reference materials',
          ],
          'outcomes': [
            'Score 600+ in NEET and secure government medical college seat',
            'Master human anatomy, physiology, and biological processes',
            'Excel in Organic Chemistry with reaction mechanisms',
            'Understand Physics applications in medical equipment',
            'Develop medical terminology and scientific vocabulary',
            'Build strong foundation for MBBS curriculum',
            'Gain knowledge of current medical research and innovations',
            'Develop empathy and healthcare service mindset',
            'Master time management for lengthy examinations',
            'Prepare for medical college admission counseling process',
          ],
          'certifications': [
            'NEET Qualification Certificate',
            'Medical College Admission Letter',
            'Biology Excellence Award',
            'Medical Terminology Proficiency',
            'Healthcare Awareness Certificate',
          ],
          'averageSalary': 1000000.0,
          'jobOutlook':
              'Excellent - Healthcare sector experiencing significant growth',
        };

      case 'govt':
      case 'upsc':
        return {
          'title': 'UPSC Civil Services Complete Preparation Program',
          'description': '''
Comprehensive preparation program for UPSC Civil Services examination covering Prelims, Mains, and Personality Test. This roadmap is designed for serious aspirants committed to public service.

🏛️ **Program Coverage:**
• Complete General Studies syllabus with current affairs integration
• Optional subject mastery with answer writing practice
• Essay writing and ethical case study analysis
• Interview preparation and personality development
• Administrative awareness and governance understanding

📚 **Holistic Approach:**
Focus on developing analytical thinking, administrative acumen, and leadership qualities required for civil services.

🇮🇳 **Service Commitment:**
Preparation not just for exam success but for effective public service delivery.
          ''',
          'prerequisites': [
            'Graduate degree from recognized university',
            'Age between 21-32/35 years (category-wise)',
            'Strong foundation in Indian History, Geography, and Polity',
            'Regular newspaper reading and current affairs awareness',
            '10-12 hours daily study commitment for 12-18 months',
          ],
          'outcomes': [
            'Clear UPSC Prelims with 110+ score and Mains with 900+ marks',
            'Develop comprehensive understanding of Indian governance',
            'Master analytical writing and essay composition skills',
            'Build strong current affairs knowledge and analysis ability',
            'Develop administrative mindset and public policy understanding',
            'Excel in interview and personality test with confidence',
            'Secure IAS/IPS/IFS or other Group A service allocation',
            'Build leadership and decision-making capabilities',
            'Develop ethical reasoning and moral judgment skills',
            'Gain deep understanding of social issues and solutions',
          ],
          'certifications': [
            'UPSC Civil Services Final Selection',
            'IAS/IPS/IFS Service Allocation',
            'Public Administration Excellence Certificate',
            'Ethics and Integrity Assessment',
            'Leadership Development Program Completion',
          ],
          'averageSalary': 1500000.0,
          'jobOutlook':
              'Prestigious - Highest level of job security and societal respect',
        };

      default:
        return {
          'title': 'Professional Development Excellence Program',
          'description':
              'Comprehensive career advancement program designed for working professionals.',
          'prerequisites': ['Work experience', 'Professional qualification'],
          'outcomes': [
            'Career advancement',
            'Leadership skills',
            'Industry expertise',
          ],
          'certifications': ['Professional Excellence Certificate'],
          'averageSalary': 600000.0,
          'jobOutlook': 'Good growth prospects in chosen field',
        };
    }
  }

  List<RoadmapPhase> _generateComprehensivePhases(
    String careerPath,
    int durationMonths,
    Map<String, dynamic> roadmapData,
  ) {
    final phaseTemplates = _getDetailedPhaseTemplates(careerPath);
    final totalPhases = _calculateOptimalPhases(durationMonths);
    final intensity = _getDurationIntensity(durationMonths);

    print(
      '📊 Duration Analysis: $durationMonths months → $totalPhases phases ($intensity intensity)',
    );

    return List.generate(totalPhases, (index) {
      final template = phaseTemplates[index % phaseTemplates.length];
      final weeksPerPhase = _calculateWeeksPerPhase(
        durationMonths,
        totalPhases,
      );
      final adjustedTemplate = _adjustPhaseForDuration(
        template,
        durationMonths,
        intensity,
      );

      return RoadmapPhase(
        id: 'enhanced_phase_${index + 1}',
        title: adjustedTemplate['title'] as String,
        description: adjustedTemplate['description'] as String,
        duration: weeksPerPhase,
        order: index + 1,
        milestones: _generateDetailedMilestones(
          adjustedTemplate,
          index + 1,
          intensity,
        ),
        skills: List<String>.from(adjustedTemplate['skills']),
        resources: _generatePremiumResources(
          adjustedTemplate['title'] as String,
          careerPath,
        ),
      );
    });
  }

  List<Map<String, dynamic>> _getDetailedPhaseTemplates(String careerPath) {
    switch (careerPath.toLowerCase()) {
      case '10th':
        return [
          {
            'title': 'Foundation Building & Study System Setup',
            'description': '''
Establish a strong foundation across all subjects and develop effective study systems. This phase focuses on understanding NCERT curriculum structure, creating personalized study schedules, and building fundamental concepts in Mathematics, Science, and Languages.

Key Activities:
• Complete diagnostic assessment of current knowledge levels
• Create subject-wise study plans with realistic timelines  
• Master basic concepts in each subject with visual learning aids
• Establish daily routine and study environment optimization
• Begin regular practice with basic exercise problems
            ''',
            'skills': [
              'NCERT Textbook Navigation and Understanding',
              'Time Management and Study Planning',
              'Basic Mathematical Operations and Number Systems',
              'Scientific Method and Observation Skills',
              'English Grammar Fundamentals and Vocabulary',
              'Social Science Map Reading and Timeline Creation',
              'Note-taking and Summarization Techniques',
              'Self-Assessment and Progress Tracking',
            ],
          },
          {
            'title': 'Core Subject Mastery - Mathematics & Science',
            'description': '''
Deep dive into Mathematics and Science subjects with emphasis on conceptual understanding and problem-solving. Focus on building strong analytical skills and scientific temperament.

Advanced Topics Coverage:
• Advanced Algebra, Geometry, and Trigonometry applications
• Physics: Light, Electricity, and Magnetic Effects with practical understanding
• Chemistry: Acids, Bases, Metals, and Carbon Compounds with experiments
• Biology: Life Processes, Heredity, and Natural Resource Management
            ''',
            'skills': [
              'Advanced Mathematical Problem Solving',
              'Quadratic Equations and Arithmetic Progressions',
              'Coordinate Geometry and Trigonometric Applications',
              'Physics Numerical Problem Techniques',
              'Chemical Equation Balancing and Reactions',
              'Biological Process Understanding and Diagrams',
              'Scientific Calculator and Lab Equipment Usage',
              'Data Analysis and Graph Interpretation',
            ],
          },
          {
            'title': 'Language Excellence & Communication Development',
            'description': '''
Master English language skills including advanced grammar, literature analysis, creative writing, and presentation skills. Also strengthen Hindi/Regional language capabilities for comprehensive communication.

Communication Focus:
• Advanced English grammar with complex sentence structures
• Literature appreciation and analytical essay writing
• Creative writing including story, poem, and article composition  
• Public speaking and presentation skill development
• Hindi literature and advanced grammar concepts
            ''',
            'skills': [
              'Advanced English Grammar and Usage',
              'Literature Analysis and Critical Thinking',
              'Creative Writing and Composition Skills',
              'Public Speaking and Presentation Abilities',
              'Hindi/Regional Language Proficiency',
              'Comprehension and Interpretation Skills',
              'Vocabulary Enhancement Techniques',
              'Essay Writing and Article Composition',
            ],
          },
          {
            'title': 'Social Science Mastery & Current Affairs Integration',
            'description': '''
Comprehensive understanding of History, Geography, Political Science, and Economics with integration of current events and contemporary issues. Develop critical thinking about societal issues.

Contemporary Connections:
• Historical events connection with current political scenarios
• Geographical concepts application in environmental issues
• Economic principles understanding through current market trends
• Political processes awareness through current governance examples
            ''',
            'skills': [
              'Historical Analysis and Timeline Mastery',
              'Geographical Map Skills and Climate Understanding',
              'Political Process and Democratic Principles',
              'Economic Concepts and Market Understanding',
              'Current Affairs Analysis and Integration',
              'Critical Thinking and Opinion Formation',
              'Research Skills and Information Verification',
              'Cultural Awareness and Social Sensitivity',
            ],
          },
          {
            'title': 'Board Exam Excellence & Future Preparation',
            'description': '''
Intensive board exam preparation with mock tests, answer writing practice, and performance analysis. Simultaneously prepare for stream selection and future academic planning.

Exam Mastery:
• Board exam pattern analysis and strategy development
• Time management techniques for different question types
• Answer presentation skills and marking scheme understanding
• Stress management and exam psychology preparation
• Stream selection guidance based on interests and aptitude
            ''',
            'skills': [
              'Board Exam Strategy and Time Management',
              'Answer Writing Techniques and Presentation',
              'Mock Test Analysis and Improvement Planning',
              'Stress Management and Confidence Building',
              'Stream Selection Decision Making',
              'Future Academic Planning and Goal Setting',
              'Revision Techniques and Memory Enhancement',
              'Performance Analysis and Weak Area Improvement',
            ],
          },
        ];

      case 'technology':
        return [
          {
            'title': 'Programming Fundamentals & Problem-Solving Mastery',
            'description': '''
Build strong programming foundations with multiple languages and develop algorithmic thinking. Master data structures, algorithms, and software engineering principles through hands-on coding practice.

Core Programming Skills:
• Master Python fundamentals with object-oriented programming
• Learn JavaScript for web development and React basics
• Understand data structures (arrays, linked lists, stacks, queues)
• Practice algorithm design and complexity analysis
• Version control with Git and GitHub collaboration
• Development environment setup and debugging techniques
            ''',
            'skills': [
              'Python Programming and OOP Concepts',
              'JavaScript ES6+ and DOM Manipulation',
              'Data Structures Implementation and Usage',
              'Algorithm Design and Complexity Analysis',
              'Git Version Control and GitHub Workflow',
              'Debugging Techniques and Error Handling',
              'Code Documentation and Best Practices',
              'Problem-Solving and Logical Thinking',
            ],
          },
          {
            'title': 'Frontend Development & User Experience Design',
            'description': '''
Master modern frontend technologies and create responsive, interactive web applications. Learn design principles, user experience optimization, and modern JavaScript frameworks.

Frontend Expertise:
• HTML5 semantic markup and accessibility standards
• Advanced CSS3, Flexbox, Grid, and responsive design
• JavaScript frameworks: React with hooks and state management
• UI/UX design principles and user-centered design
• Frontend build tools and performance optimization
• Cross-browser compatibility and testing strategies
            ''',
            'skills': [
              'HTML5 Semantic Structure and Accessibility',
              'Advanced CSS3 and Responsive Web Design',
              'React Development with Hooks and Context',
              'UI/UX Design Principles and Prototyping',
              'Frontend Build Tools (Webpack, Vite, npm)',
              'Performance Optimization and SEO',
              'Cross-browser Testing and Debugging',
              'Design Systems and Component Libraries',
            ],
          },
          {
            'title': 'Backend Development & Database Management',
            'description': '''
Develop server-side applications, RESTful APIs, and database systems. Master backend technologies, authentication systems, and cloud integration for scalable applications.

Backend Mastery:
• Node.js and Express.js server development
• RESTful API design and GraphQL implementation
• Database design with SQL and NoSQL databases
• Authentication and authorization systems
• Cloud services integration (AWS, MongoDB Atlas)
• API security, testing, and documentation
            ''',
            'skills': [
              'Node.js and Express.js Server Development',
              'RESTful API Design and Implementation',
              'Database Design and Management (SQL/NoSQL)',
              'Authentication and Security Implementation',
              'Cloud Services Integration and Deployment',
              'API Testing and Documentation',
              'Server-side Performance Optimization',
              'Microservices Architecture Understanding',
            ],
          },
          {
            'title': 'Full-Stack Projects & Professional Development',
            'description': '''
Build complete full-stack applications and develop professional skills for industry readiness. Focus on project management, code quality, and career preparation.

Professional Skills:
• Complete e-commerce or social media application development
• DevOps basics: Docker, CI/CD pipelines, and monitoring
• Code quality tools: testing, linting, and code reviews
• Agile development methodology and team collaboration
• Portfolio development and technical writing
• Interview preparation and networking strategies
            ''',
            'skills': [
              'Full-Stack Application Architecture',
              'DevOps and Deployment Pipeline Setup',
              'Testing Strategies (Unit, Integration, E2E)',
              'Agile Development and Project Management',
              'Technical Writing and Documentation',
              'Portfolio Development and Personal Branding',
              'Interview Skills and Technical Communication',
              'Open Source Contribution and Networking',
            ],
          },
        ];

      case 'jee':
        return [
          {
            'title': 'Mathematical Foundation & Advanced Concepts',
            'description': '''
Master advanced mathematics concepts essential for JEE success. Focus on building strong foundation in Algebra, Geometry, and Calculus with problem-solving techniques.

Mathematical Excellence:
• Complex numbers and their applications in engineering
• Advanced coordinate geometry and analytical methods
• Differential and integral calculus with real-world applications
• Probability, statistics, and combinatorics for competitive exams
• Vector algebra and 3D geometry visualization
• Mathematical reasoning and proof techniques
            ''',
            'skills': [
              'Complex Numbers and De Moivre\'s Theorem',
              'Advanced Coordinate Geometry Techniques',
              'Differential and Integral Calculus Mastery',
              'Probability and Combinatorics Problem Solving',
              'Vector Algebra and 3D Geometry Applications',
              'Mathematical Proof and Reasoning Skills',
              'Trigonometric Identities and Applications',
              'Sequence, Series, and Limit Calculations',
            ],
          },
          {
            'title': 'Physics Mastery & Engineering Applications',
            'description': '''
Develop deep understanding of physics concepts with engineering applications. Master mechanics, electromagnetism, and modern physics through problem-solving and practical applications.

Physics Excellence:
• Classical mechanics with rotational dynamics and oscillations
• Thermodynamics and kinetic theory applications
• Wave optics and interference phenomena
• Electromagnetic induction and AC circuit analysis
• Modern physics: atomic structure and nuclear physics
• Physics laboratory techniques and error analysis
            ''',
            'skills': [
              'Classical Mechanics and Rotational Dynamics',
              'Thermodynamics and Heat Transfer Analysis',
              'Wave Optics and Interference Calculations',
              'Electromagnetic Theory and Circuit Analysis',
              'Modern Physics and Quantum Concepts',
              'Physics Problem-Solving Strategies',
              'Laboratory Techniques and Data Analysis',
              'Physics in Engineering Applications',
            ],
          },
          {
            'title': 'Chemistry Excellence & Industrial Applications',
            'description': '''
Master organic, inorganic, and physical chemistry with focus on industrial applications and engineering relevance. Develop analytical thinking and experimental skills.

Chemistry Mastery:
• Organic chemistry: reaction mechanisms and synthesis
• Inorganic chemistry: coordination compounds and metallurgy
• Physical chemistry: thermodynamics and chemical kinetics
• Electrochemistry and its industrial applications
• Environmental chemistry and green technology
• Chemical analysis and instrumentation techniques
            ''',
            'skills': [
              'Organic Reaction Mechanisms and Synthesis',
              'Inorganic Coordination Chemistry',
              'Physical Chemistry Calculations',
              'Electrochemistry and Industrial Processes',
              'Environmental Chemistry Applications',
              'Chemical Analysis and Instrumentation',
              'Green Chemistry and Sustainable Practices',
              'Chemistry in Materials Science',
            ],
          },
          {
            'title': 'JEE Strategy & Engineering Preparation',
            'description': '''
Intensive JEE-specific preparation with mock tests, time management, and engineering career guidance. Focus on exam psychology and strategic problem-solving.

JEE Excellence:
• JEE Main and Advanced pattern analysis and strategy
• Time management techniques for competitive exams
• Previous year question analysis and trend identification
• Engineering college and branch selection guidance
• Interview skills for engineering college admissions
• Engineering career paths and industry awareness
            ''',
            'skills': [
              'JEE Exam Strategy and Time Management',
              'Competitive Exam Psychology and Stress Management',
              'Problem-Solving Speed and Accuracy',
              'Engineering College and Branch Selection',
              'Technical Interview and Communication Skills',
              'Engineering Career Planning and Industry Trends',
              'Mock Test Analysis and Improvement Strategies',
              'Engineering Ethics and Professional Development',
            ],
          },
        ];

      default:
        return [
          {
            'title': 'Foundation and Assessment',
            'description':
                'Build strong foundational knowledge and assess current skill levels.',
            'skills': [
              'Basic concepts',
              'Assessment skills',
              'Learning strategies',
            ],
          },
          {
            'title': 'Skill Development',
            'description': 'Develop core competencies and practical skills.',
            'skills': [
              'Core skills',
              'Practical application',
              'Problem solving',
            ],
          },
          {
            'title': 'Advanced Application',
            'description':
                'Apply knowledge in real-world scenarios and projects.',
            'skills': [
              'Advanced concepts',
              'Project work',
              'Real-world application',
            ],
          },
        ];
    }
  }

  List<RoadmapMilestone> _generateDetailedMilestones(
    Map<String, dynamic> template,
    int phaseNumber,
    String intensity,
  ) {
    final skills = List<String>.from(template['skills']);
    final milestones = <RoadmapMilestone>[];

    // Adjust milestone count based on intensity
    int milestoneCount;
    switch (intensity) {
      case 'Intensive':
        milestoneCount = 2; // Fewer milestones, more focused
        break;
      case 'Accelerated':
        milestoneCount = 3; // Moderate number of milestones
        break;
      case 'Comprehensive':
        milestoneCount = 4; // Standard milestone count
        break;
      case 'Mastery':
        milestoneCount = 5; // More detailed milestones
        break;
      default:
        milestoneCount = 4;
    }

    milestoneCount = milestoneCount.clamp(2, skills.length);

    for (int i = 0; i < milestoneCount; i++) {
      final skillIndex = (i * skills.length / milestoneCount).floor();
      final skill = skills[skillIndex];

      final milestoneTypes = [
        MilestoneType.learning,
        MilestoneType.assessment,
        MilestoneType.project,
        MilestoneType.certification,
      ];

      milestones.add(
        RoadmapMilestone(
          id: 'enhanced_milestone_${phaseNumber}_${i + 1}',
          title: _generateMilestoneTitle(
            skill,
            milestoneTypes[i % milestoneTypes.length],
          ),
          description: _generateMilestoneDescription(
            skill,
            milestoneTypes[i % milestoneTypes.length],
          ),
          type: milestoneTypes[i % milestoneTypes.length],
          points: _calculateMilestonePoints(
            milestoneTypes[i % milestoneTypes.length],
          ),
          deliverables: _generateMilestoneDeliverables(
            skill,
            milestoneTypes[i % milestoneTypes.length],
          ),
        ),
      );
    }

    return milestones;
  }

  String _generateMilestoneTitle(String skill, MilestoneType type) {
    switch (type) {
      case MilestoneType.learning:
        return 'Master $skill Fundamentals';
      case MilestoneType.assessment:
        return 'Complete $skill Assessment';
      case MilestoneType.project:
        return 'Build $skill Project';
      case MilestoneType.certification:
        return 'Earn $skill Certification';
      default:
        return 'Complete $skill Module';
    }
  }

  String _generateMilestoneDescription(String skill, MilestoneType type) {
    switch (type) {
      case MilestoneType.learning:
        return 'Develop comprehensive understanding of $skill through theoretical study, practical exercises, and hands-on application.';
      case MilestoneType.assessment:
        return 'Demonstrate mastery of $skill concepts through comprehensive testing and evaluation of practical skills.';
      case MilestoneType.project:
        return 'Apply $skill knowledge to create a real-world project that showcases practical implementation and problem-solving abilities.';
      case MilestoneType.certification:
        return 'Validate $skill expertise through industry-recognized certification or completion of structured learning program.';
      default:
        return 'Complete comprehensive $skill learning module with theoretical and practical components.';
    }
  }

  int _calculateMilestonePoints(MilestoneType type) {
    switch (type) {
      case MilestoneType.learning:
        return 25;
      case MilestoneType.assessment:
        return 30;
      case MilestoneType.project:
        return 50;
      case MilestoneType.certification:
        return 40;
      default:
        return 20;
    }
  }

  List<String> _generateMilestoneDeliverables(
    String skill,
    MilestoneType type,
  ) {
    switch (type) {
      case MilestoneType.learning:
        return [
          'Complete theoretical study materials',
          'Practical exercise completion',
          'Concept demonstration',
          'Study notes and summaries',
        ];
      case MilestoneType.assessment:
        return [
          'Written test completion (80%+ score)',
          'Practical skill demonstration',
          'Peer review and feedback',
          'Self-assessment report',
        ];
      case MilestoneType.project:
        return [
          'Functional project implementation',
          'Complete source code/documentation',
          'Project presentation and demo',
          'Performance analysis report',
        ];
      case MilestoneType.certification:
        return [
          'Official certification completion',
          'Portfolio evidence submission',
          'Industry mentor validation',
          'Professional skill endorsement',
        ];
      default:
        return ['Module completion', 'Knowledge verification'];
    }
  }

  List<Resource> _generatePremiumResources(
    String phaseTitle,
    String careerPath,
  ) {
    return [
      Resource(
        id: 'premium_course_${phaseTitle.hashCode.abs()}',
        title: 'Premium $phaseTitle Course',
        description:
            'Comprehensive course covering $phaseTitle with expert instruction, hands-on projects, and personalized feedback.',
        type: ResourceType.course,
        url:
            'https://www.coursera.org/specializations/${phaseTitle.toLowerCase().replaceAll(' ', '-')}',
        provider: 'Coursera Plus',
        isFree: false,
        price: 4999.0,
        duration: 60,
        rating: 4.8,
      ),
      Resource(
        id: 'interactive_${phaseTitle.hashCode.abs()}',
        title: '$phaseTitle Interactive Learning',
        description:
            'Interactive tutorials, coding challenges, and real-world projects for mastering $phaseTitle.',
        type: ResourceType.tutorial,
        url:
            'https://www.codecademy.com/learn/${phaseTitle.toLowerCase().replaceAll(' ', '-')}',
        provider: 'Codecademy Pro',
        isFree: false,
        price: 1999.0,
        duration: 40,
        rating: 4.7,
      ),
      Resource(
        id: 'masterclass_${phaseTitle.hashCode.abs()}',
        title: '$phaseTitle Expert Masterclass',
        description:
            'Learn from industry experts with advanced techniques, case studies, and professional insights.',
        type: ResourceType.course,
        url:
            'https://www.udemy.com/course/${phaseTitle.toLowerCase().replaceAll(' ', '-')}-masterclass/',
        provider: 'Udemy Business',
        isFree: false,
        price: 3499.0,
        duration: 50,
        rating: 4.9,
      ),
      Resource(
        id: 'practice_${phaseTitle.hashCode.abs()}',
        title: '$phaseTitle Practice Platform',
        description:
            'Extensive practice problems, mock tests, and performance analytics for skill improvement.',
        type: ResourceType.practice,
        url:
            'https://leetcode.com/problemset/${phaseTitle.toLowerCase().replaceAll(' ', '-')}/',
        provider: 'LeetCode Premium',
        isFree: false,
        price: 2499.0,
        rating: 4.6,
      ),
      Resource(
        id: 'mentorship_${phaseTitle.hashCode.abs()}',
        title: '$phaseTitle Personal Mentorship',
        description:
            '1-on-1 mentorship with industry professionals, personalized guidance, and career advice.',
        type: ResourceType.tutorial,
        url:
            'https://www.mentorship.com/$careerPath/${phaseTitle.toLowerCase().replaceAll(' ', '-')}',
        provider: 'Industry Mentors',
        isFree: false,
        price: 9999.0,
        duration: 80,
        rating: 4.9,
      ),
    ];
  }

  int _calculateOptimalPhases(int durationMonths) {
    // Duration-based phase calculation with proper scaling
    if (durationMonths <= 3) return 3; // 3M: Intensive, focused phases
    if (durationMonths <= 6) return 4; // 6M: Accelerated learning
    if (durationMonths <= 12) return 6; // 1Y: Comprehensive coverage
    if (durationMonths <= 24) return 8; // 2Y: Mastery with specialization
    return 10; // 2Y+: Expert level with advanced topics
  }

  String _getDifficultyLevel(int durationMonths) {
    if (durationMonths <= 3) return 'Intensive';
    if (durationMonths <= 6) return 'Accelerated';
    if (durationMonths <= 12) return 'Comprehensive';
    if (durationMonths <= 24) return 'Mastery';
    return 'Expert';
  }

  String _getDurationIntensity(int durationMonths) {
    if (durationMonths <= 3) return 'Intensive';
    if (durationMonths <= 6) return 'Accelerated';
    if (durationMonths <= 12) return 'Comprehensive';
    if (durationMonths <= 24) return 'Mastery';
    return 'Expert';
  }

  int _calculateWeeksPerPhase(int durationMonths, int totalPhases) {
    final totalWeeks = (durationMonths * 4.33).round();
    return (totalWeeks / totalPhases).round().clamp(2, 20);
  }

  /// Adjusts phase content based on duration and intensity
  Map<String, dynamic> _adjustPhaseForDuration(
    Map<String, dynamic> template,
    int durationMonths,
    String intensity,
  ) {
    final title = template['title'] as String;
    final skills = List<String>.from(template['skills']);
    final baseDescription = template['description'] as String;

    // Select skills based on duration
    List<String> adjustedSkills;
    String adjustedTitle;
    String adjustedDescription;

    switch (intensity) {
      case 'Intensive': // 3 months
        adjustedSkills = skills.take(4).toList(); // Focus on core skills
        adjustedTitle = '$title - Core Essentials';
        adjustedDescription =
            '$baseDescription\n\n🚀 **Intensive 3-Month Focus:**\n• Concentrated learning on essential concepts\n• Fast-paced skill acquisition\n• Core competencies for quick job readiness\n• 20+ hours/week intensive study';
        break;

      case 'Accelerated': // 6 months
        adjustedSkills = skills.take(6).toList(); // Moderate skill set
        adjustedTitle = '$title - Accelerated Track';
        adjustedDescription =
            '$baseDescription\n\n⚡ **Accelerated 6-Month Program:**\n• Balanced pace with thorough understanding\n• Practical application focus\n• Industry-relevant skill development\n• 15+ hours/week structured learning';
        break;

      case 'Comprehensive': // 12 months
        adjustedSkills = skills.take(8).toList(); // Full skill coverage
        adjustedTitle = '$title - Comprehensive Mastery';
        adjustedDescription =
            '$baseDescription\n\n🎯 **Comprehensive 12-Month Journey:**\n• Complete skill mastery with deep understanding\n• Advanced project development\n• Professional certification preparation\n• 10-12 hours/week sustainable learning';
        break;

      case 'Mastery': // 24 months
        adjustedSkills = skills; // All skills plus advanced topics
        adjustedTitle = '$title - Expert Mastery';
        adjustedDescription =
            '$baseDescription\n\n🏆 **Expert 24-Month Mastery Path:**\n• Complete expertise with advanced specializations\n• Leadership and mentoring capabilities\n• Industry innovation and thought leadership\n• 8-10 hours/week deep learning with research';
        break;

      default:
        adjustedSkills = skills;
        adjustedTitle = title;
        adjustedDescription = baseDescription;
    }

    return {
      'title': adjustedTitle,
      'description': adjustedDescription,
      'skills': adjustedSkills,
    };
  }

  /// Duration-specific title adjustment
  String _getDurationSpecificTitle(String baseTitle, int durationMonths) {
    final intensity = _getDurationIntensity(durationMonths);
    switch (intensity) {
      case 'Intensive':
        return '$baseTitle - 3 Month Intensive Bootcamp';
      case 'Accelerated':
        return '$baseTitle - 6 Month Accelerated Track';
      case 'Comprehensive':
        return '$baseTitle - 12 Month Comprehensive Journey';
      case 'Mastery':
        return '$baseTitle - 24 Month Expert Mastery Path';
      default:
        return baseTitle;
    }
  }

  /// Duration-specific description enhancement
  String _getDurationSpecificDescription(
    String baseDescription,
    int durationMonths,
  ) {
    final timeCommitment = _getTimeCommitmentForDuration(durationMonths);
    final intensity = _getDurationIntensity(durationMonths);

    final durationInfo =
        '''

📅 **Duration Structure:** $durationMonths months ($intensity pace)
🕰️ **Time Commitment:** $timeCommitment hours per week
🏁 **Learning Approach:** ${_getLearningApproach(intensity)}
📊 **Progress Tracking:** ${_getProgressTrackingInfo(durationMonths)}
    ''';

    return baseDescription + durationInfo;
  }

  /// Duration-specific prerequisites
  List<String> _getDurationSpecificPrerequisites(
    List<String> basePrerequisites,
    int durationMonths,
  ) {
    final additionalPrereqs = <String>[];

    switch (_getDurationIntensity(durationMonths)) {
      case 'Intensive':
        additionalPrereqs.addAll([
          'Ability to dedicate 20+ hours per week for intensive learning',
          'Strong motivation for accelerated skill acquisition',
          'Flexible schedule for concentrated study periods',
        ]);
        break;
      case 'Accelerated':
        additionalPrereqs.addAll([
          'Commitment to 15+ hours per week of focused learning',
          'Willingness to maintain consistent study schedule',
          'Access to reliable internet for online resources',
        ]);
        break;
      case 'Comprehensive':
        additionalPrereqs.addAll([
          'Sustainable 10-12 hours per week learning commitment',
          'Patience for thorough skill development',
          'Long-term career development mindset',
        ]);
        break;
      case 'Mastery':
        additionalPrereqs.addAll([
          'Commitment to 8-10 hours per week over 24 months',
          'Interest in becoming a subject matter expert',
          'Willingness to engage in research and advanced topics',
        ]);
        break;
    }

    return [...basePrerequisites, ...additionalPrereqs];
  }

  /// Duration-specific learning outcomes
  List<String> _getDurationSpecificOutcomes(
    List<String> baseOutcomes,
    int durationMonths,
  ) {
    final intensity = _getDurationIntensity(durationMonths);
    final enhancedOutcomes = <String>[];

    // Add duration-specific outcomes
    switch (intensity) {
      case 'Intensive':
        enhancedOutcomes.addAll([
          'Rapid skill acquisition with job-ready competencies in 3 months',
          'Intensive practical experience through accelerated projects',
          'Quick entry into the job market with core skills',
        ]);
        break;
      case 'Accelerated':
        enhancedOutcomes.addAll([
          'Balanced skill development with strong practical foundation',
          'Industry-relevant portfolio development within 6 months',
          'Professional networking and mentorship connections',
        ]);
        break;
      case 'Comprehensive':
        enhancedOutcomes.addAll([
          'Deep understanding with comprehensive skill mastery',
          'Advanced project portfolio showcasing expertise',
          'Leadership skills and ability to mentor others',
        ]);
        break;
      case 'Mastery':
        enhancedOutcomes.addAll([
          'Expert-level knowledge with specialization capabilities',
          'Thought leadership and industry recognition potential',
          'Advanced research and innovation abilities',
        ]);
        break;
    }

    return [...baseOutcomes, ...enhancedOutcomes];
  }

  String _getTimeCommitmentForDuration(int durationMonths) {
    switch (_getDurationIntensity(durationMonths)) {
      case 'Intensive':
        return '20-25';
      case 'Accelerated':
        return '15-18';
      case 'Comprehensive':
        return '10-12';
      case 'Mastery':
        return '8-10';
      default:
        return '10-15';
    }
  }

  String _getLearningApproach(String intensity) {
    switch (intensity) {
      case 'Intensive':
        return 'Fast-paced bootcamp style with immediate application';
      case 'Accelerated':
        return 'Structured learning with regular practice and projects';
      case 'Comprehensive':
        return 'Thorough understanding with deep dive into concepts';
      case 'Mastery':
        return 'Research-oriented with advanced specialization tracks';
      default:
        return 'Balanced theoretical and practical learning';
    }
  }

  String _getProgressTrackingInfo(int durationMonths) {
    final phases = _calculateOptimalPhases(durationMonths);
    final weeksPerPhase = _calculateWeeksPerPhase(durationMonths, phases);
    return 'Weekly milestones across $phases phases ($weeksPerPhase weeks each)';
  }
}
