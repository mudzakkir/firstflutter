import 'package:flutter/material.dart';

void main() => runApp(AnonymousMethod());

class AnonymousMethod extends StatefulWidget {
  const AnonymousMethod({Key? key}) : super(key: key);

  @override
  State<AnonymousMethod> createState() => _AnonymousMethodState();
}

class _AnonymousMethodState extends State<AnonymousMethod> {
  String message = "Text mToha";
  int iCounter = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text("Anonymous Method"),
            ),
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  Text(message),
                  RaisedButton(
                      child: Text("Tekan tombol ini"),
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
