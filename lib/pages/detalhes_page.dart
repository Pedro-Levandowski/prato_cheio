import 'package:flutter/material.dart';

import '../data/favoritos.dart';
import '../models/receita.dart';
import '../widgets/card_receita.dart';

class DetalhesPage extends StatelessWidget {
  const DetalhesPage({
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
    final resumo = [
      if (receita.culinaria != null) receita.culinaria!,
      if (receita.dificuldade != null) receita.dificuldade!,
      receita.avaliacaoTexto,
    ].join(' • ');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Receita'),
        actions: [BotaoFavorito(receita: receita, favoritos: favoritos)],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: cores.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.restaurant,
              size: 72,
              color: cores.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 16),
          Text(receita.nome, style: textos.headlineSmall),
          const SizedBox(height: 4),
          Text(
            resumo,
            style: textos.bodyMedium?.copyWith(color: cores.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          Row(
            spacing: 12,
            children: [
              if (receita.tempoMinutos != null)
                Expanded(
                  child: InfoReceita(
                    valor: '${receita.tempoMinutos} min',
                    rotulo: 'tempo total',
                  ),
                ),
              if (receita.porcoes != null)
                Expanded(
                  child: InfoReceita(
                    valor: '${receita.porcoes}',
                    rotulo: 'porções',
                  ),
                ),
              Expanded(
                child: ListenableBuilder(
                  listenable: favoritos,
                  builder: (context, _) => InfoReceita(
                    valor: favoritos.contem(receita) ? 'Salva' : 'Não salva',
                    rotulo: 'nos favoritos',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text('Ingredientes', style: textos.titleLarge),
          const SizedBox(height: 8),
          if (receita.ingredientes.isEmpty)
            const Text('Ingredientes não informados.')
          else
            for (final ingrediente in receita.ingredientes)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: Icon(Icons.circle, size: 8, color: cores.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(ingrediente)),
                  ],
                ),
              ),
          const SizedBox(height: 24),
          Text('Modo de preparo', style: textos.titleLarge),
          const SizedBox(height: 8),
          if (receita.instrucoes.isEmpty)
            const Text('Modo de preparo não informado.')
          else
            for (var i = 0; i < receita.instrucoes.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: cores.primary,
                      child: Text(
                        '${i + 1}',
                        style: TextStyle(color: cores.onPrimary, fontSize: 13),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(receita.instrucoes[i]),
                      ),
                    ),
                  ],
                ),
              ),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Voltar para as receitas'),
          ),
        ],
      ),
    );
  }
}

class InfoReceita extends StatelessWidget {
  const InfoReceita({super.key, required this.valor, required this.rotulo});

  final String valor;
  final String rotulo;

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cores.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            valor,
            style: textos.titleMedium?.copyWith(
              color: cores.onSecondaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(rotulo, style: textos.bodySmall),
        ],
      ),
    );
  }
}
