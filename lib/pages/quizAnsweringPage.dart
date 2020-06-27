import 'dart:async';
import 'package:flutter/material.dart';
import 'package:schools_out/entities/answer.dart';
import 'package:schools_out/entities/question.dart';
import 'package:schools_out/entities/quiz.dart';
import 'package:schools_out/pages/quizResultPage.dart';

class quizpage extends StatefulWidget {
  final Quiz mydata;

  const quizpage(this.mydata);

  @override
  _quizpageState createState() => _quizpageState(mydata);
}

class _quizpageState extends State<quizpage> {
  Quiz mydata;

  bool isQuizAnswered;

  _quizpageState(this.mydata);

  Color colortoshow = Colors.blueGrey[600];
  Color right = Colors.green;
  Color wrong = Colors.red;
  int marks = 0;
  int i = 0;
  int j = 0;
  int timer = 30;
  String showtimer = "30";

  var btncolor = [
    Colors.blueGrey[600],
    Colors.blueGrey[600],
    Colors.blueGrey[600],
    Colors.blueGrey[600],
    Colors.blueGrey[600],
    Colors.blueGrey[600],
  ];

  bool canceltimer = true;

  var random_array = [];

  // overriding the initstate function to start timer as this screen is created
  @override
  void initState() {
    isQuizAnswered = false;
    starttimer();
    generateRandomOrderForAnwers(mydata.questions);
    generateRandomArray();
    super.initState();
  }

  // overriding the setstate function to be called only if mounted
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void generateRandomOrderForAnwers(List<Question> questions) {
    questions.forEach((quest) {
      quest.answers.shuffle();
    });
  }

  generateRandomArray() {
    var limit = mydata.questions.length;

    for (var x = 0; x < limit; x++) {
      random_array.add(x);
    }

    random_array.shuffle();

    i = random_array[0];
  }

  void starttimer() async {
    const onesec = Duration(seconds: 1);
    Timer.periodic(onesec, (Timer t) {
      setState(() {
        if (timer < 1) {
          t.cancel();
          nextquestion();
        } else if (canceltimer == true) {
          t.cancel();
        } else {
          timer = timer - 1;
        }
        showtimer = timer.toString();
      });
    });
  }

  void nextquestion() {
    canceltimer = true;
    timer = 30;
    setState(() {
      if (j < random_array.length - 1) {
        j++;
        i = random_array[j];
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) =>
              resultpage(marks: marks, questionsLength: random_array.length),
        ));
      }
      btncolor[0] = Colors.blueGrey[600];
      btncolor[1] = Colors.blueGrey[600];
      btncolor[2] = Colors.blueGrey[600];
      btncolor[3] = Colors.blueGrey[600];
      btncolor[4] = Colors.blueGrey[600];
      btncolor[5] = Colors.blueGrey[600];
      isQuizAnswered = false;
    });
    starttimer();
  }

  void checkanswer(int k) {
    // in the previous version this was
    // mydata[2]["1"] == mydata[1]["1"][k]
    // which i forgot to change
    // so nake sure that this is now corrected
    if (!isQuizAnswered) {
      isQuizAnswered = true;
      if (mydata.questions[i].answers[k].correct) {
        // just a print sattement to check the correct working
        // debugPrint(mydata[2][i.toString()] + " is equal to " + mydata[1][i.toString()][k]);
        marks = marks + 1;
        // changing the color variable to be green
        colortoshow = right;
      } else {
        // just a print sattement to check the correct working
        // debugPrint(mydata[2]["1"] + " is equal to " + mydata[1]["1"][k]);
        colortoshow = wrong;
      }
      setState(() {
        // applying the changed color to the particular button that was selected
        btncolor[k] = colortoshow;
        canceltimer = true;
      });

      // changed timer duration to 1 second
      Timer(Duration(seconds: 1), nextquestion);
    }
  }

  Widget choicebutton(int k) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 20.0,
      ),
      child: MaterialButton(
        onPressed: () => checkanswer(k),
        child: Text(
          mydata.questions[i].answers[k].description,
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Lemon",
            fontSize: 16.0,
          ),
          maxLines: 1,
        ),
        color: btncolor[k],
        splashColor: Colors.blueGrey[700],
        highlightColor: Colors.blueGrey[700],
        minWidth: 200.0,
        height: 45.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );
  }

  List<Widget> generateChoiceButtons(List<Answer> possibleAnswers) {
    List<Widget> result = List<Padding>();

    for (var w = 0; w < possibleAnswers.length; w++) {
      result.add(choicebutton(w));
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.55,
            child: Card(
              borderOnForeground: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.width * 0.15),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(15.0),
                      alignment: Alignment.bottomLeft,
                      child: Center(
                        child: Text(
                          mydata.questions[i].description,
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontSize: 18.0, fontFamily: 'Lemon'),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                            generateChoiceButtons(mydata.questions[i].answers)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
