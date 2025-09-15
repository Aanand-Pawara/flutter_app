class ApiConfig {
  // ============ API KEYS ============
  // Replace with your actual API keys
  
  // Adzuna Job Search API (50 requests/day free)
  static const String adzunaApiKey = 'YOUR_ADZUNA_API_KEY';
  static const String adzunaAppId = 'YOUR_ADZUNA_APP_ID';
  
  // YouTube Data API (50 requests/day)
  static const String youtubeApiKey = 'YOUR_YOUTUBE_API_KEY';
  
  // Google Maps Places API
  static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';
  
  // Hugging Face API (Free tier available)
  static const String huggingFaceApiKey = 'YOUR_HUGGINGFACE_API_KEY';
  
  // ============ API ENDPOINTS ============
  
  // Government Data Sources (No API key required - Web scraping)
  static const Map<String, String> governmentSources = {
    'nsp': 'https://scholarships.gov.in',
    'ncs': 'https://www.ncs.gov.in',
    'skillIndia': 'https://skillindia.gov.in',
    'aicte': 'https://aicte-india.org',
    'ugc': 'https://ugc.ac.in',
  };
  
  // Educational Platform APIs
  static const Map<String, String> educationSources = {
    'coursera': 'https://api.coursera.org/api/courses.v1',
    'edx': 'https://api.edx.org/catalog/v1',
    'nptel': 'https://nptel.ac.in/api',
    'swayam': 'https://swayam.gov.in/api',
  };
  
  // Job Search APIs
  static const Map<String, String> jobSources = {
    'adzuna': 'https://api.adzuna.com/v1/api/jobs/in',
    'linkedin': 'https://api.linkedin.com/v2', // Requires special access
    'indeed': 'https://api.indeed.com', // Limited free access
  };
  
  // Career Guidance APIs
  static const Map<String, String> careerSources = {
    'onet': 'https://services.onetcenter.org/ws/online',
    'worldBank': 'https://api.worldbank.org/v2',
    'indiaOpenData': 'https://data.gov.in/api',
  };
  
  // Translation and NLP APIs
  static const Map<String, String> nlpSources = {
    'libreTranslate': 'https://libretranslate.de',
    'huggingFace': 'https://api-inference.huggingface.co/models',
  };
  
  // ============ RATE LIMITS ============
  
  static const Map<String, int> rateLimits = {
    'adzuna_daily': 50,
    'youtube_daily': 50,
    'google_maps_daily': 1000,
    'huggingface_monthly': 30000,
    'libre_translate_daily': 1000,
  };
  
  // ============ CACHE SETTINGS ============
  
  static const Duration cacheExpiry = Duration(hours: 2);
  static const Duration scholarshipCacheExpiry = Duration(hours: 6);
  static const Duration jobCacheExpiry = Duration(hours: 1);
  static const Duration courseCacheExpiry = Duration(hours: 4);
  
  // ============ HELPER METHODS ============
  
  static bool isApiKeyConfigured(String service) {
    switch (service.toLowerCase()) {
      case 'adzuna':
        return adzunaApiKey != 'YOUR_ADZUNA_API_KEY' && 
               adzunaAppId != 'YOUR_ADZUNA_APP_ID';
      case 'youtube':
        return youtubeApiKey != 'YOUR_YOUTUBE_API_KEY';
      case 'google_maps':
        return googleMapsApiKey != 'YOUR_GOOGLE_MAPS_API_KEY';
      case 'huggingface':
        return huggingFaceApiKey != 'YOUR_HUGGINGFACE_API_KEY';
      default:
        return false;
    }
  }
  
  static List<String> getConfiguredServices() {
    final configured = <String>[];
    
    if (isApiKeyConfigured('adzuna')) configured.add('Adzuna Jobs');
    if (isApiKeyConfigured('youtube')) configured.add('YouTube Learning');
    if (isApiKeyConfigured('google_maps')) configured.add('Google Maps');
    if (isApiKeyConfigured('huggingface')) configured.add('AI Chat');
    
    // Government sources are always available (web scraping)
    configured.addAll([
      'NSP Scholarships',
      'NCS Jobs', 
      'Coursera Courses',
      'edX Courses',
      'O*NET Career Data',
      'World Bank Data',
    ]);
    
    return configured;
  }
  
  static Map<String, String> getApiHeaders(String service) {
    switch (service.toLowerCase()) {
      case 'huggingface':
        return {
          'Authorization': 'Bearer $huggingFaceApiKey',
          'Content-Type': 'application/json',
        };
      case 'libre_translate':
        return {
          'Content-Type': 'application/json',
        };
      default:
        return {
          'Content-Type': 'application/json',
          'User-Agent': 'OSCAR-Career-Platform/1.0',
        };
    }
  }
}
