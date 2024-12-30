// lib/firebase/firestore_services.dart

// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all workspaces
  Stream<List<String>> getWorkspaces() {
    return _firestore
        .collection('workspaces')
        .orderBy('id') // Order by sequential ID
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc['name'] as String).toList();
    });
  }

  // Get the next workspace ID
  Future<int> _getNextWorkspaceId() async {
    try {
      // Get the last workspace ordered by ID in descending order
      QuerySnapshot querySnapshot = await _firestore
          .collection('workspaces')
          .orderBy('id', descending: true)
          .limit(1)
          .get();

      // If no workspaces exist, start with ID 1
      if (querySnapshot.docs.isEmpty) {
        return 1;
      }

      // Get the last ID and add 1
      int lastId = querySnapshot.docs.first['id'] as int;
      return lastId + 1;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting next workspace ID: $e');
      }
      rethrow;
    }
  }

  // Add a new workspace with sequential ID
  Future<void> addWorkspace(String workspaceName) async {
    try {
      // Get the next available ID
      int nextId = await _getNextWorkspaceId();

      // Create the document with custom ID
      await _firestore.collection('workspaces').doc(nextId.toString()).set({
        'id': nextId,
        'name': workspaceName,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error adding workspace: $e');
      }
      rethrow;
    }
  }

  // Delete a workspace
  Future<void> deleteWorkspace(String workspaceName) async {
    try {
      var querySnapshot = await _firestore
          .collection('workspaces')
          .where('name', isEqualTo: workspaceName)
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print('Error deleting workspace: $e');
      rethrow;
    }
  }

  // Similar changes for environment collection
  Stream<List<String>> getEnvironment() {
    return _firestore
        .collection('environment')
        .orderBy('id') // Order by sequential ID
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc['name'] as String).toList();
    });
  }

  Future<int> _getNextEnvironmentId() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('environment')
          .orderBy('id', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return 1;
      }

      int lastId = querySnapshot.docs.first['id'] as int;
      return lastId + 1;
    } catch (e) {
      print('Error getting next environment ID: $e');
      rethrow;
    }
  }

  Future<void> addEnvironment(String environmentName) async {
    try {
      int nextId = await _getNextEnvironmentId();

      await _firestore.collection('environment').doc(nextId.toString()).set({
        'id': nextId,
        'name': environmentName,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding environment: $e');
      rethrow;
    }
  }

  Future<void> deleteEnvironment(String environmentName) async {
    try {
      var querySnapshot = await _firestore
          .collection('environment')
          .where('name', isEqualTo: environmentName)
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting environment: $e');
      }
      rethrow;
    }
  }
}
