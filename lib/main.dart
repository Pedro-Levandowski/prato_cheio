import 'package:flutter/material.dart';
import 'data/receitas_api.dart';
import 'pages/principal_page.dart';
import 'tema.dart';

void main() {
  runApp(const PratoCheioApp());
}

class PratoCheioApp extends StatelessWidget {
  const PratoCheioApp({super.key, this.api});

  final ReceitasApi? api;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prato Cheio',
      debugShowCheckedModeBanner: false,
      theme: criarTema(),
      home: PrincipalPage(api: api),
    );
  }
}
