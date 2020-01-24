import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schools_out/components/hqSlider.dart';
import 'package:schools_out/components/comicsSlider.dart';

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
              hqSlider(),
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
              comicsSlider(),
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