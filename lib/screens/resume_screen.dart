import 'package:flutter/material.dart';

class ResumeAnalysisPage extends StatefulWidget {
  const ResumeAnalysisPage({super.key});

  @override
  State<ResumeAnalysisPage> createState() => _ResumeAnalysisPageState();
}

class _ResumeAnalysisPageState extends State<ResumeAnalysisPage> {
  bool _isAnalyzing = false;
  bool _hasResults = false;
  final TextEditingController _companyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ATS Resume Analysis',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2563EB),
              ),
            ),
            const SizedBox(height: 20),
            
            if (!_hasResults) ..._buildUploadSection() else ..._buildResultsSection(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildUploadSection() {
    return [
      // Upload Resume
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!, width: 2),
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[50],
        ),
        child: Column(
          children: [
            Icon(Icons.cloud_upload, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              'Upload Your Resume',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Drag and drop or click to browse\nSupported: PDF, DOC, DOCX',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Resume uploaded successfully!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
              ),
              child: const Text('Browse Files'),
            ),
          ],
        ),
      ),
      
      const SizedBox(height: 24),
      
      // Company Description
      Text(
        'Target Company/Role',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey[800],
        ),
      ),
      const SizedBox(height: 8),
      TextField(
        controller: _companyController,
        maxLines: 4,
        decoration: InputDecoration(
          hintText: 'Paste the job description or company requirements here...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
      ),
      
      const SizedBox(height: 24),
      
      // Analyze Button
      SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: _isAnalyzing ? null : _analyzeResume,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2563EB),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: _isAnalyzing 
              ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text('Analyzing...'),
                  ],
                )
              : const Text('Analyze Resume', style: TextStyle(fontSize: 16)),
        ),
      ),
    ];
  }

  List<Widget> _buildResultsSection() {
    return [
      // ATS Score
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ATS Score',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '78/100',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Good Match',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(255, 255, 255, 0.2),
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(
                Icons.analytics,
                color: Colors.white,
                size: 40,
              ),
            ),
          ],
        ),
      ),
      
      const SizedBox(height: 24),
      
      // Missing Skills
      const Text(
        'Missing Skills',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 12),
      
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          'React.js',
          'Node.js',
          'MongoDB',
          'Docker',
          'AWS',
        ].map((skill) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(244, 67, 54, 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color.fromRGBO(244, 67, 54, 0.3)),
          ),
          child: Text(
            skill,
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
        )).toList(),
      ),
      
      const SizedBox(height: 24),
      
      // Recommended Courses
      const Text(
        'Recommended Courses',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 12),
      
      Expanded(
        child: ListView.builder(
          itemCount: 3,
          itemBuilder: (context, index) {
            final courses = [
              {'name': 'Complete React.js Course', 'duration': '6 weeks', 'rating': '4.8'},
              {'name': 'Node.js & Express Masterclass', 'duration': '4 weeks', 'rating': '4.7'},
              {'name': 'MongoDB Database Design', 'duration': '3 weeks', 'rating': '4.6'},
            ];
            
            final course = courses[index];
            
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(37, 99, 235, 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.play_circle_fill,
                    color: Color(0xFF2563EB),
                  ),
                ),
                title: Text(
                  course['name']!,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text('${course['duration']} • ⭐ ${course['rating']}'),
                trailing: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Starting ${course['name']}')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(60, 32),
                  ),
                  child: const Text('Start'),
                ),
              ),
            );
          },
        ),
      ),
      
      const SizedBox(height: 16),
      
      // New Analysis Button
      SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () {
            setState(() {
              _hasResults = false;
              _companyController.clear();
            });
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF2563EB),
            side: const BorderSide(color: Color(0xFF2563EB)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('New Analysis'),
        ),
      ),
    ];
  }

  void _analyzeResume() {
    setState(() {
      _isAnalyzing = true;
    });
    
    // Simulate analysis
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isAnalyzing = false;
        _hasResults = true;
      });
    });
  }
}
