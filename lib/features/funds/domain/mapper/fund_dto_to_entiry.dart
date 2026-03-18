import 'package:fund_management/features/funds/data/models/fund_model.dart';
import 'package:fund_management/features/funds/domain/entity/fund_entity.dart';

class FundDtoToEntiry {
  static FundEntity fundDtoToEntity(FundModel fundDto) {
    return FundEntity(
      id: fundDto.id,
      name: fundDto.name,
      minAmount: fundDto.minAmount,
      type: fundDto.type,
      annualRate: fundDto.annualRate,
    );
  }
}
