// lib\models\market_signal_model.dart

class MarketSignal {
  final int id;
  final String signalType;
  final String? detail;
  final String severity;
  final DateTime detectedAt;

  MarketSignal({
    required this.id,
    required this.signalType,
    this.detail,
    required this.severity,
    required this.detectedAt,
  });

  factory MarketSignal.fromJson(Map<String, dynamic> json) {
    return MarketSignal(
      id: json['id'] as int,
      signalType: json['signal_type'] as String,
      detail: json['detail'] as String?,
      severity: json['severity'] as String,
      detectedAt: DateTime.parse(json['detected_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'signal_type': signalType,
      'detail': detail,
      'severity': severity,
      'detected_at': detectedAt.toIso8601String(),
    };
  }
}
