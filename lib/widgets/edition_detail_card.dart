import 'package:flutter/material.dart';

class EditionDetailCard extends StatelessWidget {
  final Function onPressed;
  final Icon leadingIcon;
  final String title;
  final String subtitle;
  final String caption;

  const EditionDetailCard({
    Key key,
    this.onPressed,
    this.leadingIcon,
    this.title,
    this.subtitle,
    this.caption,
  }) : super(key: key);

  threeSidedBorderRadius({double radius = 8}) {
    return BorderRadius.only(
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(radius),
        bottomRight: Radius.circular(radius));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 28.0,
      ),
      child: InkWell(
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
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width * 0.3,
                    ),
                    child: leadingIcon),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (title != null)
                    Text(title,
                        style: Theme.of(context).textTheme.headline6.copyWith(
                            fontSize: 15, fontWeight: FontWeight.w500)),
                  SizedBox(
                    height: 5,
                  ),
                  if (subtitle != null)
                    Text(subtitle,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.subtitle2),
                  SizedBox(
                    height: 5,
                  ),
                  if (caption != null)
                    Text(caption,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.subtitle2),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
