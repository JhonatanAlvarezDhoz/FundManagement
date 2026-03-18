import 'package:fund_management/shared/enums/fund_category.dart';
import 'package:fund_management/shared/enums/notification_method.dart';

import '../../domain/entities/portfolio_position.dart';

class PortfolioPositionModel extends PortfolioPosition {
  const PortfolioPositionModel({
    required super.id,
    required super.fundId,
    required super.fundName,
    required super.category,
    required super.subscribedAmount,
    required super.currentValue,
    required super.annualRate,
    required super.subscribedAt,
    required super.simulatedDays,
    required super.notificationMethod,
    required super.isActive,
  });

  factory PortfolioPositionModel.fromJson(Map<String, dynamic> json) =>
      PortfolioPositionModel(
        id: json['id'] as String,
        fundId: json['fundId'] as int,
        fundName: json['fundName'] as String,
        category: (json['category'] as String) == 'fpv'
            ? FundCategory.fpv
            : FundCategory.fic,
        subscribedAmount: (json['subscribedAmount'] as num).toDouble(),
        currentValue: (json['currentValue'] as num).toDouble(),
        annualRate: (json['annualRate'] as num).toDouble(),
        subscribedAt: DateTime.parse(json['subscribedAt'] as String),
        simulatedDays: json['simulatedDays'] as int,
        notificationMethod: (json['notificationMethod'] as String) == 'email'
            ? NotificationMethod.email
            : NotificationMethod.sms,
        isActive: json['isActive'] as bool,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'fundId': fundId,
    'fundName': fundName,
    'category': category.name,
    'subscribedAmount': subscribedAmount,
    'currentValue': currentValue,
    'annualRate': annualRate,
    'subscribedAt': subscribedAt.toIso8601String(),
    'simulatedDays': simulatedDays,
    'notificationMethod': notificationMethod.name,
    'isActive': isActive,
  };

  factory PortfolioPositionModel.fromEntity(PortfolioPosition entity) =>
      PortfolioPositionModel(
        id: entity.id,
        fundId: entity.fundId,
        fundName: entity.fundName,
        category: entity.category,
        subscribedAmount: entity.subscribedAmount,
        currentValue: entity.currentValue,
        annualRate: entity.annualRate,
        subscribedAt: entity.subscribedAt,
        simulatedDays: entity.simulatedDays,
        notificationMethod: entity.notificationMethod,
        isActive: entity.isActive,
      );
}
