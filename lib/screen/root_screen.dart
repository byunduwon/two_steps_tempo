import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:two_steps_metronome/screen/home_screen.dart';
import 'package:two_steps_metronome/screen/settings_screen.dart';
import 'package:two_steps_metronome/const/colors.dart';
import 'package:metronome/metronome.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> with TickerProviderStateMixin {
  TabController? controller;
  int firstBPM = 10, firstTimes = 6;
  int secondBPM = 5, secondTimes = 3;
  int setsNumber = 1;

  final _metronomePlugin = Metronome();
  bool isplaying = false;
  int bpm = 120;
  int vol = 50;
  String metronomeIcon = 'assets/metronome-left.png';
  String metronomeIconRight = 'assets/metronome-right.png';
  String metronomeIconLeft = 'assets/metronome-left.png';
  int firstCounter = 0;
  int secondCounter = 0;
  int setCounter = 0;
  int totalCounter = 0;

  final List wavs = [
    'base',
    'claves',
    'hihat',
    'snare',
    'sticks',
    'woodblock_high'
  ];

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
    controller!.addListener(tabListener);

    _metronomePlugin.init(
      'assets/audio/snare44_wav.wav',
      bpm: bpm,
      volume: vol,
      enableTickCallback: true,
    );
    _metronomePlugin.onListenTick((_) {
      if (kDebugMode) {
        print('tick');
      }
      totalCounter++;
      print('${totalCounter}-----${bpm}');

      if (totalCounter == 10) {
        bpm = 40;
        _metronomePlugin.setBPM(bpm);
      }

      setState(() {
        if (metronomeIcon == metronomeIconRight) {
          metronomeIcon = metronomeIconLeft;
        } else {
          metronomeIcon = metronomeIconRight;
        }
      });
    });
  }

  tabListener() {
    setState(() {});
  }

  @override
  dispose() {
    controller!.removeListener(tabListener);
    _metronomePlugin.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Two Steps Tempo Generator',
        style: TextStyle(
          color: Colors.black,
          fontSize: 25.0,
          fontWeight: FontWeight.w600,
        ),),
        centerTitle: true,
      ),
      body: TabBarView(
        controller: controller,
        children: renderChildren(),
      ),
      bottomNavigationBar: renderBottomNavigation(),
    );
  }

  List<Widget> renderChildren() {
    return [
      HomeScreen(
        firstBPM: firstBPM,
        firstTimes: firstTimes,
        secondBPM: secondBPM,
        secondTimes: secondTimes,
        setsNumber: setsNumber,
        playState: isplaying,
        firstBPMChanged: firstBPMChanged,
        firstTimesChanged: firstTimesChanged,
        secondBPMChanged: secondBPMChanged,
        secondTimesChanged: secondTimesChanged,
        setsNumberChanged: setsNumberChanged,
        imagePath: metronomeIcon,
        playChanged: playChanged,
      ),
      SettingsScreen(
        firstBPM: firstBPM,
        firstTimes: firstTimes,
        secondBPM: secondBPM,
        secondTimes: secondTimes,
        setsNumber: setsNumber,
        firstBPMChanged: firstBPMChanged,
        firstTimesChanged: firstTimesChanged,
        secondBPMChanged: secondBPMChanged,
        secondTimesChanged: secondTimesChanged,
        setsNumberChanged: setsNumberChanged,
      ),
    ];
  }

  void firstBPMChanged(double val1) {
    setState(() {
      firstBPM = val1.toInt();
    });
  }

  void firstTimesChanged(int time1) {
    setState(() {
      firstBPM = time1;
    });
  }

  void secondBPMChanged(double val2) {
    setState(() {
      secondBPM = val2.toInt();
    });
  }

  void secondTimesChanged(int time2) {
    setState(() {
      secondTimes = time2;
    });
  }

  void setsNumberChanged(int setNum) {
    setState(() {
      setsNumber = setNum;
    });
  }

  void playChanged(bool p_state) async {
    if (p_state) {
      _metronomePlugin.pause();
      isplaying = false;
    } else {
      //bpm = 40;
      //_metronomePlugin.setBPM(40);
      _metronomePlugin.setVolume(vol);
      _metronomePlugin.play(bpm);
      isplaying = true;
    }
    // int? bpm2 = await _metronomePlugin.getBPM();
    // print(bpm2);
    // int? vol2 = await _metronomePlugin.getVolume();
    // print(vol2);
    setState(() {});
  }

  BottomNavigationBar renderBottomNavigation() {
    return BottomNavigationBar(
      currentIndex: controller!.index,
      onTap: (int index) {
        setState(() {
          controller!.animateTo(index);
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.queue_music_rounded,
          ),
          label: 'start',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.settings,
          ),
          label: 'settings',
        ),
      ],
    );
  }
}
