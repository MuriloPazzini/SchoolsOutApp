import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schools_out/entities/answer.dart';
import 'package:schools_out/entities/question.dart';
import 'package:schools_out/entities/quiz.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String BASE_URL = 'http://schools-out-backend.herokuapp.com';

Future<List<Quiz>> getQuiz() async {
  List<Quiz> quizList = new List<Quiz>();

  final response = await http.get('${BASE_URL}/api/quiz/all');

  var documents = json.decode(response.body);

  documents.forEach((element) {
    List<Question> questions = new List<Question>();

    element['questions'].forEach((question) {
      List<Answer> answersForThisQuestion = new List<Answer>();

      question['answers'].forEach((answer) {
        answersForThisQuestion
            .add(new Answer(answer['correct'], answer['description']));
      });
      questions
          .add(new Question(question['description'], answersForThisQuestion));
    });

    Quiz quizToAdd = new Quiz(element['name'], questions);
    quizList.add(quizToAdd);
  });

  return quizList;
}
