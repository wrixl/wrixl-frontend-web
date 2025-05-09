// lib\models\portfolio_model.dart

class Portfolio {
  final int id;
  final String name;
  final String? description;
  final Map<String, dynamic> allocation;

  Portfolio({
    required this.id,
    required this.name,
    this.description,
    required this.allocation,
  });

  factory Portfolio.fromJson(Map<String, dynamic> json) {
    return Portfolio(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      allocation: json['allocation'] as Map<String, dynamic>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'allocation': allocation,
    };
  }
}
