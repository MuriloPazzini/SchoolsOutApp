import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:schools_out/entities/user.dart';
import 'package:schools_out/pages/chatPage.dart';
import 'package:schools_out/pages/comicsList.dart';
import 'package:schools_out/pages/loggedInHome.dart';
import 'package:schools_out/pages/loggedOutHome.dart';
import 'package:schools_out/pages/quizList.dart';
import 'package:schools_out/services/userService.dart';

class menu extends StatefulWidget {
  @override
  _menuState createState() => _menuState();
}

class _menuState extends State<menu> {
  Future<User> futureUser;

  @override
  void initState() {
    super.initState();
    futureUser = getLoggedUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureUser,
        initialData: null,
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return new SizedBox(
              width: MediaQuery.of(context).size.width * 0.3, //20.0,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(4.0)),
                child: new Drawer(
                  child: ListView(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(0.0),
                        color: Colors.blueGrey[600],
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                child: new CircleAvatar(
                                  backgroundImage:
                                  new NetworkImage(snapshot.data.photoUrl),
                                  radius: 35.0,
                                  backgroundColor: Colors.white,
                                ),
                                padding: EdgeInsets.only(top: 15.0),
                              ),
                              Padding(
                                padding:
                                EdgeInsets.only(top: 12.0, bottom: 20.0),
                                child: Text(snapshot.data.nickname,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16, fontFamily: 'Toontime')),
                              ),
                            ]),
                      ),
                      new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: RawMaterialButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                        new LoggedInHomepage()));
                              },
                              child: new Image.asset(
                                "assets/logo.png",
                                fit: BoxFit.contain,
                                width: 20.0,
                                height: 20.0,
                              ),
                              shape: new CircleBorder(),
                              elevation: 2.0,
                              fillColor: Colors.white,
                              padding: const EdgeInsets.all(15.0),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 12.0),
                            child: Text('Home',
                                style: TextStyle(fontFamily: 'Toontime')),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: RawMaterialButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                        new ComicsList()));
                              },
                              child: new Image.asset(
                                "assets/logo.png",
                                fit: BoxFit.contain,
                                width: 20.0,
                                height: 20.0,
                              ),
                              shape: new CircleBorder(),
                              elevation: 2.0,
                              fillColor: Colors.white,
                              padding: const EdgeInsets.all(15.0),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 12.0),
                            child: Text('Livros',
                                style: TextStyle(fontFamily: 'Toontime')),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: RawMaterialButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                        new QuizList()));
                              },
                              child: new Image.asset(
                                "assets/logo.png",
                                fit: BoxFit.contain,
                                width: 20.0,
                                height: 20.0,
                              ),
                              shape: new CircleBorder(),
                              elevation: 2.0,
                              fillColor: Colors.white,
                              padding: const EdgeInsets.all(15.0),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 12.0),
                            child: Text('Quiz',
                                style: TextStyle(fontFamily: 'Toontime')),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: RawMaterialButton(
                              onPressed: () async {
                                Navigator.push<Widget>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                      snapshot.data,
                                    ),
                                  ),
                                );
                              },
                              child: new Image.asset(
                                "assets/logo.png",
                                fit: BoxFit.contain,
                                width: 20.0,
                                height: 20.0,
                              ),
                              shape: new CircleBorder(),
                              elevation: 2.0,
                              fillColor: Colors.white,
                              padding: const EdgeInsets.all(15.0),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 12.0),
                            child: Text('Chat',
                                style: TextStyle(fontFamily: 'Toontime')),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: RawMaterialButton(
                              onPressed: () async {
                                await FirebaseAuth.instance.signOut();

                                Navigator.of(context).pop();
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                        new LoggedOutHomepage()));
                              },
                              child: new Image.asset(
                                "assets/logo.png",
                                fit: BoxFit.contain,
                                width: 20.0,
                                height: 20.0,
                              ),
                              shape: new CircleBorder(),
                              elevation: 2.0,
                              fillColor: Colors.white,
                              padding: const EdgeInsets.all(15.0),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 12.0),
                            child: Text('Sair',
                                style: TextStyle(fontFamily: 'Toontime')),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return new SizedBox(
              width: MediaQuery.of(context).size.width * 0.3, //20.0,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(4.0)),
                child: Drawer(
                  child: ListView(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(0.0),
                        color: Colors.blueGrey[600],
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                child: new Icon(
                                  Icons.account_circle,
                                  size: 70.0,
                                  color: Colors.grey,
                                ),
                                padding: EdgeInsets.only(top: 15.0),
                              ),
                              Padding(
                                padding:
                                EdgeInsets.only(top: 12.0, bottom: 20.0),
                                child: Text('Carregando...',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'Toontime')),
                              ),
                            ]),
                      ),
                      new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: RawMaterialButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                        new LoggedInHomepage()));
                              },
                              child: new Image.asset(
                                "assets/logo.png",
                                fit: BoxFit.contain,
                                width: 20.0,
                                height: 20.0,
                              ),
                              shape: new CircleBorder(),
                              elevation: 2.0,
                              fillColor: Colors.white,
                              padding: const EdgeInsets.all(15.0),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 12.0),
                            child: Text('Home',
                                style: TextStyle(fontFamily: 'Toontime')),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: RawMaterialButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                        new ComicsList()));
                              },
                              child: new Image.asset(
                                "assets/logo.png",
                                fit: BoxFit.contain,
                                width: 20.0,
                                height: 20.0,
                              ),
                              shape: new CircleBorder(),
                              elevation: 2.0,
                              fillColor: Colors.white,
                              padding: const EdgeInsets.all(15.0),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 12.0),
                            child: Text('Livros',
                                style: TextStyle(fontFamily: 'Toontime')),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: RawMaterialButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                        new QuizList()));
                              },
                              child: new Image.asset(
                                "assets/logo.png",
                                fit: BoxFit.contain,
                                width: 20.0,
                                height: 20.0,
                              ),
                              shape: new CircleBorder(),
                              elevation: 2.0,
                              fillColor: Colors.white,
                              padding: const EdgeInsets.all(15.0),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 12.0),
                            child: Text('Quiz',
                                style: TextStyle(fontFamily: 'Toontime')),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: RawMaterialButton(
                              onPressed: () async {

                              },
                              child: new Image.asset(
                                "assets/logo.png",
                                fit: BoxFit.contain,
                                width: 20.0,
                                height: 20.0,
                              ),
                              shape: new CircleBorder(),
                              elevation: 2.0,
                              fillColor: Colors.white,
                              padding: const EdgeInsets.all(15.0),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 12.0),
                            child: Text('Chat',
                                style: TextStyle(fontFamily: 'Toontime')),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: RawMaterialButton(
                              onPressed: () async {
                                await FirebaseAuth.instance.signOut();

                                Navigator.of(context).pop();
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                        new LoggedOutHomepage()));
                              },
                              child: new Image.asset(
                                "assets/logo.png",
                                fit: BoxFit.contain,
                                width: 20.0,
                                height: 20.0,
                              ),
                              shape: new CircleBorder(),
                              elevation: 2.0,
                              fillColor: Colors.white,
                              padding: const EdgeInsets.all(15.0),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 12.0),
                            child: Text('Sair',
                                style: TextStyle(fontFamily: 'Toontime')),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }
}


//ChatPage()