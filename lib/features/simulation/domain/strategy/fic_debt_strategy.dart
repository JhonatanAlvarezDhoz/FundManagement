import 'dart:math' as math;
import 'fund_profitability_strategy.dart';

class FicDebtStrategy implements FundProfitabilityStrategy {
  @override
  double calculateNextValue({
    required double currentValue,
    required double annualRate,
    required int simulatedDay,
    required int fundId,
  }) {
    final dailyRate = math.pow(1 + annualRate, 1 / 365).toDouble() - 1;
    final variation = math.sin((simulatedDay + fundId) / 5) * 0.0008;
    return currentValue * (1 + dailyRate + variation);
  }
}
