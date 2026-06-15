import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import 'router/app_router.dart';

class WaterBillApp extends StatelessWidget {
  const WaterBillApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Water Bill Collection App',
      theme: buildAppTheme(),
      initialRoute: AppRouter.initialRoute,
      routes: AppRouter.routes,
    );
  }
}
