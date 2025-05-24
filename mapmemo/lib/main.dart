import 'package:flutter/material.dart';
import 'homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MapMemo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),  // Appelle la nouvelle HomePage
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE4E1),
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MapPage()),
            );
          },
          child: Text(
            'MapMemo',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
              letterSpacing: 4,
              shadows: [
                Shadow(
                  blurRadius: 6,
                  color: Colors.deepPurpleAccent.withOpacity(0.6),
                  offset: const Offset(3, 3),
                ),
              ],
              fontFamily: 'Roboto',
            ),
          ),
        ),
      ),
    );
  }
}
