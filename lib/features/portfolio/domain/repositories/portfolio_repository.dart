import '../../../../core/result/result.dart';
import '../entities/portfolio_position.dart';
import '../entities/user_wallet.dart';

abstract class PortfolioRepository {
  Future<Result<UserWallet>> getWallet();
  Future<Result<void>> saveWallet(UserWallet wallet);
  Future<Result<List<PortfolioPosition>>> getPositions();
  Future<Result<void>> savePositions(List<PortfolioPosition> positions);
  Future<Result<void>> reset();
}
