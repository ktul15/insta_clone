import '../../domain/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<User> login(String email, String password);
  Future<void> register(String username, String email, String password);
}
