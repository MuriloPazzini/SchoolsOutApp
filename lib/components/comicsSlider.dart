import 'package:flutter/material.dart';
import 'package:schools_out/entities/user.dart';
import 'package:schools_out/pages/comicsBuyingPage.dart';
import 'package:schools_out/pages/comicsReadingPage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:schools_out/entities/comicsPage.dart';
import 'package:schools_out/entities/comics.dart';
import 'dart:async';

import 'package:schools_out/services/comicsService.dart';
import 'package:schools_out/services/userService.dart';

class comicsSlider extends StatefulWidget {
  @override
  _comicsSliderState createState() => _comicsSliderState();
}

class _comicsSliderState extends State<comicsSlider> {
  List<Comics> comicsList = new List<Comics>();
  Future<List<Comics>> futureComicsList;
  Future<User> loggedUser;

  @override
  void initState() {
    super.initState();
    futureComicsList = getComics();
    loggedUser = getLoggedUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([futureComicsList, loggedUser]),
      initialData: [],
      builder: (_, snapshot) {
        if (snapshot.data == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.data.length > 1) {
          comicsList.clear();

          List<ComicsPage> pagesForThisHq = new List<ComicsPage>();

          snapshot.data[0].forEach((element) {
            element.pages.forEach((page) {
              pagesForThisHq.add(ComicsPage(page.image.toString(), page.page));
            });

            comicsList.add(Comics(
                element.name,
                element.edition,
                pagesForThisHq,
                element.description,
                element.price,
                element.id));
          });


          return Container(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              child: Row(
                  children: comicsList.map((hq) {
                return Builder(builder: (BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 200,
                      width: 200,
                      child: GestureDetector(onTap: () {
                        if (!snapshot.data[1].owned.contains(hq.id) &&
                            hq.price > 0) {
                          Navigator.push<Widget>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ComicsBuyingPage(
                                hq,
                              ),
                            ),
                          );
                        } else {
                          Navigator.push<Widget>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ComicsReadingPage(
                                hq,
                              ),
                            ),
                          );
                        }
                      }),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(hq.pages[0].image),
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
                  );
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
