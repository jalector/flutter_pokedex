import 'package:http/http.dart' as http;

import '../Model/HttpAnswer.dart';
export '../Model/HttpAnswer.dart';

class GlobalRequest {
  static final GlobalRequest _instance = GlobalRequest._();
  static final String pokemonHub = "db.pokemongohub.net";
  static final String image =
      "https://db.pokemongohub.net/images/official/detail/";
  static final String imageFull =
      "https://db.pokemongohub.net/images/official/full/";

  static final String sprites = "https://db.pokemongohub.net/images/ingame/";
  static final String video = "https://db.pokemongohub.net/videos/";
  static final String gif =
      "https://img.pokemondb.net/sprites/black-white/anim/normal/";
  static final String pixel =
      "https://img.pokemondb.net/sprites/sun-moon/icon/";

  Map<String, String> _headers;
  String token;

  factory GlobalRequest() => _instance;

  GlobalRequest._() {
    this._headers = {"Content-Type": "application/json"};
  }
  Future<HttpAnswer<Type>> get<Type>(String api, String path,
      {Map<String, String> params}) async {
    HttpAnswer<Type> response = HttpAnswer<Type>();

    try {
      Uri uri = Uri.http(api, path, params);
      response.answer = await http
          .get(uri, headers: this._headers)
          .timeout(Duration(seconds: 30));
      response.ok = response.answer.statusCode == 200;
    } catch (e) {
      response.reasonPhrase = e?.message;
    }
    return response;
  }
}
