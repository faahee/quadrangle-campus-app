import 'package:flutter/material.dart';

/// Faded illustration of a classic domed university building, drawn with a
/// [CustomPainter] so it stays crisp at any size and needs no image asset.
class CampusBuilding extends StatelessWidget {
  const CampusBuilding({
    super.key,
    this.width = 320,
    this.color = Colors.white,
    this.opacity = 0.07,
  });

  final double width;
  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: width * 0.62,
      child: CustomPaint(
        painter: _BuildingPainter(color.withValues(alpha: opacity)),
      ),
    );
  }
}

class _BuildingPainter extends CustomPainter {
  _BuildingPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final fill = Paint()..color = color;
    final hole = Paint()..blendMode = BlendMode.clear;

    canvas.saveLayer(Offset.zero & size, Paint());

    // Steps
    for (var i = 0; i < 3; i++) {
      final inset = i * w * 0.025;
      canvas.drawRect(
        Rect.fromLTWH(inset, h - (i + 1) * h * 0.035, w - inset * 2, h * 0.035),
        fill,
      );
    }
    final baseTop = h - 3 * h * 0.035;

    // Main hall + wings
    final hall = Rect.fromLTRB(w * 0.08, h * 0.48, w * 0.92, baseTop);
    canvas.drawRect(hall, fill);

    // Columns: cut gaps between them so they read as a colonnade
    const columns = 8;
    final colTop = h * 0.52;
    final colBottom = baseTop - h * 0.02;
    final span = (w * 0.68) / (columns - 1);
    for (var i = 0; i < columns - 1; i++) {
      final x = w * 0.16 + i * span + span * 0.28;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTRB(x, colTop, x + span * 0.44, colBottom),
          const Radius.circular(2),
        ),
        hole,
      );
    }

    // Entablature + pediment
    canvas.drawRect(
      Rect.fromLTRB(w * 0.06, h * 0.43, w * 0.94, h * 0.49),
      fill,
    );
    final pediment = Path()
      ..moveTo(w * 0.22, h * 0.43)
      ..lineTo(w * 0.5, h * 0.31)
      ..lineTo(w * 0.78, h * 0.43)
      ..close();
    canvas.drawPath(pediment, fill);

    // Drum + dome + lantern
    canvas.drawRect(Rect.fromLTRB(w * 0.36, h * 0.2, w * 0.64, h * 0.33), fill);
    canvas.drawArc(
      Rect.fromLTRB(w * 0.34, h * 0.0, w * 0.66, h * 0.4),
      3.1416,
      3.1416,
      true,
      fill,
    );
    canvas.drawRect(
      Rect.fromLTRB(w * 0.485, h * -0.04, w * 0.515, h * 0.02),
      fill,
    );

    // Drum windows
    for (var i = 0; i < 4; i++) {
      final x = w * 0.39 + i * w * 0.062;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, h * 0.235, w * 0.03, h * 0.07),
          const Radius.circular(6),
        ),
        hole,
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_BuildingPainter old) => old.color != color;
}
