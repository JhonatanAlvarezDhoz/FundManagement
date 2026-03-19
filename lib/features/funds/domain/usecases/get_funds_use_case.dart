import 'package:fund_management/core/result/result.dart';
import 'package:fund_management/features/funds/domain/entities/fund.dart';
import 'package:fund_management/features/funds/domain/repositories/fund_repository.dart';

class GetFundsUseCase {
  final FundRepository repository;

  GetFundsUseCase(this.repository);

  Future<Result<List<Fund>>> call() => repository.getFunds();
}
