import 'package:flutter/material.dart';

import '../data/favoritos.dart';
import '../data/receitas_teste.dart';
import '../tema.dart';
import '../widgets/campo_busca.dart';
import '../widgets/card_receita.dart';
import '../widgets/estado_vazio.dart';
import '../widgets/prato.dart';
import 'pesquisa_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.favoritos,
    required this.onFavoritos,
  });

  final Favoritos favoritos;
  final VoidCallback onFavoritos;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final busca = TextEditingController();
  String? mensagemErro;
  bool carregando = true;
  bool falhou = false;
  String culinariaEscolhida = 'Todas';

  @override
  void initState() {
    super.initState();
    esperarCarregamento();
  }

  void esperarCarregamento() {
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => carregando = false);
    });
  }

  void tentarNovamente() {
    setState(() {
      carregando = true;
      falhou = false;
    });
    esperarCarregamento();
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
    final textos = Theme.of(context).textTheme;
    final culinarias = [
      'Todas',
      ...{for (final r in receitas) r.culinaria ?? 'Outras'},
    ];
    final filtradas = culinariaEscolhida == 'Todas'
        ? receitas
        : receitas
              .where((r) => (r.culinaria ?? 'Outras') == culinariaEscolhida)
              .toList();
    final destaque = receitas.reduce(
      (a, b) => (b.avaliacao ?? 0) > (a.avaliacao ?? 0) ? b : a,
    );

    return Scaffold(
      appBar: AppBar(title: const Logo()),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
        children: [
          if (carregando)
            const Carregando()
          else if (falhou) ...[
            const SizedBox(height: 56),
            EstadoVazio(
              icone: Icons.priority_high,
              titulo: 'Não foi possível carregar as receitas.',
              mensagem: 'Verifique sua conexão e tente novamente.',
              textoBotao: 'Tentar novamente',
              onBotao: tentarNovamente,
            ),
          ] else ...[
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
            FilledButton(
              onPressed: buscar,
              child: const Text('Buscar receitas'),
            ),
            const SizedBox(height: 32),

            // Destaque
            Text('Destaque', style: textos.titleLarge),
            const SizedBox(height: 12),
            CardDestaque(receita: destaque, favoritos: widget.favoritos),
            const SizedBox(height: 32),

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
                      selected: culinaria == culinariaEscolhida,
                      onSelected: (_) =>
                          setState(() => culinariaEscolhida = culinaria),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Cards
            for (final receita in filtradas)
              CardReceita(
                receita: receita,
                favoritos: widget.favoritos,
                origem: 'home',
              ),
          ],
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
