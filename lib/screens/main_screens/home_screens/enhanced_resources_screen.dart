import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/utils/app_theme.dart';
import 'package:flutter_app/services/api_service.dart';
import 'package:flutter_app/services/interview_service.dart';
import 'package:flutter_app/models/course.dart';
import 'package:flutter_app/models/interview.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/providers/app_provider.dart';

class EnhancedResourcesScreen extends StatefulWidget {
  const EnhancedResourcesScreen({super.key});

  @override
  State<EnhancedResourcesScreen> createState() =>
      _EnhancedResourcesScreenState();
}

class _EnhancedResourcesScreenState extends State<EnhancedResourcesScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  String _selectedCategory = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // API Integration
  bool _isLoading = false;
  List<Course> _apiCourses = [];
  List<Interview> _mockInterviews = [];
  final List<Interview> _liveInterviews = [];
  final ApiService _apiService = ApiService();
  final InterviewService _interviewService = InterviewService();

  final List<String> _categories = [
    'All',
    'Courses',
    'Interview Prep',
    'Scholarships',
    'Jobs',
    'Roadmaps',
    'Study Material',
  ];

  final List<ResourceItem> _resources = [
    // Courses
    ResourceItem(
      id: '1',
      title: 'Complete NEET Biology Course',
      description:
          'Comprehensive biology course covering all NEET topics with video lectures and practice tests.',
      category: 'Courses',
      type: ResourceType.course,
      rating: 4.8,
      price: 'Free',
      duration: '120 hours',
      level: 'Intermediate',
      imageUrl: 'https://via.placeholder.com/150x100',
      isBookmarked: false,
      tags: ['NEET', 'Biology', 'Medical'],
      provider: 'OSCAR Academy',
    ),
    ResourceItem(
      id: '2',
      title: 'JEE Mathematics Masterclass',
      description:
          'Advanced mathematics course for JEE preparation with problem-solving techniques.',
      category: 'Courses',
      type: ResourceType.course,
      rating: 4.9,
      price: '₹999',
      duration: '80 hours',
      level: 'Advanced',
      imageUrl: 'https://via.placeholder.com/150x100',
      isBookmarked: true,
      tags: ['JEE', 'Mathematics', 'Engineering'],
      provider: 'Tech Institute',
    ),
    ResourceItem(
      id: '3',
      title: 'Programming Fundamentals',
      description:
          'Learn programming basics with Python, perfect for beginners in technology.',
      category: 'Courses',
      type: ResourceType.course,
      rating: 4.7,
      price: 'Free',
      duration: '40 hours',
      level: 'Beginner',
      imageUrl: 'https://via.placeholder.com/150x100',
      isBookmarked: false,
      tags: ['Programming', 'Python', 'Technology'],
      provider: 'Code Academy',
    ),

    // Scholarships
    ResourceItem(
      id: '4',
      title: 'National Merit Scholarship',
      description:
          'Merit-based scholarship for students pursuing higher education in India.',
      category: 'Scholarships',
      type: ResourceType.scholarship,
      rating: 0,
      price: '₹50,000/year',
      duration: '4 years',
      level: 'All',
      imageUrl: 'https://via.placeholder.com/150x100',
      isBookmarked: true,
      tags: ['Merit', 'Government', 'Higher Education'],
      provider: 'Government of India',
    ),
    ResourceItem(
      id: '5',
      title: 'INSPIRE Scholarship Scheme',
      description:
          'Scholarship for students pursuing science courses at undergraduate and postgraduate levels.',
      category: 'Scholarships',
      type: ResourceType.scholarship,
      rating: 0,
      price: '₹80,000/year',
      duration: 'Course Duration',
      level: 'UG/PG',
      imageUrl: 'https://via.placeholder.com/150x100',
      isBookmarked: false,
      tags: ['Science', 'DST', 'Research'],
      provider: 'Department of Science & Technology',
    ),

    // Jobs
    ResourceItem(
      id: '6',
      title: 'Software Developer Internship',
      description:
          'Exciting internship opportunity for computer science students.',
      category: 'Jobs',
      type: ResourceType.job,
      rating: 0,
      price: '₹25,000/month',
      duration: '6 months',
      level: 'Entry Level',
      imageUrl: 'https://via.placeholder.com/150x100',
      isBookmarked: false,
      tags: ['Software', 'Internship', 'Technology'],
      provider: 'Tech Corp',
    ),
    ResourceItem(
      id: '7',
      title: 'Government Teaching Position',
      description:
          'Teaching positions available in government schools across various subjects.',
      category: 'Jobs',
      type: ResourceType.job,
      rating: 0,
      price: '₹35,000-60,000/month',
      duration: 'Permanent',
      level: 'Graduate',
      imageUrl: 'https://via.placeholder.com/150x100',
      isBookmarked: true,
      tags: ['Teaching', 'Government', 'Education'],
      provider: 'State Education Department',
    ),

    // Roadmaps
    ResourceItem(
      id: '8',
      title: 'NEET Preparation Roadmap',
      description:
          'Complete 2-year preparation strategy for NEET with monthly milestones.',
      category: 'Roadmaps',
      type: ResourceType.roadmap,
      rating: 4.6,
      price: 'Free',
      duration: '24 months',
      level: 'All',
      imageUrl: 'https://via.placeholder.com/150x100',
      isBookmarked: true,
      tags: ['NEET', 'Medical', 'Strategy'],
      provider: 'OSCAR Guidance',
    ),
    ResourceItem(
      id: '9',
      title: 'Software Engineer Career Path',
      description:
          'Step-by-step guide to becoming a software engineer from scratch.',
      category: 'Roadmaps',
      type: ResourceType.roadmap,
      rating: 4.8,
      price: 'Free',
      duration: '36 months',
      level: 'Beginner to Advanced',
      imageUrl: 'https://via.placeholder.com/150x100',
      isBookmarked: false,
      tags: ['Software Engineering', 'Technology', 'Career'],
      provider: 'Tech Career Guide',
    ),

    // Study Material
    ResourceItem(
      id: '10',
      title: 'NCERT Solutions Class 12',
      description:
          'Complete solutions for NCERT textbooks of Class 12 all subjects.',
      category: 'Study Material',
      type: ResourceType.studyMaterial,
      rating: 4.9,
      price: 'Free',
      duration: 'Self-paced',
      level: 'Class 12',
      imageUrl: 'https://via.placeholder.com/150x100',
      isBookmarked: true,
      tags: ['NCERT', 'Class 12', 'Solutions'],
      provider: 'Education Board',
    ),

    // Interview Preparation
    ResourceItem(
      id: '11',
      title: 'Mock Interview - Technical',
      description:
          'Practice technical interviews with AI-powered feedback and real-time analysis.',
      category: 'Interview Prep',
      type: ResourceType.course,
      rating: 4.7,
      price: 'Free',
      duration: '45 mins',
      level: 'Intermediate',
      imageUrl: 'https://via.placeholder.com/150x100',
      isBookmarked: false,
      tags: ['Technical', 'Mock Interview', 'AI Feedback'],
      provider: 'OSCAR Interview',
    ),
    ResourceItem(
      id: '12',
      title: 'Live Interview with Expert',
      description:
          'Schedule live 1-on-1 interview sessions with industry professionals.',
      category: 'Interview Prep',
      type: ResourceType.course,
      rating: 4.9,
      price: '₹499',
      duration: '60 mins',
      level: 'All Levels',
      imageUrl: 'https://via.placeholder.com/150x100',
      isBookmarked: true,
      tags: ['Live Interview', 'Expert', 'Professional'],
      provider: 'Interview Pro',
    ),
    ResourceItem(
      id: '13',
      title: 'HR & Behavioral Interview Prep',
      description:
          'Master common HR questions and behavioral interview techniques.',
      category: 'Interview Prep',
      type: ResourceType.course,
      rating: 4.6,
      price: 'Free',
      duration: '30 mins',
      level: 'Beginner',
      imageUrl: 'https://via.placeholder.com/150x100',
      isBookmarked: false,
      tags: ['HR', 'Behavioral', 'Communication'],
      provider: 'Career Coach',
    ),
    ResourceItem(
      id: '14',
      title: 'Government Job Interview Guide',
      description:
          'Comprehensive guide for government job interviews with practice questions.',
      category: 'Interview Prep',
      type: ResourceType.course,
      rating: 4.8,
      price: 'Free',
      duration: '90 mins',
      level: 'Intermediate',
      imageUrl: 'https://via.placeholder.com/150x100',
      isBookmarked: true,
      tags: ['Government', 'Public Sector', 'Interview'],
      provider: 'Govt Career Hub',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _setupAnimations();
    _loadAPIData();
  }

  /// Load real data from APIs
  Future<void> _loadAPIData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      final careerPath = appProvider.selectedCareerPath ?? 'technology';

      // Load courses from multiple sources
      final futures = await Future.wait([
        _apiService.searchCourses(
          query: careerPath,
          freeOnly: false,
          limit: 10,
        ),
        _apiService.getPersonalizedCourses(
          careerPath: careerPath,
          currentLevel: 'intermediate',
        ),
        _interviewService.getMockInterviews(),
        _interviewService.getAvailableSlots(),
      ]);

      setState(() {
        _apiCourses = futures[0] as List<Course>;
        _apiCourses.addAll(futures[1] as List<Course>);
        _mockInterviews = futures[2] as List<Interview>;
        // _liveInterviews can be populated from available slots
      });
    } catch (e) {
      print('Error loading API data: $e');
      // Fallback to static data if API fails
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Refresh data from APIs
  Future<void> _refreshData() async {
    await _loadAPIData();
  }

  /// Book a mock interview
  Future<void> _bookMockInterview(String interviewId) async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Find and book the mock interview
      final interview = _mockInterviews.firstWhere((i) => i.id == interviewId);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Mock interview "${interview.title}" booked successfully!',
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to book interview: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Schedule a live interview
  Future<void> _scheduleLiveInterview() async {
    try {
      final availableSlots = await _interviewService.getAvailableSlots();

      if (availableSlots.isNotEmpty && mounted) {
        _showLiveInterviewDialog(availableSlots);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading available slots: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  /// Show live interview booking dialog
  void _showLiveInterviewDialog(List<Map<String, dynamic>> availableSlots) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.video_call, color: AppColors.primary, size: 28),
              const SizedBox(width: 12),
              const Text(
                'Schedule Live Interview',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              itemCount: availableSlots.length,
              itemBuilder: (context, index) {
                final slot = availableSlots[index];
                final date = DateTime.parse(slot['date'].toString());
                final isAvailable = slot['available'] ?? false;

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isAvailable
                          ? AppColors.success
                          : AppColors.textTertiary,
                      child: Icon(
                        isAvailable ? Icons.check : Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      '${date.day}/${date.month} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isAvailable
                            ? AppColors.textPrimary
                            : AppColors.textTertiary,
                      ),
                    ),
                    subtitle: Text(
                      slot['interviewer'] ?? 'Expert Interviewer',
                      style: TextStyle(
                        color: isAvailable
                            ? AppColors.textSecondary
                            : AppColors.textTertiary,
                      ),
                    ),
                    trailing: isAvailable
                        ? ElevatedButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await _bookLiveInterviewSlot(slot['id']);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Book',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : const Text(
                            'Unavailable',
                            style: TextStyle(color: AppColors.textTertiary),
                          ),
                    enabled: isAvailable,
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Book a live interview slot
  Future<void> _bookLiveInterviewSlot(String slotId) async {
    try {
      setState(() {
        _isLoading = true;
      });

      final interview = await _interviewService.bookLiveInterview(
        slotId: slotId,
        category: 'technical',
        level: 'intermediate',
        topics: ['Programming', 'System Design'],
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Live interview scheduled successfully!\nMeeting ID: ${interview.meetingId}',
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to book live interview: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: AppDurations.slow,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: AppCurves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<ResourceItem> get filteredResources {
    return _resources.where((resource) {
      final matchesCategory =
          _selectedCategory == 'All' || resource.category == _selectedCategory;
      final matchesSearch =
          _searchQuery.isEmpty ||
          resource.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          resource.description.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          resource.tags.any(
            (tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()),
          );

      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              _buildAppBar(),
              _buildSearchAndFilter(),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildResourcesList(),
                    _buildInterviewPrepSection(),
                    _buildBookmarkedResources(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        boxShadow: AppShadows.small,
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.library_books,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Learning Resources',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Discover courses, scholarships & more',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // Filter options
            },
            icon: const Icon(Icons.tune, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Search Bar
          TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search resources, courses, scholarships...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                      icon: const Icon(Icons.clear),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: AppColors.surface,
            ),
          ),
          const SizedBox(height: 16),
          // Category Filter
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    backgroundColor: AppColors.surface,
                    selectedColor: AppColors.primary.withOpacity(0.1),
                    checkmarkColor: AppColors.primary,
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : AppColors.outline,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textSecondary,
        tabs: const [
          Tab(text: 'All Resources'),
          Tab(text: 'Interview Prep'),
          Tab(text: 'Bookmarked'),
        ],
      ),
    );
  }

  Widget _buildResourcesList() {
    final resources = filteredResources;

    if (resources.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: AppColors.textTertiary),
            const SizedBox(height: 16),
            Text(
              'No resources found',
              style: TextStyle(fontSize: 18, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              style: TextStyle(fontSize: 14, color: AppColors.textTertiary),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: resources.length,
      itemBuilder: (context, index) {
        return _buildResourceCard(resources[index]);
      },
    );
  }

  Widget _buildBookmarkedResources() {
    final bookmarkedResources = _resources
        .where((r) => r.isBookmarked)
        .toList();

    if (bookmarkedResources.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_border,
              size: 64,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              'No bookmarked resources',
              style: TextStyle(fontSize: 18, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              'Bookmark resources to access them quickly',
              style: TextStyle(fontSize: 14, color: AppColors.textTertiary),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookmarkedResources.length,
      itemBuilder: (context, index) {
        return _buildResourceCard(bookmarkedResources[index]);
      },
    );
  }

  Widget _buildResourceCard(ResourceItem resource) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.outline.withOpacity(0.5)),
      ),
      child: InkWell(
        onTap: () => _openResourceDetails(resource),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Resource Image/Icon
                  Container(
                    width: 80,
                    height: 60,
                    decoration: BoxDecoration(
                      color: _getResourceColor(resource.type).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getResourceIcon(resource.type),
                      color: _getResourceColor(resource.type),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                resource.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              onPressed: () => _toggleBookmark(resource),
                              icon: Icon(
                                resource.isBookmarked
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                                color: resource.isBookmarked
                                    ? AppColors.primary
                                    : AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          resource.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          resource.provider,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textTertiary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Resource Details
              Row(
                children: [
                  _buildInfoChip(resource.price, Icons.monetization_on),
                  const SizedBox(width: 8),
                  _buildInfoChip(resource.duration, Icons.access_time),
                  const SizedBox(width: 8),
                  _buildInfoChip(resource.level, Icons.signal_cellular_alt),
                  if (resource.rating > 0) ...[
                    const Spacer(),
                    Row(
                      children: [
                        Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          resource.rating.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              // Tags
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: resource.tags.take(3).map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.textTertiary),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getResourceColor(ResourceType type) {
    switch (type) {
      case ResourceType.course:
        return AppColors.primary;
      case ResourceType.scholarship:
        return AppColors.success;
      case ResourceType.job:
        return AppColors.accent;
      case ResourceType.roadmap:
        return AppColors.secondary;
      case ResourceType.studyMaterial:
        return Colors.orange;
    }
  }

  IconData _getResourceIcon(ResourceType type) {
    switch (type) {
      case ResourceType.course:
        return Icons.play_circle_filled;
      case ResourceType.scholarship:
        return Icons.card_giftcard;
      case ResourceType.job:
        return Icons.work;
      case ResourceType.roadmap:
        return Icons.route;
      case ResourceType.studyMaterial:
        return Icons.menu_book;
    }
  }

  void _toggleBookmark(ResourceItem resource) {
    setState(() {
      final index = _resources.indexWhere((r) => r.id == resource.id);
      if (index != -1) {
        _resources[index] = resource.copyWith(
          isBookmarked: !resource.isBookmarked,
        );
      }
    });

    // Here you would typically update the backend
    final action = resource.isBookmarked ? 'removed from' : 'added to';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${resource.title} $action bookmarks'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openResourceDetails(ResourceItem resource) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildResourceDetailsModal(resource),
    );
  }

  Widget _buildResourceDetailsModal(ResourceItem resource) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: _getResourceColor(
                                resource.type,
                              ).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              _getResourceIcon(resource.type),
                              color: _getResourceColor(resource.type),
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  resource.title,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  resource.provider,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Description',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        resource.description,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Details',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow('Price', resource.price),
                      _buildDetailRow('Duration', resource.duration),
                      _buildDetailRow('Level', resource.level),
                      if (resource.rating > 0)
                        _buildDetailRow('Rating', '${resource.rating}/5.0'),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _accessResource(resource);
                          },
                          child: Text(
                            _getAccessButtonText(resource.type),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  String _getAccessButtonText(ResourceType type) {
    switch (type) {
      case ResourceType.course:
        return 'Start Course';
      case ResourceType.scholarship:
        return 'Apply Now';
      case ResourceType.job:
        return 'Apply for Job';
      case ResourceType.roadmap:
        return 'View Roadmap';
      case ResourceType.studyMaterial:
        return 'Download Material';
    }
  }

  void _accessResource(ResourceItem resource) {
    // Here you would typically navigate to the resource or open a web view
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${resource.title}...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Build interview preparation section with live and mock interviews
  Widget _buildInterviewPrepSection() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Interview Prep Header
            Row(
              children: [
                Icon(Icons.psychology, color: AppColors.primary, size: 28),
                const SizedBox(width: 12),
                const Text(
                  'Interview Preparation',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Practice with mock interviews and schedule live sessions',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 24),

            // Quick Actions
            Row(
              children: [
                Expanded(
                  child: _buildInterviewActionCard(
                    'Mock Interview',
                    'Start AI-powered practice',
                    Icons.smart_toy,
                    AppColors.primary,
                    () => _bookMockInterview('mock_1'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInterviewActionCard(
                    'Live Interview',
                    'Book with expert',
                    Icons.video_call,
                    AppColors.accent,
                    _scheduleLiveInterview,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Mock Interviews Section
            const Text(
              'Mock Interviews',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_mockInterviews.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _mockInterviews.length,
                itemBuilder: (context, index) {
                  final interview = _mockInterviews[index];
                  return _buildInterviewCard(interview, isMock: true);
                },
              )
            else
              _buildEmptyState('No mock interviews available'),

            const SizedBox(height: 24),

            // Live Interviews Section
            const Text(
              'Available Live Sessions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildLiveInterviewSlots(),

            const SizedBox(height: 24),

            // Interview Tips
            _buildInterviewTips(),
          ],
        ),
      ),
    );
  }

  /// Build interview action card
  Widget _buildInterviewActionCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Build interview card
  Widget _buildInterviewCard(Interview interview, {bool isMock = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isMock
                        ? AppColors.primary.withOpacity(0.1)
                        : AppColors.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isMock ? Icons.smart_toy : Icons.person,
                    color: isMock ? AppColors.primary : AppColors.accent,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        interview.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        interview.description,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildInfoChip('${interview.duration} min', Icons.schedule),
                const SizedBox(width: 8),
                _buildInfoChip(interview.level, Icons.signal_cellular_alt),
                const SizedBox(width: 8),
                _buildInfoChip(interview.category, Icons.category),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Topics: ${interview.topics.take(3).join(', ')}',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => isMock
                      ? _bookMockInterview(interview.id)
                      : _scheduleLiveInterview(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isMock
                        ? AppColors.primary
                        : AppColors.accent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    isMock ? 'Start' : 'Book',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build live interview slots
  Widget _buildLiveInterviewSlots() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline, width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Next Available Slots',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTimeSlot('Today', '2:00 PM', true),
              _buildTimeSlot('Tomorrow', '10:00 AM', true),
              _buildTimeSlot('Wed', '4:00 PM', false),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _scheduleLiveInterview,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'View All Slots',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build time slot chip
  Widget _buildTimeSlot(String day, String time, bool available) {
    return Column(
      children: [
        Text(
          day,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: available ? AppColors.textPrimary : AppColors.textTertiary,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: available
                ? AppColors.success.withOpacity(0.1)
                : AppColors.textTertiary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: available ? AppColors.success : AppColors.textTertiary,
              width: 1,
            ),
          ),
          child: Text(
            time,
            style: TextStyle(
              fontSize: 10,
              color: available ? AppColors.success : AppColors.textTertiary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  /// Build interview tips section
  Widget _buildInterviewTips() {
    final tips = [
      'Research the company and role beforehand',
      'Practice common interview questions',
      'Prepare examples using the STAR method',
      'Dress appropriately for the interview',
      'Arrive 10-15 minutes early',
      'Ask thoughtful questions about the role',
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.accent.withOpacity(0.1),
            AppColors.primary.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, color: AppColors.accent, size: 24),
              const SizedBox(width: 8),
              const Text(
                'Interview Tips',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...tips.map(
            (tip) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 6),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      tip,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build empty state
  Widget _buildEmptyState(String message) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(Icons.inbox, size: 64, color: AppColors.textTertiary),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

enum ResourceType { course, scholarship, job, roadmap, studyMaterial }

class ResourceItem {
  final String id;
  final String title;
  final String description;
  final String category;
  final ResourceType type;
  final double rating;
  final String price;
  final String duration;
  final String level;
  final String imageUrl;
  final bool isBookmarked;
  final List<String> tags;
  final String provider;

  ResourceItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.type,
    required this.rating,
    required this.price,
    required this.duration,
    required this.level,
    required this.imageUrl,
    required this.isBookmarked,
    required this.tags,
    required this.provider,
  });

  ResourceItem copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    ResourceType? type,
    double? rating,
    String? price,
    String? duration,
    String? level,
    String? imageUrl,
    bool? isBookmarked,
    List<String>? tags,
    String? provider,
  }) {
    return ResourceItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      type: type ?? this.type,
      rating: rating ?? this.rating,
      price: price ?? this.price,
      duration: duration ?? this.duration,
      level: level ?? this.level,
      imageUrl: imageUrl ?? this.imageUrl,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      tags: tags ?? this.tags,
      provider: provider ?? this.provider,
    );
  }
}
