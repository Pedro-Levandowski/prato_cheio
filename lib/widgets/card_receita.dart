import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/favoritos.dart';
import '../models/receita.dart';
import '../pages/detalhes_page.dart';
import '../tema.dart';
import 'etiqueta.dart';
import 'prato.dart';

void abrirDetalhes(
  BuildContext context,
  Receita receita,
  Favoritos favoritos,
  String heroTag,
) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => DetalhesPage(
        receita: receita,
        favoritos: favoritos,
        heroTag: heroTag,
      ),
    ),
  );
}

class CardReceita extends StatelessWidget {
  const CardReceita({
    super.key,
    required this.receita,
    required this.favoritos,
    required this.origem,
  });

  final Receita receita;
  final Favoritos favoritos;
  final String origem;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final tag = '$origem-${receita.id}';

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => abrirDetalhes(context, receita, favoritos, tag),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: tag,
                child: FotoReceita(receita: receita, altura: 96, largura: 96),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: SizedBox(
                  height: 96,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 2),
                      Text(
                        receita.nome,
                        style: textos.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      TempoEDificuldade(receita: receita),
                      const SizedBox(height: 6),
                      Avaliacao(receita: receita),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 96,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: BotaoFavorito(receita: receita, favoritos: favoritos),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardDestaque extends StatelessWidget {
  const CardDestaque({
    super.key,
    required this.receita,
    required this.favoritos,
  });

  final Receita receita;
  final Favoritos favoritos;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final tag = 'destaque-${receita.id}';

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => abrirDetalhes(context, receita, favoritos, tag),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Hero(
                  tag: tag,
                  child: FotoReceita(
                    receita: receita,
                    altura: 176,
                    raio: 0,
                    escala: 0.68,
                  ),
                ),
                const Positioned(
                  left: 12,
                  top: 12,
                  child: Etiqueta(
                    texto: 'Mais bem avaliada',
                    icone: Icons.star_rounded,
                    fundo: Colors.white,
                  ),
                ),
                Positioned(
                  right: 6,
                  top: 6,
                  child: BotaoFavorito(
                    receita: receita,
                    favoritos: favoritos,
                    flutuante: true,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(receita.nome, style: textos.titleLarge),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      TempoEDificuldade(receita: receita),
                      const Spacer(),
                      Avaliacao(receita: receita),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TempoEDificuldade extends StatelessWidget {
  const TempoEDificuldade({super.key, required this.receita});

  final Receita receita;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (receita.tempo case final tempo?) ...[
          const Icon(Icons.schedule, size: 15, color: Cores.texto),
          const SizedBox(width: 4),
          Text(
            '${tempo.minutos} min',
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: Cores.texto),
          ),
          const SizedBox(width: 8),
        ],
        if (receita.dificuldade != null)
          Etiqueta.dificuldade(receita.dificuldade!),
      ],
    );
  }
}

class Avaliacao extends StatelessWidget {
  const Avaliacao({super.key, required this.receita});

  final Receita receita;

  @override
  Widget build(BuildContext context) {
    final avaliada = receita.avaliacao != null;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.star_rounded,
          size: 17,
          color: avaliada ? Cores.acafrao : Cores.borda,
        ),
        const SizedBox(width: 3),
        Text(
          receita.avaliacaoTexto,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: avaliada ? Cores.verde : Cores.texto,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class BotaoFavorito extends StatelessWidget {
  const BotaoFavorito({
    super.key,
    required this.receita,
    required this.favoritos,
    this.flutuante = false,
  });

  final Receita receita;
  final Favoritos favoritos;
  final bool flutuante;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: favoritos,
      builder: (context, _) {
        final salva = favoritos.contem(receita);
        return IconButton(
          tooltip: salva ? 'Remover dos favoritos' : 'Adicionar aos favoritos',
          style: flutuante
              ? IconButton.styleFrom(backgroundColor: Colors.white)
              : null,
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            transitionBuilder: (filho, animacao) =>
                ScaleTransition(scale: animacao, child: filho),
            child: Icon(
              salva ? Icons.favorite : Icons.favorite_border,
              key: ValueKey(salva),
              color: salva ? Cores.terracota : Cores.verdeEscuro,
            ),
          ),
          onPressed: () {
            HapticFeedback.selectionClick();
            favoritos.alternar(receita);
          },
        );
      },
    );
  }
}
