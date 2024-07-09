import 'package:flutter/material.dart';
import 'package:two_steps_metronome/const/colors.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  final int firstBPM;
  final int firstTimes;
  final int secondBPM;
  final int secondTimes;

  final ValueChanged<int> firstBpmSetting;
  final ValueChanged<int> firstTimesSetting;
  final ValueChanged<int> secondBpmSetting;
  final ValueChanged<int> secondTimesSetting;
  final ValueChanged<int> init;
  final ValueChanged<int> dataSave;

  const SettingsScreen({
    required this.firstBPM,
    required this.firstTimes,
    required this.secondBPM,
    required this.secondTimes,
    Key? key,
    required this.firstBpmSetting,
    required this.firstTimesSetting,
    required this.secondBpmSetting,
    required this.secondTimesSetting,
    required this.init,
    required this.dataSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext contex) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Settings',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: SpinBox(
            min: 1,
            max: 120,
            value: firstBPM.toDouble(),
            onChanged: (value) {
              firstBpmSetting(value.toInt());
            },
            decoration: InputDecoration(labelText: '1st speed (BPM: 1~120)'),
          ),
        ),
        // first times setting
        Padding(
          padding: const EdgeInsets.all(16),
          child: SpinBox(
            min: 1,
            max: 240,
            value: firstTimes.toDouble(),
            onChanged: (value) {
              firstTimesSetting(value.toInt());
            },
            decoration: InputDecoration(labelText: '1st times(1~240)'),
          ),
        ),
        // 2nd BPM
        Padding(
          padding: const EdgeInsets.all(16),
          child: SpinBox(
            min: 1,
            max: 60,
            value: secondBPM.toDouble(),
            onChanged: (value) {
              secondBpmSetting(value.toInt());
            },
            decoration: InputDecoration(labelText: '2nd speed (BPM:1~60)'),
          ),
        ),
        // 2nd times
        Padding(
          padding: const EdgeInsets.all(16),
          child: SpinBox(
            min: 0,
            max: 120,
            value: secondTimes.toDouble(),
            onChanged: (value) {
              secondTimesSetting(value.toInt());
            },
            decoration: InputDecoration(labelText: '2nd times(0~120)'),
          ),
        ),
        SizedBox(height: 32.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () {
                dataSave(firstBPM);
              },
                child: Text('save'),
            ),
            OutlinedButton(
              onPressed:  () {
                init(firstBPM);
              },
              child: Text('reset'),
            ),
          ],

        ),
      ],
    );
  }
}
