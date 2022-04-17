import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';
//import 'package:path_provider_ex/path_provider_ex.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    String path = join("/storage/emulated/0/", "MtohaDb.db");

    File f = new File(path);
    bool bExist = false;
    f.exists().then((value) {
      bExist = value;
    });

    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      try {
        await db.execute("CREATE TABLE LoginClient ("
            "id INTEGER PRIMARY KEY,"
            "upn TEXT,"
            "name TEXT,"
            "accessToken TEXT"
            ")");
      } catch (ex) {}
      try {
        await db.execute("CREATE TABLE LogError ("
            "id INTEGER PRIMARY KEY,"
            "source TEXT,"
            "Description TEXT,"
            "DateOccured TEXT, Query Text"
            ")");
      } catch (ex) {}
    });
  }

  LoginClient clientFromJson(String str) {
    final jsonData = json.decode(str);
    return LoginClient.fromMap(jsonData);
  }

  String clientToJson(LoginClient data) {
    final dyn = data.toMap();
    return json.encode(dyn);
  }

  insertLogError(LogError data) async {
    final db = await database;
    //get the biggest id in the table
    var table =
        await db?.rawQuery("SELECT IFNULL(MAX(id)+1, 1) as id FROM LogError");
    int? id = int.parse(table!.first['id'].toString());
    //insert to the table using the new id
    var raw = -99;
    try {
      raw = (await db?.rawInsert(
          "INSERT Into LogError (id,source,Description,DateOccured, Query)"
          " VALUES (?,?,?,?, ?)",
          [id, data.source, data.Description, data.DateOccured, data.Query]))!;
    } catch (ex) {
      await db?.execute("CREATE TABLE LogError ("
          "id INTEGER PRIMARY KEY,"
          "source TEXT,"
          "Description TEXT,"
          "DateOccured TEXT, Query Text"
          ")");

      raw = (await db?.rawInsert(
          "INSERT Into LogError (id,source,Description,DateOccured, Query)"
          " VALUES (?,?,?,?, ?)",
          [id, data.source, data.Description, data.DateOccured, data.Query]))!;
    }
    return raw;
  }

  insertClient(LoginClient newClient) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db
        ?.rawQuery("SELECT IFNULL(MAX(id)+1, 1) as id FROM LoginClient");
    int? id = int.parse(table!.first['id'].toString());
    //insert to the table using the new id
    var raw = await db?.rawInsert(
        "INSERT Into LoginClient (id,upn,name,accessToken)"
        " VALUES (?,?,?,?)",
        [id, newClient.upn, newClient.name, newClient.accessToken]);
    return raw;
  }

  getClient(int id) async {
    final db = await database;
    var res = await db!.query("LoginClient", where: "id = ?", whereArgs: [id]);
    if (res.isNotEmpty) {
      return LoginClient.fromMap(res.first);
    } else {
      return Null;
    }
  }

  getAllClients() async {
    final db = await database;
    var res = await db!.query("LoginClient");
    List<LoginClient> list =
        res.isNotEmpty ? res.map((c) => LoginClient.fromMap(c)).toList() : [];
    return list;
  }

  getByClients(String upn) async {
    final db = await database;
    var res =
        await db!.query("LoginClient", where: "upn = ?", whereArgs: [upn]);
    if (res.isNotEmpty) {
      return LoginClient.fromMap(res.first);
    }
  }

  updateClient(LoginClient newClient) async {
    final db = await database;
    var res = await db!.update("LoginClient", newClient.toMap(),
        where: "id = ?", whereArgs: [newClient.id]);
    return res;
  }

  deleteClient(String upn) async {
    final db = await database;
    db!.delete("LoginClient", where: "upn = ?", whereArgs: [upn]);
  }

  deleteAll() async {
    final db = await database;
    db!.rawDelete("Delete FROM LoginClient");
  }

  Future<List<LoginClient>> queryAll() async {
    // get a reference to the database
    Database? db = await database;
    List<LoginClient> oResult = new List<LoginClient>.empty(growable: true);
    // raw query
    List<Map> result = await db!.rawQuery('SELECT * FROM LoginClient');

    // print the results
    // result.forEach((row) => print(row));
    for (int i = 0; i < result.length; i++) {
      oResult.add(LoginClient(
          id: result[i]['id'],
          upn: result[i]['upn'],
          name: result[i]['name'],
          accessToken: result[i]['access_token']));
    }
    return oResult;
  }

  Future<List<LoginClient>> listAll() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db!.query('LoginClient');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return LoginClient(
        id: maps[i]['id'],
        upn: maps[i]['upn'],
        name: maps[i]['name'],
        accessToken: maps[i]['access_token'],
      );
    });
  }
}

class LoginClient {
  int id;
  String upn;
  String name;
  String? accessToken;

  LoginClient({
    required this.id,
    required this.upn,
    required this.name,
    this.accessToken,
  });

  factory LoginClient.fromMap(Map<String, dynamic> json) => new LoginClient(
        id: json["id"],
        upn: json["upn"],
        name: json["name"],
        accessToken: json["accessToken"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "upn": upn,
        "name": name,
        "accessToken": accessToken,
      };
}

class LogError {
  int? id;
  String source;
  String Description;
  String? DateOccured;
  String? Query;

  LogError({
    this.id,
    required this.source,
    required this.Description,
    this.DateOccured,
    this.Query,
  });

  factory LogError.fromMap(Map<String, dynamic> json) => new LogError(
        id: json["id"],
        source: json["source"],
        Description: json["Description"],
        Query: json["Query"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "source": source,
        "Description": Description,
        "Query": Query,
      };
}
