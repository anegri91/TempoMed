import 'package:flutter/material.dart';
import 'dart:async';

class ProgressBarScreen extends StatefulWidget {
  @override
  _ProgressBarScreenState createState() => _ProgressBarScreenState();
}

class _ProgressBarScreenState extends State<ProgressBarScreen> {
  late Timer _timer;
  Duration _remainingTime = Duration.zero;
  double _mainProgress = 0.0;
  List<double> _yearlyProgress = [1.0, 1.0, 1.0, 0.0, 0.0, 0.0];

  final DateTime startDate = DateTime(2022, 1, 1, 0, 0);
  final DateTime endDate = DateTime(2027, 12, 31, 23, 59);

  @override
  void initState() {
    super.initState();

    // Initialize _remainingTime immediately
    _remainingTime = endDate.difference(DateTime.now());
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      if (now.isAfter(endDate)) {
        timer.cancel();
        setState(() {
          _remainingTime = Duration.zero;
          _mainProgress = 1.0;
        });
      } else {
        final totalDuration = endDate.difference(startDate).inSeconds;
        final elapsedDuration = now.difference(startDate).inSeconds;
        final currentYear = now.year;
        final yearIndex = currentYear - 2022;
        final yearStart = DateTime(currentYear, 1, 1, 0, 0);
        final yearEnd = DateTime(currentYear + 1, 1, 1, 0, 0);
        final yearDuration = yearEnd.difference(yearStart).inSeconds;
        final yearElapsed = now.difference(yearStart).inSeconds;

        setState(() {
          _remainingTime = endDate.difference(now);
          _mainProgress = elapsedDuration / totalDuration;

          for (int i = 0; i < _yearlyProgress.length; i++) {
            if (i < yearIndex) {
              _yearlyProgress[i] = 1.0; // Completed years
            } else if (i == yearIndex) {
              _yearlyProgress[i] = yearElapsed / yearDuration; // Current year
            } else {
              _yearlyProgress[i] = 0.0; // Future years
            }
          }
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

    return '${years}y ${months}m ${days}d ${hours}h ${minutes}m ${seconds}s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Tempo Med | FCMPB Turma XXXVI'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Main Countdown Progress Bar
            Text(
              '#VemCRM',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              _formatDuration(_remainingTime),
              style: TextStyle(fontSize: 24, color: Colors.blue),
            ),
            SizedBox(height: 16),
            LinearProgressIndicator(
              value: _mainProgress,
              minHeight: 10,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            SizedBox(height: 8),
            Text(
              '${(_mainProgress * 100).toStringAsFixed(2)}%',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            // Yearly Progress Bars
            Text(
              'Progresso Anual',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ..._yearlyProgress.asMap().entries.map((entry) {
              int year = 2022 + entry.key;
              double progress = entry.value;
              return Column(
                children: [
                  Text(
                    '$year',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(progress == 1.0
                        ? Colors.green
                        : progress > 0.0
                            ? Colors.blue
                            : Colors.grey),
                  ),
                  SizedBox(height: 16),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
