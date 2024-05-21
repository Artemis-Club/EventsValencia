import 'package:json_annotation/json_annotation.dart';

import 'punto.dart';

@JsonSerializable()
class Ruta {
  final int? id;
  Punto incio;
  Punto fin;
  String perfil;
  List<Punto> geometria;
  double distancia;
  double duracion;

  Ruta({this.id, required this.incio, required this.fin, required this.perfil, required this.geometria, required this.distancia, required this.duracion});

  factory Ruta.fromJson(Map<String, dynamic> json) {
    return _$RutaFromJson(json);
  }

  Map<String, dynamic> toJson() => _$RutaToJson(this);

  @override
  String toString() {
    return "Ruta: $id, $incio, $fin, $perfil, $distancia, $duracion";
  }
}

double _$safeDouble(dynamic jsonAtribute) => double.parse(jsonAtribute.toString());

List<Punto>? _$puntosParser(dynamic geometria) {
  if (geometria is List) {
    return geometria.map((p) => Punto.fromJson(p)).toList();
  }
  return null;
}

Ruta _$RutaFromJson(Map<String, dynamic> json) => Ruta(
  id: json['id'] as int,
  incio: Punto.fromJson(json['inicio']),
  fin: Punto.fromJson(json['fin']),
  perfil: json['perfil'] as String,
  geometria: _$puntosParser(json['geometria'])!,
  distancia: _$safeDouble(json['distancia']),
  duracion: _$safeDouble(json['duracion'])
);

Map<String, dynamic> _$RutaToJson(Ruta instance) => <String, dynamic>{
      'id': instance.id,
      'inicio': instance.incio.toJson(),
      'fin': instance.fin.toJson(),
      'perfil': instance.perfil,
      'geometria': instance.geometria.map((p) => p.toJson()).toList(),
      'distancia': instance.distancia,
      'duracion': instance.duracion
    };