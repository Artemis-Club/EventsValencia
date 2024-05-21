import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:common/enums/trafico_enum.dart';
import 'package:common/models/evento.dart';
import 'package:common/models/ruta.dart';
import 'package:common/models/tramo.dart';
import 'package:common/providers/app_provider.dart';
import 'package:common/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:mobile_app/pages/phones_evento_especifico_page.dart';
import 'package:mobile_app/widgets/lista_eventos.dart';
import 'package:provider/provider.dart';

class PhonesMap extends StatefulWidget {
  final String? mapboxStyle;
  const PhonesMap({super.key, this.mapboxStyle});
  @override
  State<PhonesMap> createState() => _PhonesMapState();
}

List<Evento>? _eventos;
BuildContext? _context;

class AnnotationClickListener extends OnPointAnnotationClickListener {
  _PhonesMapState phonesMapState;
  PolylineAnnotationManager? polylineAnnotationManager;
  PolylineAnnotation? polylineAnnotation;
  final apiService = ApiService();
  PolylineAnnotation? rutaAnnotation;


  AnnotationClickListener(this.phonesMapState);

    PolylineAnnotationOptions createOneAnnotation(Ruta r) {
    return PolylineAnnotationOptions(
            geometry: LineString(coordinates:  r.geometria.map((r) => Position(r.longitud, r.latitud)).toList()).toJson(),
            lineColor: Theme.of(phonesMapState.context).colorScheme.primary.value,
            lineWidth: 6,
            lineBlur: 1.0,
            lineJoin: LineJoin.ROUND
            );
  }

  Future<Ruta> _getRuta(latDst, longDst) async {
    final posicion = await phonesMapState._mapboxMap.style.getPuckPosition();
    return apiService.getRuta('foot-walking', posicion.lat as double, posicion.lng as double, latDst, longDst);
  }
  
  void _drawRuta(latDst, longDst) async {
    final ruta = await _getRuta(latDst, longDst);
    _clearRuta();
    phonesMapState._mapboxMap.annotations.createPolylineAnnotationManager().then((value) async {
      polylineAnnotationManager = value;
      
      polylineAnnotation = await polylineAnnotationManager?.create(createOneAnnotation(ruta));

      phonesMapState.setCameraPosition(await phonesMapState._mapboxMap.style.getPuckPosition());
    });
    
  }

  void _clearRuta() {
    if (polylineAnnotation != null) polylineAnnotationManager?.delete(polylineAnnotation!);
  }
  
  @override
  void onPointAnnotationClick(PointAnnotation annotation) {
    if (_eventos == null) return;
    Provider.of<AppProvider>(_context!, listen: false)
        .setBottomSheetOpened(true);
    int id = int.tryParse(annotation.textField!)!;
    final Evento evento = _eventos!.firstWhere((element) => element.id == id);
    Provider.of<AppProvider>(_context!, listen: false).setIndiceEvento(_eventos!.indexOf(evento));

    PersistentBottomSheetController bottomSheetController = Scaffold.of(_context!).showBottomSheet(
      (context) => Material(
        color: cardColor(evento.categoria, context),
        child: DraggableScrollableSheet(
            expand: false,
            minChildSize: 0.2,
            initialChildSize: 0.4,
            maxChildSize: 0.8,
            builder: (_, controller) => SingleChildScrollView(
                  controller: controller,
                  child: Column(
                    children: [
                      Container(
                        height: 40, // Adjust height as desired
                        width: double.infinity, // Adjust width as desired
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade200, // Customize color
                        ),
                        child:
                            const Icon(Icons.drag_handle, color: Colors.grey),
                      ),
                      RichText(
                          text: TextSpan(
                              text: evento.titulo,
                              style: Theme.of(context).textTheme.titleLarge)),
                      evento.imagen != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image(
                                  fit: BoxFit.fill,
                                  image: MemoryImage(
                                    evento.imagen!,
                                  )))
                          : const Padding(padding: EdgeInsets.only()),
                      const Divider(
                        color: Colors.black54,
                      ),
                      RichText(
                          text: TextSpan(
                              text: evento.descripcion,
                              style: Theme.of(context).textTheme.titleMedium)),
                      const Divider(
                        color: Colors.black54,
                      ),
                      RichText(
                          text: TextSpan(
                              text: evento.distancia != null
                                  ? "Distancia: ${NumberFormat("##.## km").format(evento.distancia)}"
                                  : null,
                              style: Theme.of(context).textTheme.titleMedium)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          getDate(evento) != ""
                              ? const Icon(CupertinoIcons.clock)
                              : const Text(""),
                          RichText(
                              text: TextSpan(
                                  text: getDate(evento),
                                  style:
                                      Theme.of(context).textTheme.titleMedium))
                        ],
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _drawRuta(evento.posicion.latitud, evento.posicion.longitud);
                          },
                          child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("¿Como llegar?"),
                                Icon(Icons.directions)
                              ])),
                      Container(
                        child: evento.url == null
                            ? null
                            : Material(
                                color: Colors.transparent,
                                child: ListTile(
                                  title: const Text("Visitar web:"),
                                  subtitle: RichText(
                                      text: TextSpan(
                                    text: evento.url,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      decoration: TextDecoration.underline,
                                    ),
                                  )),
                                  onTap: () {
                                    launchURL(Uri.parse(evento.url!));
                                  },
                                ),
                              ),
                      )
                    ],
                  ),
                )),
      ),
      
    );
    bottomSheetController.closed.then((value) => Provider.of<AppProvider>(_context!, listen: false)
        .setBottomSheetOpened(false));
  }
}

void bottomSheetClosing(){

}


class _PhonesMapState extends State<PhonesMap> {
  late final MapboxMap _mapboxMap;
  var isStandard = true;
  var mapProject = StyleProjectionName.globe;
  late num latitude;
  late num longitude;
  final apiService = ApiService();

  geo.Position? _posicionUsuario;
  int? _indiceEvento;
  bool hasZoomedEvento = false;
  bool mapIsCreated = false;
  bool trackLocation = true;
  PointAnnotationManager? pointAnnotationManager;
  List<Tramo>? _tramos;
  PolylineAnnotationManager? polylineAnnotationManager;
  PolylineAnnotation? polylineAnnotation;


  Timer? timer;

  @override
  void initState() {
    MapboxOptions.setAccessToken(dotenv.env['MAPBOX_KEY']!);
    super.initState();
  }

  void _zoomOnEventoFromEventoPage() {
    final lat = _eventos![_indiceEvento!].posicion.latitud;
    final long = _eventos![_indiceEvento!].posicion.longitud;
    _mapboxMap
        .flyTo(
            CameraOptions(
                zoom: 16,
                center: Point(coordinates: Position(long, lat)).toJson()),
            null)
        .then((value) {
      hasZoomedEvento = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  PointAnnotationOptions createOneAnnotation(Evento e, Uint8List list) {
    return (PointAnnotationOptions(
        geometry: Point(
            coordinates: Position(
          e.posicion.longitud,
          e.posicion.latitud,
        )).toJson(),
        textField: e.id.toString(),
        textSize: 0,
        iconSize: 0.35,
        symbolSortKey: Random().nextDouble(),
        image: list));
  }

  void mapboxMapUpdateSettigns() {
    _mapboxMap.compass.updateSettings(CompassSettings(
        enabled: true, position: OrnamentPosition.TOP_RIGHT,marginTop: 90, marginRight: 5));
    _mapboxMap.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    _mapboxMap = mapboxMap;
    mapboxMapUpdateSettigns();

    mapIsCreated = true;
    _enableLocation();

    _drawTramos();

    if (widget.mapboxStyle != null) {
      _mapboxMap.loadStyleURI(widget.mapboxStyle!);
    }

    _mapboxMap.annotations.createPointAnnotationManager().then((value) async {
      pointAnnotationManager = value;

      List<String> existentPins = ["Deportes","Entretenimiento","Gastronomia","Moda","Musica"];
      var options = <PointAnnotationOptions>[];
      for (var evento in _eventos!) {
        String nombre = evento.categoria == null ||
                !existentPins.contains(evento.categoria!.nombre)
            ? "nullPin.png"
            : "${evento.categoria!.nombre}Pin.png";
        final ByteData bytes =
            await rootBundle.load('assets/MapMarkers/$nombre');
        final Uint8List list = bytes.buffer.asUint8List();
        options.add(createOneAnnotation(evento, list));
      }
      pointAnnotationManager?.setIconAllowOverlap(true);
      pointAnnotationManager?.createMulti(options);

      pointAnnotationManager
          ?.addOnPointAnnotationClickListener(AnnotationClickListener(this));
    });
  }

  void _enableLocation() {
    _mapboxMap.location.updateSettings(LocationComponentSettings(
        enabled: true,
        pulsingEnabled: true
      ));
      _mapboxMap.style.getPuckPosition();
  }

  void setCameraPosition(Position position) {
    _mapboxMap.flyTo(
        CameraOptions(
          center: Point(coordinates: position).toJson(),
          zoom: 15,
        ),
        null);
  }

  void refreshTrackLocation() async {
    timer?.cancel();
    if (trackLocation) {
      timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        final position = await _mapboxMap.style.getPuckPosition();
        setCameraPosition(position);
      });
    }
  }

  void _onStyleLoaded(StyleLoadedEventData data) {
    //refreshTrackLocation();
  }

    Future<List<Tramo>> _getTramo() async {
    return apiService.getTramos();
  }

    Future<void> _drawTramos() async {
    for (Tramo tramo in _tramos!.where((tramo) =>
        tramo.estado != Trafico.fluido &&
        tramo.estado != Trafico.pasoInferiorFluido &&
        tramo.estado != Trafico.sinDatos)) {

          _mapboxMap.annotations.createPolylineAnnotationManager().then((value) async {
          polylineAnnotationManager = value;

          polylineAnnotation = await polylineAnnotationManager?.create(createOneAnnotationLine(tramo));
        }
      );
    }
  }

    void _clearTramo() {
    if (polylineAnnotation != null) polylineAnnotationManager?.delete(polylineAnnotation!);
  }

    PolylineAnnotationOptions createOneAnnotationLine(Tramo t) {
    return PolylineAnnotationOptions(
            geometry: LineString(coordinates:  t.geometria.map((t) => Position(t.longitud, t.latitud)).toList()).toJson(),
            lineColor: mapeoEstadoTramoColor[t.estado],
            lineWidth: 6,
            lineBlur: 1.0,
            lineJoin: LineJoin.ROUND
            );
  }

    final Map<Trafico, int> mapeoEstadoTramoColor = {
    Trafico.denso:
        const Color.fromRGBO(230, 237, 22, 1).value,
    Trafico.congestionado:
        const Color.fromRGBO(255, 144, 17, 1).value,
    Trafico.cortado:
        const Color.fromRGBO(255, 53, 17, 1).value,
    Trafico.pasoInferiorDenso:
        const Color.fromRGBO(230, 237, 22, 1).value,
    Trafico.pasoInferiorCongestionado:
        const Color.fromRGBO(255, 144, 17, 1).value,
    Trafico.pasoInferiorCortado:
        const Color.fromRGBO(255, 53, 17, 1).value,
  };

  @override
  Widget build(BuildContext context) {
    _context = context;
    var watcher = context.watch<AppProvider>();
    _tramos = watcher.tramos;
    _eventos = watcher.eventos;
    _posicionUsuario = watcher.posicionUsuario;
    if (_indiceEvento != watcher.indiceEvento) hasZoomedEvento = false;
    _indiceEvento = watcher.indiceEvento;
    latitude = _posicionUsuario?.latitude ?? 39.485242;
    longitude = _posicionUsuario?.longitude ?? -0.345444;

    //_updateSymbolsOnRefresh();
    if (mapIsCreated && !hasZoomedEvento && _indiceEvento != null) {
      _zoomOnEventoFromEventoPage();
    }
    if (mapIsCreated && widget.mapboxStyle != null) {
      _mapboxMap.loadStyleURI(widget.mapboxStyle!);
    }
    return dotenv.env['MAPBOX_KEY'] == null
        ? buildAccessTokenWarning()
        : MapWidget(
            key: const ValueKey("mapWidget"),
            cameraOptions: CameraOptions(
                center:
                    Point(coordinates: Position(longitude, latitude)).toJson(),
                zoom: 16.0),
            textureView: true,
            onMapCreated: _onMapCreated,
            onStyleLoadedListener: _onStyleLoaded,
          );
  }

  Widget buildAccessTokenWarning() {
    return Container(
      color: Colors.red[900],
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            "Please pass in your access token in the .env",
            "MAPBOX_KEY=KEY",
            "See .env.example",
          ]
              .map((text) => Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(text,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

extension PuckPosition on StyleManager {
  Future<Position> getPuckPosition() async {
    Layer? layer;
    if (Platform.isAndroid) {
      layer = await getLayer("mapbox-location-indicator-layer");
    } else {
      layer = await getLayer("puck");
    }
    final location = (layer as LocationIndicatorLayer).location;
    return Future.value(Position(location![1]!, location[0]!));
  }
}