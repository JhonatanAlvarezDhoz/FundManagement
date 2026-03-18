import '../../../../core/result/result.dart';
import '../entities/fund.dart';

abstract class FundRepository {
  Future<Result<List<Fund>>> getFunds();
  Future<Result<Fund>> getFundById(int id);
}
