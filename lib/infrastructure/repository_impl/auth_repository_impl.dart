import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user_entity.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient client = Supabase.instance.client;

  @override
  Future<UserEntity> login(String email, String password) async {
    final res = await client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = res.user;
    if (user == null) throw Exception("Login gagal");

    return UserEntity(
      id: user.id,
      email: user.email ?? "",
    );
  }

  @override
  Future<UserEntity> register(String email, String password) async {
    final res = await client.auth.signUp(
      email: email,
      password: password,
    );

    final user = res.user;
    if (user == null) throw Exception("Gagal membuat akun");

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
