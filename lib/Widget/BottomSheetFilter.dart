import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_pokedex/Bloc/Pokedex_bloc.dart';
import 'package:flutter_pokedex/Provider/PokedexProvider.dart';

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
    var filterTypes = bloc.filter;
    List<Widget> types = [];

    filterTypes.forEach((String type, bool available) {
      types.add(FilterChip(
        label: Text(type),
        selected: available,
        onSelected: (value) {
          setState(() {
            filterTypes[type] = !filterTypes[type];
            print("Filter by: $type: $available");
            print(filterTypes);
            bloc.addFilter(filterTypes);
          });
          this.widget.update(() {});
        },
      ));
    });

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
            height: size.height * 0.4,
            constraints: BoxConstraints(maxWidth: 600),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              color: theme.colorScheme.secondaryVariant.withOpacity(0.5),
            ),
            padding: EdgeInsets.only(
              top: 0,
              bottom: 10,
              left: size.width * 0.02,
              right: size.width * 0.02,
            ),
            child: Column(
              children: <Widget>[
                Divider(
                  thickness: 3,
                  endIndent: size.width * 0.25,
                  indent: size.width * 0.25,
                  color: Colors.white.withOpacity(0.8),
                ),
                SizedBox(height: 15),
                Text(
                  "Select the type of pokemon that you want to filter",
                  style: theme.textTheme.title,
                ),
                SizedBox(height: 15),
                Wrap(
                  children: types,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
