import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fund_management/core/di/injection.dart';
import 'package:fund_management/core/routes/app_router.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await bootstrap();

  runApp(const MyApp());
}

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Injections
  await init();
  await initializeDateFormatting('es_CO', null);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (_, _) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Material App',
          routerConfig: AppRouter.router,
          builder: (context, child) {
            return child!;
          },
        );
      },
    );
  }
}
