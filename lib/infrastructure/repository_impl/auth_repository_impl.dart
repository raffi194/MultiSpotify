import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/entities/user_entity.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient client = Supabase.instance.client;

  @override
  Future<UserEntity?> login(String email, String password) async {
    final response = await client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = response.user;

    if (user == null) {
      throw AuthException("Email atau password salah.");
    }

    return UserEntity(
      id: user.id,
      email: user.email ?? "",
    );
  }

  @override
  Future<UserEntity?> register(String email, String password) async {
    final response = await client.auth.signUp(
      email: email,
      password: password,
    );

    final user = response.user;

    if (user == null) {
      return null;
    }

    return UserEntity(
      id: user.id,
      email: user.email ?? "",
    );
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final user = client.auth.currentUser;
    if (user == null) return null;

    return UserEntity(
      id: user.id,
      email: user.email ?? "",
    );
  }

  @override
  Future<void> logout() async {
    await client.auth.signOut();
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}
