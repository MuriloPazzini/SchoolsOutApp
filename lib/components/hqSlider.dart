import 'package:flutter/material.dart';
import 'package:schools_out/pages/comicsReadingPage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:schools_out/entities/comicsPage.dart';
import 'package:schools_out/entities/comics.dart';
import 'dart:async';

import 'package:schools_out/services/comicsService.dart';

class hqSlider extends StatefulWidget {
  @override
  _hqSliderState createState() => _hqSliderState();
}

class _hqSliderState extends State<hqSlider> {
  List<Comics> hqList = new List<Comics>();
  Future<List<Comics>> futureComicsList;

  @override
  void initState() {
    super.initState();
    futureComicsList = getComics();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureComicsList,
      initialData: [],
      builder: (_, snapshot) {
        if (snapshot.data == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.data.length > 0) {
          hqList.clear();

          List<ComicsPage> pagesForThisHq = new List<ComicsPage>();

          snapshot.data[0].pages.forEach((page) {
            pagesForThisHq.add(ComicsPage(page.image.toString(), page.page));
          });

          hqList.add(Comics(
              snapshot.data[0].name,
              snapshot.data[0].edition,
              pagesForThisHq,
              snapshot.data[0].description,
              snapshot.data[0].price,
              snapshot.data[0].id));

          return Container(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              child: Row(
                  children: hqList.map((hq) {
                return Builder(builder: (BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 200,
                      width: 200,
                      child: GestureDetector(onTap: () {
                        Navigator.push<Widget>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ComicsReadingPage(
                              hq,
                            ),
                          ),
                        );
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
