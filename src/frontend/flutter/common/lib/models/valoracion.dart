import 'package:json_annotation/json_annotation.dart';
import 'evento.dart';
import 'usuario.dart';


@JsonSerializable()
class Valoracion {
  final int? id;
  double estrellas;
  String? comentario;
  Evento evento;
  Usuario usuario;
  DateTime? fechaCreacion;
  DateTime? fechaActualizacion;

  Valoracion({this.id, required this.estrellas,  this.comentario, required this.evento, required this.usuario, this.fechaCreacion, this.fechaActualizacion});


  factory Valoracion.fromJson(Map<String, dynamic> json) {
    return _$ValoracionFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ValoracionToJson(this);

  @override
  String toString() {
    return "Valoracion: $id, $estrellas,$comentario, $evento}";
  }
}

// Para que se parsee correctamente
double _$safeDouble(dynamic jsonAtribute) => double.parse(jsonAtribute.toString());

Valoracion _$ValoracionFromJson(Map<String, dynamic> json) => Valoracion(
      id: json['id'] as int,
      estrellas: _$safeDouble(json['estrellas']),
      comentario: json['comentario'] as String?,
      evento: json['evento'] as Evento,
      usuario: json['usuario'] as Usuario,
      fechaCreacion: DateTime.parse(json['fechaCreacion']),
      fechaActualizacion: DateTime.parse(json['fechaActualizacion']),
    );

Map<String, dynamic> _$ValoracionToJson(Valoracion instance) => <String, dynamic>{
      'id': instance.id,
      'estrellas': instance.estrellas,
      'comentario': instance.comentario,
      'evento': instance.evento.toJson(),
      'usuario': instance.usuario.toJson(),
      'fechaCreacion': instance.fechaCreacion,
      'fechaActualizacion': instance.fechaActualizacion
    };

