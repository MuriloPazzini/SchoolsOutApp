import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schools_out/entities/comics.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ComicsBuyingPage extends StatefulWidget {
  final Comics comics;

  const ComicsBuyingPage(this.comics);

  @override
  _ComicsBuyingPage createState() => _ComicsBuyingPage();
}

class _ComicsBuyingPage extends State<ComicsBuyingPage> {
  final Widget placeholder = Container(color: Colors.grey);

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
        iconTheme: new IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          widget.comics.name,
          style: TextStyle(
              color: Colors.white, fontSize: 28, fontFamily: 'Toontime'),
        ),
        backgroundColor: Colors.blueGrey[600],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.fromLTRB(
                    0, MediaQuery.of(context).size.height * 0.05, 0, 0),
                child: comicsCarousel),
            Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(left: 25, right: 25, bottom: 40),
              child: Text(widget.comics.description, style: TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'Toontime'))
            ),
            Container(
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.only(left: 25, right: 25, bottom: 70),
                child: Text('Preço: ' + widget.comics.price.toString(), style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Toontime'))
            )

          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        backgroundColor: Colors.purple[600],
        child: Icon(Icons.attach_money),
        onPressed: () =>{
          //TODO PAYMENT
        },
      ),
    );
  }
}
