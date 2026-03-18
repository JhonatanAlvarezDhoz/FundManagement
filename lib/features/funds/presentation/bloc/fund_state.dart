part of 'fund_bloc.dart';

enum FundStatus { initial, loading, success, error, funds }

class FundState extends Equatable {
  final FundStatus status;
  final List<FundEntity> funds;
  final double balance;
  final String errorText;

  const FundState({
    this.status = FundStatus.initial,
    this.funds = const [],
    this.balance = 0.0,
    this.errorText = "",
  });

  FundState copyWith({
    FundStatus? status,
    List<FundEntity>? funds,
    double? balance,
    String? errorText,
  }) {
    return FundState(
      status: status ?? this.status,
      funds: funds ?? this.funds,
      balance: balance ?? this.balance,
      errorText: errorText ?? this.errorText,
    );
  }

  @override
  List<Object> get props => [status, funds, balance, errorText];
}
