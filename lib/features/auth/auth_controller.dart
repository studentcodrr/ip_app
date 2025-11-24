import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_providers.dart';

class AuthController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  AuthController(this.ref) : super(const AsyncValue.data(null));

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => 
      ref.read(authRepositoryProvider).signIn(email, password));
  }

  Future<void> signUp(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => 
      ref.read(authRepositoryProvider).signUp(email, password));
  }
  
  Future<void> logout() async {
    await ref.read(authRepositoryProvider).signOut();
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  return AuthController(ref);
});