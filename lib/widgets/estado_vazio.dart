import 'package:flutter/material.dart';

import '../tema.dart';

class EstadoVazio extends StatelessWidget {
  const EstadoVazio({
    super.key,
    required this.icone,
    required this.titulo,
    required this.mensagem,
    required this.textoBotao,
    required this.onBotao,
    this.textoLink,
    this.onLink,
  });

  final IconData icone;
  final String titulo;
  final String mensagem;
  final String textoBotao;
  final VoidCallback onBotao;
  final String? textoLink;
  final VoidCallback? onLink;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            width: 108,
            height: 108,
            decoration: const BoxDecoration(
              color: Cores.menta,
              shape: BoxShape.circle,
            ),
            child: Icon(icone, size: 44, color: Cores.verde),
          ),
        ),
        const SizedBox(height: 32),
        Text(titulo, style: textos.headlineSmall),
        const SizedBox(height: 12),
        Text(mensagem, style: textos.bodyLarge?.copyWith(color: Cores.texto)),
        const SizedBox(height: 32),
        FilledButton(onPressed: onBotao, child: Text(textoBotao)),
        if (textoLink != null) ...[
          const SizedBox(height: 8),
          TextButton(onPressed: onLink, child: Text(textoLink!)),
        ],
      ],
    );
  }
}
