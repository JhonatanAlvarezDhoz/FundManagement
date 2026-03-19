import 'package:fund_management/core/result/result.dart';
import 'package:fund_management/features/funds/domain/entities/fund.dart';
import 'package:fund_management/features/funds/domain/repositories/fund_repository.dart';

class GetFundByIdUseCase {
  final FundRepository repository;

  GetFundByIdUseCase(this.repository);

  Future<Result<Fund>> call(int id) => repository.getFundById(id);
}
