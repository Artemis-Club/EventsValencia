import 'dart:async';
import 'dart:ui';

import 'package:common/enums/trafico_enum.dart';
import 'package:common/models/contaminacion.dart';
import 'package:common/models/tramo.dart';
import 'package:common/providers/app_provider.dart';
import 'package:common/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class Info extends StatefulWidget {
  const Info({super.key});

  @override
  State<StatefulWidget> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  List<Tramo>? _trafico;
  ApiService apiService = ApiService();
  List<Tramo>? tramos;
  String? tramosText = "";
  int tramosTextIndex = 0;
  Timer? timerTramos;
  int primeraVez = 0;
  Image? tramosImage;
  bool puede = false;

  int minutosInfo = 10;
  Contaminacion? contaminacion;

  @override
  void initState() {
    super.initState();
  }

  getContaminacion() async {
    contaminacion = await apiService.getContaminacion();
  }

  getTramosAndSetTimer() {
    getTramos();
    setTramosText();
    timerTramos = Timer.periodic(Duration(seconds: minutosInfo), (timer) {
      getTramos();
      setTramosText();
    });
  }

  void getTramos() {
    if (_trafico != null) {
      tramos = _trafico!
          .where((tramo) =>
              tramo.estado != Trafico.fluido &&
              tramo.estado != Trafico.pasoInferiorFluido &&
              tramo.estado != Trafico.sinDatos)
          .toList();
    }
  }

  String eliminaAcentos(String texto) {
    texto = texto.replaceAll('á', 'a');
    texto = texto.replaceAll('é', 'e');
    texto = texto.replaceAll('í', 'i');
    texto = texto.replaceAll('ó', 'o');
    texto = texto.replaceAll('ú', 'u');
    texto = texto.replaceAll('Á', 'A');
    texto = texto.replaceAll('É', 'E');
    texto = texto.replaceAll('Í', 'I');
    texto = texto.replaceAll('Ó', 'O');
    texto = texto.replaceAll('Ú', 'U');
    //texto = texto.replaceAll('ñ', 'ny');
    //texto = texto.replaceAll('Ñ', 'NY');
    //texto = texto.replaceAll('ü', 'u');
    //texto = texto.replaceAll('Ü', 'U');
    texto = texto.replaceAll('ç', 'c');
    texto = texto.replaceAll('Ç', 'C');
    texto = texto.replaceAll('à', 'a');
    texto = texto.replaceAll('è', 'e');
    texto = texto.replaceAll('ì', 'i');
    texto = texto.replaceAll('ò', 'o');
    texto = texto.replaceAll('ù', 'u');
    texto = texto.replaceAll('À', 'A');
    texto = texto.replaceAll('È', 'E');
    texto = texto.replaceAll('Ì', 'I');
    texto = texto.replaceAll('Ò', 'O');
    texto = texto.replaceAll('Ù', 'U');
    return texto;
  }

  String getTramosText(Tramo tramo) {
    String res = ('${tramo.estado}').replaceAll('Trafico.', '');
    if (!tramo.nombre.toString().contains('?')) {
      res = res.replaceAll('paso', '');
      res = res.replaceAll('Inferior', '');
      res = res.toUpperCase();
      res = res.contains('cortado') ? ' ESTA $res ' : ' TRAFICO $res ';
      res = "${tramo.nombre}$res";
      res = eliminaAcentos(res);
    } else {
      res = contaminacion!.getConsejosContaminacion().toUpperCase();
    }

    return res;
  }

  setTramosText() {
    setState(() {
      setTramosImage();

      if (tramos != null &&
          tramos!.isNotEmpty &&
          tramosTextIndex < tramos!.length) {
        tramosText = getTramosText(tramos![tramosTextIndex]);
      } else if (contaminacion != null) {
        tramosText = contaminacion!.getConsejosContaminacion().toUpperCase();
      } else {
        tramosText = "Cargando tramos...";
      }
      ampliaTramosTextList();
    });
  }

  setTramosImage() {
    setState(() {
      puede = false;
      if ((tramos != null &&
          tramos!.isNotEmpty &&
          tramosTextIndex < tramos!.length)) {
        if (!tramos![tramosTextIndex].nombre.contains('?')) {
          tramosImage = Image.asset(
            'MapMarkers/${tramos![tramosTextIndex].estado.toString()}Pin.png',
            fit: BoxFit.cover,
          );
          puede = true;
        }
      }
    });
  }

  ampliaTramosTextList() {
    if (tramosTextIndex == tramos!.length) {
      tramosTextIndex = 0;
    } else {
      tramosTextIndex++;
      if (primeraVez == 0) {
        tramosTextIndex = 0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var watcher = context.watch<AppProvider>();
    _trafico = watcher.tramos;
    getContaminacion();
    if (primeraVez == 0) {
      getTramosAndSetTimer();
      primeraVez++;
    }
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: (_trafico != null && _trafico!.isNotEmpty)
            ? Row(
                children: [
                  SizedBox(
                    width: size.width * 0.1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: _trafico!.isEmpty
                          ? Image.asset('picture_placeholder.png')
                          : puede
                              ? tramosImage!
                              : Container(),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    //width: size.width * 0.55,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors:  [
                            Color.fromARGB(255, 255, 163, 70),
                            Color.fromARGB(255, 255, 173, 91),
                            Color.fromARGB(255, 255, 177, 99),
                            Color.fromARGB(255, 255, 181, 107),
                            Color.fromARGB(255, 255, 185, 115),
                            Color.fromARGB(255, 255, 193, 131),
                            Color.fromARGB(255, 255, 185, 115),
                            Color.fromARGB(255, 255, 181, 107),
                            Color.fromARGB(255, 255, 177, 99),
                            Color.fromARGB(255, 255, 173, 91),
                            Color.fromARGB(255, 255, 163, 70),
                          ],
                        )),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: size.width * 0.5,
                          ),
                          child: SingleChildScrollView(
                            child: (_trafico != null && _trafico!.isNotEmpty)
                                ? Text(
                                    '$tramosText',
                                    softWrap: true,
                                    maxLines: 4,
                                  )
                                : const Text("Cargando tramos..."),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Container(
                decoration: const BoxDecoration(
                color: Colors.transparent,
              )));
  }
}
