abstract class FundProfitabilityStrategy {
  double calculateNextValue({
    required double currentValue,
    required double annualRate,
    required int simulatedDay,
    required int fundId,
  });
}
