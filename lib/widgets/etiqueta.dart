import 'package:flutter/material.dart';

import '../tema.dart';

class Etiqueta extends StatelessWidget {
  const Etiqueta({
    super.key,
    required this.texto,
    this.icone,
    this.fundo = Cores.menta,
    this.cor = Cores.verde,
  });

  factory Etiqueta.dificuldade(String nivel) {
    final (fundo, cor) = switch (nivel.toLowerCase()) {
      'fácil' || 'easy' => (Cores.menta, Cores.verde),
      'médio' || 'medium' => (const Color(0xFFFBEFD9), const Color(0xFF8A5A12)),
      _ => (const Color(0xFFF6E3DA), const Color(0xFF9C4325)),
    };
    return Etiqueta(texto: nivel, fundo: fundo, cor: cor);
  }

  final String texto;
  final IconData? icone;
  final Color fundo;
  final Color cor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: fundo,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icone != null) ...[
            Icon(icone, size: 14, color: cor),
            const SizedBox(width: 4),
          ],
          Text(
            texto,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: cor,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
