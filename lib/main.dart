import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoping_cart/utils/http_service.dart';
import 'package:shoping_cart/utils/prefs/preference_manager.dart';
import 'package:shoping_cart/utils/urls.dart';
import 'package:shoping_cart/views/catalogue_view.dart';

Future<void> _setupServices() async {
  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  // Register SharedPreferences
  GetIt.instance.registerSingleton<SharedPreferences>(sharedPreferences);
  // Register PreferencesManager, passing the SharedPreferences instance
  GetIt.instance.registerSingleton<PreferencesManager>(
    await PreferencesManager.create(sharedPreferences),
  );
  // Register HttpService with base URL
  GetIt.instance.registerSingleton<HttpService>(
    HttpService(baseUrl: (Urls.baseUrl)),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _setupServices();
  runApp(
    ProviderScope(
      child: App(),
    ),
  );
}

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

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(milliseconds: 1000), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => CatalogueScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(),
    );
    // throw UnimplementedError();
  }
}
