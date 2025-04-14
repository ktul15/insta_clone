import 'package:client/core/network/app_failure.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<AppFailure, User>> login(String email, String password) async {
    try {
      final user = await remoteDataSource.login(email, password);
      await localDataSource.saveToken(user.token!);
      return Right(user);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, void>> register(
    String username,
    String email,
    String password,
  ) async {
    try {
      await remoteDataSource.register(username, email, password);
      return Right(null);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  @override
  Future<void> logout() async {
    await localDataSource.removeToken();
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await localDataSource.getToken();
    return token != null && token.isNotEmpty;
  }
}
