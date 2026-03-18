import 'package:fund_management/core/result/result.dart';
import 'package:fund_management/features/portfolio/domain/entities/user_wallet.dart';
import 'package:fund_management/features/portfolio/domain/repositories/portfolio_repository.dart';

class GetWalletSummaryUseCase {
  final PortfolioRepository repository;

  GetWalletSummaryUseCase(this.repository);

  Future<Result<UserWallet>> call() => repository.getWallet();
}
