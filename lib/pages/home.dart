import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:schools_out/components/comicsSlider.dart';
import 'package:schools_out/pages/loggedInHome.dart';
import 'package:schools_out/pages/loggedOutHome.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  Future<bool> isUserLogged() async {
    FirebaseUser firebaseUser = await getLoggedFirebaseUser();

    if (firebaseUser != null) {
      try {
        IdTokenResult tokenResult =
            await firebaseUser.getIdToken(refresh: true);
        return tokenResult.token != null;
      } catch (e) {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<FirebaseUser> getLoggedFirebaseUser() {
    return FirebaseAuth.instance.currentUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: isUserLogged(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data) {
              return LoggedInHomepage();
            } else {
              return LoggedOutHomepage();
            }
          }

          /// other way there is no user logged.
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        });
  }
}
