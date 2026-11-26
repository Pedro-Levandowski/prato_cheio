String? validarTermo(String valor) {
  if (valor.isEmpty) {
    return 'Digite um nome para pesquisar.';
  }
  if (valor.trim().isEmpty) {
    return 'Só espaços não valem. Digite um nome para pesquisar.';
  }
  return null;
}
