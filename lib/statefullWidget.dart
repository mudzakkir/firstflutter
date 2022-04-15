import 'package:flutter/material.dart';

void main() => runApp(StatefulWidgetApp());

class StatefulWidgetApp extends StatefulWidget {
  @override
  State<StatefulWidgetApp> createState() => _StatefulWidgetAppState();
}

class _StatefulWidgetAppState extends State<StatefulWidgetApp> {
  int iCounter = 0;

  void aksiTekan() {
    setState(() {
      iCounter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: Text('Stateful Widget Demo')),
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  Text(iCounter.toString(),
                      style: TextStyle(fontSize: 10 * iCounter.toDouble())),
                  RaisedButton(
                      child: Text("Tambah Ukuran angka"), onPressed: aksiTekan)
                ]))));
  }
}
