import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MapMemoApp());
}

class MapMemoApp extends StatelessWidget {
  const MapMemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Set<Marker> _markers = {};
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(43.7102, 7.2620);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _addMemoryDialog() async {
    String title = '';
    String description = '';

    await showDialog(
      context: context,
      builder: (context) {
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
              child: const Text('Annuler'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Ajouter'),
              onPressed: () async {
                final location = await mapController.getLatLng(
                  ScreenCoordinate(x: 200, y: 300),
                );

                setState(() {
                  _markers.add(
                    Marker(
                      markerId: MarkerId(DateTime.now().toString()),
                      position: location,
                      infoWindow: InfoWindow(title: title, snippet: description),
                    ),
                  );
                });

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MapMemo'),
        backgroundColor: Colors.teal,
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: _markers,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMemoryDialog,
        tooltip: 'Ajouter un souvenir',
        child: const Icon(Icons.add),
      ),
    );
  }
}

