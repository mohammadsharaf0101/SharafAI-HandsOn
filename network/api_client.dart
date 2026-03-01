import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiClient {
  // 1. BASE URL: The main address for the API services.
  // Note: Ensure the URL is correct for your specific endpoint.
  static const String _baseUrl = 'https://dummyjson.com/auth';

  // 2. LOGIN METHOD: A static function to handle authentication.
  static Future<Map<String, dynamic>> postLogin(String email, String password) async {
    try {
      // Sending a POST request to the login endpoint.
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        // The body contains the user credentials.
        body: {
          'email': email,
          'password': password,
        },
      );

      // 3. JSON DECODING: Converts the raw response body (String) into a Map (Key-Value pairs).
      final Map<String, dynamic> data = json.decode(response.body);

      // 4. RESPONSE HANDLING: Logic based on HTTP Status Codes.
      if (response.statusCode == 200) {
        // SUCCESS: Usually returns an authentication token.
        return {
          'success': true, 
          'token': data['token']
        };
      } else {
        // SERVER ERROR: Returns the error message sent by the server or a default one.
        return {
          'success': false, 
          'error': data['message'] ?? 'Login failed'
        };
      }
    } catch (e) {
      // 5. EXCEPTION HANDLING: Catches network issues like "No Internet" or timeouts.
      return {
        'success': false, 
        'error': 'Connection error. Check your internet.'
      };
    }
  }
}