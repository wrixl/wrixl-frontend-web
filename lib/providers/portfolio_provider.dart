 // lib\providers\portfolio_provider.dart

 import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/portfolio_model.dart';

class PortfolioProvider with ChangeNotifier {
  List<Portfolio> _modelPortfolios = [];
  Portfolio? _personalPortfolio;

  List<Portfolio> get modelPortfolios => _modelPortfolios;
  Portfolio? get personalPortfolio => _personalPortfolio;

  // Replace with your backend URL
  final String baseUrl = 'http://localhost:8000';

  Future<void> fetchModelPortfolios() async {
    final url = Uri.parse('$baseUrl/portfolios');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Assume the response contains a list of portfolios under a key (e.g., "portfolios")
      List portfolios = data['portfolios'] ?? [];
      _modelPortfolios = portfolios.map((p) => Portfolio.fromJson(p)).toList();
      notifyListeners();
    }
  }

  Future<void> fetchPersonalPortfolio(String walletAddress) async {
    final url = Uri.parse('$baseUrl/portfolio-insights?wallet=$walletAddress');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // For demonstration, assume the insights can be parsed into a Portfolio object.
      _personalPortfolio = Portfolio.fromJson(data['insights']);
      notifyListeners();
    }
  }
}

