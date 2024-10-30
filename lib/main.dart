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
    canvas.drawLine(Offset(size.width * .8, size.height * 0.6), Offset(size.width * 0.8, size.height * 0.9), roadPaint);

    // Yatay yollar
    canvas.drawLine(Offset(size.width * 0.5, size.height * 0.25), Offset(size.width * 0.9, size.height * 0.25), roadPaint);
    canvas.drawLine(Offset(size.width * .1, size.height * 0.20), Offset(size.width * 0.5, size.height * 0.20), roadPaint);
    canvas.drawLine(Offset(size.width * 0.1, size.height * 0.6), Offset(size.width * 0.9, size.height * 0.6), roadPaint);

    canvas.drawLine(Offset(size.width * 0.1, size.height * 0.75), Offset(size.width * 0.5, size.height * 0.75), roadPaint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class CustomRoadMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,
        title: Text('Let Me Go',),
      ),
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
