import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/auth_repository.dart';
import '../repositories/project_repository.dart';
import '../services/gemini_service.dart';
import '../repositories/history_repository.dart'; 

final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);
final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);

final authRepositoryProvider = Provider((ref) {
  return AuthRepository(ref.watch(firebaseAuthProvider));
});

final projectRepoProvider = Provider((ref) {
  return ProjectRepository(ref.watch(firestoreProvider));
});

final historyRepoProvider = Provider((ref) {
  return HistoryRepository(ref.watch(firestoreProvider));
});

final geminiServiceProvider = Provider((ref) => GeminiService());

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});