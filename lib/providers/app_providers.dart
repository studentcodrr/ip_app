import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:taskflow_app/repositories/auth_repository.dart';
import 'package:taskflow_app/repositories/project_repository.dart';
import 'package:taskflow_app/services/gemini_service.dart';
import 'package:taskflow_app/repositories/history_repository.dart';
import 'package:taskflow_app/repositories/user_repository.dart'; // <input> // Add this import

// --- Core Services ---
final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);
final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);

// --- Repositories ---
final authRepositoryProvider = Provider((ref) {
  return AuthRepository(ref.watch(firebaseAuthProvider));
});

final projectRepoProvider = Provider((ref) {
  return ProjectRepository(ref.watch(firestoreProvider));
});

final historyRepoProvider = Provider((ref) {
  return HistoryRepository(ref.watch(firestoreProvider));
});

// <input> // ADD USER REPOSITORY PROVIDER
final userRepoProvider = Provider((ref) {
  return UserRepository(ref.watch(firestoreProvider));
});

final geminiServiceProvider = Provider((ref) => GeminiService());

// --- User State ---
final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});