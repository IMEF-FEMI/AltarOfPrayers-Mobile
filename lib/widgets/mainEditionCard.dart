import 'package:flutter/material.dart';

class MainEditionCard extends StatelessWidget {
  final IconData icon;
  final String month;
  final Function onPressed;

  const MainEditionCard({Key key, this.icon, this.month, this.onPressed}) : super(key: key);

  threeSidedBorderRadius({double radius = 8}) {
    return BorderRadius.only(
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(radius),
        bottomRight: Radius.circular(radius));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: threeSidedBorderRadius(radius: 15),
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: threeSidedBorderRadius(radius: 15),
            border: Border.all(color: Colors.grey)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ConstrainedBox(
                constraints: BoxConstraints.expand(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.0,
                ),
                child: Icon(
                  icon,
                  size: 40,
                  color: Colors.cyan,
                ),
              ),
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  month,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
