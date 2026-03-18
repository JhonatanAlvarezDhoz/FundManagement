import 'package:flutter/material.dart';
import 'package:fund_management/features/funds/presentation/pages/funds_page.dart';
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
    ],
    errorBuilder: (_, _) =>
        const Scaffold(body: Center(child: Text('Ruta no encontrada'))),
  );
}
