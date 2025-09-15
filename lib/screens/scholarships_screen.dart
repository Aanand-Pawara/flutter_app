import 'package:flutter/material.dart';

class ScholarshipsPage extends StatelessWidget {
  const ScholarshipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Scholarships',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2563EB),
              ),
            ),
            const SizedBox(height: 20),
            
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search scholarships...',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Scholarship Cards
            Expanded(
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) {
                  final scholarships = [
                    {'name': 'Merit Scholarship', 'amount': '₹50,000', 'deadline': '15 Days', 'match': '95%'},
                    {'name': 'STEM Excellence Award', 'amount': '₹75,000', 'deadline': '22 Days', 'match': '88%'},
                    {'name': 'Innovation Grant', 'amount': '₹1,00,000', 'deadline': '8 Days', 'match': '82%'},
                    {'name': 'Women in Tech', 'amount': '₹60,000', 'deadline': '30 Days', 'match': '90%'},
                    {'name': 'Rural Development', 'amount': '₹40,000', 'deadline': '12 Days', 'match': '76%'},
                    {'name': 'Research Fellowship', 'amount': '₹80,000', 'deadline': '25 Days', 'match': '85%'},
                  ];
                  
                  final scholarship = scholarships[index];
                  final isUrgent = int.parse(scholarship['deadline']!.split(' ')[0]) <= 10;
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromRGBO(158, 158, 158, 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    scholarship['name']!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: int.parse(scholarship['match']!.replaceAll('%', '')) >= 85 
                                        ? const Color.fromRGBO(76, 175, 80, 0.1)
                                        : const Color.fromRGBO(255, 152, 0, 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${scholarship['match']} Match',
                                    style: TextStyle(
                                      color: int.parse(scholarship['match']!.replaceAll('%', '')) >= 85 
                                          ? Colors.green 
                                          : Colors.orange,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(Icons.monetization_on, color: Colors.green, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  scholarship['amount']!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Icon(
                                  Icons.schedule,
                                  color: isUrgent ? Colors.red : Colors.orange,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  scholarship['deadline']!,
                                  style: TextStyle(
                                    color: isUrgent ? Colors.red : Colors.orange,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Applying for ${scholarship['name']}'),
                                      backgroundColor: const Color(0xFF2563EB),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2563EB),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Apply Now'),
                              ),
                            ),
                          ],
                        ),
                      ),
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
