import 'package:altar_of_prayers/blocs/my_editions/bloc.dart';
import 'package:altar_of_prayers/widgets/app_scaffold.dart';
import 'package:altar_of_prayers/widgets/edition_card.dart';
import 'package:altar_of_prayers/widgets/error_screen.dart';
import 'package:altar_of_prayers/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyEditionsPage extends StatefulWidget {
  @override
  _MyEditionsPageState createState() => _MyEditionsPageState();
}

class _MyEditionsPageState extends State<MyEditionsPage> {
  MyEditionsBloc _myEditionsBloc;
  GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _myEditionsBloc = MyEditionsBloc();
  }

  @override
  void dispose() {
    super.dispose();
    _myEditionsBloc.close();
  }

  Future<Null> fetchNewEditions() async {
    _myEditionsBloc.add(LoadMyEditions());
    await Future.delayed(Duration(seconds: 2));
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "My Editions",
      body: BlocProvider<MyEditionsBloc>(
          create: (context) => _myEditionsBloc..add(LoadMyEditions()),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<MyEditionsBloc, MyEditionsState>(
              builder: (context, state) {
                if (state is MyEditionsLoaded)
                  return RefreshIndicator(
                    key: refreshKey,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.editions.length,
                      itemBuilder: (context, index) {
                        return EditionCard(
                          edition: state.editions[index],
                        );
                      },
                    ),
                    onRefresh: fetchNewEditions,
                  );
                if (state is MyEditionError)
                  return ErrorScreen(
                    errorMessage: 'Oops! an Error Occured',
                    btnText: 'Try Again',
                    btnOnPressed: () => _myEditionsBloc.add(LoadMyEditions()),
                  );
                if (state is MyEditionsNotLoaded)
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SvgPicture.asset(
                          'assets/icons/empty-folder.svg',
                          height: 100,
                        ),
                        SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "Nothing here",
                            textAlign: TextAlign.center,
                            style:
                                Theme.of(context).textTheme.headline6.copyWith(
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
                return LoadingWidget();
              },
            ),
          )),
    );
  }
}
