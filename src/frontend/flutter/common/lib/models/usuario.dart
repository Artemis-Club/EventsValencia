import 'package:json_annotation/json_annotation.dart';
import 'valoracion.dart';

@JsonSerializable()
class Usuario {
  final int? id;
  String nick;
  String nombre;
  String correo;
  String contrasenya;
  List<Valoracion>? valorados;
  DateTime? fechaCreacion;
  DateTime? fechaActualizacion;

  Usuario({this.id, required this.nick, required this.nombre, required this.correo, required this.contrasenya, this.valorados ,this.fechaCreacion, this.fechaActualizacion});


  factory Usuario.fromJson(Map<String, dynamic> json) {
    return _$UsuarioFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UsuarioToJson(this);

  @override
  String toString() {
    return "Usuario: $id, $nick,$nombre, $correo";
  }
}


Usuario _$UsuarioFromJson(Map<String, dynamic> json) => Usuario(
      id: json['id'] as int,
      nick: json['nick'] as String,
      nombre: json['nombre'] as String,
      correo: json['correo'] as String,
      contrasenya: json['contrasenya'] as String,
      valorados: json['valorados'] as List<Valoracion>?,
      fechaCreacion: DateTime.parse(json['fechaCreacion']),
      fechaActualizacion: DateTime.parse(json['fechaActualizacion']),
    );

Map<String, dynamic> _$UsuarioToJson(Usuario instance) => <String, dynamic>{
      'id': instance.id.toString(),
      'nick': instance.nick,
      'nombre': instance.nombre,
      'correo': instance.correo,
      'contrasenya': instance.contrasenya,
      'valorados': instance.valorados?.map((v) => v.toJson()),
      'fechaCreacion': instance.fechaCreacion?.toString(),
      'fechaActualizacion': instance.fechaActualizacion?.toString()
    };

