import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/fund_model.dart';
import 'funds_remote_data_source.dart';

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
