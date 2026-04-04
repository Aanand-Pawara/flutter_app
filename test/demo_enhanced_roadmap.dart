import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/services/roadmap_service.dart';

void main() {
  group('Enhanced Roadmap Demo', () {
    late RoadmapService roadmapService;

    setUp(() {
      roadmapService = RoadmapService();
    });

    test('Demo: Technology Career Roadmap Structure', () async {
      print('\n🚀 DEMO: Enhanced Technology Career Roadmap\n');
      print('=' * 60);

      final roadmap = await roadmapService.getRoadmapForCareerPath(
        careerPath: 'technology',
        currentLevel: 'beginner',
        durationMonths: 12,
      );

      print('\n📋 ROADMAP TITLE:');
      print(roadmap.title);

      print('\n📖 DESCRIPTION:');
      print(roadmap.description);

      print('\n🎯 PREREQUISITES (${roadmap.prerequisites.length}):');
      for (int i = 0; i < roadmap.prerequisites.length; i++) {
        print('${i + 1}. ${roadmap.prerequisites[i]}');
      }

      print('\n🏆 EXPECTED OUTCOMES (${roadmap.outcomes.length}):');
      for (int i = 0; i < roadmap.outcomes.length; i++) {
        print('${i + 1}. ${roadmap.outcomes[i]}');
      }

      print('\n📚 LEARNING PHASES (${roadmap.phases.length}):');
      for (int i = 0; i < roadmap.phases.length; i++) {
        final phase = roadmap.phases[i];
        print('\n--- PHASE ${i + 1}: ${phase.title} ---');
        print('Duration: ${phase.duration} weeks');
        print('Description: ${phase.description.substring(0, 150)}...');

        print('\nSkills (${phase.skills.length}):');
        for (int j = 0; j < phase.skills.length && j < 4; j++) {
          print('  • ${phase.skills[j]}');
        }
        if (phase.skills.length > 4) {
          print('  • ... and ${phase.skills.length - 4} more skills');
        }

        print('\nMilestones (${phase.milestones.length}):');
        for (int j = 0; j < phase.milestones.length && j < 2; j++) {
          final milestone = phase.milestones[j];
          print('  🎯 ${milestone.title} (${milestone.points} points)');
          print('     ${milestone.description.substring(0, 100)}...');
        }
        if (phase.milestones.length > 2) {
          print('  🎯 ... and ${phase.milestones.length - 2} more milestones');
        }

        print('\nResources (${phase.resources.length}):');
        for (int j = 0; j < phase.resources.length && j < 3; j++) {
          final resource = phase.resources[j];
          final price = resource.isFree
              ? 'Free'
              : '₹${resource.price?.toInt()}';
          print('  📚 ${resource.title} ($price) - ${resource.provider}');
        }
        if (phase.resources.length > 3) {
          print('  📚 ... and ${phase.resources.length - 3} more resources');
        }
      }

      print('\n💼 CAREER INFORMATION:');
      print('Average Salary: ₹${roadmap.averageSalary.toInt()}');
      print('Job Outlook: ${roadmap.jobOutlook}');
      print('Certifications: ${roadmap.certifications.join(', ')}');

      print('\n📊 ROADMAP STATISTICS:');
      final stats = roadmapService.getRoadmapStats(roadmap, null);
      print('Total Phases: ${stats['totalPhases']}');
      print('Total Milestones: ${stats['totalMilestones']}');
      print('Total Points Available: ${stats['totalPoints']}');
      print('Estimated Duration: ${roadmap.estimatedDuration} months');
      print('Difficulty Level: ${roadmap.difficultyLevel}');

      print('\n${'=' * 60}');
      print('✅ This is now a comprehensive, ChatGPT-quality roadmap!');
      print('=' * 60);

      // Verify the enhanced structure
      expect(roadmap.description.length, greaterThan(200));
      expect(roadmap.phases.length, greaterThanOrEqualTo(4));
      expect(roadmap.outcomes.length, greaterThanOrEqualTo(8));
      expect(roadmap.prerequisites.length, greaterThanOrEqualTo(3));

      for (final phase in roadmap.phases) {
        expect(phase.skills.length, greaterThanOrEqualTo(4));
        expect(phase.milestones.length, greaterThanOrEqualTo(3));
        expect(phase.resources.length, greaterThanOrEqualTo(3));
      }
    });

    test('Demo: 10th Standard Academic Roadmap Structure', () async {
      print('\n📚 DEMO: Enhanced 10th Standard Academic Roadmap\n');
      print('=' * 60);

      final roadmap = await roadmapService.getRoadmapForCareerPath(
        careerPath: '10th',
        currentLevel: 'beginner',
        durationMonths: 12,
      );

      print('\n📋 ACADEMIC PROGRAM:');
      print(roadmap.title);

      print('\n📖 PROGRAM OVERVIEW:');
      print('${roadmap.description.substring(0, 300)}...');

      print('\n🎯 ACADEMIC PREREQUISITES:');
      for (final prereq in roadmap.prerequisites) {
        print('• $prereq');
      }

      print('\n🏆 ACADEMIC OUTCOMES:');
      for (int i = 0; i < roadmap.outcomes.length && i < 5; i++) {
        print('${i + 1}. ${roadmap.outcomes[i]}');
      }

      print('\n📚 STUDY PHASES:');
      for (int i = 0; i < roadmap.phases.length; i++) {
        final phase = roadmap.phases[i];
        print('\nPhase ${i + 1}: ${phase.title}');
        print('Study Period: ${phase.duration} weeks');
        print('Subject Skills: ${phase.skills.length} skills covered');
        print('Learning Milestones: ${phase.milestones.length} assessments');
      }

      print('\n📊 ACADEMIC STATISTICS:');
      final totalSkills = roadmap.phases.expand((p) => p.skills).length;
      final totalMilestones = roadmap.phases.expand((p) => p.milestones).length;
      print('Total Subject Skills: $totalSkills');
      print('Total Assessments: $totalMilestones');
      print('Study Duration: ${roadmap.estimatedDuration} months');

      print('\n${'=' * 60}');
      print('✅ Comprehensive academic preparation program created!');
      print('=' * 60);
    });
  });
}
