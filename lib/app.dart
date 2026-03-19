import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fund_management/core/di/injection.dart';
import 'package:fund_management/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:fund_management/features/simulation/presentation/cubit/simulation_cubit.dart';
import 'package:fund_management/router/app_router.dart';
import 'package:fund_management/core/theme/app_theme.dart';
import 'package:fund_management/features/funds/presentation/bloc/funds_bloc.dart';
import 'package:fund_management/features/history/presentation/bloc/history_bloc.dart';
import 'package:fund_management/features/portfolio/presentation/bloc/portfolio_bloc.dart';

class BtgFundsApp extends StatelessWidget {
  const BtgFundsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<FundsBloc>()..add(const FundsRequested()),
        ),
        BlocProvider(
          create: (_) =>
              getIt<PortfolioBloc>()..add(const PortfolioRequested()),
        ),
        BlocProvider(
          create: (_) => getIt<HistoryBloc>()..add(const HistoryRequested()),
        ),
        BlocProvider(create: (_) => getIt<DashboardCubit>()..load()),
        BlocProvider(create: (_) => getIt<SimulationCubit>()..start()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<SimulationCubit, int>(
            listener: (context, state) {
              context.read<PortfolioBloc>().add(const PortfolioRequested());
              context.read<DashboardCubit>().load();
            },
          ),
          BlocListener<PortfolioBloc, PortfolioState>(
            listener: (context, state) {
              if (state is PortfolioLoaded && state.flashMessage != null) {
                context.read<HistoryBloc>().add(const HistoryRequested());
                context.read<DashboardCubit>().load();
              }
            },
          ),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'BTG Fondos',
          theme: AppTheme.lightTheme,
          routerConfig: AppRouter.router,
        ),
      ),
    );
  }
}
