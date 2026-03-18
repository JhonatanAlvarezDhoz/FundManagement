import 'package:flutter/material.dart';
import 'package:fund_management/features/funds/presentation/pages/fund_detail_page.dart';
import 'package:fund_management/features/funds/presentation/pages/funds_page.dart';
import 'package:fund_management/features/history/presentation/pages/history_page.dart';
import 'package:fund_management/features/portfolio/presentation/pages/portfolio_page.dart';
import 'package:fund_management/features/portfolio/presentation/pages/subscribe_page.dart';
import 'package:go_router/go_router.dart';

import 'route_names.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: RouteNames.funds,
        name: RouteNames.funds,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: FundsPage()),
      ),
      GoRoute(
        path: '${RouteNames.fundDetail}/:id',
        name: 'fund-detail-id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return FundDetailPage(fundId: id);
        },
      ),
      GoRoute(
        path: '${RouteNames.subscribe}/:id',
        name: 'subscribe-id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return SubscribePage(fundId: id);
        },
      ),
      GoRoute(
        path: RouteNames.portfolio,
        name: RouteNames.portfolio,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: PortfolioPage()),
      ),
      GoRoute(
        path: RouteNames.history,
        name: RouteNames.history,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: HistoryPage()),
      ),
    ],
    errorBuilder: (_, _) =>
        const Scaffold(body: Center(child: Text('Ruta no encontrada'))),
  );
}
