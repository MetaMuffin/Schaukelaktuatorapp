

import 'dart:async';

import 'package:eventify/eventify.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';


String targetHost = "ws://archmuffin:8080";

EventEmitter wse = new EventEmitter();
IOWebSocketChannel wsc;

void startListen(context){
  print("Connecting WS.");
  wsc = IOWebSocketChannel.connect(targetHost);
  wsc.stream.listen((data) {
    String pname = data.toString().split(":")[0];
    String pdata = data.toString().split(":").sublist(1).join(":");
    wse.emit(pname,null,pdata);
  }, onDone: () {}, onError: (error) {
    Timer(Duration(seconds: 1), () => startListen(context));
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("Och ne... Es konnte keine verbindung zum Aktuator aufgebaut werden."),
    ));
  });
}
void wsSend(String pname, String pdata){
  wsc.sink.add(pname + ":" + pdata);
}