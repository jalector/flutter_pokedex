import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HttpAnswer<Type> {
  http.Response answer;
  String reasonPhrase;
  Type object;
  bool ok;

  HttpAnswer({
    this.answer,
    this.object,
    this.reasonPhrase,
    this.ok = false,
  });

  void showError(BuildContext context) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("error"),
    ));
  }
}
