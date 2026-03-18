import 'package:fund_management/features/funds/domain/entities/fund.dart';
import 'package:fund_management/shared/enums/fund_category.dart';
import 'package:fund_management/shared/enums/risk_profile.dart';

class FundModel extends Fund {
  const FundModel({
    required super.id,
    required super.name,
    required super.category,
    required super.minimumAmount,
    required super.annualRate,
    required super.riskProfile,
  });

  factory FundModel.fromJson(Map<String, dynamic> json) {
    return FundModel(
      id: json['id'] as int,
      name: json['name'] as String,
      category: (json['category'] as String).toLowerCase() == 'fpv'
          ? FundCategory.fpv
          : FundCategory.fic,
      minimumAmount: (json['minimumAmount'] as num).toDouble(),
      annualRate: (json['annualRate'] as num).toDouble(),
      riskProfile: switch ((json['riskProfile'] as String).toLowerCase()) {
        'low' => RiskProfile.low,
        'medium' => RiskProfile.medium,
        _ => RiskProfile.high,
      },
    );
  }
}
