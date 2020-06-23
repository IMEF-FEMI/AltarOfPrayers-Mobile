import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NotAvailable extends StatelessWidget {
  final String message;

  const NotAvailable({Key key, this.message}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(
            'assets/icons/empty.svg',
            height: 100,
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '$message',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.title.copyWith(
                    fontSize: 20,
                  ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
