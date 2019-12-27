import 'package:flutter/material.dart';
import 'package:flutter_pokedex/Provider/PokedexProvider.dart';

class BottomSheetFilter extends StatefulWidget {
  BottomSheetFilter({Key key}) : super(key: key);

  @override
  _BottomSheetFilterState createState() => _BottomSheetFilterState();
}

class _BottomSheetFilterState extends State<BottomSheetFilter> {
  var agua = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    PokedexProvider provider = PokedexProvider.of(context);

    return Container(
      height: size.height * 0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        color: Colors.green,
      ),
      padding: EdgeInsets.all(30),
      child: Wrap(
        children: <Widget>[
          FilterChip(
            label: Text("Water"),
            selected: agua,
            onSelected: (value) {
              setState(() {
                agua = !agua;
              });
            },
          ),
        ],
      ),
    );
  }
}
