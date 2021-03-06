import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:schools_out/components/comicsSlider.dart';
import 'package:schools_out/components/menu.dart';
import 'package:schools_out/components/quizSlider.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text(
          "School's Out",
          style: TextStyle(
              color: Colors.black, fontSize: 28, fontFamily: 'Lemon'),
        ),
        backgroundColor: Colors.grey[100],
      ),
      drawer: menu(),
      body: SafeArea(
        child: SingleChildScrollView(
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
                      "Quiz",
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color: Colors.black,
                          fontFamily: 'Lemon'),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.65,
                    ),
                  ],
                ),
              ),
              quizSlider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "LIVROS",
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color: Colors.black,
                          fontFamily: 'Lemon'),
                    ),
                    SizedBox(
                      width: 180,
                    ),
                  ],
                ),
              ),
              comicsSlider(),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageData extends StatelessWidget {
  String image;

  ImageData(this.image);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(image),
            fit: BoxFit.scaleDown,
          ),
          borderRadius: BorderRadius.circular(8.0)),
      child: Align(
        alignment: Alignment.bottomCenter,
      ),
    );
  }
}
