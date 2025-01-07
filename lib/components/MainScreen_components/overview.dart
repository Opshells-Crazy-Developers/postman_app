// overview.dart
import 'package:flutter/material.dart';

class Overview extends StatelessWidget {
  const Overview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[850],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Text(
              'Welcome to Postman Clone',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),

            // Quick Actions Card
            SizedBox(
              width: double.infinity,
              child: Card(
                color: Colors.grey[800],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quick Actions',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildQuickActionButton(
                              context,
                              'New Request',
                              Icons.add,
                              () {
                                // Handle new request action
                              },
                            ),
                            _buildQuickActionButton(
                              context,
                              'Import',
                              Icons.file_upload,
                              () {
                                // Handle import action
                              },
                            ),
                            _buildQuickActionButton(
                              context,
                              'New Collection',
                              Icons.create_new_folder,
                              () {
                                // Handle new collection action
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Recent Requests Section
            Text(
              'Recent Requests',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: recentRequests.length,
                itemBuilder: (context, index) {
                  final request = recentRequests[index];
                  return Card(
                    color: Colors.grey[800],
                    margin: EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getMethodColor(request.method),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          request.method,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        request.url,
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        request.timestamp,
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      onTap: () {
                        // Handle request tap
                      },
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

  Widget _buildQuickActionButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onPressed: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Color _getMethodColor(String method) {
    switch (method) {
      case 'GET':
        return Colors.green;
      case 'POST':
        return Colors.orange;
      case 'PUT':
        return Colors.blue;
      case 'DELETE':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

// Sample data class for recent requests
class RecentRequest {
  final String method;
  final String url;
  final String timestamp;

  RecentRequest({
    required this.method,
    required this.url,
    required this.timestamp,
  });
}

// Sample data
final List<RecentRequest> recentRequests = [
  RecentRequest(
    method: 'GET',
    url: 'https://api.example.com/users',
    timestamp: '2 minutes ago',
  ),
  RecentRequest(
    method: 'POST',
    url: 'https://api.example.com/posts',
    timestamp: '1 hour ago',
  ),
  RecentRequest(
    method: 'PUT',
    url: 'https://api.example.com/users/1',
    timestamp: '2 hours ago',
  ),
  RecentRequest(
    method: 'DELETE',
    url: 'https://api.example.com/posts/1',
    timestamp: '3 hours ago',
  ),
  // Add more sample requests as needed
];
