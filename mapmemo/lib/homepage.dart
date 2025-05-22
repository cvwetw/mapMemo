import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  LatLng _initialPosition = const LatLng(48.8566, 2.3522);

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _handleTap(LatLng tappedPoint) {
    showDialog(
      context: context,
      builder: (context) {
        String title = '';
        String description = '';

        return AlertDialog(
          title: const Text('Ajouter un souvenir'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Titre'),
                onChanged: (value) => title = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Description'),
                onChanged: (value) => description = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                if (title.isNotEmpty) {
                  setState(() {
                    _markers.add(
                      Marker(
                        markerId: MarkerId(
                          tappedPoint.toString(),
                        ), // ID unique selon la position
                        position: tappedPoint,
                        infoWindow: InfoWindow(
                          title: title,
                          snippet: description,
                        ),
                      ),
                    );
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mapmemo')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 12,
        ),
        markers: _markers,
        onMapCreated: _onMapCreated,
        onTap: _handleTap,
      ),
    );
  }
}
