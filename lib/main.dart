import 'package:flutter/material.dart';
import 'dart:math';

class Road {
  final String id; // Yol için kimlik
  final Offset start; // Başlangıç noktası
  final Offset end; // Bitiş noktası

  Road(this.id, this.start, this.end);
}

class CustomRoadMapPainter extends CustomPainter {
  final Matrix4 transform;
  final List<Road> roads; // Yolların listesi
  final String? highlightedRoadId; // Yeşil yapılacak yolun ID'si

  CustomRoadMapPainter(this.transform, this.roads, this.highlightedRoadId);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.transform(transform.storage); // Transformu uygula

    // Normal yol boyası
    final roadPaint = Paint()
      ..color = Colors.grey[700]!
      ..strokeWidth = 20
      ..style = PaintingStyle.stroke;

    // Seçilen yol boyası (yeşil)
    final highlightedPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 20
      ..style = PaintingStyle.stroke;

    // Yolları çizme
    for (var road in roads) {
      if (road.id == highlightedRoadId) {
        canvas.drawLine(road.start, road.end, highlightedPaint); // Seçili olan yolu yeşil çiz
      } else {
        canvas.drawLine(road.start, road.end, roadPaint); // Diğer yolları gri çiz
      }
    }

    canvas.restore(); // Transformu sıfırla
  }

  @override
  bool shouldRepaint(covariant CustomRoadMapPainter oldDelegate) {
    return oldDelegate.highlightedRoadId != highlightedRoadId;
  }
}

class CustomRoadMap extends StatefulWidget {
  @override
  _CustomRoadMapState createState() => _CustomRoadMapState();
}

class _CustomRoadMapState extends State<CustomRoadMap> {
  Matrix4 _transform = Matrix4.identity();
  double _scale = 1.0;
  Offset _offset = Offset.zero;
  String? _highlightedRoadId; // Son tıklanan yolun ID'si

  final List<Road> _roads = []; // Yolları saklamak için liste

  @override
  void initState() {
    super.initState();
    // Rastgele ID ile yollar oluştur
    _generateRoads();
  }

  void _generateRoads() {
    // Yolları tanımla
    _roads.add(Road('road_1', Offset(0.2 * 400, 0.1 * 800), Offset(0.2 * 400, 0.9 * 800)));
    _roads.add(Road('road_2', Offset(0.5 * 400, 0.1 * 800), Offset(0.5 * 400, 0.9 * 800)));
    _roads.add(Road('road_3', Offset(0.8 * 400, 0.6 * 800), Offset(0.8 * 400, 0.9 * 800)));
    _roads.add(Road('road_4', Offset(0.5 * 400, 0.25 * 800), Offset(0.9 * 400, 0.25 * 800)));
    _roads.add(Road('road_5', Offset(0.1 * 400, 0.20 * 800), Offset(0.5 * 400, 0.20 * 800)));
    _roads.add(Road('road_6', Offset(0.1 * 400, 0.6 * 800), Offset(0.9 * 400, 0.6 * 800)));
    _roads.add(Road('road_7', Offset(0.1 * 400, 0.75 * 800), Offset(0.5 * 400, 0.75 * 800)));
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      // Ölçek güncelleme
      _scale *= details.scale;
      // Transform matrisini güncelle
      _transform = Matrix4.identity()
        ..scale(_scale);
    });
  }

  void _onTapDown(TapDownDetails details) {
    // Kullanıcının tıkladığı noktayı al
    Offset localPosition = details.localPosition;
    // Dönüşümü tersine çevir
    Offset transformedPosition = _applyInverseTransform(localPosition);

    // Tıklanan konumu kontrol et
    String? roadId = _findRoadId(transformedPosition);
    if (roadId != null) {
      setState(() {
        _highlightedRoadId = roadId; // Son tıklanan yolun ID'sini sakla
      });
      print('Tıkladığınız yolun ID\'si: $roadId'); // Konsola ID'yi yaz
    } else {
      print('Tıklanan yol bulunamadı');
    }
  }

  Offset _applyInverseTransform(Offset point) {
    // Ters dönüşümü manuel olarak uygula
    double invertedScaleX = 1 / _scale;
    double invertedScaleY = 1 / _scale;

    return Offset(
      (point.dx) * invertedScaleX,
      (point.dy) * invertedScaleY,
    );
  }

  String? _findRoadId(Offset point) {
    // Her yol için kontrol et
    for (var road in _roads) {
      if (_isPointNearLine(point, road.start, road.end)) {
        return road.id; // Yolun ID'sini döndür
      }
    }
    return null; // Yol bulunamazsa null döndür
  }

  bool _isPointNearLine(Offset point, Offset start, Offset end) {
    double tolerance = 20.0; // Tolerans alanı
    double distance = _pointToLineDistance(point, start, end);
    return distance < tolerance;
  }

  double _pointToLineDistance(Offset point, Offset start, Offset end) {
    double lengthSquared = (end.dx - start.dx) * (end.dx - start.dx) + (end.dy - start.dy) * (end.dy - start.dy);
    if (lengthSquared == 0) return (point - start).distance; // Eğer başlangıç ve bitiş noktası aynı ise
    double t = max(0, min(1, ((point.dx - start.dx) * (end.dx - start.dx) + (point.dy - start.dy) * (end.dy - start.dy)) / lengthSquared));
    Offset projection = Offset(start.dx + t * (end.dx - start.dx), start.dy + t * (end.dy - start.dy));
    return (point - projection).distance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Let Me Go')),
      body: GestureDetector(
        onScaleUpdate: _onScaleUpdate, // Yalnızca ölçek güncelleme
        onTapDown: _onTapDown, // Tıklama olayını yakala
        child: Center(
          child: CustomPaint(
            size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
            painter: CustomRoadMapPainter(_transform, _roads, _highlightedRoadId), // Yolları gönder
          ),
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
