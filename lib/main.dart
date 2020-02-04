import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Provider/ThemeChanger.dart';
import 'Provider/PokedexProvider.dart';
import 'route.dart';

import 'dart:io' show Platform;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var theme = 0;

  if (Platform.isAndroid || Platform.isIOS) {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    theme = preferences.getInt(ThemeChanger.darkModeKey) ?? 0;
  }
  runApp(MyApp(theme));
}

class MyApp extends StatefulWidget {
  final int themeNumber;
  MyApp(this.themeNumber);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return PokedexProvider(
      child: ChangeNotifierProvider(
        create: (BuildContext context) => ThemeChanger(widget.themeNumber),
        child: Pokedex(),
      ),
    );
  }
}

class Pokedex extends StatelessWidget {
  const Pokedex({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pokedex',
      initialRoute: "/",
      onGenerateRoute: generateRoute,
      theme: theme.getTheme(),
    );
  }
}
