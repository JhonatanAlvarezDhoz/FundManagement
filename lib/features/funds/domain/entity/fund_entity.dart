enum FundType { fpv, fic }

class FundEntity {
  final int id;
  final String name;
  final double minAmount;
  final FundType type;
  final double annualRate;

  const FundEntity({
    required this.id,
    required this.name,
    required this.minAmount,
    required this.type,
    required this.annualRate,
  });
}
