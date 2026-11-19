import 'package:flutter/material.dart';

import '../data/favoritos.dart';
import '../widgets/card_receita.dart';

class FavoritosPage extends StatelessWidget {
  const FavoritosPage({
    super.key,
    required this.favoritos,
    required this.onExplorar,
  });

  final Favoritos favoritos;
  final VoidCallback onExplorar;

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Prato Cheio'), centerTitle: true),
      body: ListenableBuilder(
        listenable: favoritos,
        builder: (context, _) {
          final salvas = favoritos.receitas;

          if (salvas.isEmpty) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const SizedBox(height: 48),
                Center(
                  child: CircleAvatar(
                    radius: 48,
                    backgroundColor: cores.secondaryContainer,
                    child: Icon(
                      Icons.favorite_border,
                      size: 40,
                      color: cores.onSecondaryContainer,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text('Nenhum favorito', style: textos.headlineSmall),
                const SizedBox(height: 8),
                const Text(
                  'Marque uma receita como favorita para encontrá-la aqui.',
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: onExplorar,
                  child: const Text('Explorar receitas'),
                ),
              ],
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Favoritos', style: textos.headlineMedium),
              const SizedBox(height: 4),
              const Text('Receitas salvas nesta sessão.'),
              const SizedBox(height: 12),
              for (final receita in salvas)
                CardReceita(receita: receita, favoritos: favoritos),
              const SizedBox(height: 12),
              Text(
                'Toque no coração para remover.',
                style: textos.bodySmall?.copyWith(
                  color: cores.onSurfaceVariant,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
