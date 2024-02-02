import 'package:autoclub_frontend/pages/home.dart';
import 'package:autoclub_frontend/code_assets/style.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Autoclub',
      theme: lightTheme,
      home: const MyHomePage(),
    );
  }
}

