import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/receita.dart';

class FalhaApi implements Exception {
  const FalhaApi(this.mensagem);

  final String mensagem;

  @override
  String toString() => mensagem;
}

class ReceitasApi {
  ReceitasApi({http.Client? cliente}) : _cliente = cliente ?? http.Client();

  final http.Client _cliente;

  static const tamanhoPagina = 10;

  Future<({List<Receita> receitas, int total})> buscarPagina({
    required int pular,
  }) async {
    final corpo = await _get(
      Uri.https('dummyjson.com', '/recipes', {
        'limit': '$tamanhoPagina',
        'skip': '$pular',
      }),
    );
    final receitas = _lerReceitas(corpo);
    final total = corpo is Map<String, dynamic> ? corpo['total'] : null;

    return (
      receitas: receitas,
      total: total is int && receitas.isNotEmpty
          ? total
          : pular + receitas.length,
    );
  }

  Future<List<Receita>> pesquisar(String termo) async {
    final palavras = termo
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    final maiorPalavra = palavras.reduce((a, b) => b.length > a.length ? b : a);

    final encontradas = _lerReceitas(
      await _get(
        Uri.https('dummyjson.com', '/recipes/search', {'q': maiorPalavra}),
      ),
    );
    return encontradas
        .where((r) => palavras.every(r.nome.toLowerCase().contains))
        .toList();
  }

  void fechar() => _cliente.close();

  List<Receita> _lerReceitas(Object? corpo) {
    final itens = corpo is Map<String, dynamic> ? corpo['recipes'] : null;
    if (itens is! List) {
      throw const FalhaApi(
        'A resposta do servidor veio em um formato inesperado. '
        'Tente novamente.',
      );
    }

    final receitas = <Receita>[];
    for (final item in itens) {
      if (item is! Map<String, dynamic>) continue;
      try {
        receitas.add(Receita.fromJson(item));
      } on FormatException {
        continue;
      }
    }
    return receitas;
  }

  Future<Object?> _get(Uri endereco) async {
    final http.Response resposta;
    try {
      resposta = await _cliente
          .get(endereco)
          .timeout(const Duration(seconds: 10));
    } on TimeoutException {
      throw const FalhaApi(
        'O servidor demorou demais para responder. Tente novamente.',
      );
    } on http.ClientException {
      throw const FalhaApi('Verifique sua conexão e tente novamente.');
    }

    if (resposta.statusCode != 200) {
      throw FalhaApi(
        'O servidor respondeu com erro (${resposta.statusCode}). '
        'Tente novamente em instantes.',
      );
    }

    try {
      return jsonDecode(utf8.decode(resposta.bodyBytes));
    } on FormatException {
      throw const FalhaApi(
        'A resposta do servidor veio em um formato inesperado. '
        'Tente novamente.',
      );
    }
  }
}
