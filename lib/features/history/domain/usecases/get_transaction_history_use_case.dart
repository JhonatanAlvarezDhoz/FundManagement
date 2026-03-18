import '../../../../core/result/result.dart';
import '../entities/transaction_entity.dart';
import '../repositories/transaction_repository.dart';

class GetTransactionHistoryUseCase {
  final TransactionRepository repository;

  GetTransactionHistoryUseCase(this.repository);

  Future<Result<List<TransactionEntity>>> call() => repository.getTransactions();
}
