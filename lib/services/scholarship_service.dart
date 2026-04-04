import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_app/models/scholarship.dart';

class ScholarshipService {
  static const String _baseUrl = 'https://api.scholarships.gov.in/v1';
  static const String _apiKey =
      'YOUR_GOVT_API_KEY'; // Replace with actual API key
  static const Duration _timeout = Duration(seconds: 10); // Reduced timeout

  final http.Client _client = http.Client();

  // Cache for better performance
  static final Map<String, List<Scholarship>> _cache = {};
  static final Map<String, DateTime> _cacheTimestamps = {};
  static const Duration _cacheExpiry = Duration(minutes: 15);

  /// Check if cache is valid
  bool _isCacheValid(String key) {
    if (!_cache.containsKey(key) || !_cacheTimestamps.containsKey(key)) {
      return false;
    }

    final timestamp = _cacheTimestamps[key]!;
    return DateTime.now().difference(timestamp) < _cacheExpiry;
  }

  /// Get from cache
  List<Scholarship>? _getFromCache(String key) {
    if (_isCacheValid(key)) {
      return _cache[key];
    }
    return null;
  }

  /// Save to cache
  void _saveToCache(String key, List<Scholarship> scholarships) {
    _cache[key] = scholarships;
    _cacheTimestamps[key] = DateTime.now();
  }

  /// Get scholarships based on gender and criteria
  Future<List<Scholarship>> getScholarships({
    required String gender, // 'male', 'female', 'all'
    String? category,
    String? state,
    String? course,
    int limit = 20,
  }) async {
    // Create cache key
    final cacheKey =
        'scholarships_${gender}_${category ?? 'all'}_${state ?? 'all'}_${course ?? 'all'}_$limit';

    // Check cache first for better performance
    final cachedResult = _getFromCache(cacheKey);
    if (cachedResult != null) {
      return cachedResult;
    }

    try {
      final queryParams = {
        'gender': gender,
        'limit': limit.toString(),
        'api_key': _apiKey,
      };

      if (category != null) queryParams['category'] = category;
      if (state != null) queryParams['state'] = state;
      if (course != null) queryParams['course'] = course;

      final uri = Uri.parse(
        '$_baseUrl/scholarships',
      ).replace(queryParameters: queryParams);

      final response = await _client
          .get(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_apiKey',
            },
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final scholarships = (data['scholarships'] as List)
            .map((item) => Scholarship.fromJson(item))
            .toList();

        // Cache the result
        _saveToCache(cacheKey, scholarships);
        return scholarships;
      } else {
        // Fallback to mock data if API fails
        final mockData = _getMockScholarships(gender);
        _saveToCache(cacheKey, mockData);
        return mockData;
      }
    } catch (e) {
      print('Error fetching scholarships: $e');
      final mockData = _getMockScholarships(gender);
      _saveToCache(cacheKey, mockData);
      return mockData;
    }
  }

  /// Get trending scholarships
  Future<List<Scholarship>> getTrendingScholarships() async {
    try {
      final uri = Uri.parse(
        '$_baseUrl/scholarships/trending',
      ).replace(queryParameters: {'api_key': _apiKey});

      final response = await _client
          .get(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_apiKey',
            },
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['scholarships'] as List)
            .map((item) => Scholarship.fromJson(item))
            .toList();
      }
    } catch (e) {
      print('Error fetching trending scholarships: $e');
    }

    return _getMockTrendingScholarships();
  }

  /// Get scholarship details by ID
  Future<Scholarship?> getScholarshipDetails(String scholarshipId) async {
    try {
      final uri = Uri.parse(
        '$_baseUrl/scholarships/$scholarshipId',
      ).replace(queryParameters: {'api_key': _apiKey});

      final response = await _client
          .get(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_apiKey',
            },
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Scholarship.fromJson(data['scholarship']);
      }
    } catch (e) {
      print('Error fetching scholarship details: $e');
    }

    return null;
  }

  /// Get scholarship statistics
  Future<Map<String, dynamic>> getScholarshipStats() async {
    try {
      final uri = Uri.parse(
        '$_baseUrl/scholarships/stats',
      ).replace(queryParameters: {'api_key': _apiKey});

      final response = await _client
          .get(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_apiKey',
            },
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      print('Error fetching scholarship stats: $e');
    }

    return _getMockStats();
  }

  /// Mock data for fallback
  List<Scholarship> _getMockScholarships(String gender) {
    final allScholarships = [
      Scholarship(
        id: 'sch_001',
        name: 'Post Matric Scholarship for SC Students',
        description:
            'Financial assistance for Scheduled Caste students pursuing post-matriculation studies.',
        provider: 'Ministry of Social Justice & Empowerment',
        amount: 50000.0,
        currency: 'INR',
        eligibility: [
          'SC category',
          'Family income < 2.5 lakhs',
          'Post matric level',
        ],
        applicationDeadline: DateTime.now().add(const Duration(days: 30)),
        applicationUrl:
            'https://scholarships.gov.in/fresh/newstdRegfrmInstruction',
        category: 'Government',
        targetGender: 'all',
        educationLevel: 'Post Matric',
        subjects: ['All subjects'],
        isActive: true,
        renewalDetails: 'Renewable annually based on academic performance',
        documents: [
          'Caste certificate',
          'Income certificate',
          'Bank details',
          'Academic certificates',
        ],
        benefits: ['Tuition fee', 'Maintenance allowance', 'Book allowance'],
      ),
      Scholarship(
        id: 'sch_002',
        name: 'National Scholarship for Girl Child',
        description:
            'Special scholarship program to encourage education among girl children.',
        provider: 'Ministry of Women & Child Development',
        amount: 25000.0,
        currency: 'INR',
        eligibility: [
          'Female students',
          'Meritorious performance',
          'Family income < 3 lakhs',
        ],
        applicationDeadline: DateTime.now().add(const Duration(days: 45)),
        applicationUrl: 'https://scholarships.gov.in/girl-child',
        category: 'Government',
        targetGender: 'female',
        educationLevel: 'All levels',
        subjects: ['All subjects'],
        isActive: true,
        renewalDetails: 'Renewable for entire course duration',
        documents: [
          'Birth certificate',
          'Income certificate',
          'Academic certificates',
        ],
        benefits: ['Monthly stipend', 'Book allowance', 'Uniform allowance'],
      ),
      Scholarship(
        id: 'sch_003',
        name: 'Merit-cum-Means Scholarship',
        description:
            'Merit and need-based scholarship for economically weaker sections.',
        provider: 'UGC (University Grants Commission)',
        amount: 30000.0,
        currency: 'INR',
        eligibility: [
          'Merit-based selection',
          'Family income < 4 lakhs',
          'Graduate/Post-graduate',
        ],
        applicationDeadline: DateTime.now().add(const Duration(days: 60)),
        applicationUrl: 'https://scholarships.gov.in/merit-means',
        category: 'Government',
        targetGender: 'all',
        educationLevel: 'Graduate/Post-Graduate',
        subjects: ['All subjects'],
        isActive: true,
        renewalDetails: 'Annual renewal based on performance',
        documents: [
          'Income certificate',
          'Academic certificates',
          'Bank details',
        ],
        benefits: ['Tuition fee support', 'Monthly allowance'],
      ),
    ];

    if (gender == 'female') {
      return allScholarships
          .where((s) => s.targetGender == 'female' || s.targetGender == 'all')
          .toList();
    } else if (gender == 'male') {
      return allScholarships
          .where((s) => s.targetGender == 'male' || s.targetGender == 'all')
          .toList();
    }

    return allScholarships;
  }

  List<Scholarship> _getMockTrendingScholarships() {
    return _getMockScholarships('all').take(5).toList();
  }

  Map<String, dynamic> _getMockStats() {
    return {
      'total_scholarships': 1250,
      'active_scholarships': 890,
      'female_specific': 320,
      'male_specific': 45,
      'gender_neutral': 525,
      'total_amount_disbursed': 15000000000, // 15 billion INR
      'beneficiaries_count': 2500000,
    };
  }

  void dispose() {
    _client.close();
  }
}
