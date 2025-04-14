import 'dart:convert';

import 'package:client/core/network/dio_client.dart';
import 'package:client/core/network/server_constants.dart';
import 'package:dio/dio.dart';

import '../../domain/models/user_model.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;

  AuthRemoteDataSourceImpl({
    required DioClient dioClient,
  }) : _dioClient = dioClient;

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await _dioClient.dio.post(
        '/${ServerConstants.auth}/${ServerConstants.login}',
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final user = User.fromJson(response.data['user']);
        return user.copyWith(token: response.data['token']);
      } else {
        throw response.data['error'];
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw e.response?.data['error'] ?? e.message;
      }
      throw e.message ?? 'Network error occurred';
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<void> register(String username, String email, String password) async {
    try {
      final response = await _dioClient.dio.post(
        '/${ServerConstants.auth}/${ServerConstants.register}',
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode != 201) {
        throw response.data['error'];
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw e.response?.data['error'] ?? e.message;
      }
      throw e.message ?? 'Network error occurred';
    } catch (e) {
      throw e.toString();
    }
  }
}
