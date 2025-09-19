

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

  Color petColor = Colors.green;
  String petMoodText = "Neutral";

  TextEditingController petNameController = TextEditingController();

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

  void _setPetName() {
    setState(() {
      petName = petNameController.text.isNotEmpty
          ? petNameController.text
          : "Your Pet";
    });
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
      hungerLevel = (hungerLevel + 5).clamp(0, 100);
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
    if (hungerLevel > 70) {
      happinessLevel = (happinessLevel - 10).clamp(0, 100);
    } else if (hungerLevel < 30) {
      happinessLevel = (happinessLevel + 5).clamp(0, 100);
    }

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
            petName == "Your Pet"
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: petNameController,
                          decoration: InputDecoration(
                            hintText: "Enter Pet Name",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: _setPetName,
                          child: Text("Set Pet Name"),
                        ),
                      ],
                    ),
                  )
                : Container(),
            Text("Name: $petName"),
            Text("Happiness: $happinessLevel"),
            Text("Hunger: $hungerLevel"),
            Text("Energy: $energyLevel"),
            SizedBox(height: 16),
            Container(
              width: 200,
              height: 200,
              color: petColor,
              child: Image.network(
                "https://i.imgur.com/QwhZRyL.png",
                fit: BoxFit.contain,
              ),
            ),
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
