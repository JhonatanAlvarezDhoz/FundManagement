class FundEntity {
  final String id;
  final String name;
  final double minAmount;
  final String type;
  final double annualRate;

  const FundEntity({
    required this.id,
    required this.name,
    required this.minAmount,
    required this.type,
    required this.annualRate,
  });
}
