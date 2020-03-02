import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schools_out/entities/answer.dart';
import 'package:schools_out/entities/question.dart';
import 'package:schools_out/entities/quiz.dart';

Future getQuiz() async {
  List<Quiz> quizList = new List<Quiz>();

  var firestore = Firestore.instance;

  QuerySnapshot qn = await firestore.collection("quiz").getDocuments();

  qn.documents.forEach((element) {
    List<Question> questions = new List<Question>();

    element.data['questions'].forEach((question) {
      List<Answer> answersForThisQuestion = new List<Answer>();

      question['answers'].forEach((answer) {
        answersForThisQuestion
            .add(new Answer(answer['correct'], answer['description']));
      });
      questions
          .add(new Question(question['description'], answersForThisQuestion));
    });

    Quiz quizToAdd = new Quiz(element.data['name'], questions);
    quizList.add(quizToAdd);
  });

  return quizList;
}
