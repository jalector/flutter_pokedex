import 'dart:io' as io;
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'package:permission_handler/permission_handler.dart';

import '../Widget/PokemonImage.dart';

class PokemonImagePage extends StatefulWidget {
  const PokemonImagePage({Key key}) : super(key: key);

  @override
  _PokemonImagePageState createState() => _PokemonImagePageState();
}

class _PokemonImagePageState extends State<PokemonImagePage> {
  FlareControls _flareController = SuccessFlareController();
  var _imagenKey = GlobalKey();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  bool storingImage = false;

  @override
  Widget build(BuildContext context) {
    String imageURL = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColorDark,
      ),
      backgroundColor: Theme.of(context).primaryColorDark,
      floatingActionButton: io.Platform.isAndroid
          ? FloatingActionButton(
              child: Icon(Icons.file_download),
              onPressed: () async {
                if ((await _savePokemonImage()) != null)
                  _flareController.play("success");
              },
            )
          : null,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
          child: Stack(
            children: <Widget>[
              Hero(
                tag: "image",
                child: RepaintBoundary(
                  key: _imagenKey,
                  child: PokemonImage(imageURL),
                ),
              ),
              FlareActor(
                "assets/flare/success.flr",
                alignment: Alignment.center,
                fit: BoxFit.contain,
                controller: _flareController,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> _savePokemonImage() async {
    String result;
    var hasPermissionToWrite = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (hasPermissionToWrite == PermissionStatus.granted) {
      ui.Image image = await _widgetToImage(_imagenKey);
      result = await _saveImageToGallery(image);
    } else {
      var permissions = await PermissionHandler()
          .requestPermissions([PermissionGroup.storage]);
      if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
        ui.Image image = await _widgetToImage(_imagenKey);
        result = await _saveImageToGallery(image);
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Storage permissions denied, can't save."),
        ));
      }
    }
    return result;
  }

  Future<ui.Image> _widgetToImage(GlobalKey key,
      {Duration delay = const Duration(milliseconds: 20),
      double pixelRatio = 1}) async {
    return Future.delayed(delay, () async {
      ui.Image image;
      try {
        RenderRepaintBoundary boundary = key.currentContext.findRenderObject();
        image = await boundary.toImage(pixelRatio: pixelRatio);
      } catch (e) {
        throw e;
      }
      return image;
    });
  }

  Future<String> _saveImageToGallery(ui.Image image) async {
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final result =
        await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
    print(result);
    return result;
  }
}

class SuccessFlareController extends FlareControls {
  @override
  void initialize(FlutterActorArtboard artboard) {
    super.initialize(artboard);
    play("idle");
  }
}
