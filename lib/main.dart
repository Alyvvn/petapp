

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Your Pet";
  int happinessLevel = 50;
  int hungerLevel = 50;
  int energyLevel = 100;

  void _playWithPet() {
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      energyLevel = (energyLevel - 10).clamp(0, 100);
    });
  }

  void _feedPet() {
    setState(() {
      hungerLevel = (hungerLevel - 15).clamp(0, 100);
      energyLevel = (energyLevel + 5).clamp(0, 100);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Digital Pet")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Name: $petName"),
            Text("Happiness: $happinessLevel"),
            Text("Hunger: $hungerLevel"),
            Text("Energy: $energyLevel"),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _playWithPet,
              child: Text("Play with Pet"),
            ),
            ElevatedButton(
              onPressed: _feedPet,
              child: Text("Feed Pet"),
            ),
          ],
        ),
      ),
    );
  }
}
