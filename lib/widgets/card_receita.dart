import 'package:flutter/material.dart';

import '../data/favoritos.dart';
import '../models/receita.dart';
import '../pages/detalhes_page.dart';

class CardReceita extends StatelessWidget {
  const CardReceita({
    super.key,
    required this.receita,
    required this.favoritos,
  });

  final Receita receita;
  final Favoritos favoritos;

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  DetalhesPage(receita: receita, favoritos: favoritos),
            ),
          );
        },
        child: Row(
          children: [
            Container(
              width: 96,
              height: 96,
              color: cores.primaryContainer,
              child: Icon(
                Icons.restaurant,
                size: 40,
                color: cores.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      receita.nome,
                      style: textos.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(receita.tempoEDificuldade),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 18, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(receita.avaliacaoTexto),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            BotaoFavorito(receita: receita, favoritos: favoritos),
          ],
        ),
      ),
    );
  }
}

class BotaoFavorito extends StatelessWidget {
  const BotaoFavorito({
    super.key,
    required this.receita,
    required this.favoritos,
  });

  final Receita receita;
  final Favoritos favoritos;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: favoritos,
      builder: (context, _) {
        final salva = favoritos.contem(receita);
        return IconButton(
          tooltip: salva ? 'Remover dos favoritos' : 'Adicionar aos favoritos',
          icon: Icon(
            salva ? Icons.favorite : Icons.favorite_border,
            color: salva ? Theme.of(context).colorScheme.primary : null,
          ),
          onPressed: () => favoritos.alternar(receita),
        );
      },
    );
  }
}
