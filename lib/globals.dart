import 'dart:async';
import 'package:eventify/eventify.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

String targetHost = "ws://schaukelaktuator/ws";
//String targetHost = "ws://192.168.178.45/ws";

EventEmitter wse = new EventEmitter();
IOWebSocketChannel? wsc;

void startListen(context) {
  print("Connecting WS.");
  wsc = IOWebSocketChannel.connect(targetHost);
  wsc!.stream.listen(
      (rawData) {
        for (var data in rawData.toString().split("!")) {
          String pname = data.split(":")[0];
          String pdata = data.split(":").sublist(1).join(":");
          wse.emit(pname, null, pdata);
        }
      },
      onDone: () {},
      onError: (error) {
        print("Ws Connection failed");
        Timer(Duration(seconds: 1), () => startListen(context));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "Oh nein... Es konnte keine verbindung zum Aktuator aufgebaut werden."),
        ));
      });
}

void wsSend(String pname, String pdata) {
  wsc!.sink.add(pname + ":" + pdata);
}
