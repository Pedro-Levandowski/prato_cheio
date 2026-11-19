import 'package:flutter/material.dart';

import '../data/favoritos.dart';
import 'favoritos_page.dart';
import 'home_page.dart';

class PrincipalPage extends StatefulWidget {
  const PrincipalPage({super.key});

  @override
  State<PrincipalPage> createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  final favoritos = Favoritos();
  int abaAtual = 0;

  void irParaAba(int aba) {
    setState(() => abaAtual = aba);
  }

  @override
  void dispose() {
    favoritos.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: abaAtual,
        children: [
          HomePage(favoritos: favoritos),
          FavoritosPage(favoritos: favoritos, onExplorar: () => irParaAba(0)),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: abaAtual,
        onDestinationSelected: irParaAba,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explorar',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
        ],
      ),
    );
  }
}
