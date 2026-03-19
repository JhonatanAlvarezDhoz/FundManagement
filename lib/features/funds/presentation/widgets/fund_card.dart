import 'package:flutter/material.dart';
import 'package:fund_management/router/route_names.dart';
import 'package:fund_management/features/funds/domain/entities/fund.dart';
import 'package:fund_management/shared/enums/fund_category.dart';
import 'package:fund_management/shared/enums/risk_profile.dart';
import 'package:fund_management/shared/extentions/double_extentions.dart';
import 'package:fund_management/shared/extentions/string_extentions.dart';
import 'package:fund_management/shared/widgets/app_card.dart';
import 'package:go_router/go_router.dart';

class FundCard extends StatelessWidget {
  final Fund fund;

  const FundCard({super.key, required this.fund});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fund.name.formatReadable(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text('Categoría: ${fund.category.label}'),
          Text('Riesgo: ${fund.riskProfile.label}'),
          Text('Monto mínimo: ${fund.minimumAmount.toCurrency()}'),
          Text('Tasa anual simulada: ${fund.annualRate.toPercentage()}'),
          const Spacer(),
          const SizedBox(height: 16),
          Row(
            children: [
              OutlinedButton(
                onPressed: () =>
                    context.go('${RouteNames.fundDetail}/${fund.id}'),
                child: const Text('Ver detalle'),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: () =>
                    context.go('${RouteNames.subscribe}/${fund.id}'),
                child: const Text('Suscribirse'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
