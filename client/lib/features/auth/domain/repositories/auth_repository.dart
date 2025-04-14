import 'package:client/core/network/app_failure.dart';
import 'package:fpdart/fpdart.dart';

import '../models/user_model.dart';

abstract class AuthRepository {
  Future<Either<AppFailure, User>> login(String email, String password);
  Future<Either<AppFailure, void>> register(
    String username,
    String email,
    String password,
  );
  Future<void> logout();
  Future<bool> isLoggedIn();
}
