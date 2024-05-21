import 'dart:async';

import 'package:flutter/material.dart';
import 'package:common/models/contaminacion.dart';
import 'package:common/services/api_service.dart';

class ContaminacionWidget extends StatefulWidget {
  @override
  _ContaminacionWidgetState createState() => _ContaminacionWidgetState();
}

class _ContaminacionWidgetState extends State<ContaminacionWidget> {
  Contaminacion? contaminacion;
  String text = 'Cargando...';
  ApiService apiService = ApiService();
  Timer? _timer;
  int? aqui;

  getContaminacion() async {
    contaminacion = await apiService.getContaminacion();
    setState(() {
      text = (contaminacion!.toString());
      aqui = contaminacion!.aqui;
    });
  }

  @override
  void initState() {
    getContaminacion();
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3600), (timer) {
      getContaminacion();
    });
  }

  Color getPrimayColor(int? aqui) {
    if (aqui != null) {
      if (aqui <= 10) {
        return const Color.fromARGB(255, 40, 157, 44);
      } else if (aqui <= 30) {
        return Color.fromARGB(255, 198, 211, 52);
      } else {
        return const Color.fromARGB(255, 153, 43, 35);
      }
    } else {
      return Colors.grey;
    }
  }
  Color getSecondaryColor(int? aqui) {
    if (aqui != null) {
      if (aqui <= 10) {
        return const Color.fromARGB(255, 15, 238, 22);
      } else if (aqui <= 30) {
        return Color.fromARGB(255, 213, 202, 35);
      } else {
        return Color.fromARGB(255, 207, 32, 20);
      }
    } else {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(  
      child:       
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [getPrimayColor(aqui), getSecondaryColor(aqui)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(text),
            )
          ),
          SizedBox(width: 4,),
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient:  LinearGradient(
                colors: [getPrimayColor(aqui), getSecondaryColor(aqui)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('ICA: 0-10 Bueno\nICA: 11-30 Regular\nICA: 31-100 Malo'),
            )
          )
        ],
      ),
    );
  }
}