import 'package:flutter/material.dart';
import 'package:fund_management/core/theme/app_colors.dart';
import 'package:fund_management/core/utils/date_formatter.dart';
import 'package:fund_management/features/portfolio/domain/entities/portfolio_position.dart';
import 'package:fund_management/shared/enums/fund_category.dart';
import 'package:fund_management/shared/enums/notification_method.dart';
import 'package:fund_management/shared/extentions/double_extentions.dart';
import 'package:fund_management/shared/extentions/string_extentions.dart';
import 'package:fund_management/shared/widgets/app_card.dart';

class PortfolioCard extends StatelessWidget {
  final PortfolioPosition position;
  final VoidCallback onCancel;

  const PortfolioCard({
    super.key,
    required this.position,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final profit = position.currentValue - position.subscribedAmount;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            position.fundName.formatReadable(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text('Categoría: ${position.category.label}'),
          Text('Suscrito: ${position.subscribedAmount.toCurrency()}'),
          Text('Valor actual: ${position.currentValue.toCurrency()}'),
          Text(
            'Ganancia/Pérdida: $profit)',
            style: TextStyle(
              color: profit >= 0 ? AppColors.success : AppColors.danger,
            ),
          ),
          Text('Días simulados: ${position.simulatedDays}'),
          Text('Fecha: ${DateFormatter.dateTime(position.subscribedAt)}'),
          Text('Notificación: ${position.notificationMethod.label}'),
          const Spacer(),
          const SizedBox(height: 12),
          FilledButton.tonal(
            onPressed: onCancel,
            child: const Text('Cancelar posición'),
          ),
        ],
      ),
    );
  }
}
