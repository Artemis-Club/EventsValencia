import 'dart:async';
import 'package:common/models/evento.dart';
import 'package:common/providers/app_provider.dart';
import 'package:common/services/api_service.dart';
import 'package:events_valencia_flutter/widgets/contaminacionWidget.dart';
import 'package:events_valencia_flutter/widgets/info.dart';
import 'package:events_valencia_flutter/widgets/street_screen_map.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:common/widgets/climawidget.dart';
import '../widgets/carrusel.dart';

class StreetScreenHomePage extends StatefulWidget {
  const StreetScreenHomePage({super.key, required this.title});

  final String title;

  @override
  State<StreetScreenHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<StreetScreenHomePage> {
  static const double radioBusqueda = 1;
  final apiService = ApiService();
  List<Evento>? _eventos;

  @override
  void initState() {
    super.initState();

    // Get location and update coordinates
    _getLocation().then(_getMapInfo);
  }

  void _getMapInfo(pos) {
    if (pos != null) {
      Provider.of<AppProvider>(context, listen: false)
            .fetchMapInfoByRadius(pos, radioBusqueda);
            
      Timer.periodic(const Duration(seconds: 30), (timer) {
        Provider.of<AppProvider>(context, listen: false)
            .fetchMapInfoByRadius(pos, radioBusqueda);
      });
    }
  }

  Future<Position?> _getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      return await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.best)
          .then((pos) {
        return pos;
      });
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var watcher = context.watch<AppProvider>();
    final Size size = MediaQuery.of(context).size;
    return Container(
      // decoration: const BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage('TorresSerranodesenfocque18.png'),
      //     fit: BoxFit.cover,
      //   ),
      // ),
      child: Scaffold(
        body: SizedBox(
          child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Stack(clipBehavior: Clip.none, children: [
                watcher.estaCargando
                    ? const Center(child: CircularProgressIndicator())
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: const StreetScreenMap()),
                if (!watcher.estaCargando)
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              alignment: Alignment.topLeft,
                              child: const Info(),
                            ),
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClimaWidget(),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Colors.green,
                                        Colors.yellow,
                                        Colors.red
                                      ],
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(3),
                                  child: const Text(
                                    'Indice de contaminación',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                ContaminacionWidget()
                              ]),
                        ],
                      ),
                      const Spacer(),
                      if (!watcher.estaCargando)
                        Container(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: const Carousel(),
                        )
                    ],
                  ),
                ),
              ])),
        ),
      ),
    );
  }
}
