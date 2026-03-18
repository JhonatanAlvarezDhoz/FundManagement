import 'package:equatable/equatable.dart';
import 'package:fund_management/core/constants/app_constants.dart';

class UserWallet extends Equatable {
  final double availableBalance;
  final double investedBalance;
  final double portfolioCurrentValue;

  const UserWallet({
    required this.availableBalance,
    required this.investedBalance,
    required this.portfolioCurrentValue,
  });

  factory UserWallet.initial() => const UserWallet(
    availableBalance: AppConstants.initialUserBalance,
    investedBalance: 0,
    portfolioCurrentValue: 0,
  );

  UserWallet copyWith({
    double? availableBalance,
    double? investedBalance,
    double? portfolioCurrentValue,
  }) {
    return UserWallet(
      availableBalance: availableBalance ?? this.availableBalance,
      investedBalance: investedBalance ?? this.investedBalance,
      portfolioCurrentValue:
          portfolioCurrentValue ?? this.portfolioCurrentValue,
    );
  }

  @override
  List<Object?> get props => [
    availableBalance,
    investedBalance,
    portfolioCurrentValue,
  ];
}
