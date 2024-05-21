import 'package:json_annotation/json_annotation.dart';

//import 'usuario.dart';

@JsonSerializable()
class Notificacion {
  final int? id;
  String titulo;
  String descripcion;
  //Usuario usuario; 
  DateTime? fechaCreacion;
  DateTime? fechaActualizacion;

  Notificacion({this.id, required this.titulo, required this.descripcion, /*required this.usuario */this.fechaCreacion, this.fechaActualizacion});


  factory Notificacion.fromJson(Map<String, dynamic> json) {
    return _$NotificacionFromJson(json);
  }

  Map<String, dynamic> toJson() => _$NotificacionToJson(this);

  @override
  String toString() {
    return "Notificacion: $id, $titulo,$descripcion";
  }
}


Notificacion _$NotificacionFromJson(Map<String, dynamic> json) => Notificacion(
      id: json['id'] as int,
      titulo: json['titulo'] as String,
      descripcion: json['descripcion'] as String,
      //usuario: Usuario.fromJson(json['usuario']),
      fechaCreacion: DateTime.parse(json['fechaCreacion']),
      fechaActualizacion: DateTime.parse(json['fechaActualizacion']),
    );

Map<String, dynamic> _$NotificacionToJson(Notificacion instance) => <String, dynamic>{
  if (instance.id != null) 'id': instance.id,
      'titulo': instance.titulo,
      'descripcion': instance.descripcion,
      //'usuario': instance.usuario?.toJson(),
    };