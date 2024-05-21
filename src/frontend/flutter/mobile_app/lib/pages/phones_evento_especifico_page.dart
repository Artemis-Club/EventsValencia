import 'package:common/providers/app_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/widgets/lista_eventos.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:common/models/evento.dart';
import 'package:intl/intl.dart';

class PaginaEvento extends StatefulWidget {
  const PaginaEvento({super.key, required this.evento,this.index});
  final Evento evento;
  final int? index;

  @override
  State<PaginaEvento> createState() => _PaginaEventoState();
}

void launchURL(Uri url) async {
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}

String getDate(Evento e) {
  if (e.inicio == null && e.fin == null) return "";
  if (e.inicio != null && e.fin == null) {
    return "Empieza: ${toStringDate(e.inicio!.toLocal())}";
  }
  if (e.inicio != null && e.fin != null) {
    if (e.inicio == e.fin) {
      return "Empieza: ${toStringDate(e.inicio!.toLocal())}";
    } else {
      return "Empieza: ${toStringDate(e.inicio!.toLocal())}\nAcaba: ${toStringDate(e.fin!.toLocal())}";
    }
  }
  return "Sin coincidencias";
}

String toStringDate(DateTime dt) {
  var horas = NumberFormat('00').format(dt.hour);
  var minutos = NumberFormat('00').format(dt.minute);
  return "${dt.day}/${dt.month}/${dt.year} $horas:$minutos";
}

void toMapPoint(int index,BuildContext context){
  Provider.of<AppProvider>(context, listen: false).setIndiceNavegacion(1);
  Provider.of<AppProvider>(context, listen: false).setIndiceEvento(index);
  Navigator.of(context).pop();
}

class _PaginaEventoState extends State<PaginaEvento> {
  final double nPadding = 10;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        backgroundColor: cardColor(widget.evento.categoria,context),
        surfaceTintColor: cardColor(widget.evento.categoria,context),
        shadowColor: cardColor(widget.evento.categoria,context),
        title: Material(
          color: Colors.transparent,
          child: RichText(
              text: TextSpan(
            text: widget.evento.titulo,
            style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                backgroundColor: Colors.transparent),
          )),
        ),
      ),
      bottomNavigationBar: widget.evento.url == null
          ? null
          : Material(
              elevation: 10,
              child: ListTile(
                title: const Text("Para mas información:"),
                subtitle: RichText(
                    text: TextSpan(
                  text: widget.evento.url,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    decoration: TextDecoration.underline,
                  ),
                )),
                onTap: () {
                  launchURL(Uri.parse(widget.evento.url!));
                },
              ),
            ),
      body: Container(
        margin: EdgeInsets.only(right: nPadding, left: nPadding, bottom: nPadding, top: nPadding),
        child: ListView(children: [
            widget.evento.imagen != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image(
                        fit: BoxFit.fill,
                        image: MemoryImage(
                          widget.evento.imagen!,
                        )))
                : const Padding(padding: EdgeInsets.only()),
            ListTile(
              subtitle: RichText(
                  text: TextSpan(
                      text: widget.evento.descripcion,
                      style: Theme.of(context).textTheme.titleSmall)),
            ),
            const Divider(
                        color: Colors.black54,
                      ),
            ListTile(
              subtitle: RichText(
                textAlign: TextAlign.center,
                  text: TextSpan(
                      text: widget.evento.distancia != null
                          ? "Distancia: ${NumberFormat("##.## km").format(widget.evento.distancia)}"
                          : null,
                      style: Theme.of(context).textTheme.titleMedium)),
            ),
            ListTile(
              subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          getDate(widget.evento) != ""
                              ? const Icon(CupertinoIcons.clock)
                              : const Text(""),
                          RichText(
                              text: TextSpan(
                                  text: getDate(widget.evento),
                                  style:
                                      Theme.of(context).textTheme.titleMedium))
                        ],
                      ),
            ),
            ListTile(
              subtitle: RichText(
                textAlign: TextAlign.center,
                  text: TextSpan(
                      text: widget.evento.categoria != null
                          ? "Categoria: ${widget.evento.categoria!.nombre}"
                          : null,
                      style: Theme.of(context).textTheme.titleMedium)),
            ),
            ElevatedButton(onPressed: () => {
              if(widget.index != null)
              toMapPoint(widget.index!,context)
              }, child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:[
                              Text("Ver en el mapa "),
                              Icon(Icons.travel_explore)
                              ])),
          ]),
        ),
    );
  }
}
