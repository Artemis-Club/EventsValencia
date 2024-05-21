import 'package:common/providers/app_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EncabezadoNotificaciones extends StatefulWidget {
  final bool toEliminar;
  final bool isCheckedSelectAll;
  final bool isCheckedEliminar;
  final bool showText;
  final int cantidadSeleccionada;
  final List<bool> isCheckedList;
  final VoidCallback toggleModeEliminar;
  final VoidCallback toggleSelectAll;
  final VoidCallback toggleEliminar;
  final VoidCallback toggleAccionEliminar;
  final VoidCallback toggleShowText;

  const EncabezadoNotificaciones({
    super.key,
    required this.toEliminar,
    required this.toggleModeEliminar,
    required this.toggleSelectAll,
    required this.isCheckedSelectAll,
    required this.isCheckedEliminar,
    required this.toggleEliminar,
    required this.cantidadSeleccionada,
    required this.toggleAccionEliminar,
    required this.isCheckedList,
    required this.showText,
    required this.toggleShowText,
  });

  @override
  State<EncabezadoNotificaciones> createState() =>
      _EncabezadoNotificacionesState();
}

class _EncabezadoNotificacionesState extends State<EncabezadoNotificaciones> {
  //bool widget.showText = false;
  IconData icono = CupertinoIcons.list_bullet;

  void onPressedHandler() {
    if(widget.isCheckedList != List.empty()){
      widget.toggleModeEliminar();
      toggleText();
    }
  }


  void toggleText() {
    setState(() {
      if (widget.showText == false) {
        icono = CupertinoIcons.xmark;
      } else {
        icono = CupertinoIcons.list_bullet;
      }
      widget.toggleShowText();
    });
  }

  void eliminarNotificaciones(){
    onPressedHandler();
    widget.toggleAccionEliminar();
    Navigator.pop(context);
  }

  BoxDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var watcher = context.watch<AppProvider>();
    ThemeMode tema = watcher.theme;

    if(widget.isCheckedSelectAll){
      decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: tema == ThemeMode.dark
          ? Colors.blue
          : tema == ThemeMode.light
              ? Theme.of(context).primaryColor
              : Theme.of(context).primaryColor
      );
    }else{
      decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.transparent,
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(right: 10, left: 10),
          child: IconButton(
            onPressed: onPressedHandler,
            icon: Icon(icono),
            tooltip: 'Más opciones',
          ),
        ),
        if (!widget.showText) SizedBox(
          width: size.width,
        ),
        if (widget.showText)
          GestureDetector(
            onTap: widget.toggleSelectAll,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: SizedBox(
                height: 50,
                width: 150,
                child: Container(
                  decoration: decoration,
                  child: Card(
                    color: tema == ThemeMode.dark
                        ? HSLColor.fromColor(Theme.of(context).primaryColor).withLightness(0.25).toColor()
                        : null,
                      margin: const EdgeInsets.all(8.0),
                      child: Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: "Seleccionar todas",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary
                            ),
                          ),
                        ),
                      )),
                ),
              ),
            ),
          ),
        if (widget.showText)
          GestureDetector(
            onTap: widget.toggleEliminar,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: SizedBox(
                height: 50,
                width: 150,
                child: Card(
                    margin: const EdgeInsets.all(8.0),
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          tema == ThemeMode.dark
                        ? HSLColor.fromColor(Theme.of(context).primaryColor).withLightness(0.25).toColor()
                        : null,
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Row(
                                  children: [
                                    const SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: Icon(CupertinoIcons.trash),
                                    ),
                                    const SizedBox(width: 10),
                                    if (widget.cantidadSeleccionada > 1)
                                      Expanded(
                                        child: RichText(
                                          text: TextSpan(
                                            text: '¿Quieres eliminar estas ${widget.cantidadSeleccionada} notificaciones?',
                                            style: Theme.of(context).textTheme.titleSmall
                                          ),
                                        ),
                                      ),
                                    if (widget.cantidadSeleccionada == 1)
                                      Expanded(
                                        child: RichText(
                                          text: TextSpan(
                                            text: '¿Quieres eliminar esta notificación?',
                                            style: Theme.of(context).textTheme.titleSmall
                                          ),
                                        ),
                                      ),
                                    if (widget.cantidadSeleccionada == 0)
                                      Expanded(
                                        child: RichText(
                                          text: TextSpan(
                                            text: 'No hay notificaciones seleccionadas',
                                            style: Theme.of(context).textTheme.titleSmall
                                          ),
                                        ),
                                      )
                                  ],
                                ),
                                actions: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: widget.cantidadSeleccionada == 0 ? null : eliminarNotificaciones,
                                        child: const Text('Eliminar')),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cerrar'),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            });
                      },
                      child: Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: "Eliminar",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary
                            ),
                          ),
                        ),
                      ),
                    )),
              ),
            ),
          ),
      ]),
    );
  }
}
