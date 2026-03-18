import 'dart:convert';

import 'package:fund_management/core/constants/storege_keys.dart';
import 'package:fund_management/features/portfolio/data/datasources/portfolio_local_data_source.dart';
import 'package:fund_management/features/portfolio/data/models/portfolio_position_model.dart';
import 'package:fund_management/features/portfolio/data/models/user_wallet_model.dart';
import 'package:fund_management/features/portfolio/domain/entities/user_wallet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PortfolioLocalDataSourceImpl implements PortfolioLocalDataSource {
  final SharedPreferences prefs;

  PortfolioLocalDataSourceImpl(this.prefs);

  @override
  Future<UserWalletModel> getWallet() async {
    final raw = prefs.getString(StorageKeys.wallet);
    if (raw == null) {
      return UserWalletModel.fromEntity(UserWallet.initial());
    }
    return UserWalletModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  @override
  Future<void> saveWallet(UserWalletModel wallet) async {
    await prefs.setString(StorageKeys.wallet, jsonEncode(wallet.toJson()));
  }

  @override
  Future<List<PortfolioPositionModel>> getPositions() async {
    final raw = prefs.getString(StorageKeys.positions);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => PortfolioPositionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> savePositions(List<PortfolioPositionModel> positions) async {
    await prefs.setString(
      StorageKeys.positions,
      jsonEncode(positions.map((e) => e.toJson()).toList()),
    );
  }

  @override
  Future<void> reset() async {
    await prefs.remove(StorageKeys.wallet);
    await prefs.remove(StorageKeys.positions);
  }
}
