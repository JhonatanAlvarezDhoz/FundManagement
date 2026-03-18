import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fund_management/core/di/injection.dart';
import 'package:fund_management/core/routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await bootstrap();

  runApp(const MyApp());
}

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Injections
  await init();
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
            return Scaffold(
              appBar: AppBar(title: const Text('Material App Bar')),
              body: const Center(child: Text('Hello World 2')),
            );
          },
        );
      },
    );
  }
}
