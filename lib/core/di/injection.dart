import 'package:fund_management/core/sync/app_operation_lock.dart';
import 'package:fund_management/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:fund_management/features/funds/data/datasources/funds_remote_data_source.dart';
import 'package:fund_management/features/funds/data/datasources/funds_remote_data_source_impl.dart';
import 'package:fund_management/features/funds/data/repositories/fund_repository_impl.dart';
import 'package:fund_management/features/funds/domain/repositories/fund_repository.dart';
import 'package:fund_management/features/funds/domain/usecases/get_fund_by_id_use_case.dart';
import 'package:fund_management/features/funds/domain/usecases/get_funds_use_case.dart';
import 'package:fund_management/features/funds/presentation/bloc/funds_bloc.dart';
import 'package:fund_management/features/history/data/datasources/history_local_data_source.dart';
import 'package:fund_management/features/history/data/datasources/history_local_data_source_impl.dart';
import 'package:fund_management/features/history/data/repositories/transaction_repository_impl.dart';
import 'package:fund_management/features/history/domain/repositories/transaction_repository.dart';
import 'package:fund_management/features/history/domain/usecases/get_transaction_history_use_case.dart';
import 'package:fund_management/features/history/presentation/bloc/history_bloc.dart';
import 'package:fund_management/features/portfolio/data/datasources/portfolio_local_data_source.dart';
import 'package:fund_management/features/portfolio/data/datasources/portfolio_local_data_source_impl.dart';
import 'package:fund_management/features/portfolio/data/repositories/portfolio_repository_impl.dart';
import 'package:fund_management/features/portfolio/domain/repositories/portfolio_repository.dart';
import 'package:fund_management/features/portfolio/domain/usecases/cancel_fund_subscription_use_case.dart';
import 'package:fund_management/features/portfolio/domain/usecases/get_portfolio_use_case.dart';
import 'package:fund_management/features/portfolio/domain/usecases/get_wallet_summary_use_case.dart';
import 'package:fund_management/features/portfolio/domain/usecases/subscribe_to_fund_use_case.dart';
import 'package:fund_management/features/portfolio/presentation/bloc/portfolio_bloc.dart';
import 'package:fund_management/features/simulation/data/datasources/simulation_local_data_source.dart';
import 'package:fund_management/features/simulation/data/datasources/simulation_local_data_source_impl.dart';
import 'package:fund_management/features/simulation/data/repositories/simulation_repository_impl.dart';
import 'package:fund_management/features/simulation/domain/repositories/simulation_repository.dart';
import 'package:fund_management/features/simulation/domain/usecases/advance_simulation_day_use_case.dart';
import 'package:fund_management/features/simulation/presentation/cubit/simulation_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  /// Obtiene instancia de SharedPreferences (async init).
  final prefs = await SharedPreferences.getInstance();

  // =========================
  //  CORE / GLOBAL SERVICES
  // =========================

  /// Registro de SharedPreferences como singleton.
  /// Se reutiliza la misma instancia en toda la app.
  getIt.registerLazySingleton<SharedPreferences>(() => prefs);

  /// Registro del lock global para operaciones críticas.
  /// Garantiza ejecución secuencial (evita race conditions).
  getIt.registerLazySingleton<AppOperationLock>(() => AppOperationLock());

  // =========================
  //  DATA SOURCES
  // =========================

  /// Fuente remota (simulada o API).
  getIt.registerLazySingleton<FundsRemoteDataSource>(
    () => FundsRemoteDataSourceImpl(),
  );

  /// Fuentes locales (persistencia).
  /// Dependen de SharedPreferences (inyectado con getIt()).
  getIt.registerLazySingleton<PortfolioLocalDataSource>(
    () => PortfolioLocalDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<HistoryLocalDataSource>(
    () => HistoryLocalDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<SimulationLocalDataSource>(
    () => SimulationLocalDataSourceImpl(getIt()),
  );

  // =========================
  //  REPOSITORIES
  // =========================

  /// Implementaciones concretas de repositorios.
  /// Abstraen el acceso a data sources.
  getIt.registerLazySingleton<FundRepository>(
    () => FundRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<PortfolioRepository>(
    () => PortfolioRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<SimulationRepository>(
    () => SimulationRepositoryImpl(getIt()),
  );

  // =========================
  // 🔹 USE CASES (DOMAIN)
  // =========================

  /// Casos de uso simples (1 repo)
  getIt.registerLazySingleton(() => GetFundsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetFundByIdUseCase(getIt()));
  getIt.registerLazySingleton(() => GetWalletSummaryUseCase(getIt()));
  getIt.registerLazySingleton(() => GetPortfolioUseCase(getIt()));

  /// Caso de uso complejo (orquestación + lock)
  getIt.registerLazySingleton(
    () => SubscribeToFundUseCase(
      fundRepository: getIt(),
      portfolioRepository: getIt(),
      transactionRepository: getIt(),
      operationLock: getIt(),
    ),
  );

  getIt.registerLazySingleton(
    () => CancelFundSubscriptionUseCase(
      portfolioRepository: getIt(),
      transactionRepository: getIt(),
      operationLock: getIt(),
    ),
  );

  /// Caso de uso que modifica estado global simulado (tiempo).
  /// Usa lock porque altera múltiples fuentes.
  getIt.registerLazySingleton(() => GetTransactionHistoryUseCase(getIt()));
  getIt.registerLazySingleton(
    () => AdvanceSimulationDayUseCase(
      portfolioRepository: getIt(),
      simulationRepository: getIt(),
      fundRepository: getIt(),
      operationLock: getIt(),
    ),
  );

  // =========================
  //  PRESENTATION (BLoC / Cubit)
  // =========================

  /// Factory: se crea una nueva instancia cada vez.
  /// Correcto para BLoCs (no deben ser singletons).
  getIt.registerFactory(() => FundsBloc(getFundsUseCase: getIt()));
  getIt.registerFactory(
    () => HistoryBloc(getTransactionHistoryUseCase: getIt()),
  );
  getIt.registerFactory(
    () => PortfolioBloc(
      getPortfolioUseCase: getIt(),
      getWalletSummaryUseCase: getIt(),
      subscribeToFundUseCase: getIt(),
      cancelFundSubscriptionUseCase: getIt(),
      portfolioRepository: getIt(),
      transactionRepository: getIt(),
      simulationRepository: getIt(),
    ),
  );
  getIt.registerFactory(
    () => DashboardCubit(
      getWalletSummaryUseCase: getIt(),
      getPortfolioUseCase: getIt(),
    ),
  );
  getIt.registerFactory(
    () => SimulationCubit(advanceSimulationDayUseCase: getIt()),
  );
}
