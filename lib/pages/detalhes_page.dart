import 'package:flutter/material.dart';

import '../data/favoritos.dart';
import '../models/receita.dart';
import '../tema.dart';
import '../widgets/card_receita.dart';
import '../widgets/etiqueta.dart';
import '../widgets/prato.dart';

class DetalhesPage extends StatefulWidget {
  const DetalhesPage({
    super.key,
    required this.receita,
    required this.favoritos,
    this.heroTag,
  });

  final Receita receita;
  final Favoritos favoritos;
  final String? heroTag;

  @override
  State<DetalhesPage> createState() => _DetalhesPageState();
}

class _DetalhesPageState extends State<DetalhesPage> {
  final separados = <int>{};

  void marcar(int indice) {
    setState(() {
      if (!separados.remove(indice)) separados.add(indice);
    });
  }

  @override
  Widget build(BuildContext context) {
    final receita = widget.receita;
    final textos = Theme.of(context).textTheme;
    final foto = FotoReceita(receita: receita, raio: 0, escala: 0.55);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 300,
            backgroundColor: Cores.creme,
            shape: const RoundedRectangleBorder(),
            leading: Padding(
              padding: const EdgeInsets.all(6),
              child: BackButton(
                style: IconButton.styleFrom(backgroundColor: Colors.white),
              ),
            ),
            title: const TituloRecolhido('Receita'),
            actions: [
              BotaoFavorito(
                receita: receita,
                favoritos: widget.favoritos,
                flutuante: true,
              ),
              const SizedBox(width: 10),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: widget.heroTag == null
                  ? foto
                  : Hero(tag: widget.heroTag!, child: foto),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(28),
              child: Container(
                height: 28,
                decoration: const BoxDecoration(
                  color: Cores.creme,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            sliver: SliverList.list(
              children: [
                Text(receita.nome, style: textos.headlineMedium),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (receita.culinaria != null)
                      Etiqueta(
                        texto: receita.culinaria!,
                        icone: Icons.public,
                        fundo: Colors.white,
                      ),
                    if (receita.dificuldade != null)
                      Etiqueta.dificuldade(receita.dificuldade!),
                    Etiqueta(
                      texto: receita.avaliacaoTexto,
                      icone: Icons.star_rounded,
                      fundo: const Color(0xFFFBEFD9),
                      cor: const Color(0xFF8A5A12),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  spacing: 10,
                  children: [
                    if (receita.tempoMinutos != null)
                      Expanded(
                        child: InfoReceita(
                          icone: Icons.schedule,
                          valor: '${receita.tempoMinutos} min',
                          rotulo: 'tempo total',
                        ),
                      ),
                    if (receita.porcoes != null)
                      Expanded(
                        child: InfoReceita(
                          icone: Icons.people_outline,
                          valor: '${receita.porcoes}',
                          rotulo: 'porções',
                        ),
                      ),
                    Expanded(
                      child: ListenableBuilder(
                        listenable: widget.favoritos,
                        builder: (context, _) {
                          final salva = widget.favoritos.contem(receita);
                          return InfoReceita(
                            icone: salva
                                ? Icons.favorite
                                : Icons.favorite_border,
                            valor: salva ? 'Salva' : 'Não salva',
                            rotulo: 'nos favoritos',
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text('Ingredientes', style: textos.titleLarge),
                    ),
                    if (receita.ingredientes.isNotEmpty)
                      Text(
                        '${separados.length} de ${receita.ingredientes.length}',
                        style: textos.bodySmall?.copyWith(color: Cores.texto),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                if (receita.ingredientes.isEmpty)
                  Text(
                    'Ingredientes não informados.',
                    style: textos.bodyLarge?.copyWith(color: Cores.texto),
                  )
                else ...[
                  Text(
                    'Toque para marcar o que já separou.',
                    style: textos.bodySmall?.copyWith(color: Cores.texto),
                  ),
                  const SizedBox(height: 8),
                  for (var i = 0; i < receita.ingredientes.length; i++)
                    Ingrediente(
                      texto: receita.ingredientes[i],
                      separado: separados.contains(i),
                      onTap: () => marcar(i),
                    ),
                ],
                const SizedBox(height: 28),
                Text('Modo de preparo', style: textos.titleLarge),
                const SizedBox(height: 14),
                if (receita.instrucoes.isEmpty)
                  Text(
                    'Modo de preparo não informado.',
                    style: textos.bodyLarge?.copyWith(color: Cores.texto),
                  )
                else
                  for (var i = 0; i < receita.instrucoes.length; i++)
                    Passo(
                      numero: i + 1,
                      texto: receita.instrucoes[i],
                      ultimo: i == receita.instrucoes.length - 1,
                    ),
                const SizedBox(height: 28),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Voltar para as receitas'),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Cores.borda)),
          ),
          child: Text(
            'Role para ler todos os ingredientes e passos.',
            style: textos.bodySmall?.copyWith(color: Cores.texto),
          ),
        ),
      ),
    );
  }
}

class TituloRecolhido extends StatelessWidget {
  const TituloRecolhido(this.texto, {super.key});

  final String texto;

  @override
  Widget build(BuildContext context) {
    final barra = context
        .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
    final recolhida =
        barra == null || barra.currentExtent <= barra.minExtent + 8;

    return AnimatedOpacity(
      opacity: recolhida ? 1 : 0,
      duration: const Duration(milliseconds: 150),
      child: Text(texto),
    );
  }
}

class InfoReceita extends StatelessWidget {
  const InfoReceita({
    super.key,
    required this.icone,
    required this.valor,
    required this.rotulo,
  });

  final IconData icone;
  final String valor;
  final String rotulo;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      decoration: BoxDecoration(
        color: Cores.menta,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icone, size: 18, color: Cores.verde),
          const SizedBox(height: 8),
          Text(
            valor,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textos.titleMedium?.copyWith(
              color: Cores.verde,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(rotulo, style: textos.bodySmall?.copyWith(color: Cores.texto)),
        ],
      ),
    );
  }
}

class Ingrediente extends StatelessWidget {
  const Ingrediente({
    super.key,
    required this.texto,
    required this.separado,
    required this.onTap,
  });

  final String texto;
  final bool separado;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final estilo = Theme.of(context).textTheme.bodyLarge;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: separado ? Cores.verde : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: separado ? Cores.verde : Cores.borda,
                  width: 1.5,
                ),
              ),
              child: separado
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                texto,
                style: estilo?.copyWith(
                  color: separado ? Cores.texto : null,
                  decoration: separado ? TextDecoration.lineThrough : null,
                  decorationColor: Cores.texto,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Passo extends StatelessWidget {
  const Passo({
    super.key,
    required this.numero,
    required this.texto,
    required this.ultimo,
  });

  final int numero;
  final String texto;
  final bool ultimo;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: Cores.verde,
                child: Text(
                  '$numero',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (!ultimo)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: Cores.menta,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 3, bottom: ultimo ? 0 : 20),
              child: Text(texto, style: Theme.of(context).textTheme.bodyLarge),
            ),
          ),
        ],
      ),
    );
  }
}
