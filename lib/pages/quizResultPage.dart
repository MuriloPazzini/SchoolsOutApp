import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:schools_out/components/menu.dart';
import 'package:schools_out/pages/loggedInHome.dart';
import 'package:schools_out/pages/loggedOutHome.dart';
import 'package:schools_out/pages/quizList.dart';

class resultpage extends StatefulWidget {
  int marks;
  int questionsLength;

  resultpage({Key key, @required this.marks, @required this.questionsLength})
      : super(key: key);

  @override
  _resultpageState createState() => _resultpageState(marks, questionsLength);
}

class _resultpageState extends State<resultpage> {
  List<String> images = [
    "assets/logo.png",
    "assets/logo.png",
    "assets/logo.png",
  ];

  String message;
  String image;

  @override
  void initState() {
    image = images[0];

    if (marks == 0) {
      message = "Você não acertou nenhuma perqunta";
    } else {
      message = "Você acertou $marks de $questionsLength";
    }

    super.initState();
  }

  int marks;
  int questionsLength;

  _resultpageState(this.marks, this.questionsLength);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Resultado",
            style: TextStyle(fontFamily: 'Toontime', color: Colors.white)),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.blueGrey[600],
      ),
      drawer: menu(),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 8,
              child: Material(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Material(
                        child: Container(
                          width: 300.0,
                          height: 300.0,
                          child: ClipRect(
                            child: Image(
                              image: AssetImage(
                                image,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15.0,
                          ),
                          child: Center(
                            child: (marks == 0)
                                ? Text(
                                    'Que pena!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 38.0,
                                      fontFamily: "Toontime",
                                    ),
                                  )
                                : Text(
                                    'Parabéns!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 38.0,
                                      fontFamily: "Toontime",
                                    ),
                                  ),
                          )),
                      Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 05.0,
                            horizontal: 15.0,
                          ),
                          child: Center(
                            child: Text(
                              message,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22.0,
                                fontFamily: "Toontime",
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  OutlineButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => QuizList(),
                      ));
                    },
                    child: Text(
                      "Continue",
                      style: TextStyle(fontSize: 18.0, fontFamily: 'Toontime'),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 25.0,
                    ),
                    borderSide: BorderSide(width: 3.0, color: Colors.indigo),
                    splashColor: Colors.indigoAccent,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
