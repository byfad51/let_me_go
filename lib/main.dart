import 'package:flutter/material.dart';

class CustomRoadMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.grey[700]!
      ..strokeWidth = 20
      ..style = PaintingStyle.stroke;
    final circlePaint = Paint()
      ..color = Colors.blueAccent[100]!
      ..style = PaintingStyle.fill;

    // Yolları çizme (Tam ekran yayılacak şekilde ayarlandı)
    // Sol dikey yol
    canvas.drawLine(Offset(size.width * 0.2, size.height * 0.1), Offset(size.width * 0.2, size.height * 0.9), roadPaint);

    // Orta dikey yol
    canvas.drawLine(Offset(size.width * 0.5, size.height * 0.1), Offset(size.width * 0.5, size.height * 0.9), roadPaint);

    // Sağ dikey yol
    canvas.drawLine(Offset(size.width * 0.8, size.height * 0.1), Offset(size.width * 0.8, size.height * 0.9), roadPaint);

    // Yatay yollar
    canvas.drawLine(Offset(size.width * 0.1, size.height * 0.25), Offset(size.width * 0.9, size.height * 0.25), roadPaint);
    canvas.drawLine(Offset(size.width * 0.1, size.height * 0.5), Offset(size.width * 0.9, size.height * 0.5), roadPaint);
    canvas.drawLine(Offset(size.width * 0.1, size.height * 0.75), Offset(size.width * 0.9, size.height * 0.75), roadPaint);

    // Yol üzerindeki yuvarlak düğümler
  /*  List<Offset> circles = [
      Offset(size.width * 0.2, size.height * 0.1),
      Offset(size.width * 0.2, size.height * 0.25),
      Offset(size.width * 0.2, size.height * 0.5),
      Offset(size.width * 0.2, size.height * 0.75),
      Offset(size.width * 0.1, size.height * 0.25),
      Offset(size.width * 0.1, size.height * 0.75),
      Offset(size.width * 0.5, size.height * 0.1),
      Offset(size.width * 0.5, size.height * 0.25),
      Offset(size.width * 0.8, size.height * 0.25),
      Offset(size.width * 0.5, size.height * 0.5),
      Offset(size.width * 0.5, size.height * 0.75),
      Offset(size.width * 0.8, size.height * 0.5),
      Offset(size.width * 0.8, size.height * 0.75),
    ];

    for (var circle in circles) {
      canvas.drawCircle(circle, 25, circlePaint);
    }*/
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class CustomRoadMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomPaint(
          size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
          painter: CustomRoadMapPainter(),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CustomRoadMap(),
  ));
}
