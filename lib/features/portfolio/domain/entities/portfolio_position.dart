import 'package:equatable/equatable.dart';
import '../../../../shared/enums/fund_category.dart';
import '../../../../shared/enums/notification_method.dart';

class PortfolioPosition extends Equatable {
  final String id;
  final int fundId;
  final String fundName;
  final FundCategory category;
  final double subscribedAmount;
  final double currentValue;
  final double annualRate;
  final DateTime subscribedAt;
  final int simulatedDays;
  final NotificationMethod notificationMethod;
  final bool isActive;

  const PortfolioPosition({
    required this.id,
    required this.fundId,
    required this.fundName,
    required this.category,
    required this.subscribedAmount,
    required this.currentValue,
    required this.annualRate,
    required this.subscribedAt,
    required this.simulatedDays,
    required this.notificationMethod,
    required this.isActive,
  });

  PortfolioPosition copyWith({
    double? currentValue,
    int? simulatedDays,
    bool? isActive,
  }) {
    return PortfolioPosition(
      id: id,
      fundId: fundId,
      fundName: fundName,
      category: category,
      subscribedAmount: subscribedAmount,
      currentValue: currentValue ?? this.currentValue,
      annualRate: annualRate,
      subscribedAt: subscribedAt,
      simulatedDays: simulatedDays ?? this.simulatedDays,
      notificationMethod: notificationMethod,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
        id,
        fundId,
        fundName,
        category,
        subscribedAmount,
        currentValue,
        annualRate,
        subscribedAt,
        simulatedDays,
        notificationMethod,
        isActive,
      ];
}
