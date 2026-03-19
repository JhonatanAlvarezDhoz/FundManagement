import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fund_management/core/theme/app_colors.dart';
import 'package:fund_management/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:fund_management/features/portfolio/presentation/bloc/portfolio_bloc.dart';
import 'package:fund_management/shared/extentions/double_extentions.dart';
import 'package:fund_management/shared/widgets/app_error_view.dart';
import 'package:fund_management/shared/widgets/app_loading_view.dart';
import 'package:fund_management/shared/widgets/app_shell.dart';
import 'package:fund_management/shared/widgets/section_header.dart';
import 'package:fund_management/shared/widgets/summary_tile.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      selectedIndex: 0,
      title: 'Dashboard',
      child: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const AppLoadingView();
          }

          if (state.error != null) {
            return AppErrorView(
              message: state.error!,
              onRetry: () => context.read<DashboardCubit>().load(),
            );
          }

          final wallet = state.wallet!;
          final profit = wallet.portfolioCurrentValue - wallet.investedBalance;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(
                  title: 'Resumen financiero',
                  subtitle:
                      'Monitorea tu saldo, inversión y rentabilidad simulada.',
                  trailing: OutlinedButton(
                    onPressed: () {
                      context.read<PortfolioBloc>().add(
                        const ResetDemoRequested(),
                      );
                      context.read<DashboardCubit>().load();
                    },
                    child: const Text('Reset demo'),
                  ),
                ),
                const SizedBox(height: 20),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = constraints.maxWidth >= 1200
                        ? 4
                        : constraints.maxWidth >= 700
                        ? 2
                        : 1;
                    return GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 2.1,
                      children: [
                        SummaryTile(
                          title: 'Saldo disponible',
                          value: wallet.availableBalance.toCurrency(),
                        ),
                        SummaryTile(
                          title: 'Capital invertido',
                          value: wallet.investedBalance.toCurrency(),
                        ),
                        SummaryTile(
                          title: 'Valor actual',
                          value: wallet.portfolioCurrentValue.toCurrency(),
                        ),
                        SummaryTile(
                          title: 'Ganancia / pérdida',
                          value: profit.toCurrency(),
                          accent: profit >= 0
                              ? AppColors.success
                              : AppColors.danger,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  'Posiciones activas: ${state.positions.length}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
