class FundModel {
  final String id;
  final String name;
  final double minAmount;
  final String type;
  final double annualRate;

  const FundModel({
    required this.id,
    required this.name,
    required this.minAmount,
    required this.type,
    required this.annualRate,
  });

  factory FundModel.fromJson(Map<String, dynamic> json) {
    return FundModel(
      id: json['id'],
      name: json['name'],
      minAmount: json['minAmount'],
      type: json['type'],
      annualRate: json['rate'],
    );
  }
}
