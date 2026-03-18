import 'package:fund_management/core/usecase/usecase.dart';
import 'package:fund_management/features/funds/domain/entity/fund_entity.dart';
import 'package:fund_management/features/funds/domain/repository/funds_repository.dart';

class UcGetFundsUseCase extends UseCase<List<FundEntity>, NoParams> {
  final FundsRepository repository;

  UcGetFundsUseCase(this.repository);

  @override
  Future<List<FundEntity>> call({NoParams? params}) {
    return repository.getFunds();
  }
}
