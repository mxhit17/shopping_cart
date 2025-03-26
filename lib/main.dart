import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoping_cart/App.dart';
import 'package:shoping_cart/utils/http_service.dart';
import 'package:shoping_cart/utils/prefs/preference_manager.dart';
import 'package:shoping_cart/utils/urls.dart';

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
