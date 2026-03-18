import '../../../../core/result/result.dart';
import '../entities/fund.dart';
import '../repositories/fund_repository.dart';

class GetFundByIdUseCase {
  final FundRepository repository;

  GetFundByIdUseCase(this.repository);

  Future<Result<Fund>> call(int id) => repository.getFundById(id);
}
