import 'package:flutter/material.dart';
import 'dart:async';

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
  Timer? _hungerTimer;

  // New mood system
  Color petColor = Colors.green;
  String petMoodText = "Neutral";

  @override
  void initState() {
    super.initState();
    _startHungerTimer();
    _updatePetState();
  }

  @override
  void dispose() {
    _hungerTimer?.cancel();
    super.dispose();
  }

  void _startHungerTimer() {
    _hungerTimer = Timer.periodic(Duration(seconds: 15), (timer) {
      setState(() {
        hungerLevel = (hungerLevel + 5).clamp(0, 100);
        _updatePetState();
      });
    });
  }

  void _playWithPet() {
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      energyLevel = (energyLevel - 10).clamp(0, 100);
      hungerLevel = (hungerLevel + 5).clamp(0, 100); // playing makes pet hungry
      _updatePetState();
    });
  }

  void _feedPet() {
    setState(() {
      hungerLevel = (hungerLevel - 15).clamp(0, 100);
      energyLevel = (energyLevel + 5).clamp(0, 100);
      _updatePetState();
    });
  }

  void _updatePetState() {
    // Adjust happiness based on hunger
    if (hungerLevel > 70) {
      happinessLevel = (happinessLevel - 10).clamp(0, 100);
    } else if (hungerLevel < 30) {
      happinessLevel = (happinessLevel + 5).clamp(0, 100);
    }

    // Mood rules
    if (happinessLevel >= 70 && energyLevel > 30) {
      petMoodText = "Happy";
      petColor = Colors.green;
    } else if (happinessLevel >= 30 && energyLevel > 20) {
      petMoodText = "Neutral";
      petColor = Colors.yellow;
    } else {
      petMoodText = "Sad";
      petColor = Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Digital Pet"),
        backgroundColor: petColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Name: $petName"),
            Text("Happiness: $happinessLevel"),
            Text("Hunger: $hungerLevel"),
            Text("Energy: $energyLevel"),
            SizedBox(height: 16),
            Text("Mood: $petMoodText"),
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
