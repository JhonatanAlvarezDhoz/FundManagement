import '../../../../shared/enums/fund_category.dart';
import '../../../../shared/enums/notification_method.dart';
import '../../../../shared/enums/transaction_type.dart';
import '../../domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    required super.id,
    required super.type,
    required super.fundId,
    required super.fundName,
    required super.category,
    required super.amount,
    required super.createdAt,
    required super.notificationMethod,
    required super.resultingBalance,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) => TransactionModel(
        id: json['id'] as String,
        type: (json['type'] as String) == 'subscription'
            ? TransactionType.subscription
            : TransactionType.cancellation,
        fundId: json['fundId'] as int,
        fundName: json['fundName'] as String,
        category: (json['category'] as String) == 'fpv' ? FundCategory.fpv : FundCategory.fic,
        amount: (json['amount'] as num).toDouble(),
        createdAt: DateTime.parse(json['createdAt'] as String),
        notificationMethod: json['notificationMethod'] == null
            ? null
            : (json['notificationMethod'] as String) == 'email'
                ? NotificationMethod.email
                : NotificationMethod.sms,
        resultingBalance: (json['resultingBalance'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'fundId': fundId,
        'fundName': fundName,
        'category': category.name,
        'amount': amount,
        'createdAt': createdAt.toIso8601String(),
        'notificationMethod': notificationMethod?.name,
        'resultingBalance': resultingBalance,
      };

  factory TransactionModel.fromEntity(TransactionEntity entity) => TransactionModel(
        id: entity.id,
        type: entity.type,
        fundId: entity.fundId,
        fundName: entity.fundName,
        category: entity.category,
        amount: entity.amount,
        createdAt: entity.createdAt,
        notificationMethod: entity.notificationMethod,
        resultingBalance: entity.resultingBalance,
      );
}
