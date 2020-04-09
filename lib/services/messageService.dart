import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schools_out/entities/answer.dart';
import 'package:schools_out/entities/message.dart';
import 'package:schools_out/entities/question.dart';
import 'package:schools_out/entities/quiz.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String BASE_URL = 'http://schools-out-backend.herokuapp.com';

Future<List<String>> getMessageHistory() async {
  List<String> messageList = new List<String>();

  final response = await http.get('${BASE_URL}/chatHistory');

  var documents = json.decode(response.body);

  documents['data'].forEach((element) {
      messageList.add(json.decode(element)['message']);
  });


  return messageList;
}
