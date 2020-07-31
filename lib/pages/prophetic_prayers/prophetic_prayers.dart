import 'package:altar_of_prayers/utils/tools.dart';
import 'package:altar_of_prayers/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';

class PropheticPrayers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> prayers = Tools.propheicPrayers;
    return AppScaffold(
      title: "Prophetic Prayers",
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      // shrinkWrap: true,
                      itemCount: prayers.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("${index + 1}. " + prayers[index],
                                softWrap: true,
                                textAlign: TextAlign.justify,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(
                                      fontFamily: "Georgia",
                                    )),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        );
                      },
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
