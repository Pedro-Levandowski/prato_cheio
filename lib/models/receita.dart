class Receita {
  const Receita({
    required this.id,
    required this.nome,
    this.culinaria,
    this.dificuldade,
    this.tempoMinutos,
    this.porcoes,
    this.avaliacao,
    this.ingredientes = const [],
    this.instrucoes = const [],
  });

  final int id;
  final String nome;
  final String? culinaria;
  final String? dificuldade;
  final int? tempoMinutos;
  final int? porcoes;
  final double? avaliacao;
  final List<String> ingredientes;
  final List<String> instrucoes;

  String get tempoEDificuldade =>
      [if (tempoMinutos != null) '$tempoMinutos min', ?dificuldade].join(' • ');

  String get avaliacaoTexto => avaliacao == null
      ? 'Sem avaliação'
      : '${avaliacao!.toStringAsFixed(1).replaceAll('.', ',')} / 5';
}
