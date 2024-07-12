import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:two_steps_metronome/screen/home_screen.dart';
import 'package:two_steps_metronome/screen/settings_screen.dart';
import 'package:two_steps_metronome/const/colors.dart';
import 'package:metronome/metronome.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> with TickerProviderStateMixin {
  TabController? controller;

  final player = AudioPlayer();

  int firstBPM = 60, firstTimes = 120;
  int secondBPM = 30, secondTimes = 60;
  double cymbalsVolume = 0.5;

  final _metronomePlugin = Metronome();
  bool isplaying = false;
  int bpm = 60;

  int vol = 50;
  String metronomeIcon = 'assets/metronome-left.png';
  String metronomeIconRight = 'assets/metronome-right.png';
  String metronomeIconLeft = 'assets/metronome-left.png';
  int _Counter = 0;

  /*
  final List wavs = [
    'base',
    'claves',
    'hihat',
    'snare',
    'sticks',
    'woodblock_high'
  ];
   */

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
    controller!.addListener(tabListener);

    // Calling of initial data
    initData();

    // Create the audio player.
    // Set the release mode to keep the source after playback has completed.
    //player.setReleaseMode(ReleaseMode.stop);

    // Start the player as soon as the app is displayed.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await player.setVolume(cymbalsVolume);
      await player.setSource(AssetSource('audio/drum.wav'));
      await player.resume();
    });

    _metronomePlugin.init(
      'assets/audio/snare44_wav.wav',
      bpm: firstBPM,
      volume: vol,
      enableTickCallback: true,
    );

    _metronomePlugin.onListenTick((_) {
      //bpm = firstBPM;

      if (kDebugMode) {
        print('tick');
      }

      ////////////////////////////
      setState(() {
        if (metronomeIcon == metronomeIconRight) {
          metronomeIcon = metronomeIconLeft;
        } else {
          metronomeIcon = metronomeIconRight;
        }
      });

      ////////////////////////////

      if (_Counter == 0) {
        bpm = firstBPM;
        _metronomePlugin.setBPM(bpm);
      }

      if (_Counter == firstTimes+1 && secondTimes != 0) {
        bpm = secondBPM;
        _metronomePlugin.setBPM(bpm);
        endPlay();
      }

      //확인용
      print('${_Counter}-----${bpm}');

      _Counter++;

      if (_Counter == (firstTimes + secondTimes+2) && secondTimes != 0) {
        _Counter = 0;
        endPlay();
      }
    });
  }

  tabListener() {
    setState(() {});
  }

  @override
  dispose() {
    controller!.removeListener(tabListener);
    _metronomePlugin.destroy();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Two Step Tempo Generator',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: TabBarView(
        controller: controller,
        children: renderChildren(),
      ),
        floatingActionButton: FloatingActionButton(
          onPressed:() {
            thisClosed();
          },
          child: const Icon(Icons.exit_to_app),
        ),
      bottomNavigationBar: renderBottomNavigation(),
    );
  }

  List<Widget> renderChildren() {
    return [
      HomeScreen(
        vol: vol,
        firstBPM: firstBPM,
        firstTimes: firstTimes,
        secondBPM: secondBPM,
        secondTimes: secondTimes,
        playState: isplaying,
        imagePath: metronomeIcon,
        playChanged: playChanged,
        volumeChangeEnd: volumeChangeEnd,
        volumeSliderChange: volumeSliderChange,
      ),
      SettingsScreen(
        firstBPM: firstBPM,
        firstTimes: firstTimes,
        secondBPM: secondBPM,
        secondTimes: secondTimes,
        firstBpmSetting: firstBpmSetting,
        firstTimesSetting: firstTimesSetting,
        secondBpmSetting: secondBpmSetting,
        secondTimesSetting: secondTimesSetting,
        init: init,
        dataSave: dataSave,
      ),
    ];
  }

  void playChanged(bool p_state) async {
    if (p_state) {
      _metronomePlugin.pause();
      isplaying = false;
    } else {
      _metronomePlugin.setVolume(vol);
      _metronomePlugin.play(bpm);
      isplaying = true;
    }
    setState(() {});
  }

  void volumeChangeEnd(int val) {
    _metronomePlugin.setVolume(val);
    cymbalsVolume = val.toDouble()/100.0;
    player.setVolume(cymbalsVolume);
  }

  void volumeSliderChange(double val) {
    vol = val.toInt();
    setState(() {});
  }

  void firstBpmSetting(int val) {
    firstBPM = val;
    setState(() {});
  }

  void firstTimesSetting(int val) {
    firstTimes = val;
    setState(() {});
  }

  void secondBpmSetting(int val) {
    secondBPM = val;
    setState(() {});
  }

  void secondTimesSetting(int val) {
    secondTimes = val;
    setState(() {});
  }

  void endPlay() async {
    player.play(AssetSource('audio/s.wav'));
    //await player.setSource(AssetSource('clock.mp3'));
  }

  void init(int val) {
    _Counter = val * 0;
    firstBPM = 60;
    firstTimes = 120;
    secondBPM = 30;
    secondTimes = 60;
    setState(() {});
  }

  /*
  void beginDataSave() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(
        'two steps',
        (firstBPM + 500).toString() +
            (firstTimes + 500).toString() +
            (secondBPM + 500).toString() +
            (secondTimes + 500).toString());
  }

  void beginDataRead() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? str = prefs.getString('two steps');

    firstBPM = int.parse(str!.substring(0, 3)) - 500;
    firstTimes = int.parse(str.substring(3, 6)) - 500;
    secondBPM = int.parse(str.substring(6, 9)) - 500;
    secondTimes = int.parse(str.substring(9, 12)) - 500;
  }
   */

  void initData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? str = prefs.getString('two steps');

    if (str == null) {
      await prefs.setString(
          'two steps',
          (firstBPM + 500).toString() +
              (firstTimes + 500).toString() +
              (secondBPM + 500).toString() +
              (secondTimes + 500).toString());
    } else {
      firstBPM = int.parse(str.substring(0, 3)) - 500;
      firstTimes = int.parse(str.substring(3, 6)) - 500;
      secondBPM = int.parse(str.substring(6, 9)) - 500;
      secondTimes = int.parse(str.substring(9, 12)) - 500;
    }
    setState(() {});
  }

  void dataSave(int val) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(
        'two steps',
        (firstBPM + 500).toString() +
            (firstTimes + 500).toString() +
            (secondBPM + 500).toString() +
            (secondTimes + 500).toString());
    setState(() {});
  }

  void thisClosed() {
    _metronomePlugin.pause();
    player.pause();
    SystemNavigator.pop();
  }





  BottomNavigationBar renderBottomNavigation() {
    return BottomNavigationBar(
      currentIndex: controller!.index,
      onTap: (int index) {
        setState(() {
          controller!.animateTo(index);
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
          ),
          label: 'home',
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
