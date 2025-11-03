import 'package:flutter/material.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    _simulateLoading();
  }

  Future<void> _simulateLoading() async {
    // Simule le chargement effectif de la page principale
    for (int i = 0; i <= 100; i += 5) {
      await Future.delayed(Duration(milliseconds: 30));
      setState(() => progress = i / 100);
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('TravelApp', style: TextStyle(fontSize: 32, color: Colors.black)),
            SizedBox(height: 40),
            LinearProgressIndicator(
              value: progress,
              color: Colors.grey[900],
              backgroundColor: Colors.grey[200],
            ),
          ],
        ),
      ),
    );
  }
}
