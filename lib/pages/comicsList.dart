import 'package:flutter/material.dart';
import 'package:schools_out/components/menu.dart';
import 'package:schools_out/entities/comics.dart';
import 'package:schools_out/entities/comicsPage.dart';
import 'package:schools_out/pages/comicsBuyingPage.dart';
import 'package:schools_out/services/comicsService.dart';

import 'comicsReadingPage.dart';

class ComicsList extends StatefulWidget {
  createState() => ComicsListState();
}

class ComicsListState extends State<ComicsList> {
  List<Comics> comicsList = new List<Comics>();

  Future<List<Comics>> futureComicsList;

  final PageController ctrl = PageController(viewportFraction: 0.7);

  // Keep track of current page to avoid unnecessary renders
  int currentPage = 0;

  @override
  void initState() {
    futureComicsList = getComics();

    // Set state when page changes
    ctrl.addListener(() {
      int next = ctrl.page.round();

      if (currentPage != next) {
        setState(() {
          currentPage = next;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Comics> comicsList = new List<Comics>();

    handleOnTap(hq) {
      Navigator.push<Widget>(
        context,
        MaterialPageRoute(
          builder: (context) => ComicsBuyingPage(
            hq,
          ),
        ),
      );
    }

    // Query Firestore
    _queryDb({String tag = 'favorites'}) {
      // TODO
    }

    // Builder Functions

    _buildStoryPage(Comics data, bool active) {
      // Animated Properties
      final double blur = active ? 20 : 0;
      final double offset = active ? 20 : 0;
      final double top = active ? 80 : 200;

      return GestureDetector(
        onTap: () => handleOnTap(data),
        child: AnimatedContainer(
          height: 20,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOutQuint,
          margin: EdgeInsets.only(top: top, bottom: 50, right: 0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                fit: BoxFit.scaleDown,
                image: NetworkImage(data.pages[0].image),
              ),
              boxShadow: []),
        ),
      );
    }

    _buildAllPages() {
      return PageView.builder(
          controller: ctrl,
          itemCount: comicsList.length,
          itemBuilder: (context, int currentIdx) {
            if (comicsList.length > currentIdx) {
              // Active page
              bool active = currentIdx == currentPage;
              return _buildStoryPage(comicsList[currentIdx], active);
            }
          });
    }

    _buildButton(tag) {
      // TODO
    }

    return FutureBuilder(
      future: futureComicsList,
      initialData: [],
      builder: (_, snapshot) {
        if (snapshot.data == null) {
          return Scaffold(
              appBar: AppBar(
                iconTheme: new IconThemeData(color: Colors.white),
                centerTitle: true,
                title: Text(
                  "School's Out",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontFamily: 'Toontime'),
                ),
                backgroundColor: Colors.blueGrey[600],
              ),
              drawer: menu(),
              body: Center(
                child: CircularProgressIndicator(),
              ));
        } else if (snapshot.data.length > 0) {
          comicsList.clear();

          snapshot.data.forEach((element) {
            List<ComicsPage> pagesForThisHq = new List<ComicsPage>();

            element.pages.forEach((page) {
              pagesForThisHq.add(ComicsPage(page.image.toString(), page.page));
            });

            comicsList
                .add(Comics(element.name, element.edition, pagesForThisHq, element.description, element.price));
          });

          return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                iconTheme: new IconThemeData(color: Colors.white),
                centerTitle: true,
                title: Text(
                  "School's Out",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontFamily: 'Toontime'),
                ),
                backgroundColor: Colors.blueGrey[600],
              ),
              drawer: menu(),
              body: PageView.builder(
                  controller: ctrl,
                  itemCount: comicsList.length,
                  itemBuilder: (context, int currentIdx) {
                    if (comicsList.length > currentIdx) {
                      // Active page
                      bool active = currentIdx == currentPage;
                      return _buildStoryPage(comicsList[currentIdx], active);
                    }
                  }));
        } else {
          return Scaffold(
              appBar: AppBar(
                iconTheme: new IconThemeData(color: Colors.white),
                centerTitle: true,
                title: Text(
                  "School's Out",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontFamily: 'Toontime'),
                ),
                backgroundColor: Colors.blueGrey[600],
              ),
              drawer: menu(),
              body: Center(
                child: CircularProgressIndicator(),
              ));
        }
      },
    );
  }
}
