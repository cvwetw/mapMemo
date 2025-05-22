import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mapmemo')),
      body: const GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(48.8566, 2.3522),
          zoom: 12,
        ),
      ),
    );
  }
}
