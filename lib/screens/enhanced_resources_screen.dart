import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/providers/app_provider.dart';
import 'package:flutter_app/utils/app_theme.dart';

class EnhancedResourcesScreen extends StatefulWidget {
  const EnhancedResourcesScreen({super.key});

  @override
  State<EnhancedResourcesScreen> createState() => _EnhancedResourcesScreenState();
}

class _EnhancedResourcesScreenState extends State<EnhancedResourcesScreen> 
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'All', 'Courses', 'Scholarships', 'Jobs', 'Roadmaps', 'Study Material'
  ];

  final List<ResourceItem> _resources = [
    // Courses
    ResourceItem(
      id: '1',
      title: 'Complete NEET Biology Course',
      description: 'Comprehensive biology course covering all NEET topics with video lectures and practice tests.',
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
      description: 'Advanced mathematics course for JEE preparation with problem-solving techniques.',
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
      description: 'Learn programming basics with Python, perfect for beginners in technology.',
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
      description: 'Merit-based scholarship for students pursuing higher education in India.',
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
      description: 'Scholarship for students pursuing science courses at undergraduate and postgraduate levels.',
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
      description: 'Exciting internship opportunity for computer science students.',
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
      description: 'Teaching positions available in government schools across various subjects.',
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
      description: 'Complete 2-year preparation strategy for NEET with monthly milestones.',
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
      description: 'Step-by-step guide to becoming a software engineer from scratch.',
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
      description: 'Complete solutions for NCERT textbooks of Class 12 all subjects.',
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
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _setupAnimations();
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
      final matchesCategory = _selectedCategory == 'All' || resource.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty || 
          resource.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          resource.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          resource.tags.any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()));
      
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
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // Filter options
            },
            icon: const Icon(
              Icons.tune,
              color: Colors.white,
            ),
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
            Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              'No resources found',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textTertiary,
              ),
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
    final bookmarkedResources = _resources.where((r) => r.isBookmarked).toList();
    
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
              style: TextStyle(
                fontSize: 18,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Bookmark resources to access them quickly',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textTertiary,
              ),
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
                        Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber,
                        ),
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
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
          Icon(
            icon,
            size: 12,
            color: AppColors.textTertiary,
          ),
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
        _resources[index] = resource.copyWith(isBookmarked: !resource.isBookmarked);
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
                              color: _getResourceColor(resource.type).withOpacity(0.1),
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
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
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
}

enum ResourceType {
  course,
  scholarship,
  job,
  roadmap,
  studyMaterial,
}

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