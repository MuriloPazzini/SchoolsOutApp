import 'package:cloud_firestore/cloud_firestore.dart';

Future getHqs() async {
  var firestore = Firestore.instance;

  QuerySnapshot qn = await firestore
      .collection("comics")
      .where('type', isEqualTo: 'hq')
      .getDocuments();

  return qn.documents;
}

Future getComics() async {
  var firestore = Firestore.instance;

  QuerySnapshot qn = await firestore.collection("comics").getDocuments();

  return qn.documents;
}
