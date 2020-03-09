import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:schools_out/entities/user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

const String BASE_URL = 'http://schools-out-backend.herokuapp.com';

Future<User> getLoggedUser() async {
  FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

  if (firebaseUser == null) {
    return null;
  } else {
    final response = await http.get('${BASE_URL}/api/user/getById/${firebaseUser.uid}');

    var document = json.decode(response.body);

    var currentLoggedUser = new User(
        document['id'],
        document['nickname'],
        document['aboutMe'],
        document['photoUrl'],
        document['role']);

    return currentLoggedUser;

  }
}

Future<User> RegisterNewUser (User user) async {
  var map = new Map<String, dynamic>();
  map["id"] = user.id;
  map["photoUrl"] = user.photoUrl;
  map["aboutMe"] = user.aboutMe;
  map["nickname"] = user.nickname;
  map["role"] = user.role;

  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json'};



  final response = await http.post('http://schools-out-backend.herokuapp.com/api/user/register', headers: requestHeaders, body: jsonEncode(map));

  var document = json.decode(response.body);

  return user;
}

Future<User> getUserById(String id) async {
  final response = await http.get('${BASE_URL}/api/user/getById/${id}');

  var document = json.decode(response.body);

  var currentLoggedUser = new User(
      document['id'],
      document['nickname'],
      document['aboutMe'],
      document['photoUrl'],
      document['role']);

  return currentLoggedUser;
}