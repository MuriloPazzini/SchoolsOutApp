import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:schools_out/pages/home.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Detailpage extends StatelessWidget {
  final Comics comics;

  Detailpage({this.comics});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: new IconThemeData(color: Colors.blueGrey[600]),
          centerTitle: true,
          title: Text(
            "Schools Out",
            style: TextStyle(color: Colors.blueGrey[600], fontSize: 28),
          ),
          backgroundColor: Colors.white,
        ),
        body: Center(
            child: CarouselSlider(
          enableInfiniteScroll: false,
          autoPlay: false,
          height: MediaQuery.of(context).size.width * 0.8,
          items: comics.pages.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(color: Colors.white),
                  child: Image.network(
                    i.image,
                  ),
                );
              },
            );
          }).toList(),
        )));
  }
}
