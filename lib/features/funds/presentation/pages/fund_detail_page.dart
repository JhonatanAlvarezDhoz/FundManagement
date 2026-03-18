import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fund_management/core/router/route_names.dart';
import 'package:fund_management/features/funds/presentation/bloc/funds_bloc.dart';
import 'package:fund_management/features/funds/presentation/bloc/funds_state.dart';
import 'package:fund_management/shared/enums/fund_category.dart';
import 'package:fund_management/shared/enums/risk_profile.dart';
import 'package:fund_management/shared/extentions/double_extentions.dart';
import 'package:fund_management/shared/widgets/app_card.dart';
import 'package:fund_management/shared/widgets/app_shell.dart';
import 'package:go_router/go_router.dart';

class FundDetailPage extends StatelessWidget {
  final int fundId;

  const FundDetailPage({super.key, required this.fundId});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FundsBloc>().state;
    if (state is! FundsLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final fund = state.allFunds.firstWhere((e) => e.id == fundId);

    return AppShell(
      selectedIndex: 1,
      title: 'Detalle del fondo',
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: AppCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fund.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                Text('Categoría: ${fund.category.label}'),
                Text('Riesgo: ${fund.riskProfile.label}'),
                Text('Monto mínimo: ${fund.minimumAmount.toCurrency()}'),
                Text(
                  'Tasa anual simulada: ${(fund.annualRate * 100).toStringAsFixed(2)}%',
                ),
                const SizedBox(height: 16),
                const Text(
                  'La rentabilidad es una simulación determinística con aceleración de tiempo. '
                  'Cada segundo equivale a un día y el valor del fondo se actualiza automáticamente.',
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () => context.go(RouteNames.funds),
                      child: const Text('Volver'),
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
          ),
        ),
      ),
    );
  }
}
