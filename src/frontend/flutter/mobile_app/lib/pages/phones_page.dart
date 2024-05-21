import 'package:common/models/notificacion.dart';
import 'package:common/services/api_service.dart';
import 'package:common/providers/app_provider.dart';
import './phones_notificaciones_page.dart';
import './phones_eventos_page.dart';
import './phones_map_page.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class PhonesHomePage extends StatefulWidget {
  const PhonesHomePage({super.key, required this.title});

  final String title;

  @override
  State<PhonesHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<PhonesHomePage> {
  static const double radioBusqueda = 10;
  final apiService = ApiService();
  Position? _posicionUsuario;
  late List<Notificacion> notificaciones;

  @override
  void initState() {
    super.initState();
    _getLocation().then(_getMapInfo);
  }

  void _getMapInfo(pos) async {
    if (pos != null) {
      Provider.of<AppProvider>(context, listen: false).fetchMapInfoByRadius(pos, radioBusqueda);
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
          _posicionUsuario = pos;
        return pos;
      });
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var watcher = context.watch<AppProvider>();

    var index = watcher.indiceNavegacion;

    void setIndex(index) {
    watcher.setIndiceNavegacion(index);
      if(watcher.bottomSeetOpened){
      Navigator.of(context).pop();
      watcher.setBottomSheetOpened(false);
    }
  }



    return Scaffold(
      body: 
      
      RefreshIndicator(
        onRefresh: () {
          if (_posicionUsuario == null) return Future(() => null);
          return watcher.fetchMapInfoByRadius(_posicionUsuario!, radioBusqueda);//apiService.getEventsByRadius(39, 1, 1000).then((value) => watcher.setEventos(value));
        },
        child: IndexedStack(
            index: index,
            children: [
              watcher.estaCargando
              ? const Center(child: CircularProgressIndicator())
              : NotificationContainer(),
              const PhonesMapPage(),
              const PhonesEventosPage()
            ],
          ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: setIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications_none_rounded),
              activeIcon: Icon(Icons.notifications_rounded),
              label: "Notificaciones"),
              BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined),
              activeIcon: Icon(Icons.map_sharp),
              label: "Mapa"),
              BottomNavigationBarItem(
              icon: Icon(Icons.view_agenda_outlined),
              activeIcon: Icon(Icons.view_agenda_rounded),
              label: "Eventos")
        ],
      ),
    );
  }
}
