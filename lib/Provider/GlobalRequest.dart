import 'package:flutter_pokedex/Model/HttpAnswer.dart';
import 'package:http/http.dart' as http;

export 'package:flutter_pokedex/Model/HttpAnswer.dart';

class GlobalRequest {
  static final GlobalRequest _instance = GlobalRequest._();
  static final String pokemonHub = "db.pokemongohub.net";
  static final String image =
      "https://db.pokemongohub.net/images/official/detail/";
  static final String sprites =
      "https://db.pokemongohub.net/images/ingame/normal/";
  static final String video = "https://db.pokemongohub.net/videos/";

  Map<String, String> _headers;
  String token;

  factory GlobalRequest() {
    return _instance;
  }

  GlobalRequest._() {
    this._headers = {"Content-Type": "application/json"};
  }
  Future<HttpAnswer<Type>> get<Type>(String api, String path,
      {Map<String, String> params}) async {
    HttpAnswer<Type> response = HttpAnswer<Type>();

    try {
      Uri uri = Uri.http(api, path, params);
      response.answer = await http.get(uri, headers: this._headers);
      response.ok = response.answer.statusCode == 200;
    } catch (e) {
      response.reasonPhrase = e?.message;
    }
    return response;
  }
}
