import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  TextEditingController _timePausaCurta = TextEditingController(); 
  TextEditingController _timePausaLonga = TextEditingController(); 
  TextEditingController _timePomodoro = TextEditingController(); 

  _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //print(int.parse(_timePausaCurta.text));
    prefs.setInt('timePausaCurta', int.parse(_timePausaCurta.text));
    prefs.setInt('timePausaLonga', int.parse(_timePausaLonga.text));
    prefs.setInt('timePomodoro', int.parse(_timePomodoro.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Configurações"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.number,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              controller: _timePomodoro,
              decoration: InputDecoration(
                labelText: "Tempo do Pomodoro:",
              ),
            ),
            TextField(
              keyboardType: TextInputType.number,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              controller: _timePausaCurta,
              decoration: InputDecoration(
                labelText: "Tempo da Pausa Curta:",
              ),
            ),
            TextField(
              keyboardType: TextInputType.number,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              controller: _timePausaLonga,
              decoration: InputDecoration(
                labelText: "Tempo da Pausa Longa:",
              ),
            ),
            SizedBox(height: 20,),
            Center(
              child: Text("Todos os valores devem ser em segundos."),
            ),
            SizedBox(height: 20,),
            RaisedButton(
              color: Colors.deepPurple,
              padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
              child: Text("Salvar"),
              onPressed: _saveSettings
            )
          ],
        ),
      ),
    );
  }
}