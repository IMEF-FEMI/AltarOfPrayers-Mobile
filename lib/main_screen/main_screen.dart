import 'package:altar_of_prayers/authentication_bloc/bloc.dart';
import 'package:altar_of_prayers/models/user.dart';
import 'package:altar_of_prayers/universal/category_card.dart';
import 'package:altar_of_prayers/universal/dev_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainScreen extends StatelessWidget {
  final User user;

  const MainScreen({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return DevScaffold(
    //   title: 'Altar Of Prayers',
    //   logout: () {
    //     BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
    //   },
    //   body: Center(
    //       child: ListView(
    //     children: <Widget>[
    //       Text(user.fullName),
    //       Text(user.email),
    //       Text(user.accountType),
    //       Text(user.admin.toString()),
    //     ],
    //   )),
    // );

    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height * .3,
            decoration: BoxDecoration(
                color: Color(0xFF000000),
                gradient: LinearGradient(colors: [
                  Color(0xFF000000),
                  Color(0xFFFFFFFF)
                  
                ], stops: [
                  0.0,
                  0.7,
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          ),
          AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: Text(
              "Altar Of Prayers",
              style: Theme.of(context)
                  .textTheme
                  .title
                  .copyWith(color: Colors.white),
            ),
          ),
          // Positioned(
          //   top: MediaQuery.of(context).size.height * 0.15,
          //   left: 20,
            
          //   right: MediaQuery.of(context).size.width * 0.3,
          //   child: Text(
          //     "Hi, Welcome to Stack Overflow Questions App",
          //     style: TextStyle(
          //       color: Colors.white70,
          //       fontSize: 22,
          //     ),
          //   ),
          // )
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 40.0),
                  Text(
                    "Welcome Back \n${user.fullName.split(' ')[0]}",
                    style: Theme.of(context).textTheme.display1.copyWith(
                        fontWeight: FontWeight.w900, color: Colors.black),
                  ),

                ],
              ),
            ),
          )

          // Expanded(
          //         child: GridView.count(
          //       childAspectRatio: .85,
          //       crossAxisSpacing: 20,
          //       mainAxisSpacing: 20,
          //       crossAxisCount: 2,
          //       padding: EdgeInsets.symmetric(vertical: 20),
          //       children: <Widget>[
          //         CategoryCard(
          //           title: "Saved",
          //           img: Image(
          //               height: 100,
          //               image: new AssetImage("assets/gifs/bookmark.gif")),
          //           onPressed: () {},
          //         ),
          //         CategoryCard(
          //           title: "Prophetic Prayers",
          //           img: Image(
          //               height: 80,
          //               image: new AssetImage(
          //                   "assets/gifs/swordandshield.gif")),
          //           onPressed: () {},
          //         ),
          //         CategoryCard(
          //           title: "New Editions",
          //           img: Image(
          //               height: 100,
          //               image: new AssetImage("assets/gifs/editions.gif")),
          //           onPressed: () {},
          //         ),
          //         CategoryCard(
          //           title: "My Editions",
          //           img: Image(
          //               height: 100,
          //               image: new AssetImage("assets/gifs/books.gif")),
          //           onPressed: () {},
          //         ),
          //         CategoryCard(
          //           title: "Profile",
          //           img: Image(
          //               height: 100,
          //               image: new AssetImage("assets/gifs/profile.gif")),
          //           onPressed: () {},
          //         ),
          //       ],
          //     ))
        ],
      ),
    );
  }
}
