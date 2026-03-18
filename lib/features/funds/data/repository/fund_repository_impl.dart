import 'package:fund_management/core/error/failures.dart';
import 'package:fund_management/features/funds/data/datasources/funds_local_datasource.dart';
import 'package:fund_management/features/funds/data/models/fund_model.dart';
import 'package:fund_management/features/funds/domain/entity/fund_entity.dart';
import 'package:fund_management/features/funds/domain/entity/transaction_entity.dart';
import 'package:fund_management/features/funds/domain/mapper/fund_dto_to_entiry.dart';
import 'package:fund_management/features/funds/domain/repository/funds_repository.dart';

class FundsRepositoryImpl implements FundsRepository {
  final FundsLocalDataSource local;

  double _balance = 500000;
  final List<TransactionEntity> _transactions = [];

  FundsRepositoryImpl(this.local);

  @override
  Future<List<FundEntity>> getFunds() async {
    final List<FundModel> listFund = await local.getFunds();
    return listFund
        .map((fModel) => FundDtoToEntiry.fundDtoToEntity(fModel))
        .toList();
  }

  @override
  Future<void> subscribe({
    required FundEntity fund,
    required double amount,
  }) async {
    if (_balance < amount) {
      throw InsufficientBalanceFailure();
    }

    _balance -= amount;

    _transactions.add(
      TransactionEntity(
        id: DateTime.now().toString(),
        fundId: fund.id,
        amount: amount,
        type: TransactionType.subscribe,
        date: DateTime.now(),
        notification: NotificationType.email,
      ),
    );
  }

  @override
  Future<void> cancel({required int fundId}) async {
    // Simulación simple
    _balance += 100000;
  }

  @override
  Future<double> getBalance() async => _balance;

  @override
  Future<List<TransactionEntity>> getTransactions() async => _transactions;
}
