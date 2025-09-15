import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'OSCAR',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: const Text('Get Started'),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Hero Section
                Text(
                  'Navigate Your Career Journey with Confidence',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'OSCAR combines AI-powered assessments, personalized roadmaps, and intelligent resume analysis to guide you towards your ideal career path.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),

                // CTA Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => context.go('/login'),
                        child: const Text('Start Your Journey'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => context.go('/login'),
                        child: const Text('Learn More'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48),

                // Statistics Section
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'The Career Challenge',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              percentage: '70%',
                              description: 'Students unsure about career paths',
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: _StatCard(
                              percentage: '45%',
                              description: 'Job seekers lack required skills',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              percentage: '60%',
                              description: 'Resumes fail ATS screening',
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: _StatCard(
                              percentage: '80%',
                              description: 'Need personalized guidance',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),

                // Features Section
                Text(
                  'How OSCAR Helps You Succeed',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                const _FeatureCard(
                  icon: Icons.psychology,
                  title: 'AI-Powered Assessment',
                  description: 'Comprehensive career assessment using advanced AI algorithms to identify your strengths and interests.',
                ),
                const SizedBox(height: 16),
                const _FeatureCard(
                  icon: Icons.route,
                  title: 'Personalized Roadmaps',
                  description: 'Custom career roadmaps tailored to your goals, skills, and preferred learning style.',
                ),
                const SizedBox(height: 16),
                const _FeatureCard(
                  icon: Icons.analytics,
                  title: 'ATS Resume Analysis',
                  description: 'Advanced resume scanning with ATS compatibility scoring and improvement suggestions.',
                ),
                const SizedBox(height: 16),
                const _FeatureCard(
                  icon: Icons.school,
                  title: 'Skill Development',
                  description: 'Curated resources and learning paths to bridge skill gaps and accelerate career growth.',
                ),
                const SizedBox(height: 48),

                // Final CTA
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor,
                        Color.fromARGB(204, Theme.of(context).primaryColor.red, Theme.of(context).primaryColor.green, Theme.of(context).primaryColor.blue),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Ready to Transform Your Career?',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Join thousands of professionals who have discovered their ideal career path with OSCAR.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xE6FFFFFF),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => context.go('/login'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Theme.of(context).primaryColor,
                        ),
                        child: const Text('Get Started Today'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String percentage;
  final String description;

  const _StatCard({
    required this.percentage,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            percentage,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color.fromARGB(26, Theme.of(context).primaryColor.red, Theme.of(context).primaryColor.green, Theme.of(context).primaryColor.blue),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
