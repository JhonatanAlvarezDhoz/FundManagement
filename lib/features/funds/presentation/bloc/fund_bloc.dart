import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fund_management/core/usecase/usecase.dart';
import 'package:fund_management/features/funds/domain/entity/fund_entity.dart';
import 'package:fund_management/features/funds/domain/usecase/uc_get_funds.dart';
import 'package:fund_management/features/funds/domain/usecase/uc_subscribe_funds.dart';

part 'fund_event.dart';
part 'fund_state.dart';

class FundBloc extends Bloc<FundEvent, FundState> {
  final UcGetFundsUseCase ucGetFundsUseCase;
  final UcSubscribeFundUseCase ucSubscribeFundUseCase;
  FundBloc({
    required this.ucGetFundsUseCase,
    required this.ucSubscribeFundUseCase,
  }) : super(FundState()) {
    on<LoadFundsEvent>(_onLoadFunds);
    on<SubscribeFundEvent>(_onSubscribe);
  }

  Future<void> _onLoadFunds(
    LoadFundsEvent event,
    Emitter<FundState> emit,
  ) async {
    emit(state.copyWith(status: FundStatus.loading));

    try {
      final funds = await ucGetFundsUseCase(params: NoParams());

      emit(state.copyWith(funds: funds, status: FundStatus.funds));
    } catch (e) {
      emit(state.copyWith(status: FundStatus.error, errorText: e.toString()));
    }
  }

  Future<void> _onSubscribe(
    SubscribeFundEvent event,
    Emitter<FundState> emit,
  ) async {
    try {
      await ucSubscribeFundUseCase(
        params: SubscribeParams(event.fund, event.amount),
      );

      add(LoadFundsEvent());
    } catch (e) {
      emit(state.copyWith(status: FundStatus.error, errorText: e.toString()));
    }
  }
}
