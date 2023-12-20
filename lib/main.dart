import 'package:flutter/material.dart';
import 'package:tic_tac_toe_ai_version/screens/start_screen.dart';

void main() {
  var app = Application();
  runApp(app);
}

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StartScreen(),
    );
  }
}
