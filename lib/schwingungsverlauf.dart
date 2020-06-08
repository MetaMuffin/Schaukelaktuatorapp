
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
  RTDataVelPwm(this.time,this.maxvel,this.vel,this.pwm);
  double maxvel;
  double vel;
  double pwm;
  DateTime time;
}

class AppSchwingungsverlaufState extends State<AppSchwingungsverlauf> {

  List<charts.Series<dynamic, DateTime>> plotData = [];
  List<RTDataVelPwm> amplitudeData = [];

  int maxDataLen = 2000;

  @override
  void initState() {
    super.initState();
    updatePlot(new RTDataVelPwm(DateTime.now(), 0, 0, 0));
    wse.on("rt_data",context,(ev,data){
      String sdata = ev.eventData.toString();
      List<double> ddata = sdata.split(",").map((v)=> double.parse(v)).toList();
      updatePlot(new RTDataVelPwm(DateTime.fromMillisecondsSinceEpoch(ddata[0].toInt()), ddata[1], ddata[2],ddata[3]));
    });
  }

  void expansionChanged(bool value){
    wsSend("rt_data_onoff", value ? "1" : "0");
  }

  void updateGraphRange(double val) {
    setState(() {
      maxDataLen = val.floor();
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
        ),
        Slider(
          min: 500,
          max: 5000,
          value: maxDataLen.toDouble(),
          activeColor: Colors.orange,
          onChanged: updateGraphRange,
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
          measureFn: (RTDataVelPwm v, _) => v.maxvel,
        ),
        new charts.Series<RTDataVelPwm,DateTime>(
          id: "setpoint",
          data: amplitudeData,
          colorFn: (_,__) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (RTDataVelPwm v, _) => v.time,
          measureFn: (RTDataVelPwm v, _) => v.vel,
        ),
        new charts.Series<RTDataVelPwm,DateTime>(
          id: "pwm",
          data: amplitudeData,
          colorFn: (_,__) => charts.MaterialPalette.green.shadeDefault,
          domainFn: (RTDataVelPwm v, _) => v.time,
          measureFn: (RTDataVelPwm v, _) => v.pwm,
        )
      ];
    });
  }

}