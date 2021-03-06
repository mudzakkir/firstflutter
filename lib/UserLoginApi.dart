import 'dart:convert';

import 'package:http/http.dart' as http;

class UserLogin {
  String upn = "";
  String name = "";
  String accessToken = "";

  UserLogin({this.upn = "", this.name = "", this.accessToken = ""});

  factory UserLogin.MapObject(Map<String, dynamic> params) {
    UserLogin oResult = new UserLogin();
    if (params['upn'] != null) oResult.upn = params['upn'];
    if (params['name'] != null) oResult.name = params['name'];
    if (params['accessToken'] != null)
      oResult.accessToken = params['accessToken'];
    return oResult;
  }

  static Future<UserLogin> connectToApi(
      String username, String password, bool getProfile) async {
    String apiUrl =
        "https://m-one.kalbe.co.id:8243/t/kalbe.co.id/authentication/v1/api/Login";
    String apiKey =
        "eyJ4NXQiOiJZamt5WkRVM05tRTRZbVZqT1RjeE4yRTRNbVZrT1dSak1XVmhZVGhoWWpjeE9UZzJNemt4WVE9PSIsImtpZCI6ImdhdGV3YXlfY2VydGlmaWNhdGVfYWxpYXMiLCJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiJtdWRoYWtpci50b2hhQGthbGJlLmNvLmlkIiwiYXBwbGljYXRpb24iOnsib3duZXIiOiJtdWRoYWtpci50b2hhQGthbGJlLmNvLmlkIiwidGllclF1b3RhVHlwZSI6bnVsbCwidGllciI6IlVubGltaXRlZCIsIm5hbWUiOiJSb2ZvIiwiaWQiOjExMCwidXVpZCI6IjgwNjJiZjYzLWI0NzMtNGNkNy05NDk5LWNiOWQzZjlhODdjNSJ9LCJpc3MiOiJodHRwczpcL1wvbS1vbmUua2FsYmUuY28uaWQ6OTQ0M1wvb2F1dGgyXC90b2tlbiIsInRpZXJJbmZvIjp7IlVubGltaXRlZCI6eyJ0aWVyUXVvdGFUeXBlIjoicmVxdWVzdENvdW50IiwiZ3JhcGhRTE1heENvbXBsZXhpdHkiOjAsImdyYXBoUUxNYXhEZXB0aCI6MCwic3RvcE9uUXVvdGFSZWFjaCI6dHJ1ZSwic3Bpa2VBcnJlc3RMaW1pdCI6MCwic3Bpa2VBcnJlc3RVbml0IjpudWxsfX0sImtleXR5cGUiOiJTQU5EQk9YIiwicGVybWl0dGVkUmVmZXJlciI6IiIsInN1YnNjcmliZWRBUElzIjpbeyJzdWJzY3JpYmVyVGVuYW50RG9tYWluIjoia2FsYmUuY28uaWQiLCJuYW1lIjoiRGF5T2ZmIiwiY29udGV4dCI6IlwvdFwva2FsYmUuY28uaWRcL0RheU9mZlwvdjEiLCJwdWJsaXNoZXIiOiJtdWhhbW1hZC5oaWRheWF0dWxsMUBrYWxiZS5jby5pZCIsInZlcnNpb24iOiJ2MSIsInN1YnNjcmlwdGlvblRpZXIiOiJVbmxpbWl0ZWQifSx7InN1YnNjcmliZXJUZW5hbnREb21haW4iOiJrYWxiZS5jby5pZCIsIm5hbWUiOiJBcHByb3ZhbEFQSSIsImNvbnRleHQiOiJcL3RcL2thbGJlLmNvLmlkXC9BcHByb3ZhbEFQSVwvdjEiLCJwdWJsaXNoZXIiOiJtdWhhbW1hZC5kaWFuaUBrYWxiZS5jby5pZCIsInZlcnNpb24iOiJ2MSIsInN1YnNjcmlwdGlvblRpZXIiOiJVbmxpbWl0ZWQifSx7InN1YnNjcmliZXJUZW5hbnREb21haW4iOiJrYWxiZS5jby5pZCIsIm5hbWUiOiJBdXRob3JpemF0aW9uQVBJIiwiY29udGV4dCI6IlwvdFwva2FsYmUuY28uaWRcL0F1dGhvcml6YXRpb25BUElcL3YxIiwicHVibGlzaGVyIjoibXVoYW1tYWQuZGlhbmlAa2FsYmUuY28uaWQiLCJ2ZXJzaW9uIjoidjEiLCJzdWJzY3JpcHRpb25UaWVyIjoiVW5saW1pdGVkIn0seyJzdWJzY3JpYmVyVGVuYW50RG9tYWluIjoia2FsYmUuY28uaWQiLCJuYW1lIjoiR2xvYmFsLUF1dGhlbnRpY2F0aW9uIiwiY29udGV4dCI6IlwvdFwva2FsYmUuY28uaWRcL2F1dGhlbnRpY2F0aW9uXC92MSIsInB1Ymxpc2hlciI6Im1vaGFtbWFkLmFtaXJydWRpbkBrYWxiZS5jby5pZCIsInZlcnNpb24iOiJ2MSIsInN1YnNjcmlwdGlvblRpZXIiOiJVbmxpbWl0ZWQifSx7InN1YnNjcmliZXJUZW5hbnREb21haW4iOiJrYWxiZS5jby5pZCIsIm5hbWUiOiJHbG9iYWwtRmlsZSIsImNvbnRleHQiOiJcL3RcL2thbGJlLmNvLmlkXC9HbG9iYWwtRmlsZVwvdjEiLCJwdWJsaXNoZXIiOiJ0ZWd1aC52YWxlbmNpYUBrYWxiZS5jby5pZCIsInZlcnNpb24iOiJ2MSIsInN1YnNjcmlwdGlvblRpZXIiOiJVbmxpbWl0ZWQifSx7InN1YnNjcmliZXJUZW5hbnREb21haW4iOiJrYWxiZS5jby5pZCIsIm5hbWUiOiJHbG9iYWwtTG9nZ2VyIiwiY29udGV4dCI6IlwvdFwva2FsYmUuY28uaWRcL2xvZ2dpbmdcL3YxIiwicHVibGlzaGVyIjoibW9oYW1tYWQuYW1pcnJ1ZGluQGthbGJlLmNvLmlkIiwidmVyc2lvbiI6InYxIiwic3Vic2NyaXB0aW9uVGllciI6IlVubGltaXRlZCJ9LHsic3Vic2NyaWJlclRlbmFudERvbWFpbiI6ImthbGJlLmNvLmlkIiwibmFtZSI6Ikdsb2JhbC1QYXJhbWV0ZXIiLCJjb250ZXh0IjoiXC90XC9rYWxiZS5jby5pZFwvR2xvYmFsLVBhcmFtZXRlclwvdjEiLCJwdWJsaXNoZXIiOiJ0ZWd1aC52YWxlbmNpYUBrYWxiZS5jby5pZCIsInZlcnNpb24iOiJ2MSIsInN1YnNjcmlwdGlvblRpZXIiOiJVbmxpbWl0ZWQifSx7InN1YnNjcmliZXJUZW5hbnREb21haW4iOiJrYWxiZS5jby5pZCIsIm5hbWUiOiJMb2dnZXIiLCJjb250ZXh0IjoiXC90XC9rYWxiZS5jby5pZFwvbG9nZ2VyXC92MSIsInB1Ymxpc2hlciI6Im1vaGFtbWFkLmFtaXJydWRpbkBrYWxiZS5jby5pZCIsInZlcnNpb24iOiJ2MSIsInN1YnNjcmlwdGlvblRpZXIiOiJVbmxpbWl0ZWQifSx7InN1YnNjcmliZXJUZW5hbnREb21haW4iOiJrYWxiZS5jby5pZCIsIm5hbWUiOiJOb3RpZmljYXRpb24iLCJjb250ZXh0IjoiXC90XC9rYWxiZS5jby5pZFwvTm90aWZpY2F0aW9uXC92MSIsInB1Ymxpc2hlciI6InJpemtpYW5hbmRhLnByYWRpbGxhaEBrYWxiZS5jby5pZCIsInZlcnNpb24iOiJ2MSIsInN1YnNjcmlwdGlvblRpZXIiOiJVbmxpbWl0ZWQifSx7InN1YnNjcmliZXJUZW5hbnREb21haW4iOiJrYWxiZS5jby5pZCIsIm5hbWUiOiJSb2ZvQXBpIiwiY29udGV4dCI6IlwvdFwva2FsYmUuY28uaWRcL1JvZm9BcGlcL3YxIiwicHVibGlzaGVyIjoibXVkaGFraXIudG9oYUBrYWxiZS5jby5pZCIsInZlcnNpb24iOiJ2MSIsInN1YnNjcmlwdGlvblRpZXIiOiJVbmxpbWl0ZWQifSx7InN1YnNjcmliZXJUZW5hbnREb21haW4iOiJrYWxiZS5jby5pZCIsIm5hbWUiOiJSb2ZvQmVzdEVzdGltYXRlIiwiY29udGV4dCI6IlwvdFwva2FsYmUuY28uaWRcL1JvZm9CZXN0RXN0aW1hdGVcL3YxIiwicHVibGlzaGVyIjoibXVkaGFraXIudG9oYUBrYWxiZS5jby5pZCIsInZlcnNpb24iOiJ2MSIsInN1YnNjcmlwdGlvblRpZXIiOiJVbmxpbWl0ZWQifSx7InN1YnNjcmliZXJUZW5hbnREb21haW4iOiJrYWxiZS5jby5pZCIsIm5hbWUiOiJSb2ZvTWFzdGVyIiwiY29udGV4dCI6IlwvdFwva2FsYmUuY28uaWRcL1JvZm9NYXN0ZXJcL3YxIiwicHVibGlzaGVyIjoibXVkaGFraXIudG9oYUBrYWxiZS5jby5pZCIsInZlcnNpb24iOiJ2MSIsInN1YnNjcmlwdGlvblRpZXIiOiJVbmxpbWl0ZWQifSx7InN1YnNjcmliZXJUZW5hbnREb21haW4iOiJrYWxiZS5jby5pZCIsIm5hbWUiOiJSb2xlIiwiY29udGV4dCI6IlwvdFwva2FsYmUuY28uaWRcL1JvbGVcL3YxIiwicHVibGlzaGVyIjoibXVoYW1tYWQuaGlkYXlhdHVsbDFAa2FsYmUuY28uaWQiLCJ2ZXJzaW9uIjoidjEiLCJzdWJzY3JpcHRpb25UaWVyIjoiVW5saW1pdGVkIn0seyJzdWJzY3JpYmVyVGVuYW50RG9tYWluIjoia2FsYmUuY28uaWQiLCJuYW1lIjoiVXNlclByb2ZpbGVBUEkiLCJjb250ZXh0IjoiXC90XC9rYWxiZS5jby5pZFwvVXNlclByb2ZpbGVBUElcL3YxIiwicHVibGlzaGVyIjoibXVoYW1tYWQuZGlhbmlAa2FsYmUuY28uaWQiLCJ2ZXJzaW9uIjoidjEiLCJzdWJzY3JpcHRpb25UaWVyIjoiVW5saW1pdGVkIn0seyJzdWJzY3JpYmVyVGVuYW50RG9tYWluIjoia2FsYmUuY28uaWQiLCJuYW1lIjoiVXNlclByb2ZpbGVFeHRlcm5hbCIsImNvbnRleHQiOiJcL3RcL2thbGJlLmNvLmlkXC9Vc2VyUHJvZmlsZUV4dGVybmFsXC92MSIsInB1Ymxpc2hlciI6Im5vYm9uLmFuZHJhQGthbGJlLmNvLmlkIiwidmVyc2lvbiI6InYxIiwic3Vic2NyaXB0aW9uVGllciI6IlVubGltaXRlZCJ9LHsic3Vic2NyaWJlclRlbmFudERvbWFpbiI6ImthbGJlLmNvLmlkIiwibmFtZSI6IkFwcHJvdmFsQ3VzdG9tIiwiY29udGV4dCI6IlwvdFwva2FsYmUuY28uaWRcL0FwcHJvdmFsQ3VzdG9tXC92MSIsInB1Ymxpc2hlciI6Im11ZGhha2lyLnRvaGFAa2FsYmUuY28uaWQiLCJ2ZXJzaW9uIjoidjEiLCJzdWJzY3JpcHRpb25UaWVyIjoiVW5saW1pdGVkIn1dLCJwZXJtaXR0ZWRJUCI6IiIsImlhdCI6MTY0OTQ5NDIxNCwianRpIjoiMjY5Y2M0OTUtMzM3Yy00OGYwLWFmM2UtNmVkMjNkNmJiODI4In0=.sqnMeGjFu3QEtHrqfupoQklMraeL9_9LiPWOiDP2oqH-30ote2SbIDnOvl9zXXtoHLeC3a_OoTC9HQKDrnDgYfeC1Fqe6i_DBZDg6F4SkSLG0CMccwhBeOW8-pTvQXy3lEKVR_sZ2_ry-taLQS9kQK48sHqEojslTryizuypYfxPW2ni4ANwkRmqVhen1uq04g08k1czspfUz5rT6YkX0O3oV9yLn4egW0iMvkagspZeQcDCOU25iowAxjsOTY_oFXHGBN77IE__ld6X4pX5AXxoNEr3fnI5-JWaXUDKGdYGOpoyG_FlnmHQsyQZtoYujGW9_367WwW1j37Brp4Y0w==";

    var body = {
      "username": username,
      "password": password,
      "getProfile": getProfile
    };
    // ignore: unused_local_variable
    var apiResult =
        await http.post(Uri.parse(apiUrl), body: json.encode(body), headers: {
      "apikey": apiKey,
      "Content-Type": "application/json",
      "accept": "application/json",
    });
    var JsonResult = json.decode(apiResult.body);

    return UserLogin.MapObject(JsonResult);
  }
}
