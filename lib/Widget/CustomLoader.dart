import 'package:flutter/material.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 30,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorDark,
          borderRadius: BorderRadius.circular(size.width * 0.01),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CircularProgressIndicator(
              backgroundColor: Theme.of(context).primaryColorDark,
              semanticsLabel: "Dobabes",
              semanticsValue: "Loading",
              strokeWidth: 10,
            ),
            SizedBox(height: 10),
            Text(
              "Loading",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.body1,
            ),
          ],
        ),
      ),
    );
  }
}
