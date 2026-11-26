class Receita {
  const Receita({
    required this.id,
    required this.nome,
    this.imagem,
    this.culinaria,
    this.dificuldade,
    this.tempoPreparo,
    this.tempoCozimento,
    this.porcoes,
    this.avaliacao,
    this.tiposRefeicao = const [],
    this.ingredientes = const [],
    this.instrucoes = const [],
  });

  factory Receita.fromJson(Map<String, dynamic> json) {
    final id = _inteiro(json['id']);
    if (id == null) throw const FormatException('Receita sem id.');

    final porcoes = _inteiro(json['servings']);

    return Receita(
      id: id,
      nome: _texto(json['name']) ?? 'Receita sem nome',
      imagem: _texto(json['image']),
      culinaria: _texto(json['cuisine']),
      dificuldade: _texto(json['difficulty']),
      tempoPreparo: _inteiro(json['prepTimeMinutes']),
      tempoCozimento: _inteiro(json['cookTimeMinutes']),
      porcoes: porcoes != null && porcoes > 0 ? porcoes : null,
      avaliacao: _numero(json['rating']),
      tiposRefeicao: _lista(json['mealType']),
      ingredientes: _lista(json['ingredients']),
      instrucoes: _lista(json['instructions']),
    );
  }

  final int id;
  final String nome;
  final String? imagem;
  final String? culinaria;
  final String? dificuldade;
  final int? tempoPreparo;
  final int? tempoCozimento;
  final int? porcoes;
  final double? avaliacao;
  final List<String> tiposRefeicao;
  final List<String> ingredientes;
  final List<String> instrucoes;

  ({int minutos, String rotulo})? get tempo {
    if (tempoPreparo != null && tempoCozimento != null) {
      return (minutos: tempoPreparo! + tempoCozimento!, rotulo: 'tempo total');
    }
    if (tempoPreparo != null) {
      return (minutos: tempoPreparo!, rotulo: 'só de preparo');
    }
    if (tempoCozimento != null) {
      return (minutos: tempoCozimento!, rotulo: 'só de cozimento');
    }
    return null;
  }

  String get avaliacaoTexto => avaliacao == null
      ? 'Sem avaliação'
      : '${avaliacao!.toStringAsFixed(1).replaceAll('.', ',')} / 5';
}

int? _inteiro(Object? valor) {
  final numero = switch (valor) {
    num n => n,
    String s => num.tryParse(s.trim()),
    _ => null,
  };
  if (numero == null || numero < 0) return null;
  return numero.round();
}

double? _numero(Object? valor) => switch (valor) {
  num n => n.toDouble(),
  String s => double.tryParse(s.trim()),
  _ => null,
};

String? _texto(Object? valor) {
  if (valor is! String) return null;
  final texto = valor.replaceAll('Â°', '°').trim();
  return texto.isEmpty ? null : texto;
}

List<String> _lista(Object? valor) => switch (valor) {
  List itens => itens.map(_texto).whereType<String>().toList(),
  String texto => [?_texto(texto)],
  _ => const [],
};
