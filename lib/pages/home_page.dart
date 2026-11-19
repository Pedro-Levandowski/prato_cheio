import 'package:flutter/material.dart';

import '../data/receitas_teste.dart';
import 'detalhes_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final busca = TextEditingController();
  final foco = FocusNode();
  String? mensagemErro;
  String? termoBuscado;

  void validarBusca(String valor) {
    setState(() {
      if (valor.isEmpty) {
        mensagemErro = 'Digite um nome para pesquisar.';
      } else if (valor.trim().isEmpty) {
        mensagemErro = 'Só espaços não valem. Digite um nome para pesquisar.';
      } else {
        mensagemErro = null;
      }
    });
  }

  void buscar() {
    validarBusca(busca.text);

    if (mensagemErro != null) {
      setState(() => termoBuscado = null);
      return;
    }

    setState(() => termoBuscado = busca.text.trim());
  }

  void limparBusca() {
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

  @override
  void dispose() {
    busca.dispose();
    foco.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;
    final palavras = termoBuscado?.toLowerCase().split(RegExp(r'\s+')) ?? [];
    final encontradas = receitas
        .where((r) => palavras.every(r.nome.toLowerCase().contains))
        .toList();
    final encontrou = encontradas.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Prato Cheio'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Pesquisa
          Text('Receitas', style: textos.headlineMedium),
          const SizedBox(height: 4),
          const Text('Pesquise uma receita pelo nome.'),
          const SizedBox(height: 16),
          TextField(
            controller: busca,
            focusNode: foco,
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
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: buscar,
              child: const Text('Buscar receitas'),
            ),
          ),
          const SizedBox(height: 24),

          // Listagem
          if (!encontrou) ...[
            const SizedBox(height: 8),
            Center(
              child: CircleAvatar(
                radius: 48,
                backgroundColor: cores.secondaryContainer,
                child: Icon(
                  Icons.search_off,
                  size: 40,
                  color: cores.onSecondaryContainer,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Nenhum resultado', style: textos.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Não encontramos receitas para “$termoBuscado”. '
              'Tente outro termo.',
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: alterarPesquisa,
              child: const Text('Alterar pesquisa'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: limparBusca,
              child: const Text('Ver todas as receitas'),
            ),
          ] else ...[
            Text(
              termoBuscado == null
                  ? 'Receitas disponíveis'
                  : 'Resultados para “$termoBuscado”',
              style: textos.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              termoBuscado == null
                  ? 'Selecione uma receita para ver o preparo.'
                  : 'Toque na receita para ver o preparo.',
            ),
            const SizedBox(height: 12),
          ],

          // Cards de exemplo
          for (final receita in encontradas)
            Card(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetalhesPage(receita: receita),
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
                                const Icon(
                                  Icons.star,
                                  size: 18,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 4),
                                Text(receita.avaliacaoTexto),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (termoBuscado != null && encontrou) ...[
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: limparBusca,
              child: const Text('Limpar pesquisa'),
            ),
          ],
        ],
      ),
      // Barra inferior das telas de referência
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explorar',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
        ],
      ),
    );
  }
}
