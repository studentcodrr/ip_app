import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/search_history_model.dart';

final historyRepoProvider = Provider((ref) => HistoryRepository(FirebaseFirestore.instance));

class HistoryRepository {
  final FirebaseFirestore _firestore;
  HistoryRepository(this._firestore);

  Future<void> addHistory(String userId, String description, String strategy) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('search_history')
        .add({
          'description': description,
          'strategy': strategy,
          'createdAt': FieldValue.serverTimestamp(),
        });
  }

  Stream<List<SearchHistoryModel>> watchHistory(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('search_history')
        .orderBy('createdAt', descending: true)
        .limit(30)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SearchHistoryModel.fromFirestore(doc))
            .toList());
  }
}