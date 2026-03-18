import '../models/transaction_model.dart';

abstract class HistoryLocalDataSource {
  Future<List<TransactionModel>> getTransactions();
  Future<void> addTransaction(TransactionModel transaction);
  Future<void> reset();
}
