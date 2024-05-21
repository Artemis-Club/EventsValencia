import 'dart:async';
import 'package:flutter/material.dart';

import '../models/clima.dart';
import '../services/api_service.dart';

class ClimaWidget extends StatefulWidget {
  const ClimaWidget({super.key});

  @override
  State<ClimaWidget> createState() => _ClimaState();
}

class _ClimaState extends State<ClimaWidget> {
  Clima? clima;
  ApiService apiService = ApiService();

  String? text;
  String? humedadText;
  String? vientoText;

  Timer? _timer;

  Image icono = Image.network('https://openweathermap.org/img/wn/01d@2x.png');

  @override
  void initState() {
    super.initState();
    getClima();
    // Inicia el temporizador para que se ejecute cada 5 segundos
    _timer = Timer.periodic(const Duration(seconds: 3600), (timer) {
      // Ejecuta tu función aquí
      getClima();
    });
  }

  String insertarSaltosDeLineaEnEspacios(String texto) {
    // Reemplaza cada espacio por un espacio seguido de un salto de línea
    return texto.replaceAll(' ', '\n');
  }

  getClima() async {
    clima = await apiService.getClima();
    setState(() {
      icono = Image.network(
          'https://openweathermap.org/img/wn/${clima!.icono}@2x.png');
      text =
          ('${clima!.temperaturaActual} ºC\n');
    });
  }

  int getDay() {
    return DateTime.now().hour;
  }

  @override
  void dispose() {
    super.dispose();

    // Cancela el temporizador cuando el widget se elimine
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SizedBox(
      
      width: size.width * 0.15,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
             // const Color.fromARGB(255, 3, 112, 202),
              Theme.of(context).colorScheme.secondaryContainer,
            ],
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icono,
            Text(text == null? 'no data': text!),
          ],
        ),
      ),
    );
  }
}
