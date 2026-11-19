import 'package:flutter/material.dart';

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
    final cores = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: CircleAvatar(
            radius: 48,
            backgroundColor: cores.secondaryContainer,
            child: Icon(icone, size: 40, color: cores.onSecondaryContainer),
          ),
        ),
        const SizedBox(height: 24),
        Text(titulo, style: textos.headlineSmall),
        const SizedBox(height: 8),
        Text(mensagem),
        const SizedBox(height: 24),
        FilledButton(onPressed: onBotao, child: Text(textoBotao)),
        if (textoLink != null) ...[
          const SizedBox(height: 8),
          TextButton(onPressed: onLink, child: Text(textoLink!)),
        ],
      ],
    );
  }
}
