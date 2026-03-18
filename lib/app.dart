import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fund_management/core/di/injection.dart';
import 'package:fund_management/core/router/app_router.dart';
import 'package:fund_management/core/theme/app_theme.dart';
import 'package:fund_management/features/funds/presentation/bloc/funds_bloc.dart';
import 'package:fund_management/features/funds/presentation/bloc/funds_event.dart';

class BtgFundsApp extends StatelessWidget {
  const BtgFundsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<FundsBloc>()..add(const FundsRequested()),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,

        title: 'BTG Fondos',
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
