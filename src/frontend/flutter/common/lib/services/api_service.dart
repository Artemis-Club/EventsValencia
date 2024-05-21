import 'dart:math';

import 'package:common/models/categoria.dart';
import 'package:common/models/contaminacion.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/evento.dart';
import '../models/tramo.dart';
import '../models/clima.dart';
import '../models/ruta.dart';
import '../models/notificacion.dart';

class ApiService {
  final scheme = dotenv.env['BACKEND_SCHEME'] ?? "http";
  final host = dotenv.env['BACKEND_HOST'] ?? "localhost";
  final port = int.parse(dotenv.env['BACKEND_PORT'] ?? "3000");

  Future<List<Evento>> getEventsByRadius(
      double latitud, double longitud, double radio) async {
    final response = await http.get(Uri(
      scheme: scheme,
      host: host,
      port: port,
      path: '/eventos/@$latitud,$longitud,$radio',
    ));

    if (response.statusCode == 200) {
      List<Evento> events = List.empty();
      final decodedData = jsonDecode(response.body);
      if (decodedData is List) {
        events = decodedData.map((event) => Evento.fromJson(event)).toList();
      }
      return events;
    } else {
      throw Exception('Error al obtener los eventos');
    }
  }

  Future<Contaminacion> getContaminacion() async {
    final response = await http.get(Uri(
        scheme: 'http',
        host: 'api.waqi.info',
        path: '/feed/valencia/',
        queryParameters: {
          'token': '6c50f7557514198397b5bc731938bece91d67f0b'
        }));
    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      return Contaminacion.fromJson(decodedData);
    } else {
      throw Exception('Error al obtener el clima');
    }
  }

  Future<List<Tramo>> getTramos() async {
    final response = await http.get(Uri(
      scheme: scheme,
      host: host,
      port: port,
      path: '/tramos',
    ));

    if (response.statusCode == 200) {
      List<Tramo> tramos = List.empty();
      final decodedData = jsonDecode(response.body);
      if (decodedData is List) {
        tramos = decodedData.map((tramo) => Tramo.fromJson(tramo)).toList();
      }
      return tramos;
    } else {
      throw Exception('Error al obtener los tramos');
    }
  }

  Future<List<Evento>> getAllEvents() async {
    final response = await http.get(Uri(
      scheme: scheme,
      host: host,
      port: port,
      path: '/eventos/',
    ));

    if (response.statusCode == 200) {
      List<Evento> events = List.empty();
      final decodedData = jsonDecode(response.body);
      if (decodedData is List) {
        events = decodedData.map((event) => Evento.fromJson(event)).toList();
      }
      return events;
    } else {
      throw Exception('Error al obtener los eventos');
    }
  }

  //https://api.openweathermap.org/data/2.5/weather?lat=39.4697500&lon=-0.3773900&appid=ab1f6dd1cabb79c44fd0adf4f639572c&units=metric datos de la api
  //https://openweathermap.org/img/wn/iconod@2x.png iconos de la api

  Future<Clima> getClima() async {
    final response = await http.get(Uri(
      scheme: 'https',
      host: 'api.openweathermap.org',
      path: '/data/2.5/weather',
      queryParameters: {
        'lat': '39.4697500',
        'lon': '-0.3773900',
        'appid': 'ab1f6dd1cabb79c44fd0adf4f639572c',
        'units': 'metric',
      },
    ));

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      return Clima.fromJson(decodedData);
    } else {
      throw Exception('Error al obtener el clima');
    }
  }

  //ejemplo de ruta http://montnoirr.ddns.net:5500/rutas/foot-walking/@39.47252330763848,-0.354534092051189/@39.48251368832389,-0.34674717194512156
  /// El parámetro [perfil] debe ser uno de estos valores para su correcto funcionamiento:
  ///
  /// [perfil] = 'foot-walking',
  /// [perfil] = 'cycling-regular'
  ///
  Future<Ruta> getRuta(
      String perfil,
      double latitudOrigen,
      double longitudOrigen,
      double latitudDestino,
      double longitudDestino) async {
    //Importante aplicar redondeo para evitar persistir rutas similares,
    //sacrificando un poco la precision de la query
    final latOrgRound = _$redondeoPorDecimales(latitudOrigen, 5);
    final longOrgRound = _$redondeoPorDecimales(longitudOrigen, 4);
    final latDestRound = _$redondeoPorDecimales(latitudDestino, 5);
    final longDestRound = _$redondeoPorDecimales(longitudDestino, 4);
    final response = await http.get(Uri(
      scheme: scheme,
      host: host,
      port: port,
      path:
          '/rutas/$perfil/@$latOrgRound,$longOrgRound/@$latDestRound,$longDestRound',
    ));
    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      return Ruta.fromJson(decodedData);
    } else {
      throw Exception('Error al obtener la ruta');
    }
  }

  Future<List<Categoria>> getCategorias() async {
    final response = await http
        .get(Uri(scheme: scheme, host: host, port: port, path: '/categorias'));
    if (response.statusCode == 200) {
      List<Categoria> categorias = List.empty();
      final decodedData = jsonDecode(response.body);
      if (decodedData is List) {
        categorias = decodedData
            .map((categoria) => Categoria.fromJson(categoria))
            .toList();
      }
      return categorias;
    } else {
      throw Exception('Error al obtener las categorias');
    }
  }

  Future<List<Notificacion>> getNotificaciones() async {
    final response = await http.get(
        Uri(scheme: scheme, host: host, port: port, path: '/notificaciones/'));
    if (response.statusCode == 200) {
      List<Notificacion> notificaciones = List.empty();
      final decodedData = jsonDecode(response.body);
      if (decodedData is List) {
        notificaciones = decodedData
            .map((notificacion) => Notificacion.fromJson(notificacion))
            .toList();
      }
      return notificaciones;
    } else {
      throw Exception('Error al obtener las notificaciones');
    }
  }

  submitNotificaciones(List<Notificacion> notificaciones) async {
    if (notificaciones.isNotEmpty) {
      for (var n in notificaciones) {
        try {
          var response = await http.post(
              Uri(
                  scheme: scheme,
                  host: host,
                  port: port,
                  path: '/notificaciones/'),
              body: n.toJson());
          if (response.statusCode == 201) {
            print("Se han insertado las nuevas notificaciones");
          } else {
            throw Exception('HTTP ${response.statusCode}: ${response.body}');
          }
        } catch (e) {
          throw Exception('Exception: $e');
        }
      }
    } else {
      throw Exception(
          'No hay notificaciones para añadir. Añade a la lista notificaciones');
    }
  }

  double _$redondeoPorDecimales(double n, int nDecimales) {
    final pot10 = pow(10, nDecimales);
    return (n * pot10).round() / pot10;
  }
}
