class ApiConfig {
  static const String baseUrl = 'http://localhost:8080/api';

  // headers zonder auth
  static Map<String, String> get baseHeaders => {
        'Content-Type': 'application/json',
      };

  // headers mét auth (JWT)
  static Map<String, String> authHeaders(String token) => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
}
