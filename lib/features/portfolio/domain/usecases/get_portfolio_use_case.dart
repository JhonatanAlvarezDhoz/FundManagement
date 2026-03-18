import 'package:fund_management/core/result/result.dart';
import 'package:fund_management/features/portfolio/domain/entities/portfolio_position.dart';
import 'package:fund_management/features/portfolio/domain/repositories/portfolio_repository.dart';

class GetPortfolioUseCase {
  final PortfolioRepository repository;

  GetPortfolioUseCase(this.repository);

  Future<Result<List<PortfolioPosition>>> call() => repository.getPositions();
}
