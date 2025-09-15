import 'package:flutter/material.dart';

class RoadmapPage extends StatelessWidget {
  const RoadmapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Career Roadmap',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2563EB),
              ),
            ),
            const SizedBox(height: 20),
            
            // Progress Overview
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Progress',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: 0.65,
                    backgroundColor: const Color.fromRGBO(255, 255, 255, 0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '65% Complete - Software Developer Path',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Roadmap Steps
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  final steps = [
                    {'title': 'Foundation Skills', 'status': 'completed', 'icon': Icons.check_circle},
                    {'title': 'Programming Languages', 'status': 'completed', 'icon': Icons.check_circle},
                    {'title': 'Web Development', 'status': 'current', 'icon': Icons.play_circle_filled},
                    {'title': 'Advanced Projects', 'status': 'pending', 'icon': Icons.radio_button_unchecked},
                    {'title': 'Industry Ready', 'status': 'pending', 'icon': Icons.radio_button_unchecked},
                  ];
                  
                  final step = steps[index];
                  final isCompleted = step['status'] == 'completed';
                  final isCurrent = step['status'] == 'current';
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isCompleted ? Colors.green : (isCurrent ? const Color(0xFF2563EB) : Colors.grey[300]),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            step['icon'] as IconData,
                            color: isCompleted || isCurrent ? Colors.white : Colors.grey[600],
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isCurrent ? const Color.fromRGBO(37, 99, 235, 0.1) : Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isCurrent ? const Color(0xFF2563EB) : Colors.grey[300]!,
                                width: isCurrent ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  step['title'] as String,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isCurrent ? const Color(0xFF2563EB) : Colors.black87,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  isCompleted ? 'Completed ✓' : (isCurrent ? 'In Progress...' : 'Not Started'),
                                  style: TextStyle(
                                    color: isCompleted ? Colors.green : (isCurrent ? const Color(0xFF2563EB) : Colors.grey[600]),
                                    fontSize: 12,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
