import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final Widget img;
  final String title;
  final Function onPressed;

  const CategoryCard({Key key, this.img, this.title, this.onPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFE6E6E6),
            blurRadius: 20,
            offset: Offset(0, 17),
            spreadRadius: -17,
          )
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(13),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onPressed,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Spacer(),
                img,
                Spacer(),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .title
                      .copyWith(fontSize: 15, fontWeight: FontWeight.w700),
                ),
                Spacer()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
