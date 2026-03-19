import 'dart:math' as math;
import 'fund_profitability_strategy.dart';

class FicEquityStrategy implements FundProfitabilityStrategy {
  @override
  double calculateNextValue({
    required double currentValue,
    required double annualRate,
    required int simulatedDay,
    required int fundId,
  }) {
    final dailyRate = math.pow(1 + annualRate, 1 / 365).toDouble() - 1;
    final trend = math.sin((simulatedDay + fundId) / 4) * 0.0018;
    final pulse = math.cos((simulatedDay + fundId) / 9) * 0.0012;
    return currentValue * (1 + dailyRate + trend + pulse);
  }
}
