// lib\models\smart_money_model.dart

class SmartMoneyTransaction {
  final String token;
  final String action;
  final double amount;
  final String walletLabel;
  final DateTime timestamp;
  final String? context;

  SmartMoneyTransaction({
    required this.token,
    required this.action,
    required this.amount,
    required this.walletLabel,
    required this.timestamp,
    this.context,
  });

  factory SmartMoneyTransaction.fromJson(Map<String, dynamic> json) {
    return SmartMoneyTransaction(
      token: json['token'] as String,
      action: json['action'] as String,
      amount: (json['amount'] as num).toDouble(),
      walletLabel: json['wallet_label'] as String,
      timestamp: DateTime.parse(json['timestamp']),
      context: json['context'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'action': action,
      'amount': amount,
      'wallet_label': walletLabel,
      'timestamp': timestamp.toIso8601String(),
      'context': context,
    };
  }
}
