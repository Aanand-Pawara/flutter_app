class Roadmap {
  final String id;
  final String careerPath;
  final String title;
  final String description;
  final int estimatedDuration; // in months
  final String difficultyLevel;
  final List<RoadmapPhase> phases;
  final List<String> prerequisites;
  final List<String> outcomes;
  final List<String> certifications;
  final double averageSalary;
  final String jobOutlook;
  final DateTime createdAt;
  final DateTime updatedAt;

  Roadmap({
    required this.id,
    required this.careerPath,
    required this.title,
    required this.description,
    required this.estimatedDuration,
    required this.difficultyLevel,
    required this.phases,
    required this.prerequisites,
    required this.outcomes,
    required this.certifications,
    required this.averageSalary,
    required this.jobOutlook,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Roadmap.fromJson(Map<String, dynamic> json) {
    return Roadmap(
      id: json['id'] ?? '',
      careerPath: json['careerPath'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      estimatedDuration: json['estimatedDuration'] ?? 0,
      difficultyLevel: json['difficultyLevel'] ?? 'Beginner',
      phases: (json['phases'] as List?)
          ?.map((phase) => RoadmapPhase.fromJson(phase))
          .toList() ?? [],
      prerequisites: List<String>.from(json['prerequisites'] ?? []),
      outcomes: List<String>.from(json['outcomes'] ?? []),
      certifications: List<String>.from(json['certifications'] ?? []),
      averageSalary: (json['averageSalary'] ?? 0).toDouble(),
      jobOutlook: json['jobOutlook'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'careerPath': careerPath,
      'title': title,
      'description': description,
      'estimatedDuration': estimatedDuration,
      'difficultyLevel': difficultyLevel,
      'phases': phases.map((phase) => phase.toJson()).toList(),
      'prerequisites': prerequisites,
      'outcomes': outcomes,
      'certifications': certifications,
      'averageSalary': averageSalary,
      'jobOutlook': jobOutlook,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Roadmap copyWith({
    String? id,
    String? careerPath,
    String? title,
    String? description,
    int? estimatedDuration,
    String? difficultyLevel,
    List<RoadmapPhase>? phases,
    List<String>? prerequisites,
    List<String>? outcomes,
    List<String>? certifications,
    double? averageSalary,
    String? jobOutlook,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Roadmap(
      id: id ?? this.id,
      careerPath: careerPath ?? this.careerPath,
      title: title ?? this.title,
      description: description ?? this.description,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      phases: phases ?? this.phases,
      prerequisites: prerequisites ?? this.prerequisites,
      outcomes: outcomes ?? this.outcomes,
      certifications: certifications ?? this.certifications,
      averageSalary: averageSalary ?? this.averageSalary,
      jobOutlook: jobOutlook ?? this.jobOutlook,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class RoadmapPhase {
  final String id;
  final String title;
  final String description;
  final int duration; // in weeks
  final int order;
  final List<RoadmapMilestone> milestones;
  final List<String> skills;
  final List<Resource> resources;
  final bool isCompleted;
  final DateTime? completedAt;

  RoadmapPhase({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.order,
    required this.milestones,
    required this.skills,
    required this.resources,
    this.isCompleted = false,
    this.completedAt,
  });

  factory RoadmapPhase.fromJson(Map<String, dynamic> json) {
    return RoadmapPhase(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      duration: json['duration'] ?? 0,
      order: json['order'] ?? 0,
      milestones: (json['milestones'] as List?)
          ?.map((milestone) => RoadmapMilestone.fromJson(milestone))
          .toList() ?? [],
      skills: List<String>.from(json['skills'] ?? []),
      resources: (json['resources'] as List?)
          ?.map((resource) => Resource.fromJson(resource))
          .toList() ?? [],
      isCompleted: json['isCompleted'] ?? false,
      completedAt: json['completedAt'] != null 
          ? DateTime.parse(json['completedAt']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'duration': duration,
      'order': order,
      'milestones': milestones.map((milestone) => milestone.toJson()).toList(),
      'skills': skills,
      'resources': resources.map((resource) => resource.toJson()).toList(),
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
    };
  }
}

class RoadmapMilestone {
  final String id;
  final String title;
  final String description;
  final MilestoneType type;
  final bool isCompleted;
  final DateTime? completedAt;
  final int points;
  final List<String> deliverables;

  RoadmapMilestone({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.isCompleted = false,
    this.completedAt,
    required this.points,
    required this.deliverables,
  });

  factory RoadmapMilestone.fromJson(Map<String, dynamic> json) {
    return RoadmapMilestone(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: MilestoneType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => MilestoneType.learning,
      ),
      isCompleted: json['isCompleted'] ?? false,
      completedAt: json['completedAt'] != null 
          ? DateTime.parse(json['completedAt']) 
          : null,
      points: json['points'] ?? 0,
      deliverables: List<String>.from(json['deliverables'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.toString().split('.').last,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
      'points': points,
      'deliverables': deliverables,
    };
  }
}

class Resource {
  final String id;
  final String title;
  final String description;
  final ResourceType type;
  final String url;
  final String provider;
  final bool isFree;
  final double? price;
  final int? duration; // in hours
  final double? rating;

  Resource({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.url,
    required this.provider,
    this.isFree = true,
    this.price,
    this.duration,
    this.rating,
  });

  factory Resource.fromJson(Map<String, dynamic> json) {
    return Resource(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: ResourceType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => ResourceType.article,
      ),
      url: json['url'] ?? '',
      provider: json['provider'] ?? '',
      isFree: json['isFree'] ?? true,
      price: json['price']?.toDouble(),
      duration: json['duration'],
      rating: json['rating']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.toString().split('.').last,
      'url': url,
      'provider': provider,
      'isFree': isFree,
      'price': price,
      'duration': duration,
      'rating': rating,
    };
  }
}

enum MilestoneType {
  learning,
  project,
  assessment,
  certification,
  internship,
  job_application
}

enum ResourceType {
  course,
  article,
  video,
  book,
  tutorial,
  documentation,
  practice,
  tool,
  certification,
  assessment
}

// Roadmap progress tracking
class RoadmapProgress {
  final String userId;
  final String roadmapId;
  final double completionPercentage;
  final List<String> completedPhases;
  final List<String> completedMilestones;
  final int totalPoints;
  final DateTime startedAt;
  final DateTime? completedAt;
  final DateTime lastUpdated;

  RoadmapProgress({
    required this.userId,
    required this.roadmapId,
    required this.completionPercentage,
    required this.completedPhases,
    required this.completedMilestones,
    required this.totalPoints,
    required this.startedAt,
    this.completedAt,
    required this.lastUpdated,
  });

  factory RoadmapProgress.fromJson(Map<String, dynamic> json) {
    return RoadmapProgress(
      userId: json['userId'] ?? '',
      roadmapId: json['roadmapId'] ?? '',
      completionPercentage: (json['completionPercentage'] ?? 0).toDouble(),
      completedPhases: List<String>.from(json['completedPhases'] ?? []),
      completedMilestones: List<String>.from(json['completedMilestones'] ?? []),
      totalPoints: json['totalPoints'] ?? 0,
      startedAt: DateTime.parse(json['startedAt'] ?? DateTime.now().toIso8601String()),
      completedAt: json['completedAt'] != null 
          ? DateTime.parse(json['completedAt']) 
          : null,
      lastUpdated: DateTime.parse(json['lastUpdated'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'roadmapId': roadmapId,
      'completionPercentage': completionPercentage,
      'completedPhases': completedPhases,
      'completedMilestones': completedMilestones,
      'totalPoints': totalPoints,
      'startedAt': startedAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}