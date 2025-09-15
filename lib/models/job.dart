class Job {
  final String id;
  final String title;
  final String company;
  final String location;
  final String salary;
  final String experience;
  final String description;
  final List<String> requirements;
  final DateTime postedDate;
  final String applicationUrl;
  final String source;
  final String jobType;
  final DateTime? applicationDeadline;
  final List<String>? skills;
  final String? department;

  Job({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.salary,
    required this.experience,
    required this.description,
    required this.requirements,
    required this.postedDate,
    required this.applicationUrl,
    required this.source,
    required this.jobType,
    this.applicationDeadline,
    this.skills,
    this.department,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      company: json['company'] ?? '',
      location: json['location'] ?? '',
      salary: json['salary'] ?? '',
      experience: json['experience'] ?? '',
      description: json['description'] ?? '',
      requirements: List<String>.from(json['requirements'] ?? []),
      postedDate: DateTime.tryParse(json['postedDate'] ?? '') ?? DateTime.now(),
      applicationUrl: json['applicationUrl'] ?? '',
      source: json['source'] ?? '',
      jobType: json['jobType'] ?? '',
      applicationDeadline: json['applicationDeadline'] != null 
          ? DateTime.tryParse(json['applicationDeadline']) 
          : null,
      skills: json['skills'] != null ? List<String>.from(json['skills']) : null,
      department: json['department'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'company': company,
      'location': location,
      'salary': salary,
      'experience': experience,
      'description': description,
      'requirements': requirements,
      'postedDate': postedDate.toIso8601String(),
      'applicationUrl': applicationUrl,
      'source': source,
      'jobType': jobType,
      'applicationDeadline': applicationDeadline?.toIso8601String(),
      'skills': skills,
      'department': department,
    };
  }
}
