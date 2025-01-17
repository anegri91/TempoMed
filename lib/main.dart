import 'package:flutter/material.dart';
import 'progress_bar_screen.dart';

void main() {
  runApp(TempoMedApp());
}

class TempoMedApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tempo Med',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ProgressBarScreen(),
    );
  }
}
