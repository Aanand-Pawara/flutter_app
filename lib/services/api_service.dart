import 'dart:convert';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:flutter_app/models/scholarship.dart';
import 'package:flutter_app/models/job.dart';
import 'package:flutter_app/models/course.dart';
import 'package:flutter_app/models/career_data.dart';

class ApiService {
  static const String _adzunaApiKey = 'YOUR_ADZUNA_API_KEY';
  static const String _adzunaAppId = 'YOUR_ADZUNA_APP_ID';
  static const String _youtubeApiKey = 'YOUR_YOUTUBE_API_KEY';
  static const String _googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';
  
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final http.Client _client = http.Client();
  static const Duration _timeout = Duration(seconds: 30);

  // ============ SCHOLARSHIP SERVICES ============
  
  /// Scrapes National Scholarship Portal for active scholarships
  Future<List<Scholarship>> getNSPScholarships({
    String? category,
    String? state,
    int page = 1,
  }) async {
    try {
      const String nspUrl = 'https://scholarships.gov.in/schemeFullDetails.do';
      final response = await _client.get(Uri.parse(nspUrl)).timeout(_timeout);
      
      if (response.statusCode == 200) {
        final document = html_parser.parse(response.body);
        final scholarshipElements = document.querySelectorAll('.scholarship-card');
        
        return scholarshipElements.map((element) {
          final title = element.querySelector('.scheme-name')?.text?.trim() ?? '';
          final description = element.querySelector('.scheme-desc')?.text?.trim() ?? '';
          final deadline = element.querySelector('.deadline')?.text?.trim() ?? '';
          final amount = element.querySelector('.amount')?.text?.trim() ?? '';
          final eligibility = element.querySelector('.eligibility')?.text?.trim() ?? '';
          
          return Scholarship(
            id: title.hashCode.toString(),
            title: title,
            description: description,
            amount: _parseAmount(amount),
            deadline: _parseDate(deadline),
            eligibility: eligibility.split(',').map((e) => e.trim()).toList(),
            source: 'National Scholarship Portal',
            category: category ?? 'General',
            state: state,
            applicationUrl: 'https://scholarships.gov.in/fresh/newstdRegfrmInstruction',
            isActive: true,
          );
        }).toList();
      }
      
      return _getFallbackScholarships();
    } catch (e) {
      // Error scraping NSP scholarships
      return _getFallbackScholarships();
    }
  }

  // ============ JOB SERVICES ============
  
  /// Fetches jobs from National Career Service (NCS)
  Future<List<Job>> getNCSJobs({
    String? location,
    String? category,
    int page = 1,
  }) async {
    try {
      const String ncsUrl = 'https://www.ncs.gov.in/Pages/default.aspx';
      final response = await _client.get(Uri.parse(ncsUrl)).timeout(_timeout);
      
      if (response.statusCode == 200) {
        final document = html_parser.parse(response.body);
        final jobElements = document.querySelectorAll('.job-listing');
        
        return jobElements.map((element) {
          final title = element.querySelector('.job-title')?.text?.trim() ?? '';
          final company = element.querySelector('.company-name')?.text?.trim() ?? '';
          final jobLocation = element.querySelector('.location')?.text?.trim() ?? '';
          final salary = element.querySelector('.salary')?.text?.trim() ?? '';
          final experience = element.querySelector('.experience')?.text?.trim() ?? '';
          
          return Job(
            id: title.hashCode.toString(),
            title: title,
            company: company,
            location: jobLocation,
            salary: salary,
            experience: experience,
            description: 'Government job opportunity through National Career Service',
            requirements: [],
            postedDate: DateTime.now(),
            applicationUrl: 'https://www.ncs.gov.in/',
            source: 'National Career Service',
            jobType: 'Government',
          );
        }).toList();
      }
      
      return _getFallbackJobs();
    } catch (e) {
      // Error fetching NCS jobs
      return _getFallbackJobs();
    }
  }
  
  /// Fetches jobs from Adzuna API (50 requests/day free)
  Future<List<Job>> getAdzunaJobs({
    String? location = 'india',
    String? category,
    int page = 1,
  }) async {
    try {
      final queryParams = {
        'app_id': _adzunaAppId,
        'app_key': _adzunaApiKey,
        'results_per_page': '20',
        'page': page.toString(),
        'where': location ?? 'india',
      };
      
      if (category != null) {
        queryParams['what'] = category;
      }
      
      final uri = Uri.https(
        'api.adzuna.com',
        '/v1/api/jobs/in/search/$page',
        queryParams,
      );
      
      final response = await _client.get(uri).timeout(_timeout);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;
        
        return results.map((jobData) {
          return Job(
            id: jobData['id'].toString(),
            title: jobData['title'] ?? '',
            company: jobData['company']['display_name'] ?? '',
            location: jobData['location']['display_name'] ?? '',
            salary: jobData['salary_min'] != null 
                ? '₹${jobData['salary_min']} - ₹${jobData['salary_max'] ?? jobData['salary_min']}'
                : 'Not specified',
            experience: 'As per requirement',
            description: jobData['description'] ?? '',
            requirements: [],
            postedDate: DateTime.parse(jobData['created']),
            applicationUrl: jobData['redirect_url'] ?? '',
            source: 'Adzuna',
            jobType: jobData['category']['label'] ?? 'Full-time',
          );
        }).toList();
      }
      
      return _getFallbackJobs();
    } catch (e) {
      // Error fetching Adzuna jobs
      return _getFallbackJobs();
    }
  }

  // ============ COURSE SERVICES ============
  
  /// Fetches courses from Coursera Catalog API
  Future<List<Course>> getCourseraCourses({
    String? category,
    String? level,
    int page = 1,
  }) async {
    try {
      final queryParams = {
        'start': ((page - 1) * 20).toString(),
        'limit': '20',
        'fields': 'name,description,photoUrl,instructors,partners,workload,certificates',
      };
      
      if (category != null) {
        queryParams['q'] = 'search';
        queryParams['query'] = category;
      }
      
      final uri = Uri.https(
        'api.coursera.org',
        '/api/courses.v1/courses',
        queryParams,
      );
      
      final response = await _client.get(uri).timeout(_timeout);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final courses = data['elements'] as List;
        
        return courses.map((courseData) {
          return Course(
            id: courseData['id'].toString(),
            title: courseData['name'] ?? '',
            description: courseData['description'] ?? '',
            provider: 'Coursera',
            instructor: courseData['instructors']?.isNotEmpty == true 
                ? courseData['instructors'][0]['fullName'] ?? 'Coursera Instructor'
                : 'Coursera Instructor',
            duration: courseData['workload'] ?? '4-6 weeks',
            level: level ?? 'Beginner',
            rating: 4.5,
            enrolledCount: 10000,
            price: 'Free to audit',
            imageUrl: courseData['photoUrl'] ?? '',
            skills: [],
            category: category ?? 'Technology',
            certificateAvailable: courseData['certificates']?.isNotEmpty == true,
            courseUrl: 'https://www.coursera.org/learn/${courseData['slug'] ?? ''}',
          );
        }).toList();
      }
      
      return _getFallbackCourses();
    } catch (e) {
      // Error fetching Coursera courses
      return _getFallbackCourses();
    }
  }
  
  /// Fetches courses from edX Catalog API
  Future<List<Course>> getEdXCourses({
    String? category,
    String? level,
    int page = 1,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'page_size': '20',
      };
      
      if (category != null) {
        queryParams['search'] = category;
      }
      
      final uri = Uri.https(
        'api.edx.org',
        '/catalog/v1/courses/',
        queryParams,
      );
      
      final response = await _client.get(uri).timeout(_timeout);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final courses = data['results'] as List;
        
        return courses.map((courseData) {
          return Course(
            id: courseData['key'].toString(),
            title: courseData['title'] ?? '',
            description: courseData['short_description'] ?? '',
            provider: 'edX',
            instructor: courseData['owners']?.isNotEmpty == true 
                ? courseData['owners'][0]['name'] ?? 'edX Instructor'
                : 'edX Instructor',
            duration: '6-8 weeks',
            level: courseData['level_type'] ?? level ?? 'Intermediate',
            rating: 4.3,
            enrolledCount: 5000,
            price: 'Free (Certificate fee applies)',
            imageUrl: courseData['image']?['src'] ?? '',
            skills: (courseData['subjects'] as List?)?.map((s) => s['name'].toString()).toList() ?? [],
            category: category ?? 'Education',
            certificateAvailable: true,
            courseUrl: 'https://www.edx.org/course/${courseData['key']}',
          );
        }).toList();
      }
      
      return _getFallbackCourses();
    } catch (e) {
      // Error fetching edX courses
      return _getFallbackCourses();
    }
  }
  
  /// Fetches learning videos from YouTube Data API
  Future<List<Course>> getYouTubeLearningContent({
    required String query,
    int maxResults = 20,
  }) async {
    try {
      final queryParams = {
        'part': 'snippet,statistics',
        'q': '$query tutorial learning course',
        'type': 'video',
        'maxResults': maxResults.toString(),
        'order': 'relevance',
        'videoDuration': 'medium',
        'key': _youtubeApiKey,
      };
      
      final uri = Uri.https(
        'www.googleapis.com',
        '/youtube/v3/search',
        queryParams,
      );
      
      final response = await _client.get(uri).timeout(_timeout);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final videos = data['items'] as List;
        
        return videos.map((videoData) {
          final snippet = videoData['snippet'];
          return Course(
            id: videoData['id']['videoId'].toString(),
            title: snippet['title'] ?? '',
            description: snippet['description'] ?? '',
            provider: 'YouTube',
            instructor: snippet['channelTitle'] ?? 'YouTube Creator',
            duration: 'Video content',
            level: 'All levels',
            rating: 4.0,
            enrolledCount: 1000,
            price: 'Free',
            imageUrl: snippet['thumbnails']['medium']['url'] ?? '',
            skills: [query],
            category: 'Video Learning',
            certificateAvailable: false,
            courseUrl: 'https://www.youtube.com/watch?v=${videoData['id']['videoId']}',
          );
        }).toList();
      }
      
      return [];
    } catch (e) {
      // Error fetching YouTube content
      return [];
    }
  }

  // ============ CAREER GUIDANCE SERVICES ============
  
  /// Fetches career data from O*NET Web Services
  Future<CareerData> getONetCareerData(String occupation) async {
    try {
      final uri = Uri.https(
        'services.onetcenter.org',
        '/ws/online/occupations/$occupation/summary',
      );
      
      final response = await _client.get(uri).timeout(_timeout);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        return CareerData(
          title: data['title'] ?? occupation,
          description: data['description'] ?? '',
          skills: (data['skills'] as List?)?.map((s) => s.toString()).toList() ?? [],
          averageSalary: data['median_wages']?['annual']?.toString() ?? 'Not available',
          jobOutlook: data['job_outlook'] ?? 'Stable',
          education: data['education'] ?? 'Bachelor\'s degree',
          workEnvironment: data['work_environment'] ?? 'Office setting',
          relatedOccupations: (data['related_occupations'] as List?)?.map((o) => o.toString()).toList() ?? [],
        );
      }
      
      return _getFallbackCareerData(occupation);
    } catch (e) {
      // Error fetching O*NET career data
      return _getFallbackCareerData(occupation);
    }
  }

  // ============ MARKET TRENDS SERVICES ============
  
  /// Fetches employment data from World Bank API
  Future<Map<String, dynamic>> getEmploymentTrends(String countryCode) async {
    try {
      final uri = Uri.https(
        'api.worldbank.org',
        '/v2/country/$countryCode/indicator/SL.UEM.TOTL.ZS',
        {'format': 'json', 'date': '2020:2023'},
      );
      
      final response = await _client.get(uri).timeout(_timeout);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List && data.length > 1) {
          final trends = data[1] as List;
          return {
            'unemployment_rate': trends.isNotEmpty ? trends[0]['value'] : 'N/A',
            'year': trends.isNotEmpty ? trends[0]['date'] : '2023',
            'country': countryCode,
          };
        }
      }
      
      return {'unemployment_rate': '7.5', 'year': '2023', 'country': countryCode};
    } catch (e) {
      // Error fetching employment trends
      return {'unemployment_rate': '7.5', 'year': '2023', 'country': countryCode};
    }
  }

  // ============ TRANSLATION SERVICES ============
  
  /// Translates text using LibreTranslate
  Future<String> translateText(String text, String targetLanguage) async {
    try {
      final response = await _client.post(
        Uri.parse('https://libretranslate.de/translate'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'q': text,
          'source': 'en',
          'target': targetLanguage,
          'format': 'text',
        }),
      ).timeout(_timeout);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['translatedText'] ?? text;
      }
      
      return text;
    } catch (e) {
      // Error translating text
      return text;
    }
  }

  // ============ LOCATION SERVICES ============
  
  /// Finds colleges near a location using Google Maps Places API
  Future<List<Map<String, dynamic>>> findNearbyColleges({
    required double latitude,
    required double longitude,
    int radius = 50000, // 50km
  }) async {
    try {
      final queryParams = {
        'location': '$latitude,$longitude',
        'radius': radius.toString(),
        'type': 'university',
        'key': _googleMapsApiKey,
      };
      
      final uri = Uri.https(
        'maps.googleapis.com',
        '/maps/api/place/nearbysearch/json',
        queryParams,
      );
      
      final response = await _client.get(uri).timeout(_timeout);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;
        
        return results.map((place) => {
          'name': place['name'],
          'rating': place['rating'],
          'vicinity': place['vicinity'],
          'place_id': place['place_id'],
          'types': place['types'],
        }).toList();
      }
      
      return [];
    } catch (e) {
      // Error finding nearby colleges
      return [];
    }
  }

  // ============ HELPER METHODS ============
  
  String _parseAmount(String amountText) {
    final regex = RegExp(r'[\d,]+');
    final match = regex.firstMatch(amountText);
    return match?.group(0) ?? '0';
  }
  
  DateTime _parseDate(String dateText) {
    try {
      // Try to parse common date formats
      final cleanDate = dateText.replaceAll(RegExp(r'[^\d\-\/]'), '');
      return DateTime.parse(cleanDate);
    } catch (e) {
      return DateTime.now().add(const Duration(days: 30));
    }
  }
  
  List<Scholarship> _getFallbackScholarships() {
    return [
      Scholarship(
        id: '1',
        title: 'Merit-cum-Means Scholarship',
        description: 'For economically weaker sections with good academic performance',
        amount: '12000',
        deadline: DateTime.now().add(const Duration(days: 45)),
        eligibility: ['Income < 2.5 LPA', 'Minimum 60% marks'],
        source: 'NSP Fallback',
        category: 'Merit',
        applicationUrl: 'https://scholarships.gov.in',
        isActive: true,
      ),
    ];
  }
  
  List<Job> _getFallbackJobs() {
    return [
      Job(
        id: '1',
        title: 'Software Developer',
        company: 'Government of India',
        location: 'New Delhi',
        salary: '₹40,000 - ₹60,000',
        experience: '2-5 years',
        description: 'Develop software solutions for government departments',
        requirements: ['B.Tech/MCA', 'Programming skills'],
        postedDate: DateTime.now(),
        applicationUrl: 'https://www.ncs.gov.in',
        source: 'NCS Fallback',
        jobType: 'Government',
      ),
    ];
  }
  
  List<Course> _getFallbackCourses() {
    return [
      Course(
        id: '1',
        title: 'Introduction to Programming',
        description: 'Learn programming fundamentals',
        provider: 'Coursera',
        instructor: 'Tech Expert',
        duration: '6 weeks',
        level: 'Beginner',
        rating: 4.5,
        enrolledCount: 10000,
        price: 'Free',
        imageUrl: '',
        skills: ['Programming', 'Logic'],
        category: 'Technology',
        certificateAvailable: true,
        courseUrl: 'https://coursera.org',
      ),
    ];
  }
  
  CareerData _getFallbackCareerData(String occupation) {
    return CareerData(
      title: occupation,
      description: 'Career information for $occupation',
      skills: ['Communication', 'Problem Solving'],
      averageSalary: '₹5,00,000',
      jobOutlook: 'Growing',
      education: 'Bachelor\'s degree',
      workEnvironment: 'Office',
      relatedOccupations: [],
    );
  }
  
  void dispose() {
    _client.close();
  }
}
