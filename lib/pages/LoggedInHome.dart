import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:schools_out/components/hqSlider.dart';
import 'package:schools_out/components/comicsSlider.dart';
import 'package:schools_out/pages/loggedOutHome.dart';
import 'package:schools_out/pages/quizList.dart';

class LoggedInHomepage extends StatefulWidget {
  @override
  _LoggedInHomepage createState() => _LoggedInHomepage();
}

class _LoggedInHomepage extends State<LoggedInHomepage>
    with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController animationController;

  @override
  void initState() {
    //super.initState();
    animationController =
        new AnimationController(duration: Duration(seconds: 200), vsync: this);
    animation =
        IntTween(begin: 0, end: photos.length - 1).animate(animationController)
          ..addListener(() {
            setState(() {
              index = animation.value;
            });
          });

    animationController.repeat(period: Duration(seconds: 20));
  }

  int index = 0;
  List<String> photos = [
    'https://i.ibb.co/kc1mjTW/abduc-a-o-55-1.png',
    'https://i.ibb.co/nmFdgs8/abduc-a-o-55-2.jpg'
  ];

  @override
  dispose() {
    animationController.dispose(); // you need this
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: new IconThemeData(color: Colors.blueGrey[600]),
          centerTitle: true,
          title: Text(
            "School's Out",
            style: TextStyle(color: Colors.blueGrey[600], fontSize: 28),
          ),
          backgroundColor: Colors.white,
        ),
        drawer: new SizedBox(
          width: MediaQuery.of(context).size.width * 0.55, //20.0,
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(4.0)),
            child: new Drawer(
              child: ListView(
                children: <Widget>[
                  new Container(
                      height: MediaQuery.of(context).size.width * 0.21,
                      child: Center(
                        child: UserAccountsDrawerHeader(
                          accountName: new Text('Test User'),
                          accountEmail: new Text('testemail@test.com'),
                        ),
                      )),
                  new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RawMaterialButton(
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
                      Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text('Home'),
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
                        child: Text('Quiz'),
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
                        child: Text('Sair'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    ImageData(photos[index]),

                    //  TopMovies()
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "HQ's",
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          color: Colors.blueGrey),
                    ),
                    SizedBox(
                      width: 180,
                    ),
                  ],
                ),
              ),
              hqSlider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Tirinhas",
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          color: Colors.blueGrey),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.65,
                    ),
                  ],
                ),
              ),
              comicsSlider(),
            ],
          ),
        ));
  }
}

class ImageData extends StatelessWidget {
  String image;

  ImageData(this.image);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 180,
      decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(image),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(8.0)),
      child: Align(
        alignment: Alignment.bottomCenter,
      ),
    );
  }
}
