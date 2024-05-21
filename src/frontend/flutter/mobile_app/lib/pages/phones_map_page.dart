import 'package:common/constants.dart';
import 'package:common/models/categoria.dart';
import 'package:common/providers/app_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mobile_app/widgets/barra_busqueda.dart';
import 'package:provider/provider.dart';
import '../widgets/phones_map.dart';

class PhonesMapPage extends StatefulWidget {
  const PhonesMapPage({super.key});

  @override
  State<PhonesMapPage> createState() => _PhonesMapPageState();
}

class _PhonesMapPageState extends State<PhonesMapPage> {
  bool _showStyleBar = false;
  bool _showFilterBar = false;

  IconData selectedMode =
      SchedulerBinding.instance.platformDispatcher.platformBrightness == Brightness.light ? Icons.light_mode : Icons.dark_mode;
  String mapboxStyle = SchedulerBinding.instance.platformDispatcher.platformBrightness == Brightness.light
      ? MapboxStyles.STANDARD
      : MapboxStyles.DARK;
  List<bool> _categoriasSelected = List.filled(7,false);
 

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var watcher = context.watch<AppProvider>();
    List<Categoria>? categorias = watcher.categorias;

    return Scaffold(
      body: Stack(
        children: [
          watcher.estaCargando
              ? const Center(child: CircularProgressIndicator())
              : PhonesMap(
                  mapboxStyle: mapboxStyle,
                ),
          Column(
            children: [
              const Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: SafeArea(child: BarraBusqueda())),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Material(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      child: IconButton(
                          onPressed: () => {
                                setState(() {
                                  _showStyleBar = !_showStyleBar;
                                })
                              },
                          icon: Icon(selectedMode)),
                    ),
                    _showStyleBar
                        ? Row(
                          children: [
                            ElevatedButton(
                                onPressed: () => {
                                      setState(() {
                                        _showStyleBar = !_showStyleBar;
                                        mapboxStyle = MapboxStyles.STANDARD;
                                        watcher.setTheme(ThemeMode.light);
                                        selectedMode = Icons.light_mode;
                                      })
                                    },
                                child: const Column(
                                  children: [
                                    Icon(Icons.light_mode),
                                    //Text("LIGHT")
                                  ],
                                )),
                            ElevatedButton(
                                onPressed: () => {
                                      setState(() {
                                        _showStyleBar = !_showStyleBar;
                                        mapboxStyle = MapboxStyles.DARK;
                                       watcher.setTheme(ThemeMode.dark);
                                        selectedMode = Icons.dark_mode;
                                      })
                                    },
                                child: const Column(
                                  children: [
                                    Icon(Icons.dark_mode),
                                    //Text("DARK")
                                  ],
                                )),
                            ElevatedButton(
                                onPressed: () => {
                                      setState(() {
                                        _showStyleBar = !_showStyleBar;
                                        mapboxStyle = MapboxStyles.SATELLITE;
                                        watcher.setTheme(ThemeMode.light);
                                        selectedMode = Icons.satellite_rounded;
                                      })
                                    },
                                child: const Column(
                                  children: [
                                    Icon(Icons.satellite_rounded),
                                    //Text("SATELLITE")
                                  ],
                                )),
                          ],
                        )
                        : const Text(""),
                  ],
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.all(10.0),
                  //   child: Material(
                  //       color: Theme.of(context).cardColor,
                  //       borderRadius: BorderRadius.circular(12),
                  //       child: IconButton(
                  //           onPressed: () => {},
                  //           icon: const Icon(Icons.location_searching_rounded)),
                  //     ),
                  // ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
