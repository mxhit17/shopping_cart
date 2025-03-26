import 'package:flutter/material.dart';
import 'package:shoping_cart/views/splash_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // navigatorObservers: [ChuckerFlutter.navigatorObserver],
      themeMode: ThemeMode.system,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      home: const SplashView(),
    );
  }
}
