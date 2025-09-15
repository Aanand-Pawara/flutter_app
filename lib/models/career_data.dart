class CareerData {
  final String title;
  final String description;
  final List<String> skills;
  final String averageSalary;
  final String jobOutlook;
  final String education;
  final String workEnvironment;
  final List<String> relatedOccupations;
  final Map<String, dynamic>? additionalInfo;

  CareerData({
    required this.title,
    required this.description,
    required this.skills,
    required this.averageSalary,
    required this.jobOutlook,
    required this.education,
    required this.workEnvironment,
    required this.relatedOccupations,
    this.additionalInfo,
  });

  factory CareerData.fromJson(Map<String, dynamic> json) {
    return CareerData(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      skills: List<String>.from(json['skills'] ?? []),
      averageSalary: json['averageSalary'] ?? '',
      jobOutlook: json['jobOutlook'] ?? '',
      education: json['education'] ?? '',
      workEnvironment: json['workEnvironment'] ?? '',
      relatedOccupations: List<String>.from(json['relatedOccupations'] ?? []),
      additionalInfo: json['additionalInfo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'skills': skills,
      'averageSalary': averageSalary,
      'jobOutlook': jobOutlook,
      'education': education,
      'workEnvironment': workEnvironment,
      'relatedOccupations': relatedOccupations,
      'additionalInfo': additionalInfo,
    };
  }
}
