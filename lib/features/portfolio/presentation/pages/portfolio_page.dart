import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fund_management/core/theme/app_colors.dart';
import 'package:fund_management/features/portfolio/presentation/bloc/portfolio_bloc.dart';
import 'package:fund_management/features/portfolio/presentation/bloc/portfolio_event.dart';
import 'package:fund_management/features/portfolio/presentation/bloc/portfolio_state.dart';
import 'package:fund_management/features/portfolio/presentation/widgets/portfolio_card.dart';
import 'package:fund_management/shared/extentions/double_extentions.dart';
import 'package:fund_management/shared/widgets/app_empty_view.dart';
import 'package:fund_management/shared/widgets/app_error_view.dart';
import 'package:fund_management/shared/widgets/app_loading_view.dart';
import 'package:fund_management/shared/widgets/app_shell.dart';
import 'package:fund_management/shared/widgets/section_header.dart';

class PortfolioPage extends StatelessWidget {
  const PortfolioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      selectedIndex: 2,
      title: 'Portafolio',
      child: BlocConsumer<PortfolioBloc, PortfolioState>(
        listener: (context, state) {
          if (state is PortfolioLoaded && state.flashMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.flashMessage!)));
          }
        },
        builder: (context, state) {
          if (state is PortfolioLoading || state is PortfolioInitial) {
            return const AppLoadingView();
          }

          if (state is PortfolioError) {
            return AppErrorView(
              message: state.message,
              onRetry: () =>
                  context.read<PortfolioBloc>().add(const PortfolioRequested()),
            );
          }

          final loaded = state as PortfolioLoaded;
          final profit =
              loaded.wallet.portfolioCurrentValue -
              loaded.wallet.investedBalance;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(
                title: 'Tus posiciones activas',
                subtitle:
                    'Cancela una posición para regresar su valor actual al saldo disponible.',
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _MiniSummary(
                    title: 'Saldo disponible',
                    value: loaded.wallet.availableBalance.toCurrency(),
                  ),
                  _MiniSummary(
                    title: 'Valor actual portafolio',
                    value: loaded.wallet.portfolioCurrentValue.toCurrency(),
                  ),
                  _MiniSummary(
                    title: 'Ganancia / pérdida',
                    value: profit.toCurrency(),
                    color: profit >= 0 ? AppColors.success : AppColors.danger,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (loaded.positions.isEmpty)
                const Expanded(
                  child: AppEmptyView(
                    title: 'No tienes posiciones activas',
                    subtitle:
                        'Ve al listado de fondos y realiza tu primera suscripción.',
                  ),
                )
              else
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final crossAxisCount = constraints.maxWidth >= 1200
                          ? 3
                          : constraints.maxWidth >= 700
                          ? 2
                          : 1;
                      return GridView.builder(
                        itemCount: loaded.positions.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: 1.3,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemBuilder: (_, index) => PortfolioCard(
                          position: loaded.positions[index],
                          onCancel: () => context.read<PortfolioBloc>().add(
                            CancelPositionRequested(loaded.positions[index].id),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _MiniSummary extends StatelessWidget {
  final String title;
  final String value;
  final Color? color;

  const _MiniSummary({required this.title, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: 240,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
