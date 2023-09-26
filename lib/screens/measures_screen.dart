import 'package:bmi/screens/result_screen.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import '../data/bmi_standards.dart';

class MeasurementScreen extends StatefulWidget {
  const MeasurementScreen({Key? key}) : super(key: key);

  @override
  State<MeasurementScreen> createState() => _MeasurementScreenState();
}

class _MeasurementScreenState extends State<MeasurementScreen> {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  void _dialog() {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text(
            'Invalid input, enter Your weight in kilograms and height in meters'),
      ),
    );
  }

  String bmiStatus = '';

  String getBMIStatus(int bmi) {
    resultStatusMap;

    for (var entry in resultStatusMap.entries) {
      if (bmi <= entry.key) {
        bmiStatus = entry.value;
        break;
      } else {
        bmiStatus = 'Severe obese (Obese class III)';
      }
    }
    return bmiStatus;
  }

  void _onSubmit() {
    final savedWeight = num.tryParse(_weightController.text);
    final savedHeight = num.tryParse(_heightController.text);
    final invalidMeasurements = savedWeight == null ||
        savedWeight <= 0 ||
        savedHeight == null ||
        savedHeight <= 0 ||
        savedHeight >= 2.5;
    if (invalidMeasurements) {
      _dialog();
    } else {
      final poweredHeight = pow(savedHeight, 2);
      final result = (savedWeight / poweredHeight).round();
      String bmiStatus = getBMIStatus(result);

      Navigator.of(context)
          .push(
        MaterialPageRoute(
          builder: (context) => Result(
            result: result.toString(),
            description: bmiStatus,
          ),
        ),
      )
          .then((value) {
        _weightController.clear();
        _heightController.clear();
      });
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your measurements'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      label: Text('Your weight'),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 50,
                  child: Text('kg'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: _heightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      label: Text('Your hight'),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 50,
                  child: Text(
                    'meters',
                    textAlign: TextAlign.end,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _onSubmit,
                  child: const Text('Submit'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
