import 'package:flutter/material.dart';

import '../data/favoritos.dart';
import '../data/receitas_api.dart';
import '../widgets/barra_navegacao.dart';
import 'favoritos_page.dart';
import 'home_page.dart';

class PrincipalPage extends StatefulWidget {
  const PrincipalPage({super.key, this.api});

  final ReceitasApi? api;

  @override
  State<PrincipalPage> createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  late final api = widget.api ?? ReceitasApi();
  final favoritos = Favoritos();
  int abaAtual = 0;

  void irParaAba(int aba) {
    setState(() => abaAtual = aba);
  }

  @override
  void dispose() {
    favoritos.dispose();
    api.fechar();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: abaAtual,
        children: [
          HomePage(
            api: api,
            favoritos: favoritos,
            onFavoritos: () => irParaAba(1),
          ),
          FavoritosPage(favoritos: favoritos, onExplorar: () => irParaAba(0)),
        ],
      ),
      bottomNavigationBar: BarraNavegacao(
        abaAtual: abaAtual,
        onSelecionar: irParaAba,
      ),
    );
  }
}
