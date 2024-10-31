import 'dart:ui';

class Road {
  final String id; // Yolun kimliği
  final Offset start; // Başlangıç noktası
  final Offset end; // Bitiş noktası
  bool isSelected; // Yolun seçili olup olmadığını tutan özellik

  Road(this.id, this.start, this.end, {this.isSelected = false});
}