import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:fund_management/core/constants/storege_keys.dart';
import 'package:fund_management/features/history/data/datasources/history_local_data_source.dart';
import 'package:fund_management/features/history/data/models/transaction_model.dart';

class HistoryLocalDataSourceImpl implements HistoryLocalDataSource {
  final SharedPreferences prefs;

  HistoryLocalDataSourceImpl(this.prefs);

  @override
  Future<List<TransactionModel>> getTransactions() async {
    final raw = prefs.getString(StorageKeys.transactions);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    final current = await getTransactions();
    final updated = [transaction, ...current];
    await prefs.setString(
      StorageKeys.transactions,
      jsonEncode(updated.map((e) => e.toJson()).toList()),
    );
  }

  @override
  Future<void> reset() async {
    await prefs.remove(StorageKeys.transactions);
  }
}
