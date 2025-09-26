class ApiConfig {
  static const String baseUrl = "http://localhost:8080/api"; 
  static String? token; 

  static Map<String, String> get headers {
    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }
}
