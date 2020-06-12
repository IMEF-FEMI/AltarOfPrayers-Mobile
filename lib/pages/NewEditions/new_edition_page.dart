import 'package:altar_of_prayers/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NewEditionPage extends StatefulWidget {
  final edition;

  const NewEditionPage({Key key, this.edition}) : super(key: key);

  @override
  NewEditionPageState createState() => NewEditionPageState();
}

class NewEditionPageState extends State<NewEditionPage> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: '',
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: <Widget>[
            Center(
              child: Hero(
                tag: widget.edition['name'],
                child: SvgPicture.asset(
                  'assets/icons/shopping-cart.svg',
                  fit: BoxFit.contain,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
