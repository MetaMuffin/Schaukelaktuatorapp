
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:math';

import 'globals.dart';

class Schwingungsverlauf extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SchwingungsverlaufState();
  }

}

class RTDataAmplitude{
  RTDataAmplitude(time,current,setpoint);
  double current;
  double setpoint;
  DateTime time;
}

class SchwingungsverlaufState extends State<Schwingungsverlauf> {

  List<charts.Series<dynamic, DateTime>> plotData = [];
  List<RTDataAmplitude> amplitudeData = [];

  final int maxDataLen = 20;

  @override
  void initState() {
    super.initState();
    updatePlot(new RTDataAmplitude(DateTime.now(), 0, 0));
    wse.on("rt_data",context,(ev,data){
      String sdata = data.toString();
      List<double> ddata = sdata.split(",").map((e) => double.parse(e));
      
    });
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
      ]
    );
  }

  void updatePlot(RTDataAmplitude newAmpltudeCata){
    

    amplitudeData.add(newAmpltudeCata);
    amplitudeData = amplitudeData.sublist(max(amplitudeData.length - maxDataLen, 0));


    setState(() {
      plotData = [
        new charts.Series<RTDataAmplitude,DateTime>(
          id: "current",
          data: amplitudeData,
          colorFn: (_,__) => charts.MaterialPalette.red.shadeDefault,
          domainFn: (RTDataAmplitude v, _) => v.time,
          measureFn: (RTDataAmplitude v, _) => v.current,
        ),
        new charts.Series<RTDataAmplitude,DateTime>(
          id: "setpoint",
          data: amplitudeData,
          colorFn: (_,__) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (RTDataAmplitude v, _) => v.time,
          measureFn: (RTDataAmplitude v, _) => v.setpoint,
        )
      ];
    });
  }

}