import 'package:common/providers/app_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:common/models/evento.dart';

class Carousel extends StatefulWidget {
  const Carousel({super.key});

  @override
  State<Carousel> createState() => _MyCarouselState();
}

class _MyCarouselState extends State<Carousel> {
  static const int segundosCarousel = 10;

  List<Evento>? _eventos;

  int _index = 0;
  final dependenciaDeSize = 5.9;

  @override
  void initState() {
    super.initState();
  }

  String distanciaToString(double distanciaEnKm) {
    if (distanciaEnKm < 1) {
      return "${(distanciaEnKm * 1000).round()} m";
    } else {
      return "${(distanciaEnKm * 10).round() / 10} km";
    }
  }

  CarouselController _onCarouselCreated(CarouselController controller) {
    controller = controller;
    return controller;
  }

  @override
  Widget build(BuildContext context) {
    var watcher = context.watch<AppProvider>();
    _eventos = watcher.eventos;

    final Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ScrollCaroussel(context),
        funcionCarrousel(context, size),
      ],
    );
  }

  Widget ScrollCaroussel(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.02,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < _eventos!.length; i++)
            Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.005),
                child: (i != _index)
                    ? Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey,
                          border: Border.all(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            width: 1.0,
                          ),
                        ),
                      )
                    : Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      )),
        ],
      ),
    );
  }

  double withEnFuncionCarrousel() {
    double max = 0;
    for (var evento in _eventos!) {
      if (evento.titulo.length > max) {
        max = evento.titulo.length * 1.0;
      }
    }
    return max;
  }

  Widget funcionCarrousel(BuildContext context, Size size) {
    return Container(
      constraints: BoxConstraints(
        minWidth: size.width * 0.3,
        maxWidth: size.width * 1,
      ),
        height: size.height * 0.13,
        width: size.width * 0.60,
        child: CarouselSlider(
          options: CarouselOptions(
            viewportFraction: 1,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: segundosCarousel),
            //aspectRatio: 19 / 9,
            enlargeFactor: 1,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {

              if (_eventos!.isNotEmpty) {
                setState((){
                _index = index;
              });
              Provider.of<AppProvider>(context, listen: false).setIndiceEvento(_index);
              }
              
            },
          ),
          carouselController: _onCarouselCreated(CarouselController()),
          items: _eventos!.map((evento) {
            return Builder(
              builder: (BuildContext context) {
                return Material(
                  clipBehavior: Clip.hardEdge,
                  elevation: 2,
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).cardColor,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: evento.imagen == null
                                ? Image.asset('picture_placeholder.png')
                                : Image.memory(evento.imagen!,
                                    fit: BoxFit.fitHeight),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            
                            child: SingleChildScrollView(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    
                                    Text(
                                      evento.titulo,
                                      maxLines: 3,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      locale: const Locale('es', 'ca'),
                                      style: const TextStyle(fontSize: 20.0),
                                    ),
                                    Text(distanciaToString(evento.distancia!))
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ));
  }
}
