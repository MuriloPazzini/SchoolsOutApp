import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:schools_out/pages/comicsReadingPage.dart';
import 'package:schools_out/entities/comicsPage.dart';
import 'package:schools_out/entities/comics.dart';
import 'dart:async';

class comicsSlider extends StatefulWidget {
  @override
  _comicsSlider createState() => _comicsSlider();
}



class _comicsSlider extends State<comicsSlider> {
  Future getComics() async {
    var firestore = Firestore.instance;

    QuerySnapshot qn = await firestore.collection("comics").where('type', isEqualTo: 'comics').getDocuments();

    return qn.documents;
  }

  @override
  Widget build(BuildContext context) {
    List<Comics> comicsList = new List<Comics>();

    ComicsList(Comics clist) => InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ComicsReadingPage(clist)));


          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ComicsReadingPage(
                  clist,
                )),
          );
        },
        child: PopularHq(
          image: clist.pages[0].image,
          name: clist.name,
        ));
    bestm(BMovies movie) => HqWidget(
      image: movie.Image,
    );


    return FutureBuilder(
      future: getComics(),
      initialData: [],
      builder: (_, snapshot) {
        if (snapshot.data == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if(snapshot.data.length > 0){
          comicsList.clear();

          snapshot.data.forEach((element) {
            List<ComicsPage> pagesForThisHq = new List<ComicsPage>();

            element.data['pages'].forEach((page) {
              pagesForThisHq.add(ComicsPage(page['image'].toString(), page['page']));
            });

            comicsList.add(
                Comics(element.data['name'], element.data['edition'], pagesForThisHq));
          });

          return Container(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              child: Row(
                children: comicsList.map((cl) => ComicsList(cl)).toList(),
              ),
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


class BMovies {
  String Image;
  int Boxc;

  BMovies(this.Image);
}


class PopularHq extends StatelessWidget {
  String image, name;

  PopularHq({this.image, this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        child: Column(
          children: <Widget>[
            Container(
              height: 140,
              width: 100,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(image),
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.circular(6.0),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0.5, 1.0),
                        blurRadius: 5,
                        color: Colors.white)
                  ]),
            ),
            Container(
              //width: 100,
              //height: 40,
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class HqWidget extends StatelessWidget {
  final String image;

  HqWidget({Key key, this.image});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipOval(
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(image),
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
    );
  }
}