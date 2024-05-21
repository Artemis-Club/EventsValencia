//key 6c50f7557514198397b5bc731938bece91d67f0b
//api http://api.waqi.info/feed/valencia/?token=6c50f7557514198397b5bc731938bece91d67f0b

import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Contaminacion {
  int? aqui;

  Contaminacion({this.aqui});

  factory Contaminacion.fromJson(Map<String, dynamic> json) {
    return _$ClimaFromJson(json);
  }

  @override
  String toString() {
    return "ICA:\n$aqui";
  }

  String getConsejosContaminacion() {
    if (aqui! > 0 && aqui! <= 10) {
      return "La calidad del aire es satisfactoria, disfruta de tus actividades al aire libre.";
    } else if (aqui! > 10 && aqui! <= 30) {
      return  "La calidad del aire es aceptable, si puede pasear con tranquilidad.";
    } else {
      return "Debido al alto Indice de contaminacion, las personas con enfermedades respiratorias, como el asma, deben limitar los esfuerzos al aire libre.";
    } 
  }
}

Contaminacion _$ClimaFromJson(Map<String, dynamic> json) => Contaminacion(
      aqui: json['data']['aqi'] as int,
    );
