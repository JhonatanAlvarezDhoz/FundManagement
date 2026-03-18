import '../models/fund_model.dart';

abstract class FundsRemoteDataSource {
  Future<List<FundModel>> getFunds();
}
