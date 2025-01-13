import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  String _formatDate(DateTime date) {
    DateTime now = DateTime.now();
    DateTime yesterday = DateTime.now().subtract(Duration(days: 1));

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today';
    } else if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return 'Yesterday';
    } else {
      return DateFormat('MMM dd, yyyy').format(date);
    }
  }

  String _formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        backgroundColor: Colors.grey[900],
      ),
      body: Container(
        color: Colors.grey[850],
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('history')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  'No history found',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            // Group documents by date
            Map<String, List<QueryDocumentSnapshot>> groupedDocs = {};

            for (var doc in snapshot.data!.docs) {
              final data = doc.data() as Map<String, dynamic>;
              if (data['timestamp'] != null) {
                DateTime date = (data['timestamp'] as Timestamp).toDate();
                String dateKey = _formatDate(date);
                if (!groupedDocs.containsKey(dateKey)) {
                  groupedDocs[dateKey] = [];
                }
                groupedDocs[dateKey]!.add(doc);
              }
            }

            return ListView.builder(
              itemCount: groupedDocs.length,
              itemBuilder: (context, index) {
                String dateKey = groupedDocs.keys.elementAt(index);
                List<QueryDocumentSnapshot> docs = groupedDocs[dateKey]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        dateKey,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ...docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final timestamp =
                          (data['timestamp'] as Timestamp).toDate();

                      return Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        color: Colors.grey[800],
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(top: 8, right: 8, left: 12),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _formatTime(timestamp),
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            ListTile(
                              leading: _getMethodIcon(data['method'] ?? ''),
                              title: Text(
                                data['url'] ?? 'No URL',
                                style: TextStyle(color: Colors.white),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                'Method: ${data['method'] ?? 'N/A'}',
                                style: TextStyle(color: Colors.grey[400]),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _deleteHistoryItem(doc.id);
                                },
                              ),
                              onTap: () {
                                _showHistoryDetails(context, data);
                              },
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _getMethodIcon(String method) {
    Color iconColor;
    switch (method.toUpperCase()) {
      case 'GET':
        iconColor = Colors.green;
        break;
      case 'POST':
        iconColor = Colors.blue;
        break;
      case 'PUT':
        iconColor = Colors.orange;
        break;
      case 'DELETE':
        iconColor = Colors.red;
        break;
      default:
        iconColor = Colors.grey;
    }
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        method.toUpperCase(),
        style: TextStyle(
          color: iconColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _deleteHistoryItem(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('history')
          .doc(docId)
          .delete();
    } catch (e) {
      print('Error deleting history item: $e');
    }
  }

  void _showHistoryDetails(BuildContext context, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Request Details',
          style: TextStyle(color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _detailItem('URL', data['url'] ?? 'N/A'),
              _detailItem('Method', data['method'] ?? 'N/A'),
              _detailItem('Auth Type', data['authType'] ?? 'N/A'),
              _detailItem('Body', data['body'] ?? 'N/A'),
              if (data['timestamp'] != null)
                _detailItem(
                  'Time',
                  (data['timestamp'] as Timestamp).toDate().toString(),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _detailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[400],
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(color: Colors.white),
          ),
          Divider(color: Colors.grey[700]),
        ],
      ),
    );
  }
}
