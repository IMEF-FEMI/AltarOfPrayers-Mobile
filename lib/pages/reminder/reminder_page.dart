import 'package:altar_of_prayers/blocs/reminder/bloc.dart';
import 'package:altar_of_prayers/blocs/reminder/reminder_bloc.dart';
import 'package:altar_of_prayers/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ReminderPage extends StatefulWidget {
  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  ReminderBloc _bloc;
  @override
  void initState() {
    super.initState();
    _bloc = ReminderBloc();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReminderBloc>(
      create: (context) => _bloc..add(CheckReminder()),
      child: BlocBuilder<ReminderBloc, ReminderState>(
        builder: (context, state) {
          return AppScaffold(
            title: "Reminder",
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Image.asset(
                        "assets/gifs/timer-animation.gif",
                        height: 300,
                        // width: 300,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Set Reminder On / Off",
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    if (state is ReminderInitial || state is ReminderOff)
                      IconButton(
                        icon: Icon(
                          FontAwesomeIcons.toggleOff,
                          size: 38,
                        ),
                        onPressed: () {
                          _bloc.add(SetReminderOn(
                              time: TimeOfDay(hour: 6, minute: 00)));
                        },
                      ),
                    if (state is ReminderOn)
                      IconButton(
                        icon: Icon(
                          FontAwesomeIcons.toggleOn,
                          size: 38,
                        ),
                        onPressed: () {
                          _bloc.add(SetReminderOff());
                        },
                      ),
                    SizedBox(
                      height: 15,
                    ),
                    if (state is ReminderOn)
                      RaisedButton(
                        onPressed: () async {
                          await showTimePicker(
                            initialTime: TimeOfDay(hour: state.time.hour, minute: state.time.minute),
                            context: context,
                          ).then((value) {
                            if (value != null) {
                              _bloc.add(SetReminderOn(
                                time: TimeOfDay(
                                  hour: value.hour,
                                  minute: value.minute,
                                ),
                              ));
                            }
                            return;
                          });
                        },
                        child: Text("${state.time.format(context)}",
                            style: TextStyle(color: Colors.white)),
                        color: Theme.of(context).accentColor,
                        splashColor: Colors.white.withOpacity(.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8)),
                        ),
                      )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
