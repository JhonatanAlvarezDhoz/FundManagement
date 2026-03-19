import 'package:equatable/equatable.dart';
import 'package:fund_management/shared/enums/fund_category.dart';
import 'package:fund_management/shared/enums/notification_method.dart';
import 'package:fund_management/shared/enums/transaction_type.dart';

class TransactionEntity extends Equatable {
  final String id;
  final TransactionType type;
  final int fundId;
  final String fundName;
  final FundCategory category;
  final double amount;
  final DateTime createdAt;
  final NotificationMethod? notificationMethod;
  final double resultingBalance;

  const TransactionEntity({
    required this.id,
    required this.type,
    required this.fundId,
    required this.fundName,
    required this.category,
    required this.amount,
    required this.createdAt,
    required this.notificationMethod,
    required this.resultingBalance,
  });

  @override
  List<Object?> get props => [
    id,
    type,
    fundId,
    fundName,
    category,
    amount,
    createdAt,
    notificationMethod,
    resultingBalance,
  ];
}
