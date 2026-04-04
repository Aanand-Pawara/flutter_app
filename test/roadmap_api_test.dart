import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/services/roadmap_service.dart';

void main() {
  group('Roadmap API Tests', () {
    late RoadmapService roadmapService;

    setUp(() {
      roadmapService = RoadmapService();
    });

    test(
      'should generate comprehensive structured roadmap for 10th standard',
      () async {
        final roadmap = await roadmapService.getRoadmapForCareerPath(
          careerPath: '10th',
          currentLevel: 'beginner',
          durationMonths: 12,
        );

        expect(roadmap, isNotNull);
        expect(roadmap.careerPath, equals('10th'));
        expect(roadmap.phases, isNotEmpty);
        expect(roadmap.title, contains('10th'));

        // Check for comprehensive structure
        expect(
          roadmap.description.length,
          greaterThan(100),
        ); // Should have detailed description
        expect(
          roadmap.phases.length,
          greaterThanOrEqualTo(4),
        ); // Should have multiple phases
        expect(
          roadmap.outcomes.length,
          greaterThanOrEqualTo(5),
        ); // Should have detailed outcomes

        // Check phase structure
        for (final phase in roadmap.phases) {
          expect(
            phase.skills.length,
            greaterThanOrEqualTo(3),
          ); // Each phase should have multiple skills
          expect(
            phase.milestones.length,
            greaterThanOrEqualTo(3),
          ); // Each phase should have multiple milestones
          expect(
            phase.resources.length,
            greaterThanOrEqualTo(3),
          ); // Each phase should have multiple resources
        }

        print('✅ Comprehensive 10th Standard roadmap generated successfully');
        print('Title: ${roadmap.title}');
        print('Description length: ${roadmap.description.length} characters');
        print('Phases: ${roadmap.phases.length}');
        print(
          'Total milestones: ${roadmap.phases.expand((p) => p.milestones).length}',
        );
        print('Total skills: ${roadmap.phases.expand((p) => p.skills).length}');
        print('Duration: ${roadmap.estimatedDuration} months');
      },
    );

    test('should generate comprehensive technology career roadmap', () async {
      final roadmap = await roadmapService.getRoadmapForCareerPath(
        careerPath: 'technology',
        currentLevel: 'beginner',
        durationMonths: 24,
      );

      expect(roadmap, isNotNull);
      expect(roadmap.careerPath, equals('technology'));
      expect(roadmap.phases, isNotEmpty);
      // Accept either "Technology" or "Developer" or "Full-Stack" in the title
      expect(
        roadmap.title.toLowerCase().contains('technology') ||
            roadmap.title.toLowerCase().contains('developer') ||
            roadmap.title.toLowerCase().contains('full-stack') ||
            roadmap.title.toLowerCase().contains('mastery'),
        isTrue,
      );

      // Check for comprehensive structure
      expect(
        roadmap.description.length,
        greaterThan(200),
      ); // Should have very detailed description
      expect(
        roadmap.phases.length,
        greaterThanOrEqualTo(4),
      ); // Should have multiple phases
      expect(
        roadmap.prerequisites.length,
        greaterThanOrEqualTo(3),
      ); // Should have detailed prerequisites

      print('✅ Comprehensive Technology roadmap generated successfully');
      print('Title: ${roadmap.title}');
      print('Description: ${roadmap.description.substring(0, 150)}...');
      print('Phases: ${roadmap.phases.length}');
      print('Prerequisites: ${roadmap.prerequisites.length}');
      print('Outcomes: ${roadmap.outcomes.length}');
      print('Duration: ${roadmap.estimatedDuration} months');
    });

    test('should generate roadmap for JEE preparation', () async {
      final roadmap = await roadmapService.getRoadmapForCareerPath(
        careerPath: 'jee',
        currentLevel: 'intermediate',
        durationMonths: 18,
      );

      expect(roadmap, isNotNull);
      expect(roadmap.careerPath, equals('jee'));
      expect(roadmap.phases, isNotEmpty);

      print('✅ JEE roadmap generated successfully');
      print('Title: ${roadmap.title}');
      print('Phases: ${roadmap.phases.length}');
    });

    test('should handle cache correctly', () async {
      // Clear cache first
      roadmapService.clearCache();

      // First call - should generate new roadmap
      final roadmap1 = await roadmapService.getRoadmapForCareerPath(
        careerPath: 'neet',
        currentLevel: 'beginner',
        durationMonths: 12,
      );

      // Second call with same parameters - should return cached roadmap
      final roadmap2 = await roadmapService.getRoadmapForCareerPath(
        careerPath: 'neet',
        currentLevel: 'beginner',
        durationMonths: 12,
      );

      expect(roadmap1.id, equals(roadmap2.id));
      print('✅ Cache working correctly');
    });

    test('should return available career paths', () {
      final careerPaths = roadmapService.getAvailableCareerPaths();

      expect(careerPaths, isNotEmpty);
      expect(careerPaths, contains('10th'));
      expect(careerPaths, contains('12th'));
      expect(careerPaths, contains('technology'));
      expect(careerPaths, contains('jee'));
      expect(careerPaths, contains('neet'));

      print('✅ Available career paths: ${careerPaths.join(', ')}');
    });

    test('should generate roadmap stats', () async {
      final roadmap = await roadmapService.getRoadmapForCareerPath(
        careerPath: 'technology',
        currentLevel: 'beginner',
        durationMonths: 12,
      );

      final stats = roadmapService.getRoadmapStats(roadmap, null);

      expect(stats, isNotNull);
      expect(stats['totalPhases'], greaterThan(0));
      expect(stats['totalMilestones'], greaterThan(0));
      expect(stats['completionPercentage'], equals(0.0));

      print('✅ Roadmap stats generated successfully');
      print('Stats: $stats');
    });
  });
}
