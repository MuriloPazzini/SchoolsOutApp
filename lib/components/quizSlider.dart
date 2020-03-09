import 'package:flutter/material.dart';
import 'package:schools_out/entities/answer.dart';
import 'package:schools_out/entities/question.dart';
import 'package:schools_out/entities/quiz.dart';
import 'package:schools_out/pages/comicsReadingPage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:schools_out/entities/comicsPage.dart';
import 'package:schools_out/entities/comics.dart';
import 'package:schools_out/pages/quizAnsweringPage.dart';
import 'dart:async';
import 'package:schools_out/services/quizService.dart';

class quizSlider extends StatefulWidget {
  @override
  _quizSliderState createState() => _quizSliderState();
}

class _quizSliderState extends State<quizSlider> {

  Future<List<Quiz>> futureQuizList;

  @override
  void initState() {
    super.initState();
    futureQuizList = getQuiz();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureQuizList,
      initialData: [],
      builder: (_, snapshot) {
        if (snapshot.data == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.data.length > 0) {
          var quizList = new List<Quiz>();

          snapshot.data.forEach((element) {
            var questionList = new List<Question>();

            element.questions.forEach((question) {
              var answersToAdd = new List<Answer>();
              question.answers.forEach((answer) {
                answersToAdd
                    .add(new Answer(answer.correct, answer.description));
              });
              var questionToAdd =
                  new Question(question.description, answersToAdd);
              questionList.add(questionToAdd);
            });

            quizList.add(new Quiz(element.name, questionList));
          });

          return Container(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              child: Row(
                  children: quizList.map((quiz) {
                return Builder(builder: (BuildContext context) {
                  return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          ClipOval(
                            child: Container(
                              height: 60,
                              width: 60,
                              child: GestureDetector(onTap: () {
                                Navigator.push<Widget>(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            new quizpage(quiz)));
                              }),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/logo.png"),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(0.5, 1.0),
                                        blurRadius: 5,
                                        color: Colors.white)
                                  ]),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Text(
                              quiz.name,
                              style: TextStyle(fontFamily: 'Toontime'),
                            ),
                          )
                        ],
                      ));
                });
              }).toList()),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
