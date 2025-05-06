 // lib\providers\dashboard_provider.dart

 import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/smart_money_model.dart';
import '../models/market_signal_model.dart';

class DashboardProvider with ChangeNotifier {
  List<SmartMoneyTransaction> _smartMoneyFeed = [];
  List<MarketSignal> _marketSignals = [];

  List<SmartMoneyTransaction> get smartMoneyFeed => _smartMoneyFeed;
  List<MarketSignal> get marketSignals => _marketSignals;

  // Replace with your backend URL
  final String baseUrl = 'http://localhost:8000';

  Future<void> fetchSmartMoneyFeed() async {
    final url = Uri.parse('$baseUrl/smart-money');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Assume the transactions are under a "transfers" key
      List transactions = data['transfers'] ?? [];
      _smartMoneyFeed = transactions
          .map((tx) => SmartMoneyTransaction.fromJson(tx))
          .toList();
      notifyListeners();
    }
  }

  Future<void> fetchMarketSignals() async {
    final url = Uri.parse('$baseUrl/market-signals');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Assume the signals are under a "signals" key
      List signals = data['signals'] ?? [];
      _marketSignals = signals.map((s) => MarketSignal.fromJson(s)).toList();
      notifyListeners();
    }
  }
}

