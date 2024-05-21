import '../models/evento.dart';
import '../models/punto.dart';

class EventosMock {

EventosMock(){
  eventosDeffault = eventosDeffault;
}

  List<Evento> eventosDeffault = [
    Evento(
        id: 1,
        titulo: "Evento A",
        descripcion: "Descripcion 1",
        posicion: Punto(latitud: 39.4827818, longitud: -0.3466524),
        fechaCreacion: DateTime.now(),
        fechaActualizacion: DateTime.now()),
    Evento(
        id: 2,
        titulo: "Evento B",
        descripcion: "Descripcion 2",
        posicion: Punto(latitud: 37.46975, longitud: -0.37739),
        fechaCreacion: DateTime.now(),
        fechaActualizacion: DateTime.now()),
    Evento(
        id: 3,
        titulo: "Evento C",
        descripcion: "Descripcion 3",
        posicion: Punto(latitud: 38.56975, longitud: -1.37739),
        fechaCreacion: DateTime.now(),
        fechaActualizacion: DateTime.now()),
    Evento(
        id: 4,
        titulo: "Evento D",
        descripcion: "Descripcion 4",
        posicion: Punto(latitud: 38.46975, longitud: 0.37739),
        fechaCreacion: DateTime.now(),
        fechaActualizacion: DateTime.now()),
    Evento(
        id: 5,
        titulo: "Evento E",
        descripcion: "Descripcion 5",
        posicion: Punto(latitud: 35.46975, longitud: -2.37739),
        fechaCreacion: DateTime.now(),
        fechaActualizacion: DateTime.now())
  ];

List<Evento> getEventos(){return eventosDeffault;} 

}