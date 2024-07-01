import 'package:flutter/material.dart';
import 'package:two_steps_metronome/const/colors.dart';

class HomeScreen extends StatelessWidget {
  final int firstBPM;
  final int firstTimes;
  final int secondBPM;
  final int secondTimes;
  final int setsNumber;

  final ValueChanged<double> firstBPMChanged;
  final ValueChanged<int> firstTimesChanged;
  final ValueChanged<double> secondBPMChanged;
  final ValueChanged<int> secondTimesChanged;
  final ValueChanged<int> setsNumberChanged;

  const HomeScreen({
    required this.firstBPM,
    required this.firstTimes,
    required this.secondBPM,
    required this.secondTimes,
    required this.setsNumber,
    Key? key,
    required this.firstBPMChanged,
    required this.firstTimesChanged,
    required this.secondBPMChanged,
    required this.secondTimesChanged,
    required this.setsNumberChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext contex) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Image.asset(
            'assets/metronome-left.png',
            height: 200,
            //color: Colors.blue,
          ),
        ),
        SizedBox(height: 32.0),
        Text(
          firstBPM.toString(),
          style: TextStyle(
            color: primaryColor,
            fontSize: 60.0,
            fontWeight: FontWeight.w200,
          ),
        ),
        Text(
          '설정 스크린',
          style: TextStyle(
            color: Colors.white,
            fontSize: 50,
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              children: [
                Text('volume',
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            )
        ),
        Slider(
          min: 0.1,
          max: 60.0,
          divisions: 101,
          value: firstBPM.toDouble(),
          onChanged: firstBPMChanged,
          label: firstBPM.toStringAsFixed(1),
        ),
      ],
    );
  }
}
