import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/auth_repository.dart';
import '../repositories/project_repository.dart';
import '../services/gemini_service.dart';
import '../repositories/history_repository.dart';

final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);
final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);

final authRepositoryProvider = Provider((ref) => AuthRepository(ref.watch(firebaseAuthProvider)));
final projectRepoProvider = Provider((ref) => ProjectRepository(ref.watch(firestoreProvider)));
final historyRepoProvider = Provider((ref) => HistoryRepository(ref.watch(firestoreProvider)));
final geminiServiceProvider = Provider((ref) => GeminiService());

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

final currentUserIdProvider = Provider<String?>((ref) {
  return ref.watch(authStateChangesProvider).valueOrNull?.uid;
});