

import 'package:flutter/material.dart';
import 'package:schaukelaktuatorapp/globals.dart';
import 'package:schaukelaktuatorapp/schwingungsverlauf.dart';

import 'amplitudenregulator.dart';

void main() {
  runApp(SchaukelApp());
}



class SchaukelApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        accentColor: Colors.lightGreen[600],
        
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Schaukel-App"),
          backgroundColor: Colors.green[700],
        ),
        body: AppControls()
      ),
    );
  }
}

class AppControls extends StatefulWidget {
  AppControls({Key key}) : super(key: key);

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
          Amplitudenregelung(),
          Schwingungsverlauf(),
        ],
      );
  }
}
