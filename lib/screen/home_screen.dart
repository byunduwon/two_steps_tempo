import 'package:flutter/material.dart';
import 'package:two_steps_metronome/const/colors.dart';

class HomeScreen extends StatelessWidget {
  final int vol;
  final int firstBPM;
  final int firstTimes;
  final int secondBPM;
  final int secondTimes;
  final bool playState;

  final ValueChanged<bool> playChanged;
  final ValueChanged<int> volumeChangeEnd;
  final ValueChanged<double> volumeSliderChange;

  final String imagePath;

  const HomeScreen({
    required this.vol,
    required this.firstBPM,
    required this.firstTimes,
    required this.secondBPM,
    required this.secondTimes,
    required this.playState,
    super.key,
    required this.imagePath,
    required this.playChanged,
    required this.volumeChangeEnd,
    required this.volumeSliderChange,
  });

  @override
  Widget build(BuildContext contex) {
    return Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            SizedBox(height: 32.0),
            Container(
              child: Image.asset(
                imagePath,
                height: 200,
                //color: Colors.blue,
              ),
              color: Colors.yellow,
            ),
            SizedBox(height: 32.0),
            Text(
              '1st step : speed: ${firstBPM}, times: ${firstTimes}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20.0,
              ),
            ),
            Text(
              '2nd step : speed: ${secondBPM}, times: ${secondTimes}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 20.0),
            Column(
              children: [
                const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Row(
                      children: [
                        Text(
                          'volume',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    )),
                Slider(
                  value: vol.toDouble(),
                  min: 0,
                  max: 100,
                  divisions: 100,
                  label: vol.toStringAsFixed(0),
                  onChangeEnd: (val) {
                    volumeChangeEnd(vol);
                  },
                  onChanged: (val) {
                    volumeSliderChange(val);
                  },
                ),
              ],
            ),
            SizedBox(height: 32.0),
            OutlinedButton(
              onPressed: () {
                playChanged(playState);
              },
              child: Icon(playState ? Icons.pause : Icons.play_arrow),
            )
          ],
        ));
  }
}
