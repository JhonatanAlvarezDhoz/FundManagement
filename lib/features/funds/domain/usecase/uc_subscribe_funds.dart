import 'package:fund_management/core/error/failures.dart';
import 'package:fund_management/core/usecase/usecase.dart';
import 'package:fund_management/features/funds/domain/entity/fund_entity.dart';
import 'package:fund_management/features/funds/domain/repository/funds_repository.dart';

class SubscribeParams {
  final FundEntity fund;
  final double amount;

  SubscribeParams(this.fund, this.amount);
}

class UcSubscribeFundUseCase extends UseCase<void, SubscribeParams> {
  final FundsRepository repository;

  UcSubscribeFundUseCase(this.repository);

  @override
  Future<void> call({SubscribeParams? params}) async {
    if (params!.amount < params.fund.minAmount) {
      throw InsufficientBalanceFailure();
    }

    return repository.subscribe(fund: params.fund, amount: params.amount);
  }
}
