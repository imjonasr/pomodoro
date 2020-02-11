import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pomodoro/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String texto = "25:00"; // Texto exibido na tela
  Timer _timer; // O Cronometro
  int current = 60 * 5; // Segundos para o timer
  int sequencia = 1; // Sequencia de pomodoros
  int pomodoros = 0; // Quantidade de pomodoros feitos

  int timePausaCurta = 5;
  int timePausaLonga = 20;
  int timePomodoro = 25;

  void _modoPomodoro() {

    // SEQUENCIA
    // Se for par ele será uma pausa curta
    // Se for ímpar será 25:00 minutos
    // Se for divisivel por 8 será uma pausa longa

    _getValues();

    if(sequencia % 8 == 0) { 
      // Pausa longa
      //current = 60 * 20;
      current = 20;
      texto = "20:00";
    } else if(sequencia % 2 == 0) {
      // Pausa curta
      current = 5;
      //current = 60 * 5;
      texto = "05:00";
    } else { 
      // 25:00 minutos
      //current = 60 * 25;
      current = 25;
      pomodoros++;
      texto = "25:00";
    }

    _startTimer();
  }

  _getValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    timePausaCurta = prefs.getInt('timePausaCurta');
    timePausaLonga = prefs.getInt('timePausaLonga');
    timePomodoro   = prefs.getInt('timePomodoro');
  }

  void _startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          texto = (current ~/ 60) < 10 ? "0${current ~/ 60}:" : "${current ~/ 60}:";
          texto += (current % 60) < 10 ? "0${current % 60}" : "${current % 60}";
          if (current < 1) {
            sequencia++;
            timer.cancel();
          } else {
            current = current - 1;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    sequencia = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Pomodoro", style: TextStyle(fontSize: 28)),
        centerTitle: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (_) => Settings()
                )
              );
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Center(
              child: Text(
                texto,
                //"${(current ~/ 60) }:${current % 60}",
                style: TextStyle(fontSize: 64),
              ),
            ),
            Text(
              "Você já fez ${pomodoros}.",
              style: TextStyle(
                fontSize: 18,
                color: Colors.blueGrey,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: _modoPomodoro,
        child: Icon(
          Icons.play_arrow,
          color: Colors.white,
        ),
      ),
    );
  }
}
