import '../../domain/repositories/auth_repository.dart';

class GetCurrentUserUsecase {
  final AuthRepository repo;
  GetCurrentUserUsecase(this.repo);

  Future execute() {
    return repo.getCurrentUser();
  }
}
