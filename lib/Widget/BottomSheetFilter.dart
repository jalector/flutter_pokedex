import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_pokedex/Bloc/Pokedex_bloc.dart';
import 'package:flutter_pokedex/Provider/PokedexProvider.dart';
import 'package:flutter/cupertino.dart' show CupertinoSlidingSegmentedControl;

class BottomSheetFilter extends StatefulWidget {
  final Function(void Function()) update;

  BottomSheetFilter({@required this.update});

  @override
  _BottomSheetFilterState createState() => _BottomSheetFilterState();
}

class _BottomSheetFilterState extends State<BottomSheetFilter> {
  var agua = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);
    PokedexBloc bloc = PokedexProvider.of(context).bloc;

    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Container(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),
        Align(
          heightFactor: 1,
          alignment: Alignment.center,
          child: Container(
            height: size.height * 0.45,
            constraints: BoxConstraints(maxWidth: 600),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              color: theme.colorScheme.secondaryVariant.withOpacity(0.5),
            ),
            padding: EdgeInsets.only(
              top: 0,
              bottom: 10,
              left: size.width * 0.005,
              right: size.width * 0.005,
            ),
            child: Column(
              children: <Widget>[
                Divider(
                  thickness: 3,
                  endIndent: size.width * 0.18,
                  indent: size.width * 0.18,
                  color: Colors.white70,
                ),
                SizedBox(height: 15),
                Text(
                  "Select the type of pokemon that you want to filter",
                  style: theme.textTheme.title,
                ),
                SizedBox(height: 15),
                CupertinoSlidingSegmentedControl(
                  groupValue: bloc.filterMode,
                  children: {
                    PokedexBloc.filter_mode_inclusive: Text("Inclusive"),
                    PokedexBloc.filter_mode_exclusive: Text("Exclusive"),
                  },
                  onValueChanged: (int i) {
                    bloc.changeFilterMode(i);
                    setState(() {});
                    widget.update(() {});
                  },
                ),
                SizedBox(height: 15),
                Wrap(children: typeChips(context, bloc)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> typeChips(BuildContext context, PokedexBloc bloc) {
    List<Widget> types = [];
    Map<String, bool> filterTypes = bloc.filter;
    Size size = MediaQuery.of(context).size;

    filterTypes.forEach((String type, bool available) {
      types.add(Padding(
        padding: EdgeInsets.symmetric(
          vertical: size.height * 0.001,
          horizontal: size.width * 0.01,
        ),
        child: FilterChip(
          elevation: 5,
          label: Text(type),
          selected: available,
          onSelected: (value) {
            filterTypes[type] = !filterTypes[type];
            bloc.addFilter(filterTypes);

            setState(() {});
            this.widget.update(() {});
          },
        ),
      ));
    });

    return types;
  }
}
