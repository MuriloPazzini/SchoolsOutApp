import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:schools_out/entities/user.dart';

Future<User> getLoggedUser() async {
  FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

  if (firebaseUser == null) {
    return null;
  } else {
    var firestore = Firestore.instance;

    QuerySnapshot qn = await firestore
        .collection("users")
        .where('id', isEqualTo: firebaseUser.uid)
        .getDocuments();

    var currentLoggedUser = new User(
        qn.documents[0]['id'],
        qn.documents[0]['nickname'],
        qn.documents[0]['aboutMe'],
        qn.documents[0]['photoUrl'],
        qn.documents[0]['role']);

    return currentLoggedUser;
  }
}
