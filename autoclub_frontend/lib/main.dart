import 'package:autoclub_frontend/pages/home.dart';
import 'package:autoclub_frontend/code_assets/style.dart';
import 'package:autoclub_frontend/pages/login.dart';
import 'package:autoclub_frontend/utilities/sheets_api_secret.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  usePathUrlStrategy();

  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: supabaseURL,
    anonKey: supabaseKey,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Autoclub',
      theme: lightTheme,
      home: const LoginPage(),
    );
  }
}
