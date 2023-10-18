import 'dart:convert';

import 'package:http/http.dart';
import 'package:spin_better/res/strings.dart';

import '../res/uris.dart';

class JwtTokenReceiver {

  Future<void> eraseTokenAfter(int seconds) async {
    await Future.delayed(Duration(seconds: seconds));
    _accessToken = null;
  }

  Future<void> takeToken() async {
    Response response = await post(jwtTokenRequestUri, body: {
      "client_id": clientId,
      "client_secret": clientSecret
    });
    Map<String, dynamic> json = jsonDecode(response.body);
    _accessToken = json["access_token"];
    eraseTokenAfter(json["expires_in"]!);
  }

  Future<String> getToken() async {
    if(_accessToken == null) {
      await takeToken();
    }
    return _accessToken!;
  }

  String? _accessToken;
}