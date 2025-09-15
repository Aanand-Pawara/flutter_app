class Course {
  final String id;
  final String title;
  final String description;
  final String provider;
  final String instructor;
  final String duration;
  final String level;
  final double rating;
  final int enrolledCount;
  final String price;
  final String imageUrl;
  final List<String> skills;
  final String category;
  final bool certificateAvailable;
  final String courseUrl;
  final double? progress;
  final bool? isBookmarked;
  final String? language;
  final List<String>? prerequisites;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.provider,
    required this.instructor,
    required this.duration,
    required this.level,
    required this.rating,
    required this.enrolledCount,
    required this.price,
    required this.imageUrl,
    required this.skills,
    required this.category,
    required this.certificateAvailable,
    required this.courseUrl,
    this.progress,
    this.isBookmarked,
    this.language,
    this.prerequisites,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      provider: json['provider'] ?? '',
      instructor: json['instructor'] ?? '',
      duration: json['duration'] ?? '',
      level: json['level'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      enrolledCount: json['enrolledCount'] ?? 0,
      price: json['price'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      skills: List<String>.from(json['skills'] ?? []),
      category: json['category'] ?? '',
      certificateAvailable: json['certificateAvailable'] ?? false,
      courseUrl: json['courseUrl'] ?? '',
      progress: json['progress']?.toDouble(),
      isBookmarked: json['isBookmarked'],
      language: json['language'],
      prerequisites: json['prerequisites'] != null 
          ? List<String>.from(json['prerequisites']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'provider': provider,
      'instructor': instructor,
      'duration': duration,
      'level': level,
      'rating': rating,
      'enrolledCount': enrolledCount,
      'price': price,
      'imageUrl': imageUrl,
      'skills': skills,
      'category': category,
      'certificateAvailable': certificateAvailable,
      'courseUrl': courseUrl,
      'progress': progress,
      'isBookmarked': isBookmarked,
      'language': language,
      'prerequisites': prerequisites,
    };
  }
}
