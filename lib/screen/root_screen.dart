import 'package:flutter/material.dart';
import 'package:two_steps_metronome/screen/home_screen.dart';
import 'package:two_steps_metronome/screen/settings_screen.dart';
import 'package:two_steps_metronome/const/colors.dart';


class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> with
TickerProviderStateMixin{

  TabController? controller;
  int firstBPM = 10, firstTimes = 6;
  int secondBPM = 5, secondTimes = 3;
  int setsNumber = 1;

  @override
  void initState(){
    super.initState();
    controller = TabController(length: 2, vsync: this);
    controller!.addListener(tabListener);
  }


  tabListener(){
    setState((){});
  }

  @override
  dispose(){
    controller!.removeListener(tabListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Two Steps Tempo Generator'),
      centerTitle: true,
      ),
      body: TabBarView(
        controller: controller,
        children: renderChildren(),
      ),
        bottomNavigationBar: renderBottomNavigation(),
    );
  }

  List<Widget> renderChildren(){
    return [
      HomeScreen(
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

  void firstBPMChanged(double val1){
    setState((){
      firstBPM = val1.toInt();
    });
  }
  void firstTimesChanged(int time1){
    setState((){
      firstBPM = time1;
    });
  }
  void secondBPMChanged(double val2){
    setState((){
      secondBPM = val2.toInt();
    });
  }
  void secondTimesChanged(int time2){
    setState((){
      secondTimes = time2;
    });
  }
  void setsNumberChanged(int setNum){
    setState((){
      setsNumber = setNum;
    });
  }





  BottomNavigationBar renderBottomNavigation(){
    return BottomNavigationBar(
        currentIndex: controller!.index,
        onTap: (int index) {
          setState((){
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