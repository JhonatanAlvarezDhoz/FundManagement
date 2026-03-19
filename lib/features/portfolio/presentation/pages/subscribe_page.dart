import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fund_management/router/route_names.dart';
import 'package:fund_management/core/utils/validators.dart';
import 'package:fund_management/features/funds/presentation/bloc/funds_bloc.dart';
import 'package:fund_management/features/portfolio/presentation/bloc/portfolio_bloc.dart';
import 'package:fund_management/shared/enums/fund_category.dart';
import 'package:fund_management/shared/enums/notification_method.dart';
import 'package:fund_management/shared/extentions/double_extentions.dart';
import 'package:fund_management/shared/widgets/app_card.dart';
import 'package:fund_management/shared/widgets/app_shell.dart';
import 'package:go_router/go_router.dart';

class SubscribePage extends StatefulWidget {
  final int fundId;

  const SubscribePage({super.key, required this.fundId});

  @override
  State<SubscribePage> createState() => _SubscribePageState();
}

class _SubscribePageState extends State<SubscribePage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  NotificationMethod? _notificationMethod = NotificationMethod.email;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fundsState = context.watch<FundsBloc>().state;
    if (fundsState is! FundsLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final fund = fundsState.allFunds.firstWhere((e) => e.id == widget.fundId);

    return AppShell(
      selectedIndex: 1,
      title: 'Suscribirse',
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: AppCard(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fund.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text('Monto mínimo: ${fund.minimumAmount.toCurrency()}'),
                  Text('Categoría: ${fund.category.label}'),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: Validators.amount,
                    decoration: const InputDecoration(
                      labelText: 'Monto a invertir',
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<NotificationMethod>(
                    initialValue: _notificationMethod,
                    items: NotificationMethod.values
                        .map(
                          (e) =>
                              DropdownMenuItem(value: e, child: Text(e.label)),
                        )
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _notificationMethod = value),
                    decoration: const InputDecoration(
                      labelText: 'Método de notificación',
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: () => context.go(RouteNames.funds),
                        child: const Text('Cancelar'),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: _submit,
                        child: const Text('Confirmar suscripción'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_notificationMethod == null) return;

    final amount = Validators.parseAmount(_amountController.text);
    if (amount == null) return;

    final bloc = context.read<PortfolioBloc>();
    bloc.add(
      SubscribeRequested(
        fundId: widget.fundId,
        amount: amount,
        notificationMethod: _notificationMethod!,
      ),
    );

    bloc.stream
        .firstWhere((state) {
          return state is PortfolioLoaded && !state.isSubmitting ||
              state is PortfolioError;
        })
        .then((state) {
          if (!mounted) return;
          if (state is PortfolioLoaded) {
            context.go(RouteNames.portfolio);
          }
        });
  }
}
