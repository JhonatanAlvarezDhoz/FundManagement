import 'package:fund_management/features/portfolio/data/models/portfolio_position_model.dart';
import 'package:fund_management/features/portfolio/data/models/user_wallet_model.dart';

abstract class PortfolioLocalDataSource {
  Future<UserWalletModel> getWallet();
  Future<void> saveWallet(UserWalletModel wallet);

  Future<List<PortfolioPositionModel>> getPositions();
  Future<void> savePositions(List<PortfolioPositionModel> positions);

  Future<void> reset();
}
