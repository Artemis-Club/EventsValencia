import 'package:json_annotation/json_annotation.dart';
import '../enums/trafico_enum.dart';
import 'punto.dart';

@JsonSerializable()
class Tramo {
  final int? id;
  String nombre;
  Trafico estado;
  List<Punto> geometria;
  DateTime? fechaCreacion;
  DateTime? fechaActualizacion;

  Tramo({this.id, required this.nombre, required this.estado , required this.geometria,this.fechaCreacion, this.fechaActualizacion});

  
  
  factory Tramo.fromJson(Map<String, dynamic> json) {
    return _$TramoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$TramoToJson(this);

  @override
  String toString() {
    return "Tramo: $id, $nombre, $estado, $fechaCreacion, $fechaActualizacion";
  }
}

// Para que se parsee correctamente
double _$safeDouble(dynamic jsonAtribute) => double.parse(jsonAtribute.toString());

List<Punto>? _$puntosParser(dynamic geometria) {
  if (geometria is List) {
    return geometria.map((p) => Punto.fromJson(p)).toList();
  }
  return null;
}

Map<int, Trafico> _$mapeoTrafico = {
  0: Trafico.fluido,
  1: Trafico.denso,
  2: Trafico.congestionado,
  3: Trafico.cortado,
  4: Trafico.sinDatos,
  5: Trafico.pasoInferiorFluido,
  6: Trafico.pasoInferiorDenso,
  7: Trafico.pasoInferiorCongestionado,
  8: Trafico.pasoInferiorCortado
};

Tramo _$TramoFromJson(Map<String, dynamic> json) => Tramo(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      estado: _$mapeoTrafico[json['estado']] as Trafico,
      geometria: _$puntosParser(json['geometria'])!,
      fechaCreacion: DateTime.parse(json['fechaCreacion']),
      fechaActualizacion: DateTime.parse(json['fechaActualizacion']),
    );

Map<String, dynamic> _$TramoToJson(Tramo instance) => <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'estado': instance.estado,
      'geometria': instance.geometria.map((p) => p.toJson()),
      'fechaCreacion': instance.fechaCreacion,
      'fechaActualizacion': instance.fechaActualizacion
    };

