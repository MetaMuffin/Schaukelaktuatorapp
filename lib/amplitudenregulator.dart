

import 'dart:async';

import 'package:flutter/material.dart';

import 'dart:math';
import 'package:schaukelaktuatorapp/globals.dart';


class AppAmplitudenregelung extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AppAmplitudenregelungState();
  }
}

class AppAmplitudenregelungState extends State<AppAmplitudenregelung> {
  double amplitudeSetpoint = 0.1;
  double amplitudeCurrent = 0;

  void sliderUpdate(double value){
    setState((){
      amplitudeSetpoint = value;
    });
  }
  Future<void> sendSetpoint(double value) async {
    setState((){
      amplitudeSetpoint = value;
    });
    wsSend("amplitude_setpoint",value.toStringAsFixed(3));
  }

  @override
  void initState() { 
    super.initState();
    wse.on("amplitude_setpoint", this,(ev, data){
      double nv = double.parse(ev.eventData);
      setState(() {
        amplitudeSetpoint = nv;
      });
    });
    wse.on("amplitude_current", this,(ev, data){
      double nv = double.parse(ev.eventData);
      setState(() {
        amplitudeCurrent = nv;
      });
    });
  }

  
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text("Amplitudenregelung"),
      children: <Widget>[
        Text("Soll: " + (amplitudeSetpoint / pi * 180).toStringAsFixed(1)),
        Slider(
          min: 0,
          max: 0.8,
          activeColor: Theme.of(context).accentColor,
          onChanged: sliderUpdate,
          onChangeEnd: sendSetpoint,
          value: amplitudeSetpoint,
        ),
        Text("Aktuelle Amplitude: " + (amplitudeCurrent / pi * 180).toStringAsFixed(1)),
        SizedBox(
          height: 30,
          child: LinearProgressIndicator(
            backgroundColor: Colors.grey,
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
            value: (amplitudeCurrent)
            
          ),
        ),
        SizedBox(
          height: 30,
          child: LinearProgressIndicator(
            backgroundColor: Colors.grey,
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColorDark),
            value: (amplitudeSetpoint)
          ),
        ),
      ],
    );
  }
}