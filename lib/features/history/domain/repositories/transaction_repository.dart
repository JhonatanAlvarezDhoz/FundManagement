import '../../../../core/result/result.dart';
import '../entities/transaction_entity.dart';

abstract class TransactionRepository {
  Future<Result<List<TransactionEntity>>> getTransactions();
  Future<Result<void>> addTransaction(TransactionEntity transaction);
  Future<Result<void>> reset();
}
