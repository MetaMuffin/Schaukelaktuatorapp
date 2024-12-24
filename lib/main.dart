import 'package:flutter/material.dart';
import 'package:schaukelaktuatorapp/globals.dart';
import 'package:schaukelaktuatorapp/schwingungsverlauf.dart';
import 'amplitudenregulator.dart';

void main() {
  runApp(SchaukelApp());
}

class SchaukelApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Schaukel-App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // accentColor: Colors.lightGreen[600],
      ),
      home: Scaffold(
          appBar: AppBar(
            title: Text("Schaukel-App"),
            backgroundColor: Colors.green[700],
          ),
          body: AppControls(
            key: Key("app"),
          )),
    );
  }
}

class AppControls extends StatefulWidget {
  AppControls({required Key key}) : super(key: key);

  @override
  _AppControlsState createState() {
    return _AppControlsState();
  }
}

class _AppControlsState extends State<AppControls> {
  @override
  void initState() {
    super.initState();
    startListen(context);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        AppAmplitudenregelung(),
        AppSchwingungsverlauf(),
      ],
    );
  }
}
