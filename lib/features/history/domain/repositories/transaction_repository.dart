import 'package:fund_management/core/result/result.dart';
import 'package:fund_management/features/history/domain/entities/transaction_entity.dart';

abstract class TransactionRepository {
  Future<Result<List<TransactionEntity>>> getTransactions();
  Future<Result<void>> addTransaction(TransactionEntity transaction);
  Future<Result<void>> reset();
}
