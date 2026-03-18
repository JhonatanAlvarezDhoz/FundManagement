import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failure_mapper.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/usecases/get_transaction_history_use_case.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetTransactionHistoryUseCase getTransactionHistoryUseCase;

  HistoryBloc({
    required this.getTransactionHistoryUseCase,
  }) : super(const HistoryInitial()) {
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
