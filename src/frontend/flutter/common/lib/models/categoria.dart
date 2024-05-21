import 'package:json_annotation/json_annotation.dart';
import 'evento.dart';

@JsonSerializable()
class Categoria {
  final String nombre;
  DateTime? fechaCreacion;

  Categoria({required this.nombre, this.fechaCreacion});
  
  factory Categoria.fromJson(Map<String, dynamic> json) {
    return _$CategoriaFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CategoriaToJson(this);

  @override
  String toString() {
    return "Categoria: $nombre, $fechaCreacion";
  }
}

List<Evento>? _$eventosParser(dynamic eventos) {
  if (eventos != null && eventos is List) {
    return eventos.map((p) => Evento.fromJson(p)).toList();
  }
  return null;
}

// Para que se parsee correctamente
double _$safeDouble(dynamic jsonAtribute) => double.parse(jsonAtribute.toString());

Categoria _$CategoriaFromJson(Map<String, dynamic> json) => Categoria(
      nombre: json['nombre'] as String,
      fechaCreacion: DateTime.parse(json['fechaCreacion']),
    );

Map<String, dynamic> _$CategoriaToJson(Categoria instance) => <String, dynamic>{
      'nombre': instance.nombre,
      'fechaCreacion': instance.fechaCreacion,
    };

