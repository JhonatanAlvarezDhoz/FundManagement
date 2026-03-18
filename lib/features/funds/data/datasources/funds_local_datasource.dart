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
        "id": "FPV_BTG_PACTUAL_RECAUDADORA_01",
        "name": "FPV_BTG_PACTUAL_RECAUDADORA",
        "minAmount": 75000,
        "type": "FPV",
        "rate": 0.08,
      },
      {
        "id": "FPV_BTG_PACTUAL_ECOPETRO_01",
        "name": "FPV_BTG_PACTUAL_ECOPETROL",
        "minAmount": 125000,
        "type": "FPV",
        "rate": 0.1,
      },
      {
        "id": "DEUDAPRIVADA_01",
        "name": "DEUDAPRIVADA",
        "minAmount": 50000,
        "type": "FIC",
        "rate": 0.06,
      },
      {
        "id": "DEUDAPRIVADA_02",
        "name": "DEUDAPRIVADA",
        "minAmount": 800000,
        "type": "FIC",
        "rate": 0.06,
      },
      {
        "id": "FDO-ACCIONES_01",
        "name": "FDO-ACCIONES",
        "minAmount": 50000,
        "type": "FIC",
        "rate": 0.06,
      },
      {
        "id": "FDO-FPV_BTG_PACTUAL_DINAMICA_01",
        "name": "FPV_BTG_PACTUAL_DINAMICA",
        "minAmount": 100000,
        "type": "FPV",
        "rate": 0.06,
      },
    ];

    return data.map((e) => FundModel.fromJson(e)).toList();
  }
}
