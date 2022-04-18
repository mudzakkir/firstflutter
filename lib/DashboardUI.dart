import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'CommonConstant.dart';
import 'DrawerWidget.dart';

class DashboardUI extends StatefulWidget {
  static Widget _MainUI = new SingleChildScrollView(
    child: Text("Hello " + CommonConstant.GLOBAL_USER.name),
  );
  static _DashboardUIState oState = new _DashboardUIState();

  const DashboardUI({Key? key}) : super(key: key);

  @override
  State<DashboardUI> createState() => oState;

  static void SetMainUI(Widget oUI) {
    _MainUI = oUI;
    oState._updateUI(oUI);
  }
}

class _DashboardUIState extends State<DashboardUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(CommonConstant.APP_NAME),
      ),
      drawer: DrawerWidget(),
      endDrawer: DrawerWidget(),
      body: Center(
          child: SingleChildScrollView(child: _updateUI(DashboardUI._MainUI))),
    );
  }

  Widget _updateUI(Widget oNewUI) {
    setState(() {
      DashboardUI._MainUI = oNewUI;
    });

    return DashboardUI._MainUI;
  }
}
