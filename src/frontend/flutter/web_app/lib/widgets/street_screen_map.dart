import 'dart:math';
import 'package:common/enums/trafico_enum.dart';
import 'package:common/models/evento.dart';
import 'package:common/models/punto.dart';
import 'package:common/models/ruta.dart';
import 'package:common/models/tramo.dart';
import 'package:common/providers/app_provider.dart';
import 'package:common/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class StreetScreenMap extends StatefulWidget {
  const StreetScreenMap({super.key});

  @override
  State<StreetScreenMap> createState() => _StreetScreenMapState();
}

class _StreetScreenMapState extends State<StreetScreenMap> {
  late MapboxMapController _mapController;

  final Map<Trafico, String> mapeoEstadoTramoColor = {
    Trafico.denso: const Color.fromRGBO(230, 237, 22, 1).toHexStringRGB(),
    Trafico.congestionado:
        const Color.fromRGBO(255, 144, 17, 1).toHexStringRGB(),
    Trafico.cortado: const Color.fromRGBO(255, 53, 17, 1).toHexStringRGB(),
    Trafico.pasoInferiorDenso:
        const Color.fromRGBO(230, 237, 22, 1).toHexStringRGB(),
    Trafico.pasoInferiorCongestionado:
        const Color.fromRGBO(255, 144, 17, 1).toHexStringRGB(),
    Trafico.pasoInferiorCortado:
        const Color.fromRGBO(255, 53, 17, 1).toHexStringRGB(),
  };

  bool _styleLoaded = false;
  bool _mapCreated = false;
  List<Evento>? _eventos;
  List<Tramo>? _tramos;
  int? _indiceEvento;
  Position? _posicionUsuario;
  Ruta? _ruta;
  bool unoInRuta = false;
  bool inRuta = false;
  final _apiService = ApiService();
  double? distancia = 2;
  static const double _constantA = 14.333; //Modificar para pantallas grandes
  static const double _constantB = -0.074;

  @override
  void initState() {
    super.initState();
  }

  SymbolOptions usuarioSymbolOptions(Position posicionUsuario) => SymbolOptions(
        geometry: LatLng(posicionUsuario.latitude, posicionUsuario.longitude),
        iconImage: 'MyLocation.png',
        //iconOffset: const Offset(0, -10),
        iconSize: 0.17,
        //iconColor: '#ff0000', //No funciona
        textField: "TÚ",
        textSize: 12,
        textOffset: const Offset(0, -1.7),
        fontNames: List<String>.filled(1, 'DIN Offc Pro Medium'),
        textColor:
            Theme.of(context).textTheme.titleMedium!.color!.toHexStringRGB(),
      );

  SymbolOptions eventoSymbolOptions(Evento evento) => SymbolOptions(
        geometry: LatLng(evento.posicion.latitud, evento.posicion.longitud),
        iconImage: '${evento.categoria?.nombre}Pin.png',
        iconOffset: const Offset(0, -10),
        iconSize: 0.12,
        textField: evento.titulo,
        textOffset: const Offset(0, 2),
        textSize: 12,
        fontNames: List<String>.filled(1, 'DIN Offc Pro Medium'),
        textColor:
            Theme.of(context).textTheme.titleLarge!.color!.toHexStringRGB(),
      );

  SymbolOptions tramoSymbolOptionsInicio(Tramo tramo) => SymbolOptions(
        geometry:
            LatLng(tramo.geometria[0].latitud, tramo.geometria[0].longitud),
        iconImage: '${tramo.estado.toString()}Pin.png',
        iconOffset: const Offset(0, -10),
        iconSize: 0.03,
      );

  SymbolOptions tramoSymbolOptionsFinal(Tramo tramo) => SymbolOptions(
        geometry: LatLng(tramo.geometria[tramo.geometria.length - 1].latitud,
            tramo.geometria[tramo.geometria.length - 1].longitud),
        iconImage: '${tramo.estado.toString()}Pin.png',
        iconOffset: const Offset(0, -10),
        iconSize: 0.03,
      );

  void _onMapCreated(MapboxMapController mapController) async {
    _mapCreated = true;
    _mapController = mapController;
    _mapController.addImage(
        'MyLocation.png', await loadMarkerImage('MyLocation.png'));
    _mapController.addImage('EntretenimientoPin.png',
        await loadMarkerImage('EntretenimientoPin.png'));
    _mapController.addImage(
        'MusicaPin.png', await loadMarkerImage('MusicaPin.png'));
    _mapController.addImage(
        'ModaPin.png', await loadMarkerImage('ModaPin.png'));
    _mapController.addImage(
        'DeportesPin.png', await loadMarkerImage('DeportesPin.png'));
    _mapController.addImage(
        'GastronomiaPin.png', await loadMarkerImage('GastronomiaPin.png'));
    _mapController.addImage(
        'nullPin.png', await loadMarkerImage('nullPin.png'));
    _mapController.addImage('Trafico.congestionadoPin.png',
        await loadMarkerImage('Trafico.congestionadoPin.png'));
    _mapController.addImage('Trafico.cortadoPin.png',
        await loadMarkerImage('Trafico.cortadoPin.png'));
    _mapController.addImage(
        'Trafico.densoPin.png', await loadMarkerImage('Trafico.densoPin.png'));
    _mapController.addImage('Trafico.pasoInferiorCongestionadoPin.png',
        await loadMarkerImage('Trafico.pasoInferiorCongestionadoPin.png'));
    _mapController.addImage('Trafico.pasoInferiorCortadoPin.png',
        await loadMarkerImage('Trafico.pasoInferiorCortadoPin.png'));
    _mapController.addImage('Trafico.pasoInferiorDensoPin.png',
        await loadMarkerImage('Trafico.pasoInferiorDensoPin.png'));

    _mapController.removeLayer('poi-label');
  }

  Future<Uint8List> loadMarkerImage(String imageName) async {
    var byteData = await rootBundle.load("MapMarkers/$imageName");
    return byteData.buffer.asUint8List();
  }

  void _onStyleLoaded() {
    _styleLoaded = true;
    if (_posicionUsuario != null) {
      _drawUsuario();
    }
    _drawEventos();
    _drawTramos();
  }

  void _drawEventos() {
    _mapController
        .addSymbols(_eventos!.map((e) => eventoSymbolOptions(e)).toList());
  }

  void _drawUsuario() {
    _mapController.addSymbol(usuarioSymbolOptions(_posicionUsuario!));
  }

  void _clearLines() async {
    await _mapController.clearLines();
  }

  void _drawRuta() {
    _drawTramos();
    _mapController.addLine(LineOptions(
      geometry:
          _ruta!.geometria.map((p) => LatLng(p.latitud, p.longitud)).toList(),
      lineColor: Theme.of(context).colorScheme.primary.toHexStringRGB(),
      lineWidth: 4,
    ));
  }

  void _drawRutaAlterna(Ruta ruta) {
    _mapController.addLine(LineOptions(
      geometry:
          ruta.geometria.map((p) => LatLng(p.latitud, p.longitud)).toList(),
      lineColor: Color.fromARGB(255, 153, 177, 215).toHexStringRGB(),
      lineWidth: 4,
    ));
  }

  void _drawTramos() {
    for (Tramo tramo in _tramos!.where((tramo) =>
        tramo.estado != Trafico.fluido &&
        tramo.estado != Trafico.pasoInferiorFluido &&
        tramo.estado != Trafico.sinDatos)) {
      _mapController.addLine(LineOptions(
        geometry:
            tramo.geometria.map((p) => LatLng(p.latitud, p.longitud)).toList(),
        lineColor: mapeoEstadoTramoColor[tramo.estado],
        lineWidth: 6,
      ));
      _mapController.addSymbol(tramoSymbolOptionsInicio(tramo));
      _mapController.addSymbol(tramoSymbolOptionsFinal(tramo));
    }
  }

  void _updateSymbolsOnRefresh(bool semaforo) {
    if (_styleLoaded && semaforo) {
      _mapController.clearCircles();
      _mapController.clearFills();
      _mapController.clearSymbols();
      _mapController.clearLines();
      _onStyleLoaded();
      Provider.of<AppProvider>(context, listen: false)
          .setBoolNuevosEventos(false);
    }
  }

  void _getRuta(double latitudOrigen, double longitudOrigen,
      double latitudDestino, double longitudDestino) async {
    _ruta = await _apiService.getRuta('foot-walking', latitudOrigen,
        longitudOrigen, latitudDestino, longitudDestino);
    LatLng newEventoAnimationPosition = LatLng(
        (_posicionUsuario!.latitude +
                _eventos![_indiceEvento!].posicion.latitud) /
            2,
        (_posicionUsuario!.longitude +
                _eventos![_indiceEvento!].posicion.longitud) /
            2);
    _mapController.animateCamera(CameraUpdate.newLatLngZoom(
        newEventoAnimationPosition,
        zoomByDistance(_eventos![_indiceEvento!].distancia!)));
    _clearLines();
    //Ruta rutaAlterna = await _getRutaAlterna(
    //    latitudOrigen, longitudOrigen, latitudDestino, longitudDestino);
    //if (unoInRuta) {
    //  _drawRutaAlterna(rutaAlterna);
    //}
    _drawRuta();
  }

  List<bool> _getInRuta(List<Punto> geometria) {
    List<bool> inRuta = List.filled(geometria.length, false);
    for (int i = 0; i < geometria.length; i++) {
      for (var evento in _eventos!) {
        if (evento.posicion.latitud == geometria[i].latitud &&
            evento.posicion.longitud == geometria[i].longitud) {
          inRuta[i] = true;
        }
      }
    }
    return inRuta;
  }

  Future<Ruta> _getRutaAlterna(double latitudOrigen, double longitudOrigen,
      double latitudDestino, double longitudDestino) async {
    int index = 0;
    List<bool> inRuta = _getInRuta(_ruta!.geometria);
    unoInRuta = false;
    distancia = _eventos![_indiceEvento!].distancia! * 0.5;
    for (Evento evento in _eventos!) {
      if (!inRuta[index] && !unoInRuta) {
        for (Punto punto in _ruta!.geometria) {
          if (calculateDistance(punto, evento.posicion) < distancia!) {
            unoInRuta = true;
            Ruta? rutaaux = await _apiService.getRuta(
                'foot-walking',
                latitudOrigen,
                longitudOrigen,
                evento.posicion.latitud,
                evento.posicion.longitud);
            Ruta? rutaaux2 = await _apiService.getRuta(
                'foot-walking',
                evento.posicion.latitud,
                evento.posicion.longitud,
                latitudDestino,
                longitudDestino);
            rutaaux.geometria.addAll(rutaaux2.geometria);
            return rutaaux;
          }
        }
      }
      index++;
    }
    return await _apiService.getRuta('foot-walking', latitudOrigen,
        longitudOrigen, latitudDestino, longitudDestino);
  }

  void _moveCameraOnCarouselEvent() {
    if (_mapCreated && _indiceEvento != null) {
      _getRuta(
        _posicionUsuario!.latitude,
        _posicionUsuario!.longitude,
        _eventos![_indiceEvento!].posicion.latitud,
        _eventos![_indiceEvento!].posicion.longitud,
      );
    }
  }

  double calculateDistance(Punto inicio, Punto fin) {
    LatLng point1 = LatLng(inicio.latitud, inicio.longitud);
    LatLng point2 = LatLng(fin.latitud, fin.longitud);
    const double R = 6371e3; // Earth's radius in meters
    final double lat1 = math.sin(point1.latitude * math.pi / 180);
    final double lon1 = math.sin(point1.longitude * math.pi / 180);
    final double lat2 = math.sin(point2.latitude * math.pi / 180);
    final double lon2 = math.sin(point2.longitude * math.pi / 180);

    final double dLat = lat2 - lat1;
    final double dLon = lon2 - lon1;

    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final double c = (2 * math.atan2(math.sqrt(a), math.sqrt(1 - a)) / 1000);

    return R * c;
  }

  double zoomByDistance(double distance) {
    return pow(distance, _constantB).toDouble() * _constantA;
  }

  @override
  Widget build(BuildContext context) {
    var watcher = context.watch<AppProvider>();
    _eventos = watcher.eventos;
    _tramos = watcher.tramos;
    _indiceEvento = watcher.indiceEvento;
    _posicionUsuario = watcher.posicionUsuario;
    _updateSymbolsOnRefresh(watcher.hayNuevosEventos);
    _moveCameraOnCarouselEvent();

    return MapboxMap(
      compassEnabled: false,

      styleString: Theme.of(context).brightness == Brightness.light
          ? MapboxStyles.MAPBOX_STREETS
          : MapboxStyles.DARK,
      onStyleLoadedCallback: _onStyleLoaded,
      onMapCreated: _onMapCreated,
      accessToken: dotenv.env['MAPBOX_KEY'],
      //cameraTargetBounds: CameraTargetBounds(LatLngBounds(southwest: southwest, northeast: northeast)),
      initialCameraPosition: CameraPosition(
        tilt: 30,
        target: LatLng(_posicionUsuario?.latitude ?? 39.4697500,
            _posicionUsuario?.longitude ?? -0.3773900),
        zoom: 14,
      ),
    );
  }
}
