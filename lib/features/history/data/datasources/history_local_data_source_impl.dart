import 'dart:convert';

import 'package:fund_management/core/constants/storege_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/transaction_model.dart';
import 'history_local_data_source.dart';

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
