import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:schools_out/components/menu.dart';
import 'package:schools_out/entities/answer.dart';
import 'package:schools_out/entities/question.dart';
import 'package:schools_out/entities/quiz.dart';
import 'package:schools_out/pages/loggedInHome.dart';
import 'package:schools_out/pages/loggedOutHome.dart';
import 'package:schools_out/pages/quizAnsweringPage.dart';

class QuizList extends StatefulWidget {
  @override
  _QuizList createState() => _QuizList();
}

class _QuizList extends State<QuizList> {
  Future getQuiz() async {
    var firestore = Firestore.instance;

    QuerySnapshot qn = await firestore.collection("quiz").getDocuments();

    return qn.documents;
  }

  @override
  Widget build(BuildContext context) {
    List<Quiz> quizList = new List<Quiz>();

    return FutureBuilder(
      future: getQuiz(),
      initialData: [],
      builder: (_, snapshot) {
        if (snapshot.data == null) {
          return Scaffold(
              body: Center(
            child: CircularProgressIndicator(),
          ));
        } else if (snapshot.data.length > 0) {
          quizList.clear();

          snapshot.data.forEach((element) {
            List<Question> questions = new List<Question>();

            element.data['questions'].forEach((question) {
              List<Answer> answersForThisQuestion = new List<Answer>();

              question['answers'].forEach((answer) {
                answersForThisQuestion
                    .add(new Answer(answer['correct'], answer['description']));
              });
              questions.add(new Question(
                  question['description'], answersForThisQuestion));
            });

            Quiz quizToAdd = new Quiz(element.data['name'], questions);
            quizList.add(quizToAdd);
          });

          List<RawMaterialButton> quizListView = new List<RawMaterialButton>();

          quizList.forEach((f) {
            var result = new RawMaterialButton(
              onPressed: () {
                //Navigator.of(context).pop();
                //Navigator.push(
                //    context,
                //    new MaterialPageRoute(
                //        builder: (BuildContext context) =>
                //            new QuizAnswerPage()));
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
            );

            quizListView.add(result);
          });

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
            drawer: menu(),
            body: Container(
              padding: EdgeInsets.only(top:15.0),
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
                            child: Text(quizItem.name),
                          ),
                        ],
                      );
                    });
                  }).toList(),
                )),
          );
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
