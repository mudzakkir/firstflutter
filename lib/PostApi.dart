import 'package:firstflutter/Database.dart';
import 'package:flutter/material.dart';

import 'CommonConstant.dart';
import 'DashboardUI.dart';
import 'DialogAlert.dart';
import 'UserLoginApi.dart';

// flutter run --no-sound-null-safety
void main() {
  runApp(MaterialApp(
    title: CommonConstant.APP_NAME,
    home: PostApiSample(),
  ));
  // runApp(PostApiSample());
}

class PostApiSample extends StatefulWidget {
  const PostApiSample({Key? key}) : super(key: key);

  @override
  State<PostApiSample> createState() => _PostApiSampleState();
}

class _PostApiSampleState extends State<PostApiSample> {
  final txtUpn = TextEditingController();
  final txtPassword = TextEditingController();

  UserLogin oProvider = new UserLogin();
  String message = "";
  int iCounter = 0;

  // Future<List<Client>> listAll() async {
  //   final Future<List<Client>> oList = DBProvider.db.listAll();
  //   oList.then((oResult) {
  //     if (oResult == null) {
  //       // ignore: deprecated_member_use
  //       oResult = new List<Client>();
  //     }
  //     return oResult;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    txtUpn.text = "mudhakir.toha@kalbe.co.id";
    txtPassword.text = "kalbe2022";
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text(CommonConstant.APP_NAME,
                  style: TextStyle(fontFamily: "Hujan")),
            ),
            body: Center(
                child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                  TextField(
                    controller: txtUpn,
                    decoration: InputDecoration(
                      hintText: "Enter Username",
                    ),
                  ),
                  TextField(
                    obscureText: true,
                    obscuringCharacter: "*",
                    controller: txtPassword,
                    decoration: InputDecoration(
                      hintText: "Enter password",
                    ),
                  ),
                  Text(message, style: TextStyle(fontFamily: "GiveAway")),
                  Text(
                      oProvider != null
                          ? oProvider.upn +
                              " | " +
                              oProvider.name +
                              " | " +
                              oProvider.accessToken
                          : "Tidak ada data",
                      style: TextStyle(fontFamily: "GiveAway")),
                  RaisedButton(
                      child: Text("Login",
                          style: TextStyle(fontFamily: "Techovier")),
                      //Sample Anonymous Method
                      onPressed: () {
                        try {
                          UserLogin.connectToApi(
                                  txtUpn.text, txtPassword.text, false)
                              .then((value) async {
                            oProvider = value;
                            List<LoginClient> clients =
                                new List<LoginClient>.empty(growable: true);

                            clients = await DBProvider.db.queryAll();
                            // DBProvider.db.queryAll().then((value) {
                            //   if (value is Client) {
                            //     clients.add(value as Client);
                            //   }
                            //   clients = value;
                            // });
                            if (clients.length > 0)
                              await DBProvider.db.deleteAll();

                            LoginClient oSave = new LoginClient(
                                id: -1,
                                upn: oProvider.upn,
                                name: oProvider.name,
                                accessToken: oProvider.accessToken);
                            await DBProvider.db.insertClient(oSave);
                            CommonConstant.GLOBAL_USER = oSave;
                            setState(() {});

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const DashboardUI()),
                            );
                          });
                        } catch (err) {
                          var dialog = DialogAlert(
                              title: "Error",
                              message: err.toString(),
                              onNegativePressed: () {},
                              onPostivePressed: () {},
                              positiveBtnText: 'Yes',
                              negativeBtnText: 'No');
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => dialog);
                        }
                      })
                ])))));
  }
}
