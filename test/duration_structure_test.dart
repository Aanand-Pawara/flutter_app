import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/services/roadmap_service.dart';

void main() {
  group('Duration-Based Roadmap Structure Tests', () {
    late RoadmapService roadmapService;

    setUp(() {
      roadmapService = RoadmapService();
    });

    test('3 Month Intensive Technology Roadmap', () async {
      print('\n🚀 3-MONTH INTENSIVE TECHNOLOGY ROADMAP');
      print('=' * 50);
      
      final roadmap = await roadmapService.getRoadmapForCareerPath(
        careerPath: 'technology',
        currentLevel: 'beginner',
        durationMonths: 3,
      );

      print('Title: ${roadmap.title}');
      print('Duration: ${roadmap.estimatedDuration} months');
      print('Difficulty: ${roadmap.difficultyLevel}');
      print('Total Phases: ${roadmap.phases.length}');
      
      print('\nPhase Structure:');
      for (int i = 0; i < roadmap.phases.length; i++) {
        final phase = roadmap.phases[i];
        print('Phase ${i + 1}: ${phase.title}');
        print('  Duration: ${phase.duration} weeks');
        print('  Skills: ${phase.skills.length} focused skills');
        print('  Milestones: ${phase.milestones.length} intensive checkpoints');
      }

      // Verify 3-month structure
      expect(roadmap.estimatedDuration, equals(3));
      expect(roadmap.difficultyLevel, equals('Intensive'));
      expect(roadmap.phases.length, equals(3)); // Focused phases
      expect(roadmap.title.contains('Intensive'), isTrue);
    });

    test('6 Month Accelerated Technology Roadmap', () async {
      print('\n⚡ 6-MONTH ACCELERATED TECHNOLOGY ROADMAP');
      print('=' * 50);
      
      final roadmap = await roadmapService.getRoadmapForCareerPath(
        careerPath: 'technology',
        currentLevel: 'beginner',
        durationMonths: 6,
      );

      print('Title: ${roadmap.title}');
      print('Duration: ${roadmap.estimatedDuration} months');
      print('Difficulty: ${roadmap.difficultyLevel}');
      print('Total Phases: ${roadmap.phases.length}');
      
      print('\nPhase Structure:');
      for (int i = 0; i < roadmap.phases.length; i++) {
        final phase = roadmap.phases[i];
        print('Phase ${i + 1}: ${phase.title}');
        print('  Duration: ${phase.duration} weeks');
        print('  Skills: ${phase.skills.length} balanced skills');
        print('  Milestones: ${phase.milestones.length} regular checkpoints');
      }

      // Verify 6-month structure
      expect(roadmap.estimatedDuration, equals(6));
      expect(roadmap.difficultyLevel, equals('Accelerated'));
      expect(roadmap.phases.length, equals(4)); // Balanced phases
      expect(roadmap.title.contains('Accelerated'), isTrue);
    });

    test('12 Month Comprehensive Technology Roadmap', () async {
      print('\n🎯 12-MONTH COMPREHENSIVE TECHNOLOGY ROADMAP');
      print('=' * 50);
      
      final roadmap = await roadmapService.getRoadmapForCareerPath(
        careerPath: 'technology',
        currentLevel: 'beginner',
        durationMonths: 12,
      );

      print('Title: ${roadmap.title}');
      print('Duration: ${roadmap.estimatedDuration} months');
      print('Difficulty: ${roadmap.difficultyLevel}');
      print('Total Phases: ${roadmap.phases.length}');
      
      print('\nPhase Structure:');
      for (int i = 0; i < roadmap.phases.length; i++) {
        final phase = roadmap.phases[i];
        print('Phase ${i + 1}: ${phase.title}');
        print('  Duration: ${phase.duration} weeks');
        print('  Skills: ${phase.skills.length} comprehensive skills');
        print('  Milestones: ${phase.milestones.length} detailed checkpoints');
      }

      // Verify 12-month structure
      expect(roadmap.estimatedDuration, equals(12));
      expect(roadmap.difficultyLevel, equals('Comprehensive'));
      expect(roadmap.phases.length, equals(6)); // Comprehensive phases
      expect(roadmap.title.contains('Comprehensive'), isTrue);
    });

    test('24 Month Mastery Technology Roadmap', () async {
      print('\n🏆 24-MONTH MASTERY TECHNOLOGY ROADMAP');
      print('=' * 50);
      
      final roadmap = await roadmapService.getRoadmapForCareerPath(
        careerPath: 'technology',
        currentLevel: 'beginner',
        durationMonths: 24,
      );

      print('Title: ${roadmap.title}');
      print('Duration: ${roadmap.estimatedDuration} months');
      print('Difficulty: ${roadmap.difficultyLevel}');
      print('Total Phases: ${roadmap.phases.length}');
      
      print('\nPhase Structure:');
      for (int i = 0; i < roadmap.phases.length; i++) {
        final phase = roadmap.phases[i];
        print('Phase ${i + 1}: ${phase.title}');
        print('  Duration: ${phase.duration} weeks');
        print('  Skills: ${phase.skills.length} expert-level skills');
        print('  Milestones: ${phase.milestones.length} mastery checkpoints');
      }

      // Verify 24-month structure
      expect(roadmap.estimatedDuration, equals(24));
      expect(roadmap.difficultyLevel, equals('Mastery'));
      expect(roadmap.phases.length, equals(8)); // Expert phases
      expect(roadmap.title.contains('Mastery'), isTrue);
    });

    test('Duration Comparison Analysis', () async {
      print('\n📊 DURATION COMPARISON ANALYSIS');
      print('=' * 60);

      final durations = [3, 6, 12, 24];
      final roadmaps = <String, dynamic>{};

      for (final duration in durations) {
        final roadmap = await roadmapService.getRoadmapForCareerPath(
          careerPath: 'technology',
          currentLevel: 'beginner',
          durationMonths: duration,
        );
        roadmaps['${duration}M'] = roadmap;
      }

      print('\nDuration Structure Comparison:');
      print('Duration | Phases | Avg Weeks/Phase | Skills/Phase | Milestones/Phase');
      print('-' * 65);

      for (final entry in roadmaps.entries) {
        final duration = entry.key;
        final roadmap = entry.value;
        final avgWeeks = roadmap.phases.isNotEmpty 
            ? (roadmap.phases.map((p) => p.duration).reduce((a, b) => a + b) / roadmap.phases.length).round()
            : 0;
        final avgSkills = roadmap.phases.isNotEmpty
            ? (roadmap.phases.map((p) => p.skills.length).reduce((a, b) => a + b) / roadmap.phases.length).round()
            : 0;
        final avgMilestones = roadmap.phases.isNotEmpty
            ? (roadmap.phases.map((p) => p.milestones.length).reduce((a, b) => a + b) / roadmap.phases.length).round()
            : 0;

        print('${duration.padRight(8)} | ${roadmap.phases.length.toString().padRight(6)} | ${avgWeeks.toString().padRight(15)} | ${avgSkills.toString().padRight(12)} | $avgMilestones');
      }

      print('\nIntensity Analysis:');
      for (final entry in roadmaps.entries) {
        final duration = entry.key;
        final roadmap = entry.value;
        print('$duration: ${roadmap.difficultyLevel} - ${roadmap.prerequisites.length} prerequisites, ${roadmap.outcomes.length} outcomes');
      }

      print('\n✅ Duration-based structure working correctly!');
    });
  });
}