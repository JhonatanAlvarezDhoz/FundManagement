import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:fund_management/features/funds/data/datasources/funds_remote_data_source.dart';
import 'package:fund_management/features/funds/data/models/fund_model.dart';

// Simalos una api para la carga de los fondos
class FundsRemoteDataSourceImpl implements FundsRemoteDataSource {
  @override
  Future<List<FundModel>> getFunds() async {
    await Future.delayed(const Duration(milliseconds: 700));
    final raw = await rootBundle.loadString('assets/mocks/funds.json');
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => FundModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
