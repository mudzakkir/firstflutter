import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'CommonConstant.dart';
import 'DrawerWidget.dart';

class DashboardUI extends StatefulWidget {
  static SingleChildScrollView _MainUI = new SingleChildScrollView();

  const DashboardUI({Key? key}) : super(key: key);

  @override
  State<DashboardUI> createState() => _DashboardUIState();

  static void SetMainUI(SingleChildScrollView oUI) {
    _MainUI = oUI;
  }
}

class _DashboardUIState extends State<DashboardUI> {
  late final ValueListenable<SingleChildScrollView> _ParentScrollable;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(CommonConstant.APP_NAME),
      ),
      drawer: DrawerWidget(),
      endDrawer: DrawerWidget(),
      body: Center(child: DashboardUI._MainUI),
    );
  }

  void _updateUI(SingleChildScrollView oNewUI) {
    setState(() {
      DashboardUI._MainUI = oNewUI;
    });
  }
}
