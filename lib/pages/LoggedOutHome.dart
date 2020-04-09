import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:schools_out/entities/user.dart';
import 'package:schools_out/pages/home.dart';
import 'package:schools_out/services/userService.dart';
import 'package:schools_out/pages/signUp.dart';
import 'package:shared_preferences/shared_preferences.dart';

TextEditingController emailController = new TextEditingController();
TextEditingController passwordController = new TextEditingController();
bool isLoading = false;

class LoggedOutHomepage extends StatefulWidget {
  @override
  _LoggedOutHomepage createState() => _LoggedOutHomepage();
}

class _LoggedOutHomepage extends State<LoggedOutHomepage> {
  final emailField = TextField(
    controller: emailController,
    obscureText: false,
    decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "E-mail",
        hintStyle: TextStyle(fontFamily: 'Toontime'),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: new BorderSide(width: 1, color: Colors.teal)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: new BorderSide(width: 1, color: Colors.teal))),
  );
  final passwordField = TextField(
    controller: passwordController,
    obscureText: true,
    decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Senha",
        hintStyle: TextStyle(fontFamily: 'Toontime'),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: new BorderSide(width: 1, color: Colors.teal)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: new BorderSide(width: 1, color: Colors.teal))),
  );

  @override
  dispose() {
    isLoading = false;
    super.dispose();
  }

  @override
  @protected
  @mustCallSuper
  initState() {
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    SharedPreferences prefs;

    return Scaffold(
      appBar: new AppBar(
        iconTheme: new IconThemeData(color: Colors.blueGrey[600]),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "School's Out",
          style: TextStyle(
              color: Colors.white, fontSize: 28, fontFamily: 'Toontime'),
        ),
        backgroundColor: Colors.blueGrey[600],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(36.0, 56.0, 36.0, 36.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 155.0,
                      child: Image.asset(
                        "assets/logo.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 45.0),
                    emailField,
                    SizedBox(height: 25.0),
                    passwordField,
                    SizedBox(
                      height: 35.0,
                    ),
                    isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Column(
                            children: <Widget>[
                              isLoading
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          0.0, 12.0, 0.0, 0.0),
                                      child: SizedBox(
                                        width: 120,
                                        child: Material(
                                          elevation: 5.0,
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                          color: Colors.blueGrey[600],
                                          child: MaterialButton(
                                            padding: EdgeInsets.fromLTRB(
                                                20.0, 15.0, 20.0, 15.0),
                                            onPressed: () async {
                                              try {
                                                setState(() {
                                                  isLoading = true;
                                                });

                                                FirebaseUser user = (await FirebaseAuth
                                                        .instance
                                                        .signInWithEmailAndPassword(
                                                            email:
                                                                emailController
                                                                    .text,
                                                            password:
                                                                passwordController
                                                                    .text)
                                                        .timeout(new Duration(
                                                            seconds: 45)))
                                                    .user;

                                                User userInfo =
                                                    await getUserById(user.uid);

                                                await SharedPreferences
                                                        .getInstance()
                                                    .then(
                                                        (SharedPreferences sp) {
                                                  prefs = sp;
                                                  prefs.setString(
                                                      'userId', user.uid);
                                                  prefs.setStringList(
                                                      'owned', userInfo.owned);
                                                  prefs.setString('nickname',
                                                      userInfo.nickname);
                                                  prefs.setString('aboutMe',
                                                      userInfo.aboutMe);
                                                  prefs.setString('photoUrl',
                                                      userInfo.photoUrl);
                                                });

                                                Navigator.of(context).pop();
                                                Navigator.push(
                                                  context,
                                                  new MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        new HomePage(),
                                                  ),
                                                );
                                              } catch (e) {
                                                setState(() {
                                                  isLoading = false;
                                                });
                                                String errorToShow;

                                                if (Platform.isAndroid) {
                                                  switch (e.message) {
                                                    case 'There is no user record corresponding to this identifier. The user may have been deleted.':
                                                      errorToShow =
                                                          'Usuário não encontrado';
                                                      break;
                                                    case 'The password is invalid or the user does not have a password.':
                                                      errorToShow =
                                                          'Senha é inválida';
                                                      break;
                                                    case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
                                                      errorToShow =
                                                          'Problema com conexão';
                                                      break;
                                                    // ...
                                                    default:
                                                      errorToShow =
                                                          'Ocorreu um problema ao autenticar';
                                                  }
                                                } else if (Platform.isIOS) {
                                                  switch (e.code) {
                                                    case 'Error 17011':
                                                      errorToShow =
                                                          'Usuário não encontrado';
                                                      break;
                                                    case 'Error 17009':
                                                      errorToShow =
                                                          'Senha é inválida';
                                                      break;
                                                    case 'Error 17020':
                                                      errorToShow =
                                                          'Problema com conexão';
                                                      break;
                                                    // ...
                                                    default:
                                                      errorToShow =
                                                          'Ocorreu um problema ao autenticar';
                                                  }
                                                }
                                                return showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      // Retrieve the text the user has entered by using the
                                                      // TextEditingController.
                                                      content: Text(errorToShow,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Toontime',
                                                              color: Colors
                                                                  .white)),
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                            child: Text(
                                              "Login",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: 'Toontime',
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
                                child: SizedBox(
                                  width: 120,
                                  child: Material(
                                    elevation: 5.0,
                                    borderRadius: BorderRadius.circular(30.0),
                                    color: Colors.blueGrey[600],
                                    child: MaterialButton(
                                      padding: EdgeInsets.fromLTRB(
                                          20.0, 15.0, 20.0, 15.0),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SignUpPage()),
                                        );
                                      },
                                      child: Text("Cadastro",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: 'Toontime',
                                              color: Colors.white)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                    SizedBox(
                      height: 15.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
