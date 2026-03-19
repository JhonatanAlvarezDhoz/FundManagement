import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fund_management/features/funds/presentation/bloc/funds_bloc.dart';
import 'package:fund_management/features/funds/presentation/widgets/fund_card.dart';
import 'package:fund_management/features/funds/presentation/widgets/fund_category_filter.dart';
import 'package:fund_management/shared/widgets/app_empty_view.dart';
import 'package:fund_management/shared/widgets/app_error_view.dart';
import 'package:fund_management/shared/widgets/app_loading_view.dart';
import 'package:fund_management/shared/widgets/app_shell.dart';
import 'package:fund_management/shared/widgets/section_header.dart';

class FundsPage extends StatelessWidget {
  const FundsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      selectedIndex: 1,
      title: 'Fondos disponibles',
      child: BlocBuilder<FundsBloc, FundsState>(
        builder: (context, state) {
          if (state is FundsLoading || state is FundsInitial) {
            return const AppLoadingView();
          }

          if (state is FundsError) {
            return AppErrorView(
              message: state.message,
              onRetry: () =>
                  context.read<FundsBloc>().add(const FundsRequested()),
            );
          }

          final loaded = state as FundsLoaded;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(
                title: 'Fondos disponibles',
                subtitle: 'Explora fondos FPV y FIC para suscribirte.',
              ),
              const SizedBox(height: 16),
              FundCategoryFilter(
                selected: loaded.selectedCategory,
                onChanged: (value) =>
                    context.read<FundsBloc>().add(FundsCategoryChanged(value)),
              ),
              const SizedBox(height: 20),
              if (loaded.filteredFunds.isEmpty)
                const Expanded(
                  child: AppEmptyView(
                    title: 'No hay fondos',
                    subtitle: 'No hay fondos para el filtro seleccionado.',
                  ),
                )
              else
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Controllamos la distribucion del gridview teniendo en cuenta el acho de pantalla disponible
                      final crossAxisCount = constraints.maxWidth >= 1200
                          ? 3
                          : constraints.maxWidth >= 700
                          ? 2
                          : 1;
                      return GridView.builder(
                        itemCount: loaded.filteredFunds.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: 1.4,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemBuilder: (_, index) =>
                            FundCard(fund: loaded.filteredFunds[index]),
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
