import 'dart:math';

import 'package:flutter/material.dart';

import '../models/receita.dart';
import '../tema.dart';

class Prato extends StatelessWidget {
  const Prato({
    super.key,
    required this.tamanho,
    this.comida = Cores.acafrao,
    this.cobertura = Cores.terracota,
  });

  final double tamanho;
  final Color comida;
  final Color cobertura;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(tamanho),
      painter: _PratoPainter(comida: comida, cobertura: cobertura),
    );
  }
}

class _PratoPainter extends CustomPainter {
  _PratoPainter({required this.comida, required this.cobertura});

  final Color comida;
  final Color cobertura;

  @override
  void paint(Canvas canvas, Size size) {
    final r = size.shortestSide / 2;
    final centro = size.center(Offset.zero);

    canvas.drawCircle(
      centro + Offset(r * 0.04, r * 0.08),
      r * 0.94,
      Paint()..color = Colors.black.withValues(alpha: 0.08),
    );
    canvas.drawCircle(centro, r * 0.94, Paint()..color = Colors.white);
    canvas.drawCircle(
      centro,
      r * 0.78,
      Paint()
        ..color = Cores.borda
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.03,
    );
    canvas.drawCircle(centro, r * 0.62, Paint()..color = comida);

    final pedaco = Paint()..color = cobertura;
    for (final angulo in [25, 145, 265]) {
      final a = angulo * pi / 180;
      canvas.drawCircle(
        centro + Offset(cos(a), sin(a)) * r * 0.34,
        r * 0.11,
        pedaco,
      );
    }

    final base = centro + Offset(-r * 0.04, r * 0.06);
    final ponta = base + Offset(r * 0.30, -r * 0.30);
    final folha = Path()
      ..moveTo(base.dx, base.dy)
      ..quadraticBezierTo(base.dx + r * 0.02, ponta.dy, ponta.dx, ponta.dy)
      ..quadraticBezierTo(ponta.dx, base.dy - r * 0.02, base.dx, base.dy);
    canvas.drawPath(folha, Paint()..color = Cores.verde);
  }

  @override
  bool shouldRepaint(_PratoPainter antigo) =>
      antigo.comida != comida || antigo.cobertura != cobertura;
}

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Prato(tamanho: 30),
        const SizedBox(width: 10),
        Text(
          'Prato Cheio',
          style: Theme.of(context).textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.3),
        ),
      ],
    );
  }
}

class FotoReceita extends StatelessWidget {
  const FotoReceita({
    super.key,
    required this.receita,
    this.altura,
    this.largura,
    this.raio = 12,
    this.escala = 0.74,
  });

  final Receita receita;
  final double? altura;
  final double? largura;
  final double raio;
  final double escala;

  static const _sabores = [
    (Cores.acafrao, Cores.terracota),
    (Color(0xFFE39A5B), Color(0xFF8A4B2A)),
    (Color(0xFFD7B36A), Cores.verde),
    (Color(0xFF4B3B34), Color(0xFFB86B4B)),
  ];

  @override
  Widget build(BuildContext context) {
    final (comida, cobertura) = _sabores[(receita.id - 1) % _sabores.length];
    final densidade = MediaQuery.devicePixelRatioOf(context);

    return Container(
      width: largura,
      height: altura,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Cores.bege,
        borderRadius: BorderRadius.circular(raio),
      ),
      child: LayoutBuilder(
        builder: (context, limites) => Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: Prato(
                tamanho: min(limites.maxWidth, limites.maxHeight) * escala,
                comida: comida,
                cobertura: cobertura,
              ),
            ),
            if (receita.imagem != null)
              Image.network(
                receita.imagem!,
                fit: BoxFit.cover,
                cacheWidth: (limites.maxWidth * densidade).round(),
                frameBuilder: (context, imagem, quadro, sincrono) => sincrono
                    ? imagem
                    : AnimatedOpacity(
                        opacity: quadro == null ? 0 : 1,
                        duration: const Duration(milliseconds: 250),
                        child: imagem,
                      ),
                errorBuilder: (context, erro, pilha) => const SizedBox.shrink(),
              ),
          ],
        ),
      ),
    );
  }
}
