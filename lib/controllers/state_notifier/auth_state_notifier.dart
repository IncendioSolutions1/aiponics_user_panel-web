import 'package:flutter_riverpod/flutter_riverpod.dart';

// AuthStateNotifier to manage login async state
class AuthStateNotifier extends StateNotifier<AsyncValue<void>> {
  AuthStateNotifier() : super(const AsyncValue.data(null));

  // Login function that will handle async API call
  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading(); // Set state to loading
    try {
      // Simulate an API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Here, you will replace with your real API call logic
      if (email == 'test@test.com' && password == 'password') {
        state = const AsyncValue.data(null);  // Set state to success
      } else {
        throw Exception('Invalid login credentials'); // Handle failed login
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e,stackTrace); // Set state to error
    }
  }
}

// Create a StateNotifierProvider for AuthStateNotifier
final authStateProvider =
StateNotifierProvider<AuthStateNotifier, AsyncValue<void>>((ref) {
  return AuthStateNotifier();
});
