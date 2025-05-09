// lib\services\api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.get(url, headers: headers);
    return _handleResponse(response);
  }

  Future<dynamic> post(String endpoint, dynamic body,
      {Map<String, String>? headers}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.post(
      url,
      headers: headers ?? {'Content-Type': 'application/json'},
      body: json.encode(body),
    );
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    if (statusCode >= 200 && statusCode < 300) {
      if (response.body.isNotEmpty) {
        return json.decode(response.body);
      } else {
        return {};
      }
    } else {
      throw Exception(
          'API call failed (Status: $statusCode): ${response.body}');
    }
  }
}
