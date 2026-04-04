class Scholarship {
  final String id;
  final String name;
  final String description;
  final String provider;
  final double amount;
  final String currency;
  final List<String> eligibility;
  final DateTime applicationDeadline;
  final String applicationUrl;
  final String category;
  final String targetGender; // 'male', 'female', 'all'
  final String educationLevel;
  final List<String> subjects;
  final bool isActive;
  final String? renewalDetails;
  final List<String> documents;
  final List<String> benefits;
  final String? imageUrl;
  final int? maxBeneficiaries;
  final DateTime? startDate;
  final DateTime? endDate;
  final Map<String, dynamic>? additionalInfo;

  Scholarship({
    required this.id,
    required this.name,
    required this.description,
    required this.provider,
    required this.amount,
    required this.currency,
    required this.eligibility,
    required this.applicationDeadline,
    required this.applicationUrl,
    required this.category,
    required this.targetGender,
    required this.educationLevel,
    required this.subjects,
    required this.isActive,
    this.renewalDetails,
    required this.documents,
    required this.benefits,
    this.imageUrl,
    this.maxBeneficiaries,
    this.startDate,
    this.endDate,
    this.additionalInfo,
  });

  factory Scholarship.fromJson(Map<String, dynamic> json) {
    return Scholarship(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      provider: json['provider'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'INR',
      eligibility: List<String>.from(json['eligibility'] ?? []),
      applicationDeadline: json['application_deadline'] != null
          ? DateTime.parse(json['application_deadline'])
          : DateTime.now(),
      applicationUrl: json['application_url'] ?? '',
      category: json['category'] ?? '',
      targetGender: json['target_gender'] ?? 'all',
      educationLevel: json['education_level'] ?? '',
      subjects: List<String>.from(json['subjects'] ?? []),
      isActive: json['is_active'] ?? true,
      renewalDetails: json['renewal_details'],
      documents: List<String>.from(json['documents'] ?? []),
      benefits: List<String>.from(json['benefits'] ?? []),
      imageUrl: json['image_url'],
      maxBeneficiaries: json['max_beneficiaries'],
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : null,
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'])
          : null,
      additionalInfo: json['additional_info'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'provider': provider,
      'amount': amount,
      'currency': currency,
      'eligibility': eligibility,
      'application_deadline': applicationDeadline.toIso8601String(),
      'application_url': applicationUrl,
      'category': category,
      'target_gender': targetGender,
      'education_level': educationLevel,
      'subjects': subjects,
      'is_active': isActive,
      'renewal_details': renewalDetails,
      'documents': documents,
      'benefits': benefits,
      'image_url': imageUrl,
      'max_beneficiaries': maxBeneficiaries,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'additional_info': additionalInfo,
    };
  }

  Scholarship copyWith({
    String? id,
    String? name,
    String? description,
    String? provider,
    double? amount,
    String? currency,
    List<String>? eligibility,
    DateTime? applicationDeadline,
    String? applicationUrl,
    String? category,
    String? targetGender,
    String? educationLevel,
    List<String>? subjects,
    bool? isActive,
    String? renewalDetails,
    List<String>? documents,
    List<String>? benefits,
    String? imageUrl,
    int? maxBeneficiaries,
    DateTime? startDate,
    DateTime? endDate,
    Map<String, dynamic>? additionalInfo,
  }) {
    return Scholarship(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      provider: provider ?? this.provider,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      eligibility: eligibility ?? this.eligibility,
      applicationDeadline: applicationDeadline ?? this.applicationDeadline,
      applicationUrl: applicationUrl ?? this.applicationUrl,
      category: category ?? this.category,
      targetGender: targetGender ?? this.targetGender,
      educationLevel: educationLevel ?? this.educationLevel,
      subjects: subjects ?? this.subjects,
      isActive: isActive ?? this.isActive,
      renewalDetails: renewalDetails ?? this.renewalDetails,
      documents: documents ?? this.documents,
      benefits: benefits ?? this.benefits,
      imageUrl: imageUrl ?? this.imageUrl,
      maxBeneficiaries: maxBeneficiaries ?? this.maxBeneficiaries,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }

  /// Get formatted amount string
  String get formattedAmount {
    if (currency == 'INR') {
      if (amount >= 100000) {
        return '₹${(amount / 100000).toStringAsFixed(1)}L';
      } else if (amount >= 1000) {
        return '₹${(amount / 1000).toStringAsFixed(1)}K';
      } else {
        return '₹${amount.toStringAsFixed(0)}';
      }
    }
    return '$currency ${amount.toStringAsFixed(0)}';
  }

  /// Get days remaining for application
  int get daysRemaining {
    final now = DateTime.now();
    final difference = applicationDeadline.difference(now);
    return difference.inDays;
  }

  /// Check if deadline is approaching (within 7 days)
  bool get isDeadlineApproaching {
    return daysRemaining <= 7 && daysRemaining >= 0;
  }

  /// Check if deadline has passed
  bool get isExpired {
    return daysRemaining < 0;
  }

  /// Get gender-specific icon
  String get genderIcon {
    switch (targetGender.toLowerCase()) {
      case 'female':
        return '♀️';
      case 'male':
        return '♂️';
      default:
        return '👥';
    }
  }

  /// Get category color
  String get categoryColor {
    switch (category.toLowerCase()) {
      case 'government':
        return '#4CAF50';
      case 'private':
        return '#2196F3';
      case 'institutional':
        return '#FF9800';
      default:
        return '#9C27B0';
    }
  }

  @override
  String toString() {
    return 'Scholarship(id: $id, name: $name, provider: $provider, amount: $formattedAmount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Scholarship && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}