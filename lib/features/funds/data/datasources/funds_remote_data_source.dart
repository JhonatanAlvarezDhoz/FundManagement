import '../models/fund_model.dart';

// clase abstract para manejar OpenClose
abstract class FundsRemoteDataSource {
  Future<List<FundModel>> getFunds();
}
