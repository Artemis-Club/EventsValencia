
import 'package:common/models/categoria.dart';
import 'package:common/providers/app_provider.dart';
import 'package:common/models/evento.dart';
import 'package:common/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile_app/widgets/ficha_eventos.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListaEventos extends StatefulWidget {
  const ListaEventos({super.key});

  @override
  State<ListaEventos> createState() => _ListaEventosState();
}

class _ListaEventosState extends State<ListaEventos> {
  final apiService = ApiService();
  Categoria? selectedCategoria;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var watcher = context.watch<AppProvider>();
    final eventos = watcher.eventos;
    final categorias = watcher.categorias;

    return Scaffold(
        appBar: AppBar(
          title: SizedBox(
            child: Row(children: [
              const Text("Eventos\t"),
              const Spacer(),
              categorias != null && categorias.isNotEmpty
                  ? DropdownButton<Categoria>(
                      //hintText: "Filtrar categoria",
                      value: selectedCategoria,
                      underline: Container(
                        height: 2,
                        color: cardColor(selectedCategoria, context),
                      ),
                      hint: const Text("Filtrar categoria"),
                      icon: const Icon(CupertinoIcons.arrow_down),
                      items: {
                        const DropdownMenuItem<Categoria>(
                          value: null,
                          child: Text("Mostrar todos"),
                        ),
                        ...categorias.toSet().map<DropdownMenuItem<Categoria>>(
                            (Categoria value) {
                          return DropdownMenuItem<Categoria>(
                              value: value, child: Text(value.nombre));
                        }),
                      }.toSet().toList(),
                      onChanged: (Categoria? value) {
                        setState(() {
                          selectedCategoria = value;
                        });
                      },
                    )
                  : const Text(""),
            ]),
          ),
        ),
        body: getEventos(selectedCategoria, eventos, setState));
  }
}

ListView getEventos(Categoria? cat, List<Evento>? eventos, Function setState) {
  if ( cat == null && eventos!=null) {
    return ListView.builder(
      itemCount: eventos.length,
      itemBuilder: ((BuildContext context, int index) {
        final evento = eventos[index];
        return EventoItem(key: ValueKey(evento.id), evento: evento,index:eventos.indexOf(evento));
      }),
    );
  }
  if (cat != null && eventos != null) {
    List<Evento> categorizedEvents = eventos
        .where((element) =>
            element.categoria != null &&
            element.categoria!.nombre == cat.nombre)
        .toList();
    if (categorizedEvents.isNotEmpty) {
      return ListView.builder(
        itemCount: categorizedEvents.length,
        itemBuilder: ((BuildContext context, int index) {
          final evento = categorizedEvents[index];
          return EventoItem(key: ValueKey(evento.id), evento: evento,index: eventos.indexOf(evento),);
        }),
      );
    }
  }

  return ListView.builder(
    itemCount: 1,
    itemBuilder: ((BuildContext context, int index) {
      return const Padding(
          padding: EdgeInsets.all(10),
          child: Text("No se han encontrado eventos de esta categoria"));
    }),
  );
}

Color cardColor(Categoria? cat, BuildContext context) {
  if (cat == null) {
    return Theme.of(context)
        .colorScheme
        .background; //const Color.fromRGBO(168, 241, 224, 100);
  }
  switch (cat.nombre) {
    case "Gastronomia":
      return const Color.fromRGBO(122, 169, 255, 100);
    case "Musica":
      return const Color.fromRGBO(202, 246, 108, 100);
    case "Moda":
      return const Color.fromRGBO(255, 98, 135, 100);
    case "Deportes":
      return const Color.fromRGBO(255, 184, 133, 100);
    case "Entretenimiento":
      return const Color.fromRGBO(239, 111, 250, 100);
    default:
      return const Color.fromRGBO(208, 196, 90, 100);
  }
}
