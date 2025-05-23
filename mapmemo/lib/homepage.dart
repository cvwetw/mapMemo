import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class Souvenir {
  final String id;
  final String title;
  final String description;
  final LatLng position;
  final File? imageFile;

  Souvenir({
    required this.id,
    required this.title,
    required this.description,
    required this.position,
    this.imageFile,
  });
}

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController _mapController;
  final List<Souvenir> _souvenirs = [];
  LatLng _initialPosition = const LatLng(48.8566, 2.3522);

  final ImagePicker _picker = ImagePicker();

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> _handleTap(LatLng tappedPoint) async {
    String? title;
    String? description;
    File? imageFile;

    await showDialog(
      context: context,
      builder: (context) {
        final titleController = TextEditingController();
        final descriptionController = TextEditingController();

        return AlertDialog(
          title: const Text("Ajouter un souvenir"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Titre"),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: "Description"),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () async {
                    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      imageFile = File(pickedFile.path);
                      setState(() {});
                    }
                  },
                  icon: const Icon(Icons.photo),
                  label: const Text("Choisir une photo"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: () {
                title = titleController.text.trim();
                description = descriptionController.text.trim();
                if (title == null || title!.isEmpty) return;
                Navigator.pop(context);
              },
              child: const Text("Ajouter"),
            ),
          ],
        );
      },
    );

    if (title != null && title!.isNotEmpty) {
      setState(() {
        _souvenirs.add(
          Souvenir(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: title!,
            description: description ?? "",
            position: tappedPoint,
            imageFile: imageFile,
          ),
        );
      });
    }
  }

  void _showSouvenirDetails(Souvenir souvenir) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(souvenir.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(souvenir.description),
              const SizedBox(height: 8),
              souvenir.imageFile != null
                  ? Image.file(souvenir.imageFile!, height: 200)
                  : const Text("Aucune photo"),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Fermer"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final markers = _souvenirs.map((souvenir) {
      return Marker(
        markerId: MarkerId(souvenir.id),
        position: souvenir.position,
        onTap: () => _showSouvenirDetails(souvenir),
      );
    }).toSet();

    return Scaffold(
      appBar: AppBar(title: const Text('Mapmemo')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 12,
        ),
        onMapCreated: _onMapCreated,
        markers: markers,
        onTap: _handleTap,
      ),
    );
  }
}
