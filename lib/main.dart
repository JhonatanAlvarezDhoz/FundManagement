import 'package:flutter/material.dart';
import 'package:fund_management/core/di/injection.dart' as di;
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.configureDependencies();
  runApp(const BtgFundsApp());
}
