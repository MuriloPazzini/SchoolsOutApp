import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schools_out/entities/comics.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ComicsReadingPage extends StatefulWidget {
  final Comics comics;
  const ComicsReadingPage(this.comics);

  @override
  _ComicsReadingPage createState() => _ComicsReadingPage();
}

class _ComicsReadingPage extends State<ComicsReadingPage> {
  final Widget placeholder = Container(color: Colors.grey);

  TextEditingController _c = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<T> map<T>(List list, Function handler) {
      List<T> result = [];
      for (var i = 0; i < list.length; i++) {
        result.add(handler(i, list[i]));
      }

      return result;
    }

    final List child = map<Widget>(
      widget.comics.pages,
      (index, i) {
        return Container(
          margin: EdgeInsets.all(5.0),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            child: Stack(children: <Widget>[
              Image.network(i.image,
                  fit: BoxFit.cover, width: MediaQuery.of(context).size.width),
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        offset: Offset(0.2, 1.0),
                        blurRadius: 2,
                        color: Colors.grey)
                  ]),
                ),
              ),
            ]),
          ),
        );
      },
    ).toList();

    final CarouselSlider comicsCarousel = CarouselSlider(
        items: child,
        autoPlay: false,
        enableInfiniteScroll: false,
        enlargeCenterPage: true,
        aspectRatio: 2.0,
        scrollPhysics: BouncingScrollPhysics(),
        height: MediaQuery.of(context).size.width * 0.9);

    return Scaffold(
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.blueGrey[600]),
        centerTitle: true,
        title: Text(
          "School's Out",
          style: TextStyle(color: Colors.blueGrey[600], fontSize: 28),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.fromLTRB(
                    0.0, MediaQuery.of(context).size.height * 0.17, 0.0, 0.0),
                child: comicsCarousel),
            Padding(
              padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height * 0.2,
                child: TextField(
                  keyboardType: TextInputType.numberWithOptions(),
                  controller: _c,
                  obscureText: false,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      hintText: "Página que deseja ir",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0))),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        backgroundColor: Colors.blueGrey[600],
        onPressed: () {
          comicsCarousel.jumpToPage(int.parse(_c.text) - 1);
        },
        child: Icon(Icons.search),
      ),
    );
  }
}
