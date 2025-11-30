import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_entity.dart';
import '../../application/auth/login_usecase.dart';
import '../../application/auth/register_usecase.dart';
import '../../application/auth/get_current_user_usecase.dart';

class AuthController extends StateNotifier<UserEntity?> {
  final LoginUsecase loginUsecase;
  final RegisterUsecase registerUsecase;
  final GetCurrentUserUsecase getCurrentUserUsecase;

  AuthController({
    required this.loginUsecase,
    required this.registerUsecase,
    required this.getCurrentUserUsecase,
  }) : super(null) {
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final user = await getCurrentUserUsecase.execute();
    state = user;
  }

  // LOGIN → state berubah, router redirect ke '/'
  Future<void> login(String email, String password) async {
    final user = await loginUsecase.execute(email, password);
    state = user;
  }

  // REGISTER → TIDAK mengubah state
  Future<void> register(String email, String password) async {
    await registerUsecase.execute(email, password);
  }

  Future<void> logout() async {
    state = null;
  }
}
