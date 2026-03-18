import '../../domain/entities/user_wallet.dart';

class UserWalletModel extends UserWallet {
  const UserWalletModel({
    required super.availableBalance,
    required super.investedBalance,
    required super.portfolioCurrentValue,
  });

  factory UserWalletModel.fromJson(Map<String, dynamic> json) => UserWalletModel(
        availableBalance: (json['availableBalance'] as num).toDouble(),
        investedBalance: (json['investedBalance'] as num).toDouble(),
        portfolioCurrentValue: (json['portfolioCurrentValue'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'availableBalance': availableBalance,
        'investedBalance': investedBalance,
        'portfolioCurrentValue': portfolioCurrentValue,
      };

  factory UserWalletModel.fromEntity(UserWallet entity) => UserWalletModel(
        availableBalance: entity.availableBalance,
        investedBalance: entity.investedBalance,
        portfolioCurrentValue: entity.portfolioCurrentValue,
      );
}
