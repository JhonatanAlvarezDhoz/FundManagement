import 'package:fund_management/features/funds/domain/entity/fund_entity.dart';

class FundModel {
  final int id;
  final String name;
  final double minAmount;
  final FundType type;
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
      type: json['type'] == 'FPV' ? FundType.fpv : FundType.fic,
      annualRate: json['rate'],
    );
  }
}
