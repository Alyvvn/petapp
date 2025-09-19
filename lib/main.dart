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
  // Pet State variables
  String petName = "Your Pet";
  int happinessLevel = 50;
  int hungerLevel = 50;
  int energyLevel = 100;
  String petMoodText = "Neutral";
  Color petColor = Colors.green;

  // Win/Loss variables
  bool gameWon = false;
  bool gameLost = false;
  Timer? _hungerTimer;
  Timer? _winTimer;
  Duration happinessDuration = Duration.zero;

  TextEditingController petNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startHungerTimer();
  }

  @override
  void dispose() {
    _hungerTimer?.cancel();
    _winTimer?.cancel();
    super.dispose();
  }

  // Hunger increases over time
  void _startHungerTimer() {
    _hungerTimer = Timer.periodic(Duration(seconds: 15), (timer) {
      _updateHunger();
    });
  }

  // --- Pet Actions ---
  void _playWithPet() {
    if (gameWon || gameLost) return;
    setState(() {
      happinessLevel += 10;
      energyLevel -= 5;
      _updatePetState();
    });
  }

  void _feedPet() {
    if (gameWon || gameLost) return;
    setState(() {
      hungerLevel -= 10;
      energyLevel += 5;
      _updatePetState();
    });
  }

  //  State Updates
  void _updatePetState() {
    // Clamp values between 0 and 100
    happinessLevel = happinessLevel.clamp(0, 100);
    hungerLevel = hungerLevel.clamp(0, 100);
    energyLevel = energyLevel.clamp(0, 100);

    _updateHappiness();
    _setColor();
    _setMood();
    _checkWinCondition();
    _checkLossCondition();
  }

  void _updateHappiness() {
    if (hungerLevel > 70) {
      happinessLevel -= 10;
    }
    if (energyLevel < 20) {
      happinessLevel -= 5;
    }
  }

  void _updateHunger() {
    setState(() {
      hungerLevel += 5;
      if (hungerLevel > 100) {
        hungerLevel = 100;
      }
      _updatePetState();
    });
  }

  void _setColor() {
    if (happinessLevel >= 70) {
      petColor = Colors.green;
    } else if (happinessLevel >= 30) {
      petColor = Colors.yellow;
    } else {
      petColor = Colors.red;
    }
  }

  void _setMood() {
    if (happinessLevel >= 70) {
      petMoodText = "Happy";
    } else if (happinessLevel >= 30) {
      petMoodText = "Neutral";
    } else {
      petMoodText = "Sad";
    }
  }

  //  Win/Loss Logic 
  void _checkWinCondition() {
    if (happinessLevel >= 80) {
      // Start or continue win timer
      _winTimer ??= Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          happinessDuration += Duration(seconds: 1);
          if (happinessDuration.inSeconds >= 180) {
            gameWon = true;
            _winTimer?.cancel();
          }
        });
      });
    } else {
      // Reset if happiness drops
      _winTimer?.cancel();
      _winTimer = null;
      happinessDuration = Duration.zero;
    }
  }

  void _checkLossCondition() {
    if (hungerLevel == 100 && happinessLevel <= 10) {
      setState(() {
        gameLost = true;
      });
    }
  }

  void _setPetName() {
    setState(() {
      petName = petNameController.text.isNotEmpty
          ? petNameController.text
          : "Your Pet";
    });
  }

  void _restartGame() {
    setState(() {
      // Reset 
      petName = "Your Pet";
      happinessLevel = 50;
      hungerLevel = 50;
      energyLevel = 100;
      petMoodText = "Neutral";
      petColor = Colors.green;
      gameWon = false;
      gameLost = false;
      happinessDuration = Duration.zero;
      _winTimer?.cancel();
      _winTimer = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet'),
        backgroundColor: petColor,
      ),
      body: Center(
        child: gameWon
            ? _buildWinScreen()
            : gameLost
                ? _buildLossScreen()
                : _buildPetScreen(),
      ),
    );
  }

//win loss screens
  Widget _buildWinScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("🎉 You Win! 🎉",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        SizedBox(height: 20),
        Text("$petName stayed happy for 3 minutes straight!",
            style: TextStyle(fontSize: 20)),
        SizedBox(height: 40),
        ElevatedButton(
          onPressed: _restartGame,
          child: Text("Restart Game"),
        )
      ],
    );
  }

  Widget _buildLossScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("💀 Game Over 💀",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        SizedBox(height: 20),
        Text("$petName got too hungry and sad...",
            style: TextStyle(fontSize: 20)),
        SizedBox(height: 40),
        ElevatedButton(
          onPressed: _restartGame,
          child: Text("Restart Game"),
        )
      ],
    );
  }

  Widget _buildPetScreen() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          petName == "Your Pet"
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: petNameController,
                        decoration: InputDecoration(
                          hintText: 'Enter Pet Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _setPetName,
                        child: Text('Set Pet Name'),
                      ),
                    ],
                  ),
                )
              : Container(),

          // Stats
          Text("Name: $petName", style: TextStyle(fontSize: 20.0)),
          SizedBox(height: 10),
          Text("Happiness: $happinessLevel", style: TextStyle(fontSize: 20.0)),
          SizedBox(height: 10),
          Text("Hunger: $hungerLevel", style: TextStyle(fontSize: 20.0)),
          SizedBox(height: 10),
          Text("Energy: $energyLevel", style: TextStyle(fontSize: 20.0)),
          SizedBox(height: 10),
          Text("Mood: $petMoodText", style: TextStyle(fontSize: 20.0)),
          SizedBox(height: 10),
          Text("Happy Streak: ${happinessDuration.inSeconds}s",
              style: TextStyle(fontSize: 16, color: Colors.blueGrey)),

          SizedBox(height: 20),

          Container(
            width: 200,
            height: 200,
            color: petColor,
            child: Image.network(
              'https://i.imgur.com/QwhZRyL.png',
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 30),

          ElevatedButton(
            onPressed: _playWithPet,
            child: Text('Play with Your Pet'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _feedPet,
            child: Text('Feed Your Pet'),
          ),
        ],
      ),
    );
  }
}
