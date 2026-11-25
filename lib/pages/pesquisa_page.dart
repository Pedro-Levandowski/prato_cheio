import 'package:flutter/material.dart';

import '../data/favoritos.dart';
import '../data/receitas_teste.dart';
import '../tema.dart';
import '../widgets/barra_navegacao.dart';
import '../widgets/campo_busca.dart';
import '../widgets/card_receita.dart';
import '../widgets/estado_vazio.dart';

class PesquisaPage extends StatefulWidget {
  const PesquisaPage({
    super.key,
    required this.favoritos,
    required this.onFavoritos,
    this.termoInicial,
  });

  final Favoritos favoritos;
  final VoidCallback onFavoritos;
  final String? termoInicial;

  @override
  State<PesquisaPage> createState() => _PesquisaPageState();
}

class _PesquisaPageState extends State<PesquisaPage> {
  final busca = TextEditingController();
  final foco = FocusNode();
  String? mensagemErro;
  String? termoBuscado;

  @override
  void initState() {
    super.initState();
    if (widget.termoInicial != null) {
      busca.text = widget.termoInicial!;
      termoBuscado = widget.termoInicial;
    }
  }

  void validarBusca(String valor) {
    setState(() => mensagemErro = validarTermo(valor));
  }

  void pesquisar() {
    validarBusca(busca.text);

    if (mensagemErro != null) {
      setState(() => termoBuscado = null);
      return;
    }

    setState(() => termoBuscado = busca.text.trim());
  }

  void limparPesquisa() {
    busca.clear();
    setState(() {
      mensagemErro = null;
      termoBuscado = null;
    });
  }

  void alterarPesquisa() {
    foco.requestFocus();
    busca.selection = TextSelection(
      baseOffset: 0,
      extentOffset: busca.text.length,
    );
  }

  void irParaAba(int aba) {
    Navigator.pop(context);
    if (aba == 1) widget.onFavoritos();
  }

  @override
  void dispose() {
    busca.dispose();
    foco.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final encontradas = termoBuscado == null
        ? null
        : buscarReceitas(termoBuscado!);

    return Scaffold(
      appBar: AppBar(title: const Text('Pesquisar receitas')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
        children: [
          if (encontradas == null) ...[
            Text('Qual receita você procura?', style: textos.headlineSmall),
            const SizedBox(height: 20),
          ],
          CampoBusca(
            controller: busca,
            focusNode: foco,
            mensagemErro: mensagemErro,
            onChanged: validarBusca,
            onSubmitted: (_) => pesquisar(),
          ),
          const SizedBox(height: 12),
          FilledButton(onPressed: pesquisar, child: const Text('Pesquisar')),
          const SizedBox(height: 28),
          if (encontradas == null)
            Text(
              'Você pode buscar por parte do nome da receita.',
              style: textos.bodyLarge?.copyWith(color: Cores.texto),
            )
          else if (encontradas.isEmpty) ...[
            const SizedBox(height: 8),
            EstadoVazio(
              icone: Icons.search_off,
              titulo: 'Nenhum resultado',
              mensagem:
                  'Não encontramos receitas para “$termoBuscado”. '
                  'Tente outro termo.',
              textoBotao: 'Alterar pesquisa',
              onBotao: alterarPesquisa,
              textoLink: 'Ver todas as receitas',
              onLink: () => Navigator.pop(context),
            ),
          ] else ...[
            Text('Resultados para “$termoBuscado”', style: textos.titleLarge),
            const SizedBox(height: 4),
            Text(
              '${encontradas.length == 1 ? '1 receita encontrada' : '${encontradas.length} receitas encontradas'}. '
              'Toque na receita para ver o preparo.',
              style: textos.bodyMedium?.copyWith(color: Cores.texto),
            ),
            const SizedBox(height: 12),
            for (final receita in encontradas)
              CardReceita(
                receita: receita,
                favoritos: widget.favoritos,
                origem: 'pesquisa',
              ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: limparPesquisa,
              child: const Text('Limpar pesquisa'),
            ),
          ],
        ],
      ),
      bottomNavigationBar: BarraNavegacao(abaAtual: 0, onSelecionar: irParaAba),
    );
  }
}
