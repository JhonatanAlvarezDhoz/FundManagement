import '../../../../core/errors/failures.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/history_local_data_source.dart';
import '../models/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final HistoryLocalDataSource dataSource;

  TransactionRepositoryImpl(this.dataSource);

  @override
  Future<Result<void>> addTransaction(TransactionEntity transaction) async {
    try {
      await dataSource.addTransaction(TransactionModel.fromEntity(transaction));
      return const Success(null);
    } catch (_) {
      return const FailureResult<void>(
        StorageFailure('No fue posible guardar la transacción.'),
      );
    }
  }

  @override
  Future<Result<List<TransactionEntity>>> getTransactions() async {
    try {
      return Success(await dataSource.getTransactions());
    } catch (_) {
      return const FailureResult<List<TransactionEntity>>(
        StorageFailure('No fue posible leer el historial.'),
      );
    }
  }

  @override
  Future<Result<void>> reset() async {
    try {
      await dataSource.reset();
      return const Success(null);
    } catch (_) {
      return const FailureResult<void>(
        StorageFailure('No fue posible resetear el historial.'),
      );
    }
  }
}
