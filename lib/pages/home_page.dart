import 'package:flutter/material.dart';

class Receita {
  final String nome;
  final String tempoDificuldade;
  final String avaliacao;

  const Receita(this.nome, this.tempoDificuldade, this.avaliacao);
}

const receitas = [
  Receita('Pizza de Margherita', '35 min • Fácil', '4,6 / 5'),
  Receita('Bolo de Cenoura', '50 min • Fácil', '4,8 / 5'),
  Receita('Frango Xadrez', '40 min • Médio', '4,5 / 5'),
  Receita('Feijoada Completa', '180 min • Difícil', '4,9 / 5'),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final busca = TextEditingController();
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

  @override
  void dispose() {
    busca.dispose();
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
          Text(
            termoBuscado == null
                ? 'Receitas disponíveis'
                : encontrou
                ? 'Resultados para “$termoBuscado”'
                : 'Nenhum resultado para “$termoBuscado”',
            style: textos.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            termoBuscado == null
                ? 'Selecione uma receita para ver o preparo.'
                : encontrou
                ? 'Toque na receita para ver o preparo.'
                : 'Não encontramos receitas para esse nome. Tente outro termo.',
          ),
          const SizedBox(height: 12),

          // Cards de exemplo
          for (final receita in encontradas)
            Card(
              clipBehavior: Clip.antiAlias,
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
                          Text(receita.tempoDificuldade),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 18,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 4),
                              Text(receita.avaliacao),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (termoBuscado != null) ...[
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
