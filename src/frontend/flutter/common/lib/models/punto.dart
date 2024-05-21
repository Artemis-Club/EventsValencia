import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Punto {
  double latitud, longitud;
  String? direccion;

  Punto({required this.latitud, required this.longitud, this.direccion});

  factory Punto.fromJson(Map<String, dynamic> json) {
    return _$PuntoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$PuntoToJson(this);

  @override
  String toString() {
    return "Punto: $latitud, $longitud";
  }
}

double _$safeDouble(dynamic jsonAtribute) => double.parse(jsonAtribute.toString());

Punto _$PuntoFromJson(Map<String, dynamic> json) => Punto(
  latitud: _$safeDouble(json['latitud']),
  longitud: _$safeDouble(json['longitud']),
  direccion: json['direccion'],
  );

Map<String, dynamic> _$PuntoToJson(Punto instance) => <String, dynamic>{
      'latitud': instance.latitud,
      'longitud': instance.longitud,
      'direccion': instance.direccion,
    };