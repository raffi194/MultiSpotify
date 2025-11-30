import '../../domain/repositories/auth_repository.dart';

class LoginUsecase {
  final AuthRepository repo;
  LoginUsecase(this.repo);

  Future execute(String email, String password) {
    return repo.login(email, password);
  }
}
