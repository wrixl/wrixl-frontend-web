 // lib\providers\auth_provider.dart

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  String? _token;

  User? get user => _user;
  String? get token => _token;

  // Replace with your backend URL
  final String baseUrl = 'http://localhost:8000';

  Future<bool> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/auth/token');
    final response = await http.post(url, body: {
      'username': username,
      'password': password,
    });
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _token = data['access_token'];
      // Optionally, fetch the user details using the token
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String username, String password, String? telegramHandle) async {
    final url = Uri.parse('$baseUrl/auth/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
        'telegram_handle': telegramHandle,
      }),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _user = User.fromJson(data);
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _user = null;
    _token = null;
    notifyListeners();
  }
}
