import 'package:equatable/equatable.dart';
import 'package:fund_management/shared/enums/fund_category.dart';
import 'package:fund_management/shared/enums/risk_profile.dart';

class Fund extends Equatable {
  final int id;
  final String name;
  final FundCategory category;
  final double minimumAmount;
  final double annualRate;
  final RiskProfile riskProfile;

  const Fund({
    required this.id,
    required this.name,
    required this.category,
    required this.minimumAmount,
    required this.annualRate,
    required this.riskProfile,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    category,
    minimumAmount,
    annualRate,
    riskProfile,
  ];
}
