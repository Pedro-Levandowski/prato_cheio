# Prato Cheio

Aplicativo de receitas feito em Flutter para o projeto final da disciplina. Dá para ver as receitas, pesquisar pelo nome, abrir o modo de preparo e salvar as favoritas. Os dados vêm da API pública [DummyJSON Recipes](https://dummyjson.com/docs/recipes), por isso os nomes e ingredientes aparecem em inglês.

## Funcionalidades

- Tela principal com as receitas carregadas da API, 10 de cada vez, com o botão "Carregar mais receitas".
- Receita em destaque (a mais bem avaliada da primeira página) e filtro por culinária.
- Pesquisa por nome usando o endpoint de busca da API. Pesquisa vazia ou só com espaços não é aceita.
- Tela de detalhes com foto, tempo, porções, avaliação, ingredientes e modo de preparo. Os ingredientes podem ser marcados enquanto você cozinha.
- Favoritos durante o uso do app, sem repetir receita. Para remover, é só tocar no coração ou deslizar o card.
- Telas próprias para carregando, erro de conexão (com "Tentar novamente"), pesquisa sem resultado e favoritos vazios.
- Quando a foto não vem ou não carrega, aparece um desenho de prato no lugar.

## Dependências

- [`http`](https://pub.dev/packages/http) `^1.6.0`: requisições à API.
- `cupertino_icons`: já vem no projeto criado pelo Flutter.

## SDK usado

- Flutter 3.47.8 (canal stable)
- Dart 3.13.7

## Como executar

1. Ter o Flutter instalado (`flutter doctor` sem erros).
2. Clonar o repositório:
   ```
   git clone https://github.com/Pedro-Levandowski/prato_cheio.git
   cd prato_cheio
   ```
3. Baixar as dependências:
   ```
   flutter pub get
   ```
4. Rodar em um emulador, celular ou no Chrome:
   ```
   flutter run
   ```

O app precisa de internet para buscar as receitas.

## Observações sobre a API

- **Listagem:** usa `GET /recipes?limit=10&skip=N`. O `skip` aumenta a cada toque em "Carregar mais receitas".
- **Pesquisa:** usa `GET /recipes/search?q=`. A API só encontra o texto na ordem exata ("margherita pizza" encontra, "pizza margherita" não). Por isso o app busca pela maior palavra digitada e depois mantém só as receitas que têm todas as palavras no nome.
- **Detalhes:** não fazem uma nova requisição para `/recipes/{id}`. A resposta da listagem e da pesquisa já traz a receita completa (ingredientes, instruções, tempos etc.), então o mesmo objeto é reaproveitado.
- **Validação:** toda resposta tem o status conferido e o JSON validado antes de atualizar a tela. Itens sem `id` são ignorados. Campos ausentes são tratados sem quebrar o app:
  - o tempo só é somado quando existem o de preparo e o de cozimento;
  - as porções só aparecem quando são maiores que zero;
  - a avaliação é lida como número, inteiro ou decimal;
  - o `mealType` é tratado como lista.
- **Favoritos:** ficam na memória enquanto o app está aberto. Existe uma única lista (`Favoritos`), compartilhada entre as telas.

## Organização do código

```
lib/
  data/      acesso à API, favoritos e validação da busca
  models/    classe Receita e leitura do JSON
  pages/     telas (principal, pesquisa, detalhes, favoritos)
  widgets/   componentes reaproveitados (cards, campo de busca, etc.)
  tema.dart  cores e estilos do app
```
