import 'package:flutter/material.dart';
import 'dart:math';

import 'models/road.dart';



class CustomRoadMapPainter extends CustomPainter {
  final Matrix4 transform;
  final List<Road> roads;

  CustomRoadMapPainter(this.transform, this.roads);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.transform(transform.storage);

    final roadPaint = Paint()
      ..color = Colors.grey[700]!
      ..strokeWidth = 20
      ..style = PaintingStyle.stroke;

    final highlightedPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 20
      ..style = PaintingStyle.stroke;

    for (var road in roads) {
      if (road.isSelected) {
        canvas.drawLine(road.start, road.end, highlightedPaint);
      } else {
        canvas.drawLine(road.start, road.end, roadPaint);
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomRoadMapPainter oldDelegate) {
    return true;
  }
}

class CustomRoadMap extends StatefulWidget {
  @override
  _CustomRoadMapState createState() => _CustomRoadMapState();
}

class _CustomRoadMapState extends State<CustomRoadMap> {
  Matrix4 _transform = Matrix4.identity();
  double _scale = 1.0;
  Road? startRoad;
  Road? endRoad;
  final List<Road> _roads = [];

  @override
  void initState() {
    super.initState();
    _generateRoads();
  }

  void _generateRoads() {
    // Başlangıç yolları
    List<Road> originalRoads = [
      Road('1', Offset(0.2 * 400, 0.1 * 800), Offset(0.2 * 400, 0.9 * 800)),
      Road('2', Offset(0.5 * 400, 0.1 * 800), Offset(0.5 * 400, 0.9 * 800)),
      Road('3', Offset(0.8 * 400, 0.6 * 800), Offset(0.8 * 400, 0.9 * 800)),
      Road('4', Offset(0.5 * 400, 0.25 * 800), Offset(0.9 * 400, 0.25 * 800)),
      Road('5', Offset(0.1 * 400, 0.20 * 800), Offset(0.5 * 400, 0.20 * 800)),
      Road('6', Offset(0.1 * 400, 0.6 * 800), Offset(0.9 * 400, 0.6 * 800)),
      Road('7', Offset(0.1 * 400, 0.75 * 800), Offset(0.5 * 400, 0.75 * 800)),
    ];
    int lastRoadId = 7;
    // Kesişim kontrolü ve yolları ikiye bölme
    int segmentCounter = 1;
    for (var road in originalRoads) {
      bool isVertical = road.start.dx == road.end.dx;
      List<Road> splitRoads = [road];

      for (var other in originalRoads) {
        if (road == other) continue; // Aynı yol değilse kontrol et
        bool isOtherVertical = other.start.dx == other.end.dx;

        if (isVertical != isOtherVertical) {
          Offset? intersection = _findIntersection(road, other);

          if (intersection != null) {
            splitRoads = _splitRoadAtIntersection(splitRoads, intersection, segmentCounter);
            segmentCounter += splitRoads.length;
          }
        }
      }
      _roads.addAll(splitRoads); // Bölünmüş yolları ekle
    }
  }

  List<Road> _splitRoadAtIntersection(List<Road> roads, Offset intersection, int segmentCounter) {
    List<Road> splitRoads = [];
    for (var road in roads) {
      if (_isPointOnLine(intersection, road.start, road.end)) {
        // Böl yol
        splitRoads.add(Road('${road.id}.${segmentCounter++}', road.start, intersection));
        splitRoads.add(Road('${road.id}.${segmentCounter++}', intersection, road.end));
      } else {
        splitRoads.add(road); // Eğer kesişim yoksa orijinal yolu ekle
      }
    }
    return splitRoads;
  }

  Offset? _findIntersection(Road road1, Road road2) {
    double x1 = road1.start.dx;
    double y1 = road1.start.dy;
    double x2 = road1.end.dx;
    double y2 = road1.end.dy;

    double x3 = road2.start.dx;
    double y3 = road2.start.dy;
    double x4 = road2.end.dx;
    double y4 = road2.end.dy;

    double denominator = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);

    if (denominator == 0) {
      return null; // Paralel veya çakışık
    }

    double px = ((x1 * y2 - y1 * x2) * (x3 - x4) - (x1 - x2) * (x3 * y4 - y3 * x4)) / denominator;
    double py = ((x1 * y2 - y1 * x2) * (y3 - y4) - (y1 - y2) * (x3 * y4 - y3 * x4)) / denominator;

    Offset intersection = Offset(px, py);

    // Kesişimin yolda olup olmadığını kontrol et
    bool isOnRoad1 = _isPointOnLine(intersection, road1.start, road1.end);
    bool isOnRoad2 = _isPointOnLine(intersection, road2.start, road2.end);

    if (isOnRoad1 && isOnRoad2) {
      return intersection;
    }

    return null;
  }

  bool _isPointOnLine(Offset point, Offset start, Offset end) {
    double tolerance = 0.5;
    double distance = _pointToLineDistance(point, start, end);
    return distance < tolerance;
  }

  double _pointToLineDistance(Offset point, Offset start, Offset end) {
    double lengthSquared = (end.dx - start.dx) * (end.dx - start.dx) + (end.dy - start.dy) * (end.dy - start.dy);
    if (lengthSquared == 0) return (point - start).distance;
    double t = max(0, min(1, ((point.dx - start.dx) * (end.dx - start.dx) + (point.dy - start.dy) * (end.dy - start.dy)) / lengthSquared));
    Offset projection = Offset(start.dx + t * (end.dx - start.dx), start.dy + t * (end.dy - start.dy));
    return (point - projection).distance;
  }

  int selectedCount = 0;
  void _onTapDown(TapDownDetails details) {

    Offset localPosition = details.localPosition;
    Offset transformedPosition = _applyInverseTransform(localPosition);

    String? roadId = _findRoadId(transformedPosition);

    if (roadId != null) {
      setState(() {
        Road tappedRoad = _roads.firstWhere((road) => road.id == roadId);
        if(selectedCount<2 || (tappedRoad.id== startRoad?.id || tappedRoad.id== endRoad?.id)){

       if(tappedRoad.id== startRoad?.id){
         startRoad=null;
         selectedCount--;
       }

        if(tappedRoad.id== endRoad?.id){
          endRoad=null;
          selectedCount--;
        }

        tappedRoad.isSelected = !tappedRoad.isSelected;
        if(tappedRoad.isSelected){
          if(startRoad==null){
            startRoad = tappedRoad;
            selectedCount++;
          }else{
            endRoad = tappedRoad;
            selectedCount++;
          }
        }

        }
      });

      print('Tıkladığınız yolun ID\'si: $roadId');
    } else {
      print('Tıklanan yol bulunamadı');
    }
    print("start: "+startRoad.toString());
    print("end: "+endRoad.toString());
  }

  Offset _applyInverseTransform(Offset point) {
    double invertedScaleX = 1 / _scale;
    double invertedScaleY = 1 / _scale;

    return Offset(
      (point.dx) * invertedScaleX,
      (point.dy) * invertedScaleY,
    );
  }

  String? _findRoadId(Offset point) {
    for (var road in _roads) {
      if (_isPointNearLine(point, road.start, road.end)) {
        return road.id;
      }
    }
    return null;
  }

  bool _isPointNearLine(Offset point, Offset start, Offset end) {
    double tolerance = 20.0;
    double distance = _pointToLineDistance(point, start, end);
    return distance < tolerance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Let Me Go')),
      body: GestureDetector(
        onTapDown: _onTapDown,
        child: Center(
          child: CustomPaint(
            size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
            painter: CustomRoadMapPainter(_transform, _roads),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false,
    home: CustomRoadMap(),
  ));
}
