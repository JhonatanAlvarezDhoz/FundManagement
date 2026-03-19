import 'package:fund_management/core/result/result.dart';
import 'package:fund_management/features/funds/domain/entities/fund.dart';

abstract class FundRepository {
  Future<Result<List<Fund>>> getFunds();
  Future<Result<Fund>> getFundById(int id);
}
