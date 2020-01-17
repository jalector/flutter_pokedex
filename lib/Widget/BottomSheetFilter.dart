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
    PokedexProvider provider = PokedexProvider.of(context);

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 550,
      ),
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Positioned.fill(
            child: Container(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          Positioned.fill(
            top: -25,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Select the pokemon by type or name",
                textAlign: TextAlign.center,
                style: theme.textTheme.title,
              ),
            ),
          ),
          Align(
            heightFactor: 1,
            alignment: Alignment.center,
            child: Container(
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
                    endIndent: size.width * 0.18,
                    indent: size.width * 0.18,
                    color: Colors.white70,
                  ),
                  SizedBox(height: 10),
                  this.searchField(context, provider),
                  SizedBox(height: 10),
                  CupertinoSlidingSegmentedControl(
                    groupValue: provider.bloc.filterMode,
                    backgroundColor: theme.primaryColor,
                    thumbColor: theme.colorScheme.secondaryVariant,
                    children: {
                      PokedexBloc.filterModeInclusive: Text("Inclusive"),
                      PokedexBloc.filterModeExclusive: Text("Exclusive"),
                    },
                    onValueChanged: (int i) {
                      provider.bloc.changeFilterMode(i);
                      setState(() {});
                      widget.update(() {});
                    },
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Wrap(children: typeChips(context, provider.bloc)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget searchField(BuildContext context, PokedexProvider provider) {
    return StreamBuilder<String>(
      stream: provider.bloc.searchedPokemonStream,
      builder: (context, snapshot) {
        return TextFormField(
          decoration: InputDecoration(
            hintText: "Search your pokemon",
            errorText: snapshot.error,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          initialValue: provider.bloc.searchedPokemon,
          onChanged: (val) {
            provider.bloc.onChangeSearchedPokemon(val);
          },
          onEditingComplete: () {
            this.widget.update(() {});
          },
        );
      },
    );
  }

  List<Widget> typeChips(BuildContext context, PokedexBloc bloc) {
    List<Widget> types = [];
    Map<String, bool> filterTypes = bloc.filter;
    Size size = MediaQuery.of(context).size;

    filterTypes.forEach((String type, bool available) {
      types.add(Padding(
        padding: EdgeInsets.symmetric(
          vertical: 0,
          horizontal: size.width * 0.01,
        ),
        child: FilterChip(
          elevation: 5,
          label: Text(type),
          selected: available,
          avatar: Image.asset("assets/badges_type/${type.toLowerCase()}.png"),
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
