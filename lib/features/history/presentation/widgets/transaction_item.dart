import 'package:flutter/material.dart';
import 'package:fund_management/core/utils/date_formatter.dart';
import 'package:fund_management/features/history/domain/entities/transaction_entity.dart';
import 'package:fund_management/shared/enums/fund_category.dart';
import 'package:fund_management/shared/enums/notification_method.dart';
import 'package:fund_management/shared/enums/transaction_type.dart';
import 'package:fund_management/shared/extentions/double_extentions.dart';
import 'package:fund_management/shared/extentions/string_extentions.dart';
import 'package:fund_management/shared/widgets/app_card.dart';

class TransactionItem extends StatelessWidget {
  final TransactionEntity item;

  const TransactionItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.fundName.formatReadable(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text('Tipo: ${item.type.label}'),
          Text('Categoría: ${item.category.label}'),
          Text('Monto: ${item.amount.toCurrency()}'),
          Text('Notificación: ${item.notificationMethod?.label ?? 'N/A'}'),
          Text('Saldo resultante: ${item.resultingBalance.toCurrency()}'),
          Text('Fecha: ${DateFormatter.dateTime(item.createdAt)}'),
        ],
      ),
    );
  }
}
