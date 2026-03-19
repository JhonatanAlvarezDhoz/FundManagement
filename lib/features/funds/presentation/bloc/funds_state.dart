part of 'funds_bloc.dart';

sealed class FundsState extends Equatable {
  const FundsState();

  @override
  List<Object?> get props => [];
}

class FundsInitial extends FundsState {
  const FundsInitial();
}

class FundsLoading extends FundsState {
  const FundsLoading();
}

class FundsLoaded extends FundsState {
  final List<Fund> allFunds;
  final List<Fund> filteredFunds;
  final FundCategory? selectedCategory;

  const FundsLoaded({
    required this.allFunds,
    required this.filteredFunds,
    required this.selectedCategory,
  });

  @override
  List<Object?> get props => [allFunds, filteredFunds, selectedCategory];
}

class FundsError extends FundsState {
  final String message;

  const FundsError(this.message);

  @override
  List<Object?> get props => [message];
}
