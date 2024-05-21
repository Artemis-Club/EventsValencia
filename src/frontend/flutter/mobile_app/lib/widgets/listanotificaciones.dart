import 'package:common/enums/trafico_enum.dart';
import 'package:common/models/evento.dart';
import 'package:common/models/notificacion.dart';
import 'package:common/models/tramo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:common/services/api_service.dart';
import 'package:common/providers/app_provider.dart';

class ListaNotificaciones extends StatefulWidget {
  final bool toEliminar;
  final bool selectAll;
  final bool eliminar;
  final List<bool> isCheckedList;
  final Function(bool, int) onChanged;
  final List<Notificacion> notificaciones;
  final List<Evento> eventos;
  final List<Tramo> tramos;

  const ListaNotificaciones({
    super.key,
    required this.toEliminar,
    required this.selectAll,
    required this.eliminar,
    required this.isCheckedList,
    required this.onChanged,
    required this.notificaciones,
    required this.eventos,
    required this.tramos,
  });

  @override
  State<ListaNotificaciones> createState() => _ListaNotificacionesState();
}

class _ListaNotificacionesState extends State<ListaNotificaciones> {
  final apiService = ApiService();
  static const umbralDiasInicio = 7;

  @override
  void initState() {
    super.initState();
  }

  String diferenciaToString(Duration diferencia) {
    if (diferencia.inDays > 0) return '${diferencia.inDays} días';
    if (diferencia.inHours > 0) return '${diferencia.inDays} horas';
    return '${diferencia.inDays} minutos';
  }

  

  List<Notificacion> notificacionesFromEventos() {
    List<Notificacion> notificaciones = [];
    for (Evento evento in widget.eventos) {
      if (evento.inicio != null) {
        Duration diferencia = evento.inicio!.difference(DateTime.now());
        if (!diferencia.isNegative && diferencia.inDays <= umbralDiasInicio) {
          notificaciones.add(Notificacion(
              titulo: '${evento.titulo}',
              descripcion: 'En ${diferenciaToString(diferencia)}'));
        }
      }
    }
    return notificaciones;
  }

  List<Notificacion> notificacionesFromTramos() {
    List<Notificacion> notificaciones = [];
    for (Tramo tramo in widget.tramos) {
      if (tramo.estado != Trafico.sinDatos &&
          tramo.estado != Trafico.fluido &&
          tramo.estado != Trafico.pasoInferiorFluido) {
        notificaciones.add(Notificacion(
            titulo: tramo.nombre,
            descripcion: tramo.estado.toString().substring(8).toUpperCase()));
      }
    }
    return notificaciones;
  }

  @override
  Widget build(BuildContext context) {
    //final notificacionesEventosYTramos = watcher.notificaciones;

    apiService.submitNotificaciones(notificacionesFromEventos());
    apiService.submitNotificaciones(notificacionesFromTramos());
    return Scaffold(
      body: ListView.builder(
        itemCount: widget.notificaciones.length,
        itemBuilder: ((BuildContext context, int index) {
          if (widget.toEliminar == true) {
            return NotificationItemEliminar(
              title: widget.notificaciones.elementAt(index).titulo,
              description: widget.notificaciones.elementAt(index).descripcion,
              isChecked: widget.isCheckedList[index],
              onChanged: (value) {
                widget.onChanged(value!, index);
              },
            );
          } else {
            return NotificationItem(
                title: widget.notificaciones.elementAt(index).titulo,
                description:
                    widget.notificaciones.elementAt(index).descripcion);
          }
        }),
      ),
    );
  }
}

class NotificationItemEliminar extends StatelessWidget {
  final String title;
  final String description;
  final bool isChecked;
  final ValueChanged<bool?>? onChanged;

  NotificationItemEliminar({
    super.key,
    required this.title,
    required this.description,
    required this.isChecked,
    this.onChanged,
  });

  final Map<String, Color> mapeoEstadoColorIcono = {
    'DENSO': Color.fromRGBO(230, 237, 22, 1),
    'CONGESTIONADO':Color.fromRGBO(255, 144, 17, 1),
    'CORTADO':Color.fromRGBO(255, 53, 17, 1),
    'PASOINFERIORDENSO':Color.fromRGBO(230, 237, 22, 1),
    'PASOINFERIORCONGESTIONADO':Color.fromRGBO(255, 144, 17, 1),
    'PASOINFERIORCORTADO':Color.fromRGBO(255, 53, 17, 1),
  };

  void toEventosNotification(BuildContext context) {
    Provider.of<AppProvider>(context, listen: false).setIndiceNavegacion(2);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var watcher = context.watch<AppProvider>();
    ThemeMode tema = watcher.theme;

    return Row(
      children: [
        GestureDetector(
          onTap: () {
            onChanged!(!isChecked);
          },
          child: Checkbox(
            shape: const CircleBorder(),
            value: isChecked,
            onChanged: onChanged,
            activeColor: isChecked && tema == ThemeMode.dark
                ? Colors.blue.shade200
                : Theme.of(context).colorScheme.secondary,
          ),
        ),
        Expanded(
          child: Card(
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                          text: title,
                          style: Theme.of(context).textTheme.titleLarge),
                    ),
                    RichText(
                      text: TextSpan(
                          text: description,
                          style: Theme.of(context).textTheme.titleMedium),
                    ),
                  ],
                ),
                leading: CircleAvatar(
                  backgroundColor:  !description.startsWith('En') ?
                    mapeoEstadoColorIcono[description] 
                    : Theme.of(context)
                        .colorScheme
                        .primary,// Color de fondo del avatar
                  child: Icon(
                    description.startsWith('En')
                        ? Icons.access_time_rounded
                        : Icons.car_crash_outlined, // Icono de notificación
                    color: Theme.of(context)
                        .colorScheme
                        .background, // Color del icono
                  ),
                ),
                onTap: () {
                  // Acción al hacer clic en la notificación
                  if (title == "GALA ARTEMIS") {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  image: const DecorationImage(
                                    image: AssetImage('assets/5.png'),
                                    fit: BoxFit.cover,
                                  ),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text('Knekro'),
                            ],
                          ),
                          content: const Text('Un Mewtwo shiny lokoooooo'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cerrar'),
                            ),
                          ],
                        );
                      },
                    );
                  } else if (description.startsWith('En')){
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  image: const DecorationImage(
                                    image: AssetImage('assets/Campana.png'),
                                    fit: BoxFit.cover,
                                  ),
                                  shape: BoxShape.rectangle,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                      text: title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall),
                                ),
                              ),
                            ],
                          ),
                          content: ElevatedButton(
                              onPressed: () => {toEventosNotification(context)},
                              child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Ver en Eventos"),
                                    Icon(Icons.travel_explore)
                                  ])),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cerrar'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              )),
        )
      ],
    );
  }
}

class NotificationItem extends StatefulWidget {
  final String title;
  final String description;

  const NotificationItem({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  void toEventosNotification(BuildContext context) {
    Provider.of<AppProvider>(context, listen: false).setIndiceNavegacion(2);
    Navigator.of(context).pop();
  }

  final Map<String, Color> mapeoEstadoColorIcono = {
    'DENSO': Color.fromRGBO(230, 237, 22, 1),
    'CONGESTIONADO':Color.fromRGBO(255, 144, 17, 1),
    'CORTADO':Color.fromRGBO(255, 53, 17, 1),
    'PASOINFERIORDENSO':Color.fromRGBO(230, 237, 22, 1),
    'PASOINFERIORCONGESTIONADO':Color.fromRGBO(255, 144, 17, 1),
    'PASOINFERIORCORTADO':Color.fromRGBO(255, 53, 17, 1),
  };

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.all(8.0),
        child: ListTile(
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                    text: widget.title,
                    style: Theme.of(context).textTheme.titleLarge),
              ),
              RichText(
                text: TextSpan(
                    text: widget.description,
                    style: Theme.of(context).textTheme.titleMedium),
              ),
            ],
          ),
          leading: CircleAvatar(
                  backgroundColor:  !widget.description.startsWith('En') ?
                    mapeoEstadoColorIcono[widget.description] 
                    : Theme.of(context)
                        .colorScheme
                        .primary,// Color de fondo del avatar
                  child: Icon(
                    widget.description.startsWith('En')
                        ? Icons.access_time_rounded
                        : Icons.car_crash_outlined, // Icono de notificación
                    color: Theme.of(context)
                        .colorScheme
                        .background, // Color del icono
                  ),
                ),
          onTap: () {
            // Acción al hacer clic en la notificación
            if (widget.title == "GALA ARTEMIS") {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage('assets/5.png'),
                              fit: BoxFit.cover,
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text('Knekro'),
                      ],
                    ),
                    content: const Text('Un Mewtwo shiny lokoooooo'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cerrar'),
                      ),
                    ],
                  );
                },
              );
            } else if (widget.description.startsWith('En')) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage('assets/Campana.png'),
                              fit: BoxFit.cover,
                            ),
                            shape: BoxShape.rectangle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                                text: widget.title,
                                style: Theme.of(context).textTheme.titleSmall),
                          ),
                        ),
                      ],
                    ),
                    content: ElevatedButton(
                        onPressed: () => {toEventosNotification(context)},
                        child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Ver en Eventos"),
                              Icon(Icons.travel_explore)
                            ])),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cerrar'),
                      ),
                    ],
                  );
                },
              );
            }
          },
        ));
  }
}
