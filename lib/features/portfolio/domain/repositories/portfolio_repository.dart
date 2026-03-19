import 'package:fund_management/core/result/result.dart';
import 'package:fund_management/features/portfolio/domain/entities/portfolio_position.dart';
import 'package:fund_management/features/portfolio/domain/entities/user_wallet.dart';

abstract class PortfolioRepository {
  Future<Result<UserWallet>> getWallet();
  Future<Result<void>> saveWallet(UserWallet wallet);
  Future<Result<List<PortfolioPosition>>> getPositions();
  Future<Result<void>> savePositions(List<PortfolioPosition> positions);
  Future<Result<void>> reset();
}
