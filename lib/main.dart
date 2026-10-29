import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const PratoCheioApp());
}

class PratoCheioApp extends StatelessWidget {
  const PratoCheioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prato Cheio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE65100)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
