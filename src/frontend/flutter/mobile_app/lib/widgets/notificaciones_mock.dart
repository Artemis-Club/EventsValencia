import 'package:common/models/evento.dart';
import 'package:common/models/usuario.dart';
import 'package:common/models/notificacion.dart';


class NotificacionesMock {
  List<Notificacion> notificacionesDeffault = [];
NotificacionesMock(List<Evento> eventos){
  notificacionesDeffault = preparacionNotificaciones(eventos);
}

  List<Notificacion> getNotificaciones(){return notificacionesDeffault;}

  List<Notificacion> eliminarNotificacion(Notificacion not){
    notificacionesDeffault.removeWhere((element) => element.titulo == not.titulo && element.descripcion == not.descripcion);
    return notificacionesDeffault;
  }

  List<Notificacion> preparacionNotificaciones(List<Evento> eventos){
    List<Notificacion> notificaciones = [];
    for (var evento in eventos) {
      if(evento.categoria != null){
        notificaciones.add(
          Notificacion(
            titulo: evento.titulo,
            descripcion: untilDate(evento),
            fechaCreacion: DateTime.now(),
            fechaActualizacion: DateTime.now()
          )
        );
      }
    }
    return notificaciones;
  }

  String untilDate(Evento e){
      int restante = -1;
      if (e.inicio == null) return "";
      restante = e.inicio!.day - DateTime.now().day;
      if (restante == 0) return "El evento ya ha empezado!";
      if (restante < 0) return "El evento ya ha pasado!";
      if (e.inicio!.day == DateTime.now().day) {
        return "Quedan ${e.inicio!.hour - DateTime.now().hour} horas";
      }
    return "Quedan $restante dias";
  }
/*
  List<Notificacion> notificacionesDeffault = [
    Notificacion(
        id: 1,
        titulo: "FREESTYLE CHAMPIONSHIP",
        descripcion: "Quedan 9 días",
        usuario: Usuario(nick: "Knekro", nombre: "Sergio", correo: "laquetecuento@gmail.com", contrasenya: "semifreetoplay"),
        fechaCreacion: DateTime.now(),
        fechaActualizacion: DateTime.now()),
    Notificacion(
        id: 2,
        titulo: "QUEDADA FITNESS",
        descripcion: "Quedan 2 días",
        usuario: Usuario(nick: "Knekro", nombre: "Sergio", correo: "laquetecuento@gmail.com", contrasenya: "semifreetoplay"),
        fechaCreacion: DateTime.now(),
        fechaActualizacion: DateTime.now()),
    Notificacion(
        id: 3,
        titulo: "FOODTRUCK FESTIVAL",
        descripcion: "Quedan 4 días",
        usuario: Usuario(nick: "Knekro", nombre: "Sergio", correo: "laquetecuento@gmail.com", contrasenya: "semifreetoplay"),
        fechaCreacion: DateTime.now(),
        fechaActualizacion: DateTime.now()),
    Notificacion(
        id: 4,
        titulo: "MERCADO ROPA VINTAGE",
        descripcion: "Queda 1 día",
        usuario: Usuario(nick: "Knekro", nombre: "Sergio", correo: "laquetecuento@gmail.com", contrasenya: "semifreetoplay"),
        fechaCreacion: DateTime.now(),
        fechaActualizacion: DateTime.now()),
    Notificacion(
        id: 5,
        titulo: "CONCURSO DE COSPLAY",
        descripcion: "El evento ya ha pasado!",
        usuario: Usuario(nick: "Knekro", nombre: "Sergio", correo: "laquetecuento@gmail.com", contrasenya: "semifreetoplay"),
        fechaCreacion: DateTime.now(),
        fechaActualizacion: DateTime.now())
  ];
*/
}