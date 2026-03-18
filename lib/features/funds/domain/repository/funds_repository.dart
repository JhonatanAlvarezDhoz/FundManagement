import 'package:fund_management/features/funds/domain/entity/fund_entity.dart';
import 'package:fund_management/features/funds/domain/entity/transaction_entity.dart';

abstract class FundsRepository {
  Future<List<FundEntity>> getFunds();
  Future<void> subscribe({required FundEntity fund, required double amount});
  Future<void> cancel({required int fundId});
  Future<double> getBalance();
  Future<List<TransactionEntity>> getTransactions();
}
