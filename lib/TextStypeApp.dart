//Part 8 Erico Darmawan
//
import 'package:flutter/material.dart';

void main() => runApp(TextStypeApp());

class TextStypeApp extends StatefulWidget {
  const TextStypeApp({Key? key}) : super(key: key);

  @override
  State<TextStypeApp> createState() => _TextStypeAppState();
}

class _TextStypeAppState extends State<TextStypeApp> {
  String message = "Sample Text inih";
  int iCounter = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text("Anonymous Method",
                  style: TextStyle(fontFamily: "Hujan")),
            ),
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  Text(message, style: TextStyle(fontFamily: "GiveAway")),
                  RaisedButton(
                      child: Text("Tekan tombol ini",
                          style: TextStyle(fontFamily: "Techovier")),
                      //Sample Anonymous Method
                      onPressed: () {
                        setState(() {
                          iCounter++;
                          message = "Tombol ditekan " +
                              iCounter.toString() +
                              " kali.";
                        });
                      })
                ]))));
  }
}
