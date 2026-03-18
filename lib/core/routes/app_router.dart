import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fund_management/core/di/injection.dart';
import 'package:fund_management/features/funds/presentation/bloc/fund_bloc.dart';
import 'package:fund_management/features/funds/presentation/pages/fund_page.dart';
import 'package:fund_management/shared/layouts/app_shell.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return AppShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => BlocProvider(
              create: (_) => sl<FundBloc>()..add(LoadFundsEvent()),
              child: const FundsPage(),
            ),
          ),
          // GoRoute(
          //   path: '/investments',
          //   builder: (context, state) => const InvestmentsPage(),
          // ),
        ],
      ),
    ],
  );
}
