import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskflow_app/providers/app_providers.dart';

class AuthController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  AuthController(this.ref) : super(const AsyncValue.data(null));

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      // 1. Perform Login
      final credential = await ref.read(authRepositoryProvider).signIn(email, password);
      
      // 2. Sync to Firestore (Ensures user exists in DB for invites)
      if (credential.user != null) {
        await ref.read(userRepoProvider).syncUser(credential.user!);
      }
    });
  }

  Future<void> signUp(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      // 1. Create Account
      final credential = await ref.read(authRepositoryProvider).signUp(email, password);
      
      // 2. Sync to Firestore immediately
      if (credential.user != null) {
        await ref.read(userRepoProvider).syncUser(credential.user!);
      }
    });
  }
  
  Future<void> logout() async {
    await ref.read(authRepositoryProvider).signOut();
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  return AuthController(ref);
});