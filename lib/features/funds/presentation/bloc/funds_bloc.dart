import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fund_management/core/errors/failure_mapper.dart';
import 'package:fund_management/core/result/result.dart';
import 'package:fund_management/features/funds/domain/entities/fund.dart';
import 'package:fund_management/features/funds/domain/usecases/get_funds_use_case.dart';
import 'package:fund_management/shared/enums/fund_category.dart';

part 'funds_event.dart';
part 'funds_state.dart';

class FundsBloc extends Bloc<FundsEvent, FundsState> {
  final GetFundsUseCase getFundsUseCase;

  FundsBloc({required this.getFundsUseCase}) : super(const FundsInitial()) {
    on<FundsRequested>(_onRequested);
    on<FundsCategoryChanged>(_onCategoryChanged);
  }

  // Carga de los fondos
  Future<void> _onRequested(
    FundsRequested event,
    Emitter<FundsState> emit,
  ) async {
    emit(const FundsLoading());
    final result = await getFundsUseCase.call();

    if (result is FailureResult<List<Fund>>) {
      emit(FundsError(FailureMapper.map(result.failure)));
      return;
    }

    final funds = (result as Success<List<Fund>>).data;
    emit(
      FundsLoaded(
        allFunds: funds,
        filteredFunds: funds,
        selectedCategory: null,
      ),
    );
  }

  // Filtro por tipo de fondo
  void _onCategoryChanged(
    FundsCategoryChanged event,
    Emitter<FundsState> emit,
  ) {
    final current = state;
    if (current is! FundsLoaded) return;
    final category = event.category;
    final filtered = category == null
        ? current.allFunds
        : current.allFunds.where((e) => e.category == category).toList();
    emit(
      FundsLoaded(
        allFunds: current.allFunds,
        filteredFunds: filtered,
        selectedCategory: category,
      ),
    );
  }
}
