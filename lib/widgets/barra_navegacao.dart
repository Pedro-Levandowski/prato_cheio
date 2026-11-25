import 'package:flutter/material.dart';

class BarraNavegacao extends StatelessWidget {
  const BarraNavegacao({
    super.key,
    required this.abaAtual,
    required this.onSelecionar,
  });

  final int abaAtual;
  final ValueChanged<int> onSelecionar;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: abaAtual,
      onDestinationSelected: onSelecionar,
      destinations: const [
        NavigationDestination(icon: Icon(Icons.search), label: 'Explorar'),
        NavigationDestination(
          icon: Icon(Icons.favorite_border),
          selectedIcon: Icon(Icons.favorite),
          label: 'Favoritos',
        ),
      ],
    );
  }
}
