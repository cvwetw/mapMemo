import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
  final LatLng _center = const LatLng(43.7102, 7.2620); // Nice

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _loadMemories();
  }

  void _loadMemories() async {
    final snapshots = await FirebaseFirestore.instance.collection('souvenirs').get();
    final loadedMarkers = snapshots.docs.map((doc) {
      final data = doc.data();
      return Marker(
        markerId: MarkerId(doc.id),
        position: LatLng(data['lat'], data['lng']),
        infoWindow: InfoWindow(title: data['title'], snippet: data['description']),
      );
    }).toSet();

    setState(() {
      _markers = loadedMarkers;
    });
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
                final location = await mapController.getLatLng(ScreenCoordinate(x: 200, y: 300));

                await FirebaseFirestore.instance.collection('souvenirs').add({
                  'title': title,
                  'description': description,
                  'lat': location.latitude,
                  'lng': location.longitude,
                  'timestamp': FieldValue.serverTimestamp(),
                });

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
          zoom: 13.0,
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
