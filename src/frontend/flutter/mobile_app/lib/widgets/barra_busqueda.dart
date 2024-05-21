import 'package:common/models/evento.dart';
import 'package:common/providers/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BarraBusqueda extends StatefulWidget {
  const BarraBusqueda({super.key});

  @override
  State<BarraBusqueda> createState() => _BarraBusquedaState();
}

class _BarraBusquedaState extends State<BarraBusqueda> {
  List<Evento>? _eventos;
  List<Evento>? eventosSugeridos;

  String searchBarText = "";

  void filtrarEventos(String searchText) {
    if (searchText.isEmpty) return setState(() {eventosSugeridos = _eventos;});
      final eventosFiltrados = _eventos!
          .where((evento) =>
              evento.titulo
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              (evento.descripcion != null &&
                  evento.descripcion!
                      .toLowerCase()
                      .contains(searchText.toLowerCase())))
          .toList();

          setState(() {
            eventosSugeridos = eventosFiltrados;
          });
    }

  @override
  Widget build(BuildContext context) {
    var watcher = context.watch<AppProvider>();
    _eventos = watcher.eventos;
    
    return SearchAnchor(
      keyboardType: TextInputType.name,
      viewOnChanged: (text) {
        filtrarEventos(text);
      },
      builder: (context, controller) {
        return SearchBar(
          hintText: 'Busca algún evento o monumento...',
          controller: controller,
          padding: const MaterialStatePropertyAll<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: 16.0)),
          onTap: () {
            controller.openView();
          },
          onChanged: (text) {
            controller.openView();
          },
          leading: const Icon(Icons.search),
        );
      },
      suggestionsBuilder: (context, controller) {
        if (eventosSugeridos == null) return [].map((e) => const ListTile());
        return eventosSugeridos!.map((e) => ListTile(
          title: Text(e.titulo),
          onTap: () {
            setState(() {
              controller.closeView(e.titulo);
            });
            watcher.setIndiceEvento(_eventos!.indexOf(e)); 
          },
        )).toList();
      },
    );
  }
}
