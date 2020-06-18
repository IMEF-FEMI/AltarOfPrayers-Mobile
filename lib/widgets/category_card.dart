import 'package:altar_of_prayers/blocs/app_config/index.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String desctiption;
  final IconData icon;
  final Color color;
  final Function onTap;

  const CategoryCard(
      {Key key,
      this.title,
      this.desctiption,
      this.icon,
      this.color,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        // color: color.withOpacity(.15),
        color: Colors.grey.withOpacity(.15),
        // color: ConfigBloc().darkModeOn
        //     ? Colors.blueGrey.withOpacity(.15)
        //     : color.withOpacity(.15),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
            bottomRight: Radius.circular(8)),
        child: InkWell(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
              bottomRight: Radius.circular(4)),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(
                  icon,
                  size: 20,
                  color: color.withOpacity(.7),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(title,
                    style: Theme.of(context).textTheme.title.copyWith(
                          fontSize: 14,
                          color: color.withOpacity(.7),
                        )),
                SizedBox(
                  height: 15,
                ),
                Text(
                  desctiption,
                  style: TextStyle(fontSize: 10),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
