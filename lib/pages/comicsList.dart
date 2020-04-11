import 'package:flutter/material.dart';
import 'package:schools_out/components/menu.dart';
import 'package:schools_out/entities/comics.dart';
import 'package:schools_out/entities/comicsPage.dart';
import 'package:schools_out/entities/user.dart';
import 'package:schools_out/pages/comicsBuyingPage.dart';
import 'package:schools_out/services/comicsService.dart';
import 'package:schools_out/services/userService.dart';

import 'comicsReadingPage.dart';

class ComicsList extends StatefulWidget {
  createState() => ComicsListState();
}

class ComicsListState extends State<ComicsList> {
  List<Comics> comicsList = new List<Comics>();

  Future<List<Comics>> futureComicsList;
  Future<User> loggedUser;

  final PageController ctrl = PageController(viewportFraction: 0.7);

  // Keep track of current page to avoid unnecessary renders
  int currentPage = 0;

  @override
  void initState() {
    futureComicsList = getComics();
    loggedUser = getLoggedUser();

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

    handleOnTap(book, user) {
      if (!user.owned.contains(book.id) && book.price > 0) {
        Navigator.push<Widget>(
          context,
          MaterialPageRoute(
            builder: (context) => ComicsBuyingPage(
              book,
            ),
          ),
        );
      } else {
        Navigator.push<Widget>(
          context,
          MaterialPageRoute(
            builder: (context) => ComicsReadingPage(
              book,
            ),
          ),
        );
      }
    }

    buildPreviewPage(Comics data, bool active, User user) {
      // Animated Properties
      final double blur = active ? 20 : 0;
      final double offset = active ? 20 : 0;
      final double top = active ? 80 : 200;

      if (data.price != 0 && !user.owned.contains(data.id)) {
        return GestureDetector(
          onTap: () => handleOnTap(data, user),
          child: AnimatedContainer(
            height: 20,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeOutQuint,
            margin: EdgeInsets.only(top: top, bottom: 50, right: 0),
            child: ShaderMask(
              blendMode: BlendMode.lighten,
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  colors: [Colors.grey, Colors.grey],
                ).createShader(bounds);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.network(data.pages[0].image),
              ),
            ),
          ),
        );
      } else {
        return GestureDetector(
          onTap: () => handleOnTap(data, user),
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
    }

    return FutureBuilder(
      future: Future.wait([futureComicsList, loggedUser]),
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
        } else if (snapshot.data.length > 1) {
          comicsList.clear();

          snapshot.data[0].forEach((element) {
            List<ComicsPage> pagesForThisHq = new List<ComicsPage>();

            element.pages.forEach((page) {
              pagesForThisHq.add(ComicsPage(page.image.toString(), page.page));
            });

            comicsList.add(Comics(element.name, element.edition, pagesForThisHq,
                element.description, element.price, element.id));
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
                      return buildPreviewPage(
                          comicsList[currentIdx], active, snapshot.data[1]);
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
              body: SafeArea(
                  child: Center(
                child: CircularProgressIndicator(),
              )));
        }
      },
    );
  }
}
