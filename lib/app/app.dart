import 'package:flutter/material.dart';
import 'router.dart';

class CatholicApp extends StatelessWidget {
  const CatholicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catholic',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple, useMaterial3: true),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: AppRouter.home,
    );
  }
}
