import 'package:flutter/material.dart';

class CampoBusca extends StatelessWidget {
  const CampoBusca({
    super.key,
    required this.controller,
    required this.mensagemErro,
    required this.onChanged,
    required this.onSubmitted,
    this.focusNode,
  });

  final TextEditingController controller;
  final String? mensagemErro;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Nome da receita',
          style: Theme.of(context).textTheme.labelLarge
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          focusNode: focusNode,
          textInputAction: TextInputAction.search,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: 'Buscar pelo nome',
            errorText: mensagemErro,
            errorMaxLines: 2,
            prefixIcon: const Icon(Icons.search),
          ),
          onChanged: onChanged,
          onSubmitted: onSubmitted,
        ),
      ],
    );
  }
}
