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

  int timePausaCurta = 5; // Tempo da pausa curta
  int timePausaLonga = 20; // Tempo da pausa longa
  int timePomodoro = 25; // Tempo do pomodoro

  void _modoPomodoro() {

    // SEQUENCIA
    // Se for par ele será uma pausa curta
    // Se for ímpar será 25:00 minutos
    // Se for divisivel por 8 será uma pausa longa

    _getValues();

    if(sequencia % 8 == 0) { 
      // Pausa longa
      current = timePausaLonga * 60;
      texto = "20:00";
    } else if(sequencia % 2 == 0) {
      // Pausa curta
      current = timePausaCurta * 60;
      texto = "05:00";
    } else { 
      // 25:00 minutos
      current = timePomodoro * 60;
      pomodoros++;
      texto = "25:00";
    }

    _startTimer();
  }

  _getValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    timePausaCurta = prefs.getInt('timePausaCurta') ?? 0;
    timePausaLonga = prefs.getInt('timePausaLonga') ?? 0;
    timePomodoro   = prefs.getInt('timePomodoro') ?? 0;

    print(timePausaCurta);
    print(timePausaLonga);
    print(timePomodoro);

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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(
                texto,
                //"${(current ~/ 60) }:${current % 60}",
                style: TextStyle(fontSize: 64),
              ),
            ),
            Center(
              child: Text(
                "You already did $pomodoros pomodoros.",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w200,
                  color: Colors.grey,
                ),
              ),
            ),
            
          ],
        ),
      ),
      bottomNavigationBar: Row(
        children: <Widget>[
          Expanded(
            child: RaisedButton(
              padding: EdgeInsets.only(top: 15, bottom: 15),
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(0.0),
                side: BorderSide(color: Colors.deepPurple)
              ),
              color: Colors.deepPurple,
              child: Icon(Icons.play_arrow, color: Colors.white),
              onPressed: _modoPomodoro,
            ),
          ),
          Expanded(
            child: RaisedButton(
              padding: EdgeInsets.only(top: 15, bottom: 15),
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(0.0),
               side: BorderSide(color: Colors.red)
              ),
              color: Colors.red,
              child: Icon(Icons.stop, color: Colors.white),
              onPressed: () {
                _timer.cancel();
                setState(() {
                  pomodoros--;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
