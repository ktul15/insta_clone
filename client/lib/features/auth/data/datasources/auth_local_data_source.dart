abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<void> removeToken();
  Future<String?> getToken();
} 