import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_tts/flutter_tts.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int seconds = 0;
  String time = "00:00";

  Timer timer;

  final FlutterTts txtToSpeech = FlutterTts();

  Future _speak() async {
    int minutes = seconds ~/ 5;
    String text;
    await txtToSpeech.setLanguage("it-IT");
    switch (minutes) {
      case 1:
        text = "è passato " + minutes.toString() + " minuto";
        break;
      default:
        text = "sono passati " + minutes.toString() + " minuti";
    }
    await txtToSpeech.speak(text);
  }

  _startTimer() {
    seconds = 0;
    if (timer != null && timer.isActive) {
      _stopTimer();
    }
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        seconds++;
        if (seconds % 5 == 0) {
          _speak();
        }
        time = convertToTime(seconds);
      });
    });
  }

  _stopTimer() {
    seconds = 0;
    setState(() {
      if (timer != null && timer.isActive) {
        timer.cancel();
      }
      time = convertToTime(seconds);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(title: Text("Title")),
          body: Container(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(time, style: TextStyle(fontSize: 60)),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: RaisedButton(
                            onPressed: _startTimer, child: Text("Start")),
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: RaisedButton(
                              onPressed: _stopTimer, child: Text("Stop"))),
                    ],
                  ))
            ],
          ))),
    );
  }
}

String convertToTime(int secs) {
  String hours = (secs ~/ 3600).toString();
  String minutes = ((secs ~/ 60) % 60).toString();
  String seconds = (secs % 60).toString();

  if (minutes.length == 1) {
    minutes = "0" + minutes;
  }

  if (seconds.length == 1) {
    seconds = "0" + seconds;
  }

  String time;
  if (hours != "0") {
    time = hours + ":" + minutes + ":" + seconds;
  } else {
    time = minutes + ":" + seconds;
  }
  return time;
}
