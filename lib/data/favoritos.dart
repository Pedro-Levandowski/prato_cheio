import 'package:flutter/foundation.dart';

import '../models/receita.dart';

class Favoritos extends ChangeNotifier {
  final List<Receita> _receitas = [];

  List<Receita> get receitas => List.unmodifiable(_receitas);

  bool contem(Receita receita) => _receitas.any((r) => r.id == receita.id);

  void alternar(Receita receita) {
    if (contem(receita)) {
      _receitas.removeWhere((r) => r.id == receita.id);
    } else {
      _receitas.add(receita);
    }
    notifyListeners();
  }
}
