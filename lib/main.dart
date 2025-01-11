import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_pomodoro/config/theme/dark_theme.dart';
import 'package:simple_pomodoro/config/theme/light_theme.dart';

import 'config/router/router.dart';

void main() {
  const isAuthenticated = true; // Set this based on your auth logic
  runApp(
    ProviderScope(
      //change isAuthenticated check logic
      child: MyApp(appRouter: AppRouter(isAuthenticated: isAuthenticated)),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;

  const MyApp({Key? key, required this.appRouter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Simple Pomodoro',
      // theme: lightTheme,
      theme: darkTheme,
      routerConfig: appRouter.router,
    );
  }
}