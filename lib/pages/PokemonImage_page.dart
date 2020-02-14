//import 'dart:io' as io;
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
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
  SuccessController _flareController;
  var _imagenKey = GlobalKey();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  bool storingImage = false;

  void update() => setState(() {});

  @override
  void initState() {
    super.initState();
    _flareController = SuccessController("success", update, 0);
  }

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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.file_download),
        onPressed: () async {
          if ((await _savePokemonImage()) != null) _flareController.playOnce();
        },
      ),
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

class SuccessController extends FlareController {
  final Function _update;
  final String _animationName;
  final double _mix;
  ActorAnimation _actor;
  double _duration = 0, _loopCount = 0, _loopAmount;

  SuccessController(this._animationName, this._update,
      [this._mix = 0.5, this._loopAmount = 1]);

  void playOnce() {
    _loopAmount = 1;
    _loopCount = 0;
    _update();
  }

  @override
  void initialize(FlutterActorArtboard artboard) {
    _actor = artboard.getAnimation(_animationName);
  }

  @override
  bool advance(FlutterActorArtboard artBoard, double elapsed) {
    if (_loopCount >= _loopAmount) {
      _actor.apply(0, artBoard, 1);
    } else {
      _duration += elapsed;

      if (_duration >= _actor.duration) {
        _loopCount++;
        _duration %= _actor.duration;
      }
      _actor.apply(_duration, artBoard, _mix);
    }

    return true;
  }

  @override
  void setViewTransform(Mat2D viewTransform) {}
}
