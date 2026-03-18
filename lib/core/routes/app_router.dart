import 'package:fund_management/core/routes/route_paths.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RoutePaths.home,
    routes: [
      /// home
    ],
  );
}
