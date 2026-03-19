import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fund_management/core/errors/failures.dart';
import 'package:fund_management/core/result/result.dart';
import 'package:fund_management/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:fund_management/features/portfolio/domain/entities/portfolio_position.dart';
import 'package:fund_management/features/portfolio/domain/entities/user_wallet.dart';
import 'package:fund_management/features/portfolio/domain/usecases/get_portfolio_use_case.dart';
import 'package:fund_management/features/portfolio/domain/usecases/get_wallet_summary_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockGetWalletSummary extends Mock implements GetWalletSummaryUseCase {}

class MockGetPortfolio extends Mock implements GetPortfolioUseCase {}

void main() {
  late MockGetWalletSummary getWalletUseCase;
  late MockGetPortfolio getPortfolioUseCase;

  /// Datos mock
  late UserWallet mockWallet;

  setUp(() {
    getWalletUseCase = MockGetWalletSummary();
    getPortfolioUseCase = MockGetPortfolio();

    mockWallet = const UserWallet(
      availableBalance: 100000,
      investedBalance: 50000,
      portfolioCurrentValue: 55000,
    );
  });

  blocTest<DashboardCubit, DashboardState>(
    'emits loading -> success when load succeeds',
    build: () {
      when(
        () => getWalletUseCase.call(),
      ).thenAnswer((_) async => Success(mockWallet));

      when(
        () => getPortfolioUseCase.call(),
      ).thenAnswer((_) async => const Success(<PortfolioPosition>[]));

      return DashboardCubit(
        getWalletSummaryUseCase: getWalletUseCase,
        getPortfolioUseCase: getPortfolioUseCase,
      );
    },
    act: (cubit) => cubit.load(),
    expect: () => [
      /// estado de loading
      isA<DashboardState>().having((s) => s.isLoading, 'isLoading', true),

      /// estado final
      isA<DashboardState>()
          .having((s) => s.isLoading, 'isLoading', false)
          .having((s) => s.wallet, 'wallet', isNotNull)
          .having((s) => s.positions, 'positions', isEmpty),
    ],
  );

  blocTest<DashboardCubit, DashboardState>(
    'emits error when wallet fails',
    build: () {
      when(() => getWalletUseCase.call()).thenAnswer(
        (_) async => const FailureResult(
          InsufficientBalanceFailure("Error en carga de wallet"),
        ),
      );

      when(
        () => getPortfolioUseCase.call(),
      ).thenAnswer((_) async => const Success(<PortfolioPosition>[]));

      return DashboardCubit(
        getWalletSummaryUseCase: getWalletUseCase,
        getPortfolioUseCase: getPortfolioUseCase,
      );
    },
    act: (cubit) => cubit.load(),
    expect: () => [
      isA<DashboardState>().having((s) => s.isLoading, 'isLoading', true),
      isA<DashboardState>()
          .having((s) => s.isLoading, 'isLoading', false)
          .having((s) => s.error, 'error', isNotNull),
    ],
  );

  blocTest<DashboardCubit, DashboardState>(
    'emits error when portfolio fails but wallet succeeds',
    build: () {
      when(
        () => getWalletUseCase.call(),
      ).thenAnswer((_) async => Success(mockWallet));

      when(() => getPortfolioUseCase.call()).thenAnswer(
        (_) async => const FailureResult(UnknownFailure("Error en la carga")),
      );

      return DashboardCubit(
        getWalletSummaryUseCase: getWalletUseCase,
        getPortfolioUseCase: getPortfolioUseCase,
      );
    },
    act: (cubit) => cubit.load(),
    expect: () => [
      /// loading
      isA<DashboardState>().having((s) => s.isLoading, 'isLoading', true),

      /// error final
      isA<DashboardState>()
          .having((s) => s.isLoading, 'isLoading', false)
          .having((s) => s.error, 'error', isNotNull),
    ],
    verify: (_) {
      verify(() => getWalletUseCase.call()).called(1);
      verify(() => getPortfolioUseCase.call()).called(1);
    },
  );
}
