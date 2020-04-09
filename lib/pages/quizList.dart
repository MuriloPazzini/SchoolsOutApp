import 'package:flutter/material.dart';
import 'package:schools_out/components/menu.dart';
import 'package:schools_out/entities/answer.dart';
import 'package:schools_out/entities/question.dart';
import 'package:schools_out/entities/quiz.dart';
import 'package:schools_out/pages/quizAnsweringPage.dart';
import 'package:schools_out/services/quizService.dart';

class QuizList extends StatefulWidget {
  @override
  _QuizList createState() => _QuizList();
}

class _QuizList extends State<QuizList> {
  Future<List<Quiz>> futureQuizList;

  @override
  void initState() {
    super.initState();
    futureQuizList = getQuiz();
  }

  @override
  Widget build(BuildContext context) {
    List<Quiz> quizList = new List<Quiz>();

    return FutureBuilder(
      future: futureQuizList,
      initialData: [],
      builder: (_, snapshot) {
        if (snapshot.data == null) {
          return Scaffold(
              body: Center(
            child: CircularProgressIndicator(),
          ));
        } else if (snapshot.data.length > 0) {
          quizList = snapshot.data;

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              iconTheme: new IconThemeData(color: Colors.white),
              centerTitle: true,
              title: Text(
                "School's Out",
                style: TextStyle(
                    color: Colors.white, fontSize: 28, fontFamily: 'Toontime'),
              ),
              backgroundColor: Colors.blueGrey[600],
            ),
            drawer: menu(),
            body: SafeArea(
              child: Container(
                padding: EdgeInsets.only(top: 15.0),
                child: GridView.count(
                  crossAxisCount: 3,
                  childAspectRatio: 1.3,
                  children: quizList.map((quizItem) {
                    return Builder(builder: (BuildContext context) {
                      return new Column(
                        children: <Widget>[
                          RawMaterialButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          new quizpage(quizItem)));
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
                            child: Text(quizItem.name,
                                style: TextStyle(fontFamily: 'Toontime')),
                          ),
                        ],
                      );
                    });
                  }).toList(),
                ),
              ),
            ),
          );
        } else {
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
      },
    );
  }
}
