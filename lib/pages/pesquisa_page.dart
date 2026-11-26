import 'package:flutter/material.dart';

import '../data/favoritos.dart';
import '../data/receitas_api.dart';
import '../data/validacao.dart';
import '../models/receita.dart';
import '../tema.dart';
import '../widgets/barra_navegacao.dart';
import '../widgets/campo_busca.dart';
import '../widgets/card_receita.dart';
import '../widgets/estado_vazio.dart';

class PesquisaPage extends StatefulWidget {
  const PesquisaPage({
    super.key,
    required this.api,
    required this.favoritos,
    required this.onFavoritos,
    this.termoInicial,
  });

  final ReceitasApi api;
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
  Future<List<Receita>>? resultados;

  @override
  void initState() {
    super.initState();
    final termo = widget.termoInicial;
    if (termo != null) {
      busca.text = termo;
      termoBuscado = termo;
      resultados = widget.api.pesquisar(termo);
    }
  }

  void validarBusca(String valor) {
    setState(() => mensagemErro = validarTermo(valor));
  }

  void pesquisar() {
    validarBusca(busca.text);

    if (mensagemErro != null) {
      setState(() {
        termoBuscado = null;
        resultados = null;
      });
      return;
    }

    final termo = busca.text.trim();
    setState(() {
      termoBuscado = termo;
      resultados = widget.api.pesquisar(termo);
    });
  }

  void tentarNovamente() {
    setState(() => resultados = widget.api.pesquisar(termoBuscado!));
  }

  void limparPesquisa() {
    busca.clear();
    setState(() {
      mensagemErro = null;
      termoBuscado = null;
      resultados = null;
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

    return Scaffold(
      appBar: AppBar(title: const Text('Pesquisar receitas')),
      body: FutureBuilder(
        future: resultados,
        builder: (context, estado) {
          final buscando =
              resultados != null &&
              estado.connectionState != ConnectionState.done;

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            children: [
              if (termoBuscado == null) ...[
                Text('Qual receita você procura?', style: textos.headlineSmall),
                const SizedBox(height: 20),
              ],
              CampoBusca(
                controller: busca,
                focusNode: foco,
                mensagemErro: mensagemErro,
                onChanged: validarBusca,
                onSubmitted: (_) => buscando ? null : pesquisar(),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: buscando ? null : pesquisar,
                child: buscando
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Pesquisar'),
              ),
              const SizedBox(height: 28),
              ...resultado(context, estado, buscando),
            ],
          );
        },
      ),
      bottomNavigationBar: BarraNavegacao(abaAtual: 0, onSelecionar: irParaAba),
    );
  }

  List<Widget> resultado(
    BuildContext context,
    AsyncSnapshot<List<Receita>> estado,
    bool buscando,
  ) {
    final textos = Theme.of(context).textTheme;

    if (termoBuscado == null) {
      return [
        Text(
          'Você pode buscar por parte do nome da receita.',
          style: textos.bodyLarge?.copyWith(color: Cores.texto),
        ),
      ];
    }

    if (buscando) {
      return [
        Row(
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Buscando “$termoBuscado”…',
                style: textos.bodyLarge?.copyWith(color: Cores.texto),
              ),
            ),
          ],
        ),
      ];
    }

    if (estado.hasError) {
      final erro = estado.error;
      return [
        const SizedBox(height: 8),
        EstadoVazio(
          icone: Icons.wifi_off,
          titulo: 'Não foi possível pesquisar',
          mensagem: erro is FalhaApi
              ? erro.mensagem
              : 'Algo deu errado. Tente novamente.',
          textoBotao: 'Tentar novamente',
          onBotao: tentarNovamente,
          textoLink: 'Ver todas as receitas',
          onLink: () => Navigator.pop(context),
        ),
      ];
    }

    final encontradas = estado.data ?? <Receita>[];
    if (encontradas.isEmpty) {
      return [
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
      ];
    }

    return [
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
    ];
  }
}
