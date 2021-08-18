import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class User {
  String id;
  String name;

  User({required this.id, required this.name});

  factory User.createUser(Map<String, dynamic> object) {
    return User(
        id: object['id'].toString(),
        name: object['firstname'] + ' ' + object['lastname']);
  }

  static Future<User> get(String id) async {
    var apiURL = Uri.https('reqres.in/api/Users/', id);
    //Uri apiURL = "https://reqres.in/api/Users/" + id;

    var response = await http.get(apiURL);
    if (response.statusCode == 200) {
      var jsonObject =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var userData = (jsonObject)['data'];

      return User.createUser(userData);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return User(id: '0', name: '');
    }
  }
}
