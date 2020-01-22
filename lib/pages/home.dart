import 'package:firebase_auth/firebase_auth.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schools_out/pages/comicsPage.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController animationController;

  @override
  void initState() {
    // super.initState();
    animationController =
        new AnimationController(duration: Duration(seconds: 200), vsync: this);
    animation =
        IntTween(begin: 0, end: photos.length - 1).animate(animationController)
          ..addListener(() {
            setState(() {
              index = animation.value;
            });
          });

    animationController.repeat(period: Duration(seconds: 20));
  }

  int index = 0;
  List<String> photos = [
    'https://i.ibb.co/kc1mjTW/abduc-a-o-55-1.png',
    'https://i.ibb.co/nmFdgs8/abduc-a-o-55-2.jpg'
  ];

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ComicsList(Comics clist) => InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Detailpage(
                      comics: clist,
                    )),
          );
        },
        child: PopularMovie(
          image: clist.pages[0].image,
          name: clist.name,
          rating: '10',
        ));
    bestm(BMovies movie) => TopMovies(
          image: movie.Image,
        );

    final comics_scroll = Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        child: Row(
          children: comicsList.map((cl) => ComicsList(cl)).toList(),
        ),
      ),
    );

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: new IconThemeData(color: Colors.blueGrey[600]),
          centerTitle: true,
          title: Text(
            "Schools Out",
            style: TextStyle(color: Colors.blueGrey[600], fontSize: 28),
          ),
          backgroundColor: Colors.white,
          //    leading:Icon(Icons.notifications,color: Colors.red,) ,
          //  toolbarOpacity: 0,
        ),
        drawer: new Drawer(
          child: ListView(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountName: new Text('Test User'),
                accountEmail: new Text('testemail@test.com'),
                currentAccountPicture: new CircleAvatar(
                  backgroundImage: new NetworkImage('http://i.pravatar.cc/300'),
                ),
              ),
              new ListTile(
                title: new Text('Test Navigation'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) => new Homepage()));
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    ImageData(photos[index]),

                    //  TopMovies()
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "HQ's",
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          color: Colors.blueGrey),
                    ),
                    SizedBox(
                      width: 180,
                    ),
                  ],
                ),
              ),
              netflixslider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Tirinhas",
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          color: Colors.blueGrey),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.65,
                    ),
                    Text(
                      "See All",
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          color: Colors.blueGrey),
                    )
                  ],
                ),
              ),
              comics_scroll
            ],
          ),
        ));
  }
}

class ImageData extends StatelessWidget {
  String image;

  ImageData(this.image);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 180,
      decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(image),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(8.0)),
      child: Align(
        alignment: Alignment.bottomCenter,
      ),
    );
  }
}

class TopMovies extends StatelessWidget {
  final String image;

  TopMovies({Key key, this.image});

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

////////////////////////////////////////////

class PopularMovie extends StatelessWidget {
  String image, name;
  String rating;

  PopularMovie({this.image, this.name, this.rating});

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
                    fit: BoxFit.cover,
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
            Text(
              "IMDB ${rating}",
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////

class ComicsPage {
  String image;
  int page;

  ComicsPage(this.image, this.page);
}

class Comics {
  List<ComicsPage> pages;
  String name;
  int edition;

  Comics(this.name, this.edition, this.pages);
}

final List<Comics> comicsList = [
  Comics('Teste', 1, [
    ComicsPage('https://i.ibb.co/nmFdgs8/abduc-a-o-55-2.jpg', 1),
    ComicsPage('https://i.ibb.co/kc1mjTW/abduc-a-o-55-1.png', 2),
  ]),
  Comics('Teste 2', 2, [
    ComicsPage('https://i.ibb.co/nmFdgs8/abduc-a-o-55-2.jpg', 1),
    ComicsPage('https://i.ibb.co/kc1mjTW/abduc-a-o-55-1.png', 2),
  ]),
  Comics('Teste 3', 3, [
    ComicsPage('https://i.ibb.co/nmFdgs8/abduc-a-o-55-2.jpg', 1),
    ComicsPage('https://i.ibb.co/kc1mjTW/abduc-a-o-55-1.png', 2),
  ]),
];

///////////////////////////////////////////////////

final List<String> imglist = [
  "assets/abducao_55_1.png",
  "assets/abducao_55_1.jpg",
  "assets/abducao_55_1.jpg",
  "assets/abducao_55_1.jpg",
  "assets/abducao_55_1.jpg",
  "assets/abducao_55_1.jpg",
  "assets/abducao_55_1.jpg",
  "assets/abducao_55_1.jpg",
  "assets/abducao_55_1.jpg",
  "assets/abducao_55_1.jpg"
];
//final Widget placeholder=container();
//List<hi> map<hi> hi passed in list for to
// accpet any type agrument like widget,string,class (model class)

class netflixslider extends StatelessWidget {
  final CarouselSlider mostwatch = CarouselSlider(
      autoPlay: true,
      viewportFraction: 0.9,
      aspectRatio: 2.4,
      enlargeCenterPage: false,
      items: imglist.map((url) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                image:
                    DecorationImage(image: AssetImage(url), fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0.2, 1.0),
                      blurRadius: 2,
                      color: Colors.white)
                ]),
            // child: Image.network(url),
          ),
        );
      }).toList());

  @override
  Widget build(BuildContext context) {
    return mostwatch;
  }
}

/////////////////////////////////////////////////////

class BMovies {
  String Image;
  int Boxc;

  BMovies(this.Image);
}
