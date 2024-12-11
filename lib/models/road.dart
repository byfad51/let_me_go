import 'dart:ui';

class Road {
  final String id; // Yolun kimliği
  final Offset start; // Başlangıç noktası
  final Offset end; // Bitiş noktası
  bool isSelected; // Yolun seçili olup olmadığını tutan özellik
  List<String> goWhere; // Bu yoldan gidilebilecek yol ID'leri
  List<String> fromWhere; // Bu yola gelebilecek yol ID'leri

  Road(this.id, this.start, this.end,
      {this.isSelected = false, this.goWhere = const [], this.fromWhere = const []});
}
