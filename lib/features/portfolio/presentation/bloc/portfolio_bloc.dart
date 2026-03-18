import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fund_management/core/errors/failure_mapper.dart';
import 'package:fund_management/core/result/result.dart';
import 'package:fund_management/features/history/domain/repositories/transaction_repository.dart';
import 'package:fund_management/features/portfolio/domain/entities/portfolio_position.dart';
import 'package:fund_management/features/portfolio/domain/entities/user_wallet.dart';
import 'package:fund_management/features/portfolio/domain/repositories/portfolio_repository.dart';
import 'package:fund_management/features/portfolio/domain/usecases/cancel_fund_subscription_use_case.dart';
import 'package:fund_management/features/portfolio/domain/usecases/get_portfolio_use_case.dart';
import 'package:fund_management/features/portfolio/domain/usecases/get_wallet_summary_use_case.dart';
import 'package:fund_management/features/portfolio/domain/usecases/subscribe_to_fund_use_case.dart';
import 'package:fund_management/features/portfolio/presentation/bloc/portfolio_event.dart';
import 'package:fund_management/features/portfolio/presentation/bloc/portfolio_state.dart';

class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  final GetPortfolioUseCase getPortfolioUseCase;
  final GetWalletSummaryUseCase getWalletSummaryUseCase;
  final SubscribeToFundUseCase subscribeToFundUseCase;
  final CancelFundSubscriptionUseCase cancelFundSubscriptionUseCase;
  final PortfolioRepository portfolioRepository;
  final TransactionRepository transactionRepository;

  PortfolioBloc({
    required this.getPortfolioUseCase,
    required this.getWalletSummaryUseCase,
    required this.subscribeToFundUseCase,
    required this.cancelFundSubscriptionUseCase,
    required this.portfolioRepository,
    required this.transactionRepository,
  }) : super(const PortfolioInitial()) {
    on<PortfolioRequested>(_onRequested);
    on<SubscribeRequested>(_onSubscribe);
    on<CancelPositionRequested>(_onCancel);
    on<ResetDemoRequested>(_onReset);
  }

  Future<void> _onRequested(
    PortfolioRequested event,
    Emitter<PortfolioState> emit,
  ) async {
    if (state is! PortfolioLoaded) {
      emit(const PortfolioLoading());
    }
    await _loadState(emit);
  }

  Future<void> _onSubscribe(
    SubscribeRequested event,
    Emitter<PortfolioState> emit,
  ) async {
    final current = state;
    if (current is PortfolioLoaded) {
      emit(current.copyWith(isSubmitting: true, flashMessage: null));
    }

    final result = await subscribeToFundUseCase.call(
      SubscribeToFundParams(
        fundId: event.fundId,
        amount: event.amount,
        notificationMethod: event.notificationMethod,
      ),
    );

    if (result is FailureResult<void>) {
      if (state is PortfolioLoaded) {
        final loaded = state as PortfolioLoaded;
        emit(
          loaded.copyWith(
            isSubmitting: false,
            flashMessage: FailureMapper.map(result.failure),
          ),
        );
      } else {
        emit(PortfolioError(FailureMapper.map(result.failure)));
      }
      return;
    }

    await _loadState(
      emit,
      flashMessage: 'Suscripción realizada correctamente.',
    );
  }

  Future<void> _onCancel(
    CancelPositionRequested event,
    Emitter<PortfolioState> emit,
  ) async {
    final result = await cancelFundSubscriptionUseCase.call(event.positionId);

    if (result is FailureResult<void>) {
      if (state is PortfolioLoaded) {
        final loaded = state as PortfolioLoaded;
        emit(loaded.copyWith(flashMessage: FailureMapper.map(result.failure)));
      } else {
        emit(PortfolioError(FailureMapper.map(result.failure)));
      }
      return;
    }

    await _loadState(emit, flashMessage: 'Posición cancelada correctamente.');
  }

  Future<void> _onReset(
    ResetDemoRequested event,
    Emitter<PortfolioState> emit,
  ) async {
    emit(const PortfolioLoading());
    await portfolioRepository.reset();
    await transactionRepository.reset();

    await _loadState(emit, flashMessage: 'Demo reiniciada correctamente.');
  }

  Future<void> _loadState(
    Emitter<PortfolioState> emit, {
    String? flashMessage,
  }) async {
    final walletResult = await getWalletSummaryUseCase.call();
    final positionsResult = await getPortfolioUseCase.call();

    if (walletResult is FailureResult<UserWallet>) {
      emit(PortfolioError(FailureMapper.map(walletResult.failure)));
      return;
    }

    if (positionsResult is FailureResult<List<PortfolioPosition>>) {
      emit(PortfolioError(FailureMapper.map(positionsResult.failure)));
      return;
    }

    emit(
      PortfolioLoaded(
        wallet: (walletResult as Success<UserWallet>).data,
        positions: (positionsResult as Success<List<PortfolioPosition>>).data,
        flashMessage: flashMessage,
      ),
    );
  }
}
