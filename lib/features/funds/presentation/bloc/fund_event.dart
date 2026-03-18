part of 'fund_bloc.dart';

sealed class FundEvent extends Equatable {
  const FundEvent();

  @override
  List<Object> get props => [];
}

class LoadFundsEvent extends FundEvent {}

class SubscribeFundEvent extends FundEvent {
  final FundEntity fund;
  final double amount;

  const SubscribeFundEvent(this.fund, this.amount);
}
