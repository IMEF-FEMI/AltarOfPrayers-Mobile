import 'package:altar_of_prayers/models/user.dart';
import 'package:altar_of_prayers/universal/category_card.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  final User user;

  const Home({Key key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var initial = user.fullName.split(' ')[0][0];
    var username = user.fullName
        .split(' ')[0]
        .replaceFirst(new RegExp('$initial'), '${initial.toUpperCase()}');

    return Stack(
      children: <Widget>[
        Container(
          height: size.height * .45,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              gradient: LinearGradient(colors: [
                Color(0xFF000000),
                // Color(0xFF093312),
                Color(0xFFFFFFFF),
              ], stops: [
                0.0,
                7.0,
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        ),
        AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text(
            "Altar Of Prayers",
            style:
                Theme.of(context).textTheme.title.copyWith(color: Colors.white),
          ),
        ),
        Padding(
          // padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          padding: const EdgeInsets.only(right: 30, left: 30, top: 30),
          child: Column(
            children: <Widget>[
              SizedBox(height: 40.0),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text(
                  "Welcome $username",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
              Expanded(
                  child: GridView.count(
                childAspectRatio: .85,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                crossAxisCount: 2,
                padding: EdgeInsets.symmetric(
                  vertical: 30,
                  // horizontal: 20
                ),
                children: <Widget>[
                  CategoryCard(
                    title: "Saved",
                    img: Image(
                        height: 100,
                        image: new AssetImage("assets/gifs/bookmark.gif")),
                    onPressed: () {},
                  ),
                  CategoryCard(
                    title: "Prophetic Prayers",
                    img: Image(
                        height: 80,
                        image:
                            new AssetImage("assets/gifs/swordandshield.gif")),
                    onPressed: () {},
                  ),
                  CategoryCard(
                    title: "New Editions",
                    img: Image(
                        height: 100,
                        image: new AssetImage("assets/gifs/editions.gif")),
                    onPressed: () {},
                  ),
                  CategoryCard(
                    title: "My Editions",
                    img: Image(
                        height: 100,
                        image: new AssetImage("assets/gifs/books.gif")),
                    onPressed: () {},
                  ),
                  CategoryCard(
                    title: "Profile",
                    img: Image(
                        height: 100,
                        image: new AssetImage("assets/gifs/profile.gif")),
                    onPressed: () {},
                  ),
                ],
              ))
            ],
          ),
        ),
      ],
    );
  }
}
