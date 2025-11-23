import '../../domain/repositories/auth_repository.dart';

class RegisterUsecase {
  final AuthRepository repo;
  RegisterUsecase(this.repo);

  Future execute(String email, String password) {
    return repo.register(email, password);
  }
}
