import 'package:flutter/material.dart';

import '../data/favoritos.dart';
import '../widgets/card_receita.dart';
import '../widgets/estado_vazio.dart';

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
                EstadoVazio(
                  icone: Icons.favorite_border,
                  titulo: 'Nenhum favorito',
                  mensagem:
                      'Marque uma receita como favorita para encontrá-la aqui.',
                  textoBotao: 'Explorar receitas',
                  onBotao: onExplorar,
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
