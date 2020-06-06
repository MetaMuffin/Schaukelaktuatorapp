
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:math';

import 'globals.dart';

class AppSchwingungsverlauf extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AppSchwingungsverlaufState();
  }
}

class RTDataVelPwm{
  RTDataVelPwm(this.time,this.pwm,this.vel);
  double pwm;
  double vel;
  DateTime time;
}

class AppSchwingungsverlaufState extends State<AppSchwingungsverlauf> {

  List<charts.Series<dynamic, DateTime>> plotData = [];
  List<RTDataVelPwm> amplitudeData = [];

  final int maxDataLen = 200;

  @override
  void initState() {
    super.initState();
    updatePlot(new RTDataVelPwm(DateTime.now(), 0, 0));
    wse.on("rt_data",context,(ev,data){
      String sdata = ev.eventData.toString();
      List<double> ddata = sdata.split(",").map((v)=> double.parse(v)).toList();
      updatePlot(new RTDataVelPwm(DateTime.fromMillisecondsSinceEpoch(ddata[0].toInt()), ddata[1], ddata[2]));
    });
  }

  void expansionChanged(bool value){
    wsSend("rt_data_onoff", value ? "1" : "0");
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text("Schwingungsverlaufüberwachungsdiagram"),
      children: <Widget>[
        SizedBox(
          child: charts.TimeSeriesChart(
            plotData,
            animate: false,
          ),
          height: 200,
        )
      ],
      onExpansionChanged: expansionChanged
    );
  }

  void updatePlot(RTDataVelPwm newAmpltudeData){
    

    amplitudeData.add(newAmpltudeData);
    amplitudeData = amplitudeData.sublist(max(amplitudeData.length - maxDataLen, 0));

    
    setState(() {
      plotData = [
        new charts.Series<RTDataVelPwm,DateTime>(
          id: "current",
          data: amplitudeData,
          colorFn: (_,__) => charts.MaterialPalette.red.shadeDefault,
          domainFn: (RTDataVelPwm v, _) => v.time,
          measureFn: (RTDataVelPwm v, _) => v.pwm,
        ),
        new charts.Series<RTDataVelPwm,DateTime>(
          id: "setpoint",
          data: amplitudeData,
          colorFn: (_,__) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (RTDataVelPwm v, _) => v.time,
          measureFn: (RTDataVelPwm v, _) => v.vel,
        )
      ];
    });
  }

}