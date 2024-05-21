import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CabeceraEventos extends StatefulWidget{
  const CabeceraEventos({super.key});

  @override
  State<CabeceraEventos> createState() => _CabeceraEventosState();

}


class _CabeceraEventosState extends State<CabeceraEventos>{
//Cambiar
  @override
  Widget build(BuildContext context){
    return Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Spacer(),
            Align (
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: IconButton(
                onPressed: () => {},
                icon: const Icon(CupertinoIcons.trash),
                tooltip: 'Eliminar eventos',
                ),
              )
            )
          ],
        )
    );


  }

}