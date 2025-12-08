import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/app_user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore;

  UserRepository(this._firestore);

  // 1. Sync Current User to Firestore (Call this after Login/SignUp)
  // This ensures the user exists in the 'users' collection so they can be invited.
  Future<void> syncUser(User user) async {
    final userRef = _firestore.collection('users').doc(user.uid);
    
    // LOGIC: Extract name from email if display name is missing
    String derivedName = 'User';
    if (user.email != null && user.email!.contains('@')) {
      derivedName = user.email!.split('@')[0];
    }

    // Use Auth Display Name if available, otherwise use the extracted email name
    final finalName = (user.displayName != null && user.displayName!.isNotEmpty) 
        ? user.displayName!
        : derivedName;

    // We use set with merge: true to update fields without overwriting existing data
    await userRef.set({
      'email': user.email,
      'displayName': finalName,
      'photoUrl': user.photoURL ?? '',
      'lastSeen': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // 2. Find User by Email (For Invite System)
  Future<AppUserModel?> getUserByEmail(String email) async {
    final snapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return AppUserModel.fromFirestore(snapshot.docs.first);
    }
    return null;
  }

  // 3. Get User Details by ID (For assigning tasks)
  Future<AppUserModel?> getUserById(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      return AppUserModel.fromFirestore(doc);
    }
    return null;
  }
  
  // 4. Stream of a specific User (Real-time updates for avatar/name changes)
  Stream<AppUserModel?> watchUser(String userId) {
    return _firestore.collection('users').doc(userId).snapshots().map((doc) {
      if (doc.exists) return AppUserModel.fromFirestore(doc);
      return null;
    });
  }
  
  // 5. Get Multiple Users (For showing Project Members)
  Stream<List<AppUserModel>> watchUsers(List<String> userIds) {
    if (userIds.isEmpty) return Stream.value([]);
    
    // Firestore 'whereIn' is limited to 10 items.
    // We take the first 10 to prevent crashes.
    return _firestore
        .collection('users')
        .where(FieldPath.documentId, whereIn: userIds.take(10).toList()) 
        .snapshots()
        .map((s) => s.docs.map((d) => AppUserModel.fromFirestore(d)).toList());
  }
}