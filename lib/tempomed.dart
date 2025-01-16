import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(TempoMedApp());
}

class TempoMedApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tempo Med',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: ProgressBarScreen(),
    );
  }
}

class ProgressBarScreen extends StatefulWidget {
  @override
  _ProgressBarScreenState createState() => _ProgressBarScreenState();
}

class _ProgressBarScreenState extends State<ProgressBarScreen> {
  late Timer _timer;
  late Duration _remainingTime;
  double _progress = 0.0;

  final DateTime startDate = DateTime(2022, 1, 1, 12, 0);
  final DateTime endDate = DateTime(2027, 12, 31, 23, 59);

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      if (now.isAfter(endDate)) {
        timer.cancel();
        setState(() {
          _remainingTime = Duration.zero;
          _progress = 1.0;
        });
      } else {
        final totalDuration = endDate.difference(startDate).inSeconds;
        final elapsedDuration = now.difference(startDate).inSeconds;

        setState(() {
          _remainingTime = endDate.difference(now);
          _progress = elapsedDuration / totalDuration;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final years = duration.inDays ~/ 365;
    final months = (duration.inDays % 365) ~/ 30;
    final days = (duration.inDays % 365) % 30;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    return '${years}anos ${months}meses ${days}dias ${hours}h ${minutes}m ${seconds}s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Tempo Med',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'FCM-PB Turma XXXVI',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '#VemCRM',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              _formatDuration(_remainingTime),
              style: TextStyle(
                  fontSize: 24, color: const Color.fromARGB(255, 24, 114, 3)),
            ),
            SizedBox(height: 16),
            LinearProgressIndicator(
              value: _progress,
              minHeight: 10,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                  const Color.fromARGB(255, 24, 114, 3)),
            ),
            SizedBox(height: 8),
            Text('${(_progress * 100).toStringAsFixed(2)}%',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
