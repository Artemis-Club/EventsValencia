import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Clima {
  String? estadoCielo;
  String? temperaturaActual;
  String? icono;
  String? humedad;
  String? viento;

  Clima(
      {this.estadoCielo,
      this.temperaturaActual,
      this.icono,
      this.humedad,
      this.viento});

  factory Clima.fromJson(Map<String, dynamic> json) {
    return _$ClimaFromJson(json);
  }

  @override
  String toString() {
    return "$estadoCielo,\n$temperaturaActual ºC";
  }
}

// Para que se parsee correctamente
double _$safeDouble(dynamic jsonAtribute) =>
    double.parse(jsonAtribute.toString());

Clima _$ClimaFromJson(Map<String, dynamic> json) => Clima(
      estadoCielo: json['weather'][0]['main'] as String,
      temperaturaActual: json['main']['temp'].toString(),
      icono: json['weather'][0]['icon'] as String,
      humedad: json['main']['humidity'].toString(),
      viento: json['wind']['speed'].toString(),
    );
