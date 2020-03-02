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
  @override
  Widget build(BuildContext context) {
    List<Comics> hqList = new List<Comics>();

    return FutureBuilder(
      future: getComics(),
      initialData: [],
      builder: (_, snapshot) {
        if (snapshot.data == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.data.length > 0) {
          hqList.clear();

          snapshot.data.forEach((element) {
            List<ComicsPage> pagesForThisHq = new List<ComicsPage>();

            element.data['pages'].forEach((page) {
              pagesForThisHq
                  .add(ComicsPage(page['image'].toString(), page['page']));
            });

            hqList.add(Comics(
                element.data['name'], element.data['edition'], pagesForThisHq));
          });

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

          return CarouselSlider(
              autoPlay: true,
              viewportFraction: 1.0,
              aspectRatio: 0.9,
              enlargeCenterPage: false,
              items: hqList.map((hq) {
                return Builder(
                  builder: (BuildContext context) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
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
                                image:
                                    NetworkImage(hq.pages[0].image, scale: 0.5),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0.2, 1.0),
                                  blurRadius: 2,
                                  color: Colors.grey)
                            ]),
                      ),
                    );
                  },
                );
              }).toList());
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
