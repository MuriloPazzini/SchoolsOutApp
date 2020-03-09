import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:schools_out/components/comicsSlider.dart';
import 'dart:convert';

import 'package:schools_out/entities/comics.dart';
import 'package:schools_out/entities/comicsPage.dart';

const String BASE_URL = 'http://schools-out-backend.herokuapp.com';

Future<List<Comics>> getHqs() async {
  final response = await http.get('${BASE_URL}/api/comics/all');

  var documents = json.decode(response.body);

  List<Comics> comics = new List<Comics>();

  documents.forEach((element) {
    if (element['type'] == 'hq') {
      List<ComicsPage> comicsPages = new List<ComicsPage>();

      element['pages'].forEach((page) {
        ComicsPage comicsPage = new ComicsPage(page['image'], page['page']);
        comicsPages.add(comicsPage);
      });

      Comics currentComics =
          new Comics(element['name'], element['edition'], comicsPages);

      comics.add(currentComics);
    }
  });

  return comics;
}

Future<List<Comics>> getComics() async {
  final response = await http.get('${BASE_URL}/api/comics/all');

  var documents = json.decode(response.body);

  List<Comics> comics = new List<Comics>();

  documents.forEach((element) {
    List<ComicsPage> comicsPages = new List<ComicsPage>();

    element['pages'].forEach((page) {
      ComicsPage comicsPage = new ComicsPage(page['image'], page['page']);
      comicsPages.add(comicsPage);
    });

    Comics currentComics =
        new Comics(element['name'], element['edition'], comicsPages);

    comics.add(currentComics);
  });

  return comics;
}
