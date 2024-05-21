import 'dart:convert';
import 'dart:typed_data';
import 'package:json_annotation/json_annotation.dart';
import 'categoria.dart';
import 'punto.dart';
import 'valoracion.dart';

@JsonSerializable()
class Evento {
  final int? id;
  String titulo;
  String? descripcion;
  Punto posicion;
  List<Valoracion>? valoraciones;
  Categoria? categoria;
  DateTime? fechaCreacion;
  DateTime? fechaActualizacion;
  double? distancia;
  Uint8List? imagen;
  String? url;
  DateTime? inicio;
  DateTime? fin;
  Evento({this.id, required this.titulo, this.descripcion, required this.posicion, this.categoria, this.distancia, this.fechaCreacion, this.fechaActualizacion, this.url, this.imagen, this.inicio, this.fin});

  
  
  factory Evento.fromJson(Map<String, dynamic> json) {
    return _$EventoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$EventoToJson(this);

  @override
  String toString() {
    return "Evento: $id, $titulo,$descripcion, $posicion";
  }
}

// Para que se parsee correctamente
double? _$safeDouble(dynamic jsonAtribute) => jsonAtribute != null ? double.parse(jsonAtribute.toString()) : null;

Uint8List? _$convertirAUint8List(dynamic imagen) {
  if (imagen != null) {

      // Elimina la parte inicial "data:image/png;base64,"
    String base64Image = imagen.split(',').last;
  
    // Decodifica la cadena base64 en una lista de bytes (Uint8List)
    Uint8List bytes = base64.decode(base64Image);

    return bytes;
  }
  return null;
}

DateTime? _$safeDatetime(dynamic jsonAtribute) => jsonAtribute != null ? DateTime.parse(jsonAtribute) : null;

Evento _$EventoFromJson(Map<String, dynamic> json) => Evento(
      id: json['id'] as int,
      titulo: json['titulo'] as String,
      descripcion: json['descripcion'] as String?,
      url: json['url'] as String?,
      categoria: json['categoria'] != null ? Categoria.fromJson(json['categoria']) : null,
      imagen: _$convertirAUint8List(json['imagen']),
      posicion: Punto.fromJson(json['posicion']),
      distancia: _$safeDouble(json['distancia']),
      fechaCreacion: DateTime.parse(json['fechaCreacion']),
      fechaActualizacion: DateTime.parse(json['fechaActualizacion']),
      inicio: _$safeDatetime(json['inicio']),
      fin: _$safeDatetime(json['fin']),
    );

Map<String, dynamic> _$EventoToJson(Evento instance) => <String, dynamic>{
      'id': instance.id,
      'titulo': instance.titulo,
      'descripcion': instance.descripcion,
      'url': instance.url,
      'image': instance.imagen,
      'posicion': instance.posicion.toJson(),
      'valoraciones': instance.valoraciones?.map((v) => v.toJson()),
      'fechaCreacion': instance.fechaCreacion,
      'fechaActualizacion': instance.fechaActualizacion,
      'inicio': instance.inicio,
      'fin': instance.fin,
      'categorias': instance.categoria,
    };

