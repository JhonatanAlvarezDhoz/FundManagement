import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fund_management/core/errors/failure_mapper.dart';
import 'package:fund_management/core/result/result.dart';
import 'package:fund_management/features/portfolio/domain/entities/portfolio_position.dart';
import 'package:fund_management/features/portfolio/domain/entities/user_wallet.dart';
import 'package:fund_management/features/portfolio/domain/usecases/get_portfolio_use_case.dart';
import 'package:fund_management/features/portfolio/domain/usecases/get_wallet_summary_use_case.dart';

class DashboardState {
  final bool isLoading;
  final String? error;

  /// Resumen del wallet del usuario.
  final UserWallet? wallet;

  /// Lista de posiciones del portafolio.
  final List<PortfolioPosition> positions;

  DashboardState({
    required this.isLoading,
    this.error,
    this.wallet,
    this.positions = const [],
  });

  DashboardState copyWith({
    bool? isLoading,
    String? error,
    UserWallet? wallet,
    List<PortfolioPosition>? positions,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      wallet: wallet ?? this.wallet,
      positions: positions ?? this.positions,
    );
  }
}

/// Cubit encargado de orquestar la carga del dashboard.
///
/// Responsabilidad:
/// - Obtener datos del dominio (use cases)
/// - Transformarlos en estado UI
/// - Manejar errores de forma centralizada
class DashboardCubit extends Cubit<DashboardState> {
  final GetWalletSummaryUseCase getWalletSummaryUseCase;
  final GetPortfolioUseCase getPortfolioUseCase;

  DashboardCubit({
    required this.getWalletSummaryUseCase,
    required this.getPortfolioUseCase,
  }) : super(DashboardState(isLoading: true));

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, error: null));

    final results = await Future.wait([
      getWalletSummaryUseCase.call(),
      getPortfolioUseCase.call(),
    ]);

    final walletResult = results[0];
    final portfolioResult = results[1];

    if (walletResult is FailureResult<UserWallet>) {
      emit(
        state.copyWith(
          isLoading: false,
          error: FailureMapper.map(walletResult.failure),
        ),
      );
      return;
    }

    if (portfolioResult is FailureResult<List<PortfolioPosition>>) {
      emit(
        state.copyWith(
          isLoading: false,
          error: FailureMapper.map(portfolioResult.failure),
        ),
      );
      return;
    }

    emit(
      DashboardState(
        isLoading: false,
        wallet: (walletResult as Success<UserWallet>).data,
        positions: (portfolioResult as Success<List<PortfolioPosition>>).data,
      ),
    );
  }
}
