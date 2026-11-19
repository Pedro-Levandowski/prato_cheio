import 'package:flutter/material.dart';

import '../data/favoritos.dart';
import '../data/receitas_teste.dart';
import '../widgets/card_receita.dart';
import '../widgets/estado_vazio.dart';
import 'pesquisa_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.favoritos});

  final Favoritos favoritos;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final busca = TextEditingController();
  String? mensagemErro;
  bool carregando = true;
  bool falhou = false;

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

    return Scaffold(
      appBar: AppBar(title: const Text('Prato Cheio'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (carregando)
            const Carregando()
          else if (falhou) ...[
            const SizedBox(height: 48),
            EstadoVazio(
              icone: Icons.priority_high,
              titulo: 'Não foi possível carregar as receitas.',
              mensagem: 'Verifique sua conexão e tente novamente.',
              textoBotao: 'Tentar novamente',
              onBotao: tentarNovamente,
            ),
          ] else ...[
            // Pesquisa
            Text('Receitas', style: textos.headlineMedium),
            const SizedBox(height: 4),
            const Text('Pesquise uma receita pelo nome.'),
            const SizedBox(height: 16),
            TextField(
              controller: busca,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                labelText: 'Buscar pelo nome',
                errorText: mensagemErro,
                errorMaxLines: 2,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
              onChanged: validarBusca,
              onSubmitted: (_) => buscar(),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: buscar,
              child: const Text('Buscar receitas'),
            ),
            const SizedBox(height: 24),

            // Listagem
            Text('Receitas disponíveis', style: textos.titleLarge),
            const SizedBox(height: 4),
            const Text('Selecione uma receita para ver o preparo.'),
            const SizedBox(height: 12),

            // Cards
            for (final receita in receitas)
              CardReceita(receita: receita, favoritos: widget.favoritos),
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
    final cores = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;

    Widget bloco(double largura, double altura) => Container(
      width: largura,
      height: altura,
      decoration: BoxDecoration(
        color: cores.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
    );

    Widget cardVazio() => Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            bloco(80, 80),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                bloco(160, 14),
                const SizedBox(height: 10),
                bloco(110, 14),
                const SizedBox(height: 22),
                bloco(70, 14),
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
        bloco(double.infinity, 48),
        const SizedBox(height: 24),
        cardVazio(),
        cardVazio(),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 12),
            Text('Carregando receitas…', style: textos.bodyMedium),
          ],
        ),
      ],
    );
  }
}
