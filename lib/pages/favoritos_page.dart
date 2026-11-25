import 'package:flutter/material.dart';

import '../data/favoritos.dart';
import '../models/receita.dart';
import '../tema.dart';
import '../widgets/card_receita.dart';
import '../widgets/estado_vazio.dart';
import '../widgets/etiqueta.dart';
import '../widgets/prato.dart';

class FavoritosPage extends StatelessWidget {
  const FavoritosPage({
    super.key,
    required this.favoritos,
    required this.onExplorar,
  });

  final Favoritos favoritos;
  final VoidCallback onExplorar;

  void remover(BuildContext context, Receita receita) {
    favoritos.alternar(receita);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${receita.nome} saiu dos favoritos.'),
          action: SnackBarAction(
            label: 'Desfazer',
            onPressed: () => favoritos.alternar(receita),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Logo()),
      body: ListenableBuilder(
        listenable: favoritos,
        builder: (context, _) {
          final salvas = favoritos.receitas;

          if (salvas.isEmpty) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              children: [
                const SizedBox(height: 56),
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
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text('Favoritos', style: textos.headlineMedium),
                  ),
                  Etiqueta(
                    texto: salvas.length == 1
                        ? '1 receita'
                        : '${salvas.length} receitas',
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Receitas salvas nesta sessão.',
                style: textos.bodyLarge?.copyWith(color: Cores.texto),
              ),
              const SizedBox(height: 16),
              for (final receita in salvas)
                Dismissible(
                  key: ValueKey(receita.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => remover(context, receita),
                  background: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.only(right: 24),
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6E3DA),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Color(0xFF9C4325),
                    ),
                  ),
                  child: CardReceita(
                    receita: receita,
                    favoritos: favoritos,
                    origem: 'favoritos',
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                'Toque no coração ou deslize para remover.',
                style: textos.bodySmall?.copyWith(color: Cores.texto),
              ),
            ],
          );
        },
      ),
    );
  }
}
