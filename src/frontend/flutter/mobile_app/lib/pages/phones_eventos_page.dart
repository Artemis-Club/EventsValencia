import '../widgets/lista_eventos.dart';
import 'package:flutter/material.dart';


class PhonesEventosPage extends StatefulWidget {
  const PhonesEventosPage({super.key});

  //final List<Evento> eventos;

  @override
  State<PhonesEventosPage> createState() => _PhonesEventosPageState();
}

class _PhonesEventosPageState extends State<PhonesEventosPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
       body:  Column(
          children: [
            /**
              Expanded(
                child: CabeceraEventos()
              ),
            */
            Expanded(
              flex: 8,
              child: ListaEventos()
            )
          ]
         ),
       );
  }
}
