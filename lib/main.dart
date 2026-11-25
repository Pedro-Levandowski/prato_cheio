import 'package:flutter/material.dart';
import 'pages/principal_page.dart';
import 'tema.dart';

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
      theme: criarTema(),
      home: const PrincipalPage(),
    );
  }
}
