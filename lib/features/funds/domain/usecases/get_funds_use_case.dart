import '../../../../core/result/result.dart';
import '../entities/fund.dart';
import '../repositories/fund_repository.dart';

class GetFundsUseCase {
  final FundRepository repository;

  GetFundsUseCase(this.repository);

  Future<Result<List<Fund>>> call() => repository.getFunds();
}
