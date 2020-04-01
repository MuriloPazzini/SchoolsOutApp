import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:schools_out/pages/home.dart';
import 'package:splashscreen/splashscreen.dart';

Widget splash() {
  return Stack(
    children: <Widget>[
      SplashScreen(
        seconds: 1,
        navigateAfterSeconds: HomePage(),
        loaderColor: Colors.transparent,
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(15, 20, 20, 15),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/logo.png"),
              fit: BoxFit.scaleDown,
            ),
          ),
        ),
      ),
    ],
  );
}

class SplashScreenComponent extends StatefulWidget {
  @override
  _SplashScreenComponentState createState() => _SplashScreenComponentState();
}

class _SplashScreenComponentState extends State<SplashScreenComponent> {
  final assetsAudioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    super.initState();
    assetsAudioPlayer.open("assets/success.mp3");
    assetsAudioPlayer.play();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return MaterialApp(
        title: 'Splash Screen',
        theme: ThemeData(primaryColor: Colors.white),
        home: Container(
          height: height,
          width: width,
          child: splash(),
        ));
  }
}
