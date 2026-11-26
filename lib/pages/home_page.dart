import 'package:flutter/material.dart';

import '../data/favoritos.dart';
import '../data/receitas_api.dart';
import '../data/validacao.dart';
import '../models/receita.dart';
import '../tema.dart';
import '../widgets/campo_busca.dart';
import '../widgets/card_receita.dart';
import '../widgets/estado_vazio.dart';
import '../widgets/prato.dart';
import 'pesquisa_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.api,
    required this.favoritos,
    required this.onFavoritos,
  });

  final ReceitasApi api;
  final Favoritos favoritos;
  final VoidCallback onFavoritos;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final busca = TextEditingController();
  String? mensagemErro;
  List<Receita> receitas = [];
  bool carregando = true;
  bool buscando = false;
  String? falha;
  String culinariaEscolhida = 'Todas';
  Receita? destaque;
  int total = 0;
  bool carregandoMais = false;
  String? falhaMais;
  int geracao = 0;

  @override
  void initState() {
    super.initState();
    carregar();
  }

  Receita? maisBemAvaliada(List<Receita> lista) => lista.isEmpty
      ? null
      : lista.reduce((a, b) => (b.avaliacao ?? 0) > (a.avaliacao ?? 0) ? b : a);

  Future<void> carregar() async {
    if (buscando) return;
    buscando = true;
    final atual = ++geracao;
    if (falha != null) {
      setState(() {
        falha = null;
        carregando = true;
      });
    }

    try {
      final pagina = await widget.api.buscarPagina(pular: 0);
      if (!mounted || atual != geracao) return;
      setState(() {
        receitas = pagina.receitas;
        total = pagina.total;
        destaque = maisBemAvaliada(pagina.receitas);
        carregandoMais = false;
        falhaMais = null;
        carregando = false;
      });
    } on FalhaApi catch (erro) {
      if (!mounted || atual != geracao) return;
      if (receitas.isEmpty) {
        setState(() {
          falha = erro.mensagem;
          carregando = false;
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(erro.mensagem)));
      }
    } finally {
      buscando = false;
    }
  }

  Future<void> carregarMais() async {
    if (buscando ||
        carregandoMais ||
        falhaMais != null ||
        receitas.length >= total) {
      return;
    }
    final atual = geracao;
    setState(() => carregandoMais = true);

    try {
      final pagina = await widget.api.buscarPagina(pular: receitas.length);
      if (!mounted || atual != geracao) return;
      setState(() {
        final ids = {for (final r in receitas) r.id};
        receitas = [
          ...receitas,
          ...pagina.receitas.where((r) => ids.add(r.id)),
        ];
        total = pagina.receitas.isEmpty ? receitas.length : pagina.total;
        carregandoMais = false;
      });
    } on FalhaApi catch (erro) {
      if (!mounted || atual != geracao) return;
      setState(() {
        falhaMais = erro.mensagem;
        carregandoMais = false;
      });
    }
  }

  void tentarCarregarMais() {
    setState(() => falhaMais = null);
    carregarMais();
  }

  void validarBusca(String valor) {
    setState(() => mensagemErro = validarTermo(valor));
  }

  void buscar() {
    validarBusca(busca.text);
    if (mensagemErro != null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PesquisaPage(
          api: widget.api,
          favoritos: widget.favoritos,
          onFavoritos: widget.onFavoritos,
          termoInicial: busca.text.trim(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    busca.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const margem = EdgeInsets.symmetric(horizontal: 20);

    return Scaffold(
      appBar: AppBar(title: const Logo()),
      body: carregando
          ? ListView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              children: const [Carregando()],
            )
          : falha != null
          ? ListView(
              padding: const EdgeInsets.fromLTRB(20, 80, 20, 24),
              children: [
                EstadoVazio(
                  icone: Icons.priority_high,
                  titulo: 'Não foi possível carregar as receitas.',
                  mensagem: falha!,
                  textoBotao: 'Tentar novamente',
                  onBotao: carregar,
                ),
              ],
            )
          : receitas.isEmpty
          ? ListView(
              padding: const EdgeInsets.fromLTRB(20, 80, 20, 24),
              children: [
                EstadoVazio(
                  icone: Icons.restaurant_menu,
                  titulo: 'Nenhuma receita disponível',
                  mensagem: 'O servidor não enviou receitas agora.',
                  textoBotao: 'Tentar novamente',
                  onBotao: carregar,
                ),
              ],
            )
          : RefreshIndicator(
              onRefresh: carregar,
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: margem.copyWith(top: 24),
                    sliver: SliverList.list(children: cabecalho(context)),
                  ),
                  SliverPadding(
                    padding: margem.copyWith(bottom: 24),
                    sliver: listaFiltrada(),
                  ),
                  SliverToBoxAdapter(child: rodape(context)),
                ],
              ),
            ),
    );
  }

  List<String> get culinarias => [
    'Todas',
    ...{for (final r in receitas) r.culinaria ?? 'Outras'}.toList()..sort(),
  ];

  String get culinariaAtual =>
      culinarias.contains(culinariaEscolhida) ? culinariaEscolhida : 'Todas';

  List<Widget> cabecalho(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final destaque = this.destaque;

    return [
      // Pesquisa
      Text(
        'Olá!',
        style: textos.labelLarge?.copyWith(
          color: Cores.terracota,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 2),
      Text('Receitas', style: textos.headlineMedium),
      const SizedBox(height: 6),
      Text(
        'Pesquise uma receita pelo nome.',
        style: textos.bodyLarge?.copyWith(color: Cores.texto),
      ),
      const SizedBox(height: 20),
      CampoBusca(
        controller: busca,
        mensagemErro: mensagemErro,
        onChanged: validarBusca,
        onSubmitted: (_) => buscar(),
      ),
      const SizedBox(height: 12),
      FilledButton(onPressed: buscar, child: const Text('Buscar receitas')),
      const SizedBox(height: 32),

      // Destaque
      if (destaque != null) ...[
        Text('Destaque', style: textos.titleLarge),
        const SizedBox(height: 12),
        CardDestaque(receita: destaque, favoritos: widget.favoritos),
        const SizedBox(height: 32),
      ],

      // Listagem
      Text('Receitas disponíveis', style: textos.titleLarge),
      const SizedBox(height: 4),
      Text(
        'Selecione uma receita para ver o preparo.',
        style: textos.bodyMedium?.copyWith(color: Cores.texto),
      ),
      const SizedBox(height: 14),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        child: Row(
          spacing: 8,
          children: [
            for (final culinaria in culinarias)
              ChoiceChip(
                label: Text(culinaria),
                labelStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: culinaria == culinariaAtual
                      ? Colors.white
                      : Cores.verdeEscuro,
                ),
                selected: culinaria == culinariaAtual,
                onSelected: (_) {
                  setState(() => culinariaEscolhida = culinaria);
                },
              ),
          ],
        ),
      ),
      const SizedBox(height: 10),
    ];
  }

  // Cards
  Widget listaFiltrada() {
    final filtradas = culinariaAtual == 'Todas'
        ? receitas
        : receitas
              .where((r) => (r.culinaria ?? 'Outras') == culinariaAtual)
              .toList();

    return SliverList.builder(
      itemCount: filtradas.length,
      itemBuilder: (context, i) => CardReceita(
        receita: filtradas[i],
        favoritos: widget.favoritos,
        origem: 'home',
      ),
    );
  }

  Widget rodape(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final cinza = textos.bodyMedium?.copyWith(color: Cores.texto);

    if (receitas.length >= total) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Text(
          total == 1
              ? 'Você viu a única receita.'
              : 'Você viu todas as $total receitas.',
          style: cinza,
          textAlign: TextAlign.center,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            falhaMais ?? 'Mostrando ${receitas.length} de $total receitas',
            style: cinza,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: carregandoMais
                ? null
                : falhaMais != null
                ? tentarCarregarMais
                : carregarMais,
            child: carregandoMais
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    falhaMais != null
                        ? 'Tentar carregar mais'
                        : 'Carregar mais receitas',
                  ),
          ),
        ],
      ),
    );
  }
}

class Carregando extends StatelessWidget {
  const Carregando({super.key});

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;

    Widget bloco(double largura, double altura, {double raio = 8}) => Container(
      width: largura,
      height: altura,
      decoration: BoxDecoration(
        color: Cores.bege,
        borderRadius: BorderRadius.circular(raio),
      ),
    );

    Widget cardVazio() => Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            bloco(92, 92, raio: 12),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                bloco(150, 14),
                const SizedBox(height: 10),
                bloco(100, 14),
                const SizedBox(height: 24),
                bloco(60, 12),
              ],
            ),
          ],
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Explorar receitas', style: textos.headlineMedium),
        const SizedBox(height: 24),
        bloco(double.infinity, 52, raio: 16),
        const SizedBox(height: 24),
        cardVazio(),
        cardVazio(),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 12),
            Text(
              'Carregando receitas…',
              style: textos.bodyMedium?.copyWith(color: Cores.texto),
            ),
          ],
        ),
      ],
    );
  }
}
