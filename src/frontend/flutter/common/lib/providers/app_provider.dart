import 'package:common/models/categoria.dart';
import 'package:common/models/notificacion.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../models/evento.dart';
import '../models/tramo.dart';
import '../services/api_service.dart';

class AppProvider with ChangeNotifier {
  final apiService = ApiService();
  bool estaCargando = true;
  bool huboError = false;
  bool _hayNuevosEventos = true;
  List<Evento>? _eventos;
  List<Tramo>? _tramos;
  int? _indiceEvento;
  double? _radioBusqueda;
  Position? _posicionUsuario;
  List<Categoria>? _categorias;
  List<Notificacion>? _notificaciones;
  int _indiceNavegacion = 1;
  bool _bottomSheetOpened = false;
  ThemeMode _theme = ThemeMode.system;


  List<Categoria>? get categorias => _categorias;
  List<Evento>? get eventos => _eventos;
  List<Tramo>? get tramos => _tramos;
  List<Notificacion>? get notificaciones => _notificaciones;
  int? get indiceEvento => _indiceEvento;
  double? get radioBusqueda => _radioBusqueda;
  Position? get posicionUsuario => _posicionUsuario;
  bool get hayNuevosEventos => _hayNuevosEventos;
  int get indiceNavegacion => _indiceNavegacion;
  bool get bottomSeetOpened => _bottomSheetOpened;
  ThemeMode get theme => _theme;

  Future<void> fetchMapInfoByRadius(Position pos, double radio) async {

    _radioBusqueda = radio;
    _posicionUsuario = pos;
    List<Future> futures = [
      apiService.getEventsByRadius(pos.latitude, pos.longitude, radio).then((eventos) {_eventos = eventos; _hayNuevosEventos = true;} ).catchError((error) {print(error); huboError = true; return null;}),
      apiService.getTramos().then((tramos) => _tramos = tramos).catchError((error) {print(error); huboError = true; return null;}),
      apiService.getCategorias().then((categorias) => _categorias = categorias).catchError((error) {print(error); huboError = true; return null;}),
      apiService.getNotificaciones().then((notificaciones) => _notificaciones = notificaciones).catchError((error) {print(error); huboError = true; return null;} )
    ];
    await Future.wait(futures);
    estaCargando = false;

    print("Cantidad de categorias: ${_categorias?.length ?? "null"}");
    
    notifyListeners();
  }

  void setTheme(ThemeMode newTheme){
    _theme = newTheme;
    notifyListeners();
  }

  void setEventos(List<Evento> newEventos) {
    _eventos = newEventos;
    print("Cantidad de eventos: ${_eventos?.length ?? "null"}");
    notifyListeners();
  }

  void setIndiceEvento(int indiceEvento) {
    _indiceEvento = indiceEvento;
    print("Indice de evento: $_indiceEvento");
    notifyListeners();
  }

  void setRadioBusqeuda(double radioBusqueda) {
    _radioBusqueda = radioBusqueda;
    print("Radio de busqueda: $_radioBusqueda");
    notifyListeners();
  }

  void setPosicion(Position newPosicion) {
    _posicionUsuario = newPosicion;
    print("Posicion: $_posicionUsuario");
    notifyListeners();
  }

  void setBoolNuevosEventos(bool hayNuevosEventos) {
    _hayNuevosEventos = hayNuevosEventos;
  }

  void setIndiceNavegacion(int newIndice){
    _indiceNavegacion = newIndice;
    notifyListeners();
  }

  void setBottomSheetOpened(bool newBottomShepOpenned){
    _bottomSheetOpened = newBottomShepOpenned;
  }

}
