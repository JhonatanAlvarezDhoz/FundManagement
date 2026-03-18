import 'package:fund_management/features/funds/data/models/fund_model.dart';

abstract class FundsLocalDataSource {
  Future<List<FundModel>> getFunds();
}

class FundsLocalDataSourceImpl implements FundsLocalDataSource {
  @override
  Future<List<FundModel>> getFunds() async {
    // Mock local JSON
    final data = [
      {
        "id": 1,
        "name": "FPV_BTG_PACTUAL_RECAUDADORA",
        "minAmount": 75000,
        "type": "FPV",
        "rate": 0.08,
      },
      {
        "id": 2,
        "name": "FPV_BTG_PACTUAL_ECOPETROL",
        "minAmount": 125000,
        "type": "FPV",
        "rate": 0.1,
      },
      {
        "id": 3,
        "name": "DEUDAPRIVADA",
        "minAmount": 50000,
        "type": "FIC",
        "rate": 0.06,
      },
    ];

    return data.map((e) => FundModel.fromJson(e)).toList();
  }
}
