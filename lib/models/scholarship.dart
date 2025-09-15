class Scholarship {
  final String id;
  final String title;
  final String description;
  final String amount;
  final DateTime deadline;
  final List<String> eligibility;
  final String source;
  final String category;
  final String? state;
  final String applicationUrl;
  final bool isActive;
  final double? matchPercentage;
  final String? applicationStatus;

  Scholarship({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.deadline,
    required this.eligibility,
    required this.source,
    required this.category,
    this.state,
    required this.applicationUrl,
    required this.isActive,
    this.matchPercentage,
    this.applicationStatus,
  });

  factory Scholarship.fromJson(Map<String, dynamic> json) {
    return Scholarship(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      amount: json['amount']?.toString() ?? '0',
      deadline: DateTime.tryParse(json['deadline'] ?? '') ?? DateTime.now(),
      eligibility: List<String>.from(json['eligibility'] ?? []),
      source: json['source'] ?? '',
      category: json['category'] ?? '',
      state: json['state'],
      applicationUrl: json['applicationUrl'] ?? '',
      isActive: json['isActive'] ?? true,
      matchPercentage: json['matchPercentage']?.toDouble(),
      applicationStatus: json['applicationStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'amount': amount,
      'deadline': deadline.toIso8601String(),
      'eligibility': eligibility,
      'source': source,
      'category': category,
      'state': state,
      'applicationUrl': applicationUrl,
      'isActive': isActive,
      'matchPercentage': matchPercentage,
      'applicationStatus': applicationStatus,
    };
  }
}
