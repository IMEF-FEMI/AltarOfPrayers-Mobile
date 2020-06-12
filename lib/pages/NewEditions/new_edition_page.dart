import 'package:altar_of_prayers/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NewEditionPage extends StatefulWidget {
  final edition;

  const NewEditionPage({Key key, this.edition}) : super(key: key);

  @override
  NewEditionPageState createState() => NewEditionPageState();
}

class NewEditionPageState extends State<NewEditionPage> {
  final months = {
    1: 'January - March',
    4: 'April - June',
    7: 'July - September',
    10: 'October - December',
  };
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: '',
      leading: IconButton(
        icon: Icon(
          Icons.close,
          // size: 20,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Column(
            children: <Widget>[
              Center(
                child: Hero(
                  tag: widget.edition['name'],
                  child: SvgPicture.asset(
                    'assets/icons/bible.svg',
                    fit: BoxFit.contain,
                    height: MediaQuery.of(context).size.height * .3,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                widget.edition['name'],
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.title.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w500
                      // color: Tools.multiColors[Random().nextInt(4)],
                    ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                months[int.parse('${widget.edition['startingMonth']}')],
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.title.copyWith(
                      fontSize: 18,
                      // fontWeight: FontWeight.bold,
                    ),
              ),

               SizedBox(
                height: 10,
              ),
              Text(
                '${widget.edition['year']}',
                textAlign: TextAlign.center,
                style:
                    Theme.of(context).textTheme.title.copyWith(fontSize: 15),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
