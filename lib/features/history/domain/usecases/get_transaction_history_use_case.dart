import 'package:fund_management/core/result/result.dart';
import 'package:fund_management/features/history/domain/entities/transaction_entity.dart';
import 'package:fund_management/features/history/domain/repositories/transaction_repository.dart';

class GetTransactionHistoryUseCase {
  final TransactionRepository repository;

  GetTransactionHistoryUseCase(this.repository);

  Future<Result<List<TransactionEntity>>> call() =>
      repository.getTransactions();
}
