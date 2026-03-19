import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fund_management/core/errors/failure_mapper.dart';
import 'package:fund_management/core/result/result.dart';
import 'package:fund_management/features/history/domain/entities/transaction_entity.dart';
import 'package:fund_management/features/history/domain/usecases/get_transaction_history_use_case.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetTransactionHistoryUseCase getTransactionHistoryUseCase;

  HistoryBloc({required this.getTransactionHistoryUseCase})
    : super(const HistoryInitial()) {
    on<HistoryRequested>(_onRequested);
  }

  Future<void> _onRequested(
    HistoryRequested event,
    Emitter<HistoryState> emit,
  ) async {
    emit(const HistoryLoading());

    final result = await getTransactionHistoryUseCase.call();
    if (result is FailureResult<List<TransactionEntity>>) {
      emit(HistoryError(FailureMapper.map(result.failure)));
      return;
    }

    emit(HistoryLoaded((result as Success<List<TransactionEntity>>).data));
  }
}
