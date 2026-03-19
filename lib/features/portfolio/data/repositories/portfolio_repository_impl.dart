import 'package:fund_management/core/errors/failures.dart';
import 'package:fund_management/core/result/result.dart';
import 'package:fund_management/features/portfolio/data/datasources/portfolio_local_data_source.dart';
import 'package:fund_management/features/portfolio/data/models/portfolio_position_model.dart';
import 'package:fund_management/features/portfolio/data/models/user_wallet_model.dart';
import 'package:fund_management/features/portfolio/domain/entities/portfolio_position.dart';
import 'package:fund_management/features/portfolio/domain/entities/user_wallet.dart';
import 'package:fund_management/features/portfolio/domain/repositories/portfolio_repository.dart';

class PortfolioRepositoryImpl implements PortfolioRepository {
  final PortfolioLocalDataSource dataSource;

  PortfolioRepositoryImpl(this.dataSource);

  @override
  Future<Result<UserWallet>> getWallet() async {
    try {
      return Success(await dataSource.getWallet());
    } catch (_) {
      return const FailureResult<UserWallet>(
        StorageFailure('No fue posible leer el saldo local.'),
      );
    }
  }

  @override
  Future<Result<List<PortfolioPosition>>> getPositions() async {
    try {
      return Success(await dataSource.getPositions());
    } catch (_) {
      return const FailureResult<List<PortfolioPosition>>(
        StorageFailure('No fue posible leer el portafolio local.'),
      );
    }
  }

  @override
  Future<Result<void>> savePositions(List<PortfolioPosition> positions) async {
    try {
      await dataSource.savePositions(
        positions.map(PortfolioPositionModel.fromEntity).toList(),
      );
      return const Success(null);
    } catch (_) {
      return const FailureResult<void>(
        StorageFailure('No fue posible guardar el portafolio.'),
      );
    }
  }

  @override
  Future<Result<void>> saveWallet(UserWallet wallet) async {
    try {
      await dataSource.saveWallet(UserWalletModel.fromEntity(wallet));
      return const Success(null);
    } catch (_) {
      return const FailureResult<void>(
        StorageFailure('No fue posible guardar el saldo.'),
      );
    }
  }

  @override
  Future<Result<void>> reset() async {
    try {
      await dataSource.reset();
      return const Success(null);
    } catch (_) {
      return const FailureResult<void>(
        StorageFailure('No fue posible resetear el portafolio.'),
      );
    }
  }
}
