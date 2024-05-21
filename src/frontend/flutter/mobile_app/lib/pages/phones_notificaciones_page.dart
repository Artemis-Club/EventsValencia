import 'package:common/models/evento.dart';
import 'package:common/models/notificacion.dart';
import 'package:common/models/tramo.dart';
import 'package:common/providers/app_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/cabecera_notificaciones.dart';
import '../widgets/listanotificaciones.dart';
import 'package:flutter/material.dart';

class NotificationContainer extends StatefulWidget {
  const NotificationContainer({super.key});

  @override
  State<NotificationContainer> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationContainer> {
    bool modeEliminar = false;
    bool selectAll = false;
    bool eliminar = false;
    bool fueSeleccionado = false;
    bool generacionCheckBoxFalse = false;
    bool _showText = false;
    int cantidadSeleccionada = 0;
    late List<bool> isCheckedList;
    late List<Notificacion> notificaciones;
    late List<Evento> eventos;
    late List<Tramo> tramos;
    int posNotificacion = 0;

  @override
  void initState() {
    super.initState();
  }

  void checkBoxOnChanged(bool value, int index){
    setState(() {
      isCheckedList[index] = value;
      if (value) {
        cantidadSeleccionada++;
      } else {
        cantidadSeleccionada--;
      }
    });
  }

  void toggleSelectAll(){
    setState(() {
      selectAll = !selectAll;
      if (selectAll) {
        fueSeleccionado = true;
        isCheckedList.fillRange(0, isCheckedList.length, true);
        cantidadSeleccionada = isCheckedList.length;
      } else if (fueSeleccionado) {
        fueSeleccionado = false;
        isCheckedList.fillRange(0, isCheckedList.length, false);
        cantidadSeleccionada = 0;
      }
    });
  }

  void toggleShowText(){
    _showText = !_showText;
  }

  void toggleEliminar(){
    setState(() {
      eliminar = !eliminar;
    });
  }

  void toggleModeEliminar() {
    setState(() {
      modeEliminar = !modeEliminar;
    });
  }

  void toggleAccionEliminar(){
    setState(() {
      var isCheckedListAux = isCheckedList;
      if(selectAll){
        selectAll = false;
      }
      for (var i = isCheckedList.length - 1; i >= 0; i--) {
        if (isCheckedListAux[i] == true) {
          checkBoxOnChanged(false, i);
          notificaciones.removeAt(i);
          isCheckedListAux.removeAt(i);
        }
      }
      isCheckedList = isCheckedListAux;
    });
  }


    @override
      Widget build(BuildContext context) {
        var watcher = context.watch<AppProvider>();
        eventos = watcher.eventos!;
        notificaciones = watcher.notificaciones!;
        tramos = watcher.tramos!;
        if(!generacionCheckBoxFalse || (notificaciones.isNotEmpty && isCheckedList.length != notificaciones.length && !modeEliminar)){
          isCheckedList = List<bool>.generate(notificaciones.length, (index) => false);
          generacionCheckBoxFalse = true;
        }
      return Scaffold(
        appBar: AppBar(
        title: const Text('Notificaciones'),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight), // Tamaño preferido para el widget
          child: EncabezadoNotificaciones(
            toEliminar: modeEliminar,
            isCheckedSelectAll: selectAll,
            isCheckedEliminar: eliminar,
            cantidadSeleccionada: cantidadSeleccionada,
            isCheckedList : isCheckedList,
            showText: _showText,
            toggleShowText: toggleShowText,
            toggleModeEliminar: toggleModeEliminar,
            toggleSelectAll: toggleSelectAll,
            toggleEliminar: toggleEliminar,
            toggleAccionEliminar: toggleAccionEliminar,
          ),
        ),
        ),
        body: ListaNotificaciones(
          toEliminar: modeEliminar,
          selectAll: selectAll,
          eliminar: eliminar,
          isCheckedList: isCheckedList,
          onChanged: checkBoxOnChanged,
          notificaciones: notificaciones,
          eventos: eventos,
          tramos: tramos,
        )
      );
    }
}

