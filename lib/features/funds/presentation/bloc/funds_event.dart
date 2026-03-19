part of 'funds_bloc.dart';

sealed class FundsEvent extends Equatable {
  const FundsEvent();

  @override
  List<Object?> get props => [];
}

class FundsRequested extends FundsEvent {
  const FundsRequested();
}

class FundsCategoryChanged extends FundsEvent {
  final FundCategory? category;

  const FundsCategoryChanged(this.category);

  @override
  List<Object?> get props => [category];
}
