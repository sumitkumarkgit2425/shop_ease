import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_ease/data/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AsyncValue<User?>>(
      (ref) => AuthViewModel(ref.read(authRepositoryProvider)),
    );

class AuthViewModel extends StateNotifier<AsyncValue<User?>> {
  final AuthRepository _repository;

  AuthViewModel(this._repository) : super(const AsyncValue.data(null));

  Future<void> signUp({
    required String email,
    required String password,
    String? name,
    String? username,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = await _repository.signUpWithEmail(
        email: email,
        password: password,
      );

      if (user != null) {
        await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          "uid": user.uid,
          "email": email,
          "name": name ?? "",
          "username": username ?? "",
          "createdAt": FieldValue.serverTimestamp(),
        });
      }

      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      final user = await _repository.signInWithGoogle();

      if (user != null) {
        final userDoc = FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid);

        final doc = await userDoc.get();
        if (!doc.exists) {
          await userDoc.set({
            "uid": user.uid,
            "email": user.email,
            "name": user.displayName ?? "",
            "photoUrl": user.photoURL ?? "",
            "createdAt": FieldValue.serverTimestamp(),
          });
        }
      }

      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _repository.signInWithEmail(
        email: email,
        password: password,
      );
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
