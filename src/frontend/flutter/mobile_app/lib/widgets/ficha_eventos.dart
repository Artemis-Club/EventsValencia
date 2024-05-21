
import 'package:common/models/evento.dart';
import 'package:mobile_app/widgets/lista_eventos.dart';
import '../pages/phones_evento_especifico_page.dart';
import 'package:flutter/material.dart';


class EventoItem extends StatefulWidget {
  final Evento evento;
  final int? index;
  const EventoItem({super.key, required this.evento,this.index});

  @override
  State<EventoItem> createState() => _EventoItemState();
}


class _EventoItemState extends State<EventoItem> {
  late Evento evento;

  @override
  void initState() {
    super.initState();
    evento = widget.evento;
  }


  @override
  Widget build(BuildContext context) {
    
    return Card(
        color: cardColor(evento.categoria, context),
        margin: const EdgeInsets.all(8.0),
        child: ListTile(
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                  text: TextSpan(
                      text: evento.titulo,
                      style: Theme.of(context).textTheme.titleLarge)),
              RichText(
                  text: TextSpan(
                      text: evento.posicion.direccion != null &&
                              evento.posicion.direccion != "false" &&
                              evento.posicion.direccion !=
                                  "No hay lugar definido"
                          ? "${evento.posicion.direccion}"
                          : "",
                      style: Theme.of(context).textTheme.titleMedium)),
              RichText(
                  text: TextSpan(
                      text: untilDate(evento),
                      style: Theme.of(context).textTheme.titleMedium)),
              
            ],
          ),
          leading: evento.imagen == null
              ? null
              : ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image(image: MemoryImage(evento.imagen!))),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaginaEvento(evento: evento,index:widget.index),
              ),
            );
          },
        ));
  }
}

String untilDate(Evento e) {
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