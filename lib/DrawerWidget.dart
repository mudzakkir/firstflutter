import 'dart:convert';
import 'dart:io';
import 'package:image/image.dart' as ImageConvert;

import 'package:firstflutter/ApiSpreading.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import 'CommonConstant.dart';
import 'DashboardUI.dart';
import 'Database.dart';
import 'PostApi.dart';

class DrawerWidget extends StatelessWidget {
  static late PickedFile _imageFile;
  static final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _drawerHeader(),
          _drawerItem(
              icon: Icons.folder,
              text: 'Upload Spreading',
              onTap: () => eventUploadSpreading(context)),
          _drawerItem(
              icon: Icons.group,
              text: 'Shared with me',
              onTap: () => print('Tap Shared menu')),
          _drawerItem(
              icon: Icons.access_time,
              text: 'Recent',
              onTap: () => print('Tap Recent menu')),
          _drawerItem(
              icon: Icons.delete,
              text: 'Trash',
              onTap: () => print('Tap Trash menu')),
          Divider(height: 25, thickness: 1),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10, bottom: 10),
            child: Text("Labels",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                )),
          ),
          _drawerItem(
              icon: Icons.exit_to_app,
              text: 'Logout',
              onTap: () => eventLogout(context)),
        ],
      ),
    );
  }

  eventLogout(BuildContext context) async {
    await DBProvider.db.deleteAll();
    CommonConstant.GLOBAL_USER = LoginClient(id: -99, name: '', upn: '');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PostApiSample()),
    );
  }

  eventUploadSpreading(BuildContext context) async {
    // _pickImage();
    try {
      final pickedFile = await DrawerWidget._picker.getImage(
          source: ImageSource.gallery,
          imageQuality: 11,
          maxHeight: 1024,
          maxWidth: 1024);
      _imageFile = pickedFile!;
    } catch (e) {
      print("Image picker error " + e.toString());
      LogError oError = new LogError(
        source: '_pickImage',
        Description: e.toString(),
        DateOccured: DateTime.now().toString(),
      );
      DBProvider.db.insertLogError(oError);
    }

    var oUI = SingleChildScrollView(child: _previewImage());
    DashboardUI.SetMainUI(oUI);
    VisitSpreading oResult = await uploadImage(_imageFile.path);
    String sResponse = json.encode(oResult);
    LogError oError = new LogError(
      source: 'eventUploadSpreading Response',
      Description: sResponse,
      DateOccured: DateTime.now().toString(),
    );
    DBProvider.db.insertLogError(oError);
  }

  void _pickImage() async {
    try {
      final pickedFile = await DrawerWidget._picker.getImage(
          source: ImageSource.gallery,
          imageQuality: 11,
          maxHeight: 1024,
          maxWidth: 1024);
      _imageFile = pickedFile!;
    } catch (e) {
      print("Image picker error " + e.toString());
      LogError oError = new LogError(
        source: '_pickImage',
        Description: e.toString(),
        DateOccured: DateTime.now().toString(),
      );
      DBProvider.db.insertLogError(oError);
    }
  }

  Future<VisitSpreading> uploadImage(filepath) async {
    final bytes = File(filepath).readAsBytesSync();
    ImageConvert.Image? imageSource =
        ImageConvert.decodeImage(new File(filepath).readAsBytesSync());
    ImageConvert.Image thumbnail =
        ImageConvert.copyResize(imageSource!, width: 120);
    // Save the thumbnail as a PNG.
    String path = join("/storage/emulated/0/", "MToha-thumbnail.jpg");

    new File(path)..writeAsBytesSync(ImageConvert.encodeJpg(thumbnail));
    final bytesResult = File(path).readAsBytesSync();

    String fileBase64 = base64Encode(bytesResult);
    VisitSpreading oResult = await VisitSpreading.connectToApi(fileBase64);
    return oResult;
  }
}

Widget _previewImage() {
  if (DrawerWidget._imageFile != null) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.file(File(DrawerWidget._imageFile.path)),
          SizedBox(
            height: 20,
          ),
          RaisedButton(
            onPressed: () async {
              String fileBase64 = "";
              await VisitSpreading.connectToApi(fileBase64);
            },
            child: const Text('Upload'),
          )
        ],
      ),
    );
  } else {
    return const Text(
      'You have not yet picked an image.',
      textAlign: TextAlign.center,
    );
  }
}

Future<void> retriveLostData() async {
  final LostData response = await DrawerWidget._picker.getLostData();
  if (response.isEmpty) {
    return;
  }
  if (response.file != null) {
    DrawerWidget._imageFile = response.file!;
  } else {
    print('Retrieve error ' + response.exception!.code);
  }
}

Widget _drawerHeader() {
  return UserAccountsDrawerHeader(
    currentAccountPicture: ClipOval(
      child: Image(
          image: AssetImage('assets/images/orang2.jpg'), fit: BoxFit.cover),
    ),
    otherAccountsPictures: [
      ClipOval(
        child: Image(
            image: AssetImage('assets/images/orang1.png'), fit: BoxFit.cover),
      ),
      ClipOval(
        child: Image(
            image: AssetImage('assets/images/orang3.jpg'), fit: BoxFit.cover),
      )
    ],
    accountName: Text(CommonConstant.GLOBAL_USER.name),
    accountEmail: Text(CommonConstant.GLOBAL_USER.upn),
  );
}

Widget _drawerItem(
    {required IconData icon,
    required String text,
    required GestureTapCallback onTap}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(icon),
        Padding(
          padding: EdgeInsets.only(left: 25.0),
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
    onTap: onTap,
  );
}
