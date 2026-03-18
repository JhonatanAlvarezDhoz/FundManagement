import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/widgets/app_empty_view.dart';
import '../../../../shared/widgets/app_error_view.dart';
import '../../../../shared/widgets/app_loading_view.dart';
import '../../../../shared/widgets/app_shell.dart';
import '../../../../shared/widgets/section_header.dart';
import '../bloc/history_bloc.dart';
import '../bloc/history_event.dart';
import '../bloc/history_state.dart';
import '../widgets/transaction_item.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      selectedIndex: 3,
      title: 'Historial',
      child: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoading || state is HistoryInitial) {
            return const AppLoadingView();
          }

          if (state is HistoryError) {
            return AppErrorView(
              message: state.message,
              onRetry: () => context.read<HistoryBloc>().add(const HistoryRequested()),
            );
          }

          final loaded = state as HistoryLoaded;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: 'Historial de transacciones',
                subtitle: 'Revisa tus suscripciones y cancelaciones.',
              ),
              const SizedBox(height: 16),
              if (loaded.items.isEmpty)
                const Expanded(
                  child: AppEmptyView(
                    title: 'No hay transacciones',
                    subtitle: 'Aún no realizas suscripciones ni cancelaciones.',
                  ),
                )
              else
                Expanded(
                  child: ListView.separated(
                    itemCount: loaded.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, index) => TransactionItem(item: loaded.items[index]),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
