import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:schools_out/pages/home.dart';
import 'package:schools_out/pages/loggedinHome.dart';
import 'package:schools_out/pages/signUp.dart';

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
        hintText: "Email",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
  );
  final passwordField = TextField(
    controller: passwordController,
    obscureText: true,
    decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Password",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        iconTheme: new IconThemeData(color: Colors.blueGrey[600]),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "School's Out",
          style: TextStyle(color: Colors.blueGrey[600], fontSize: 28),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
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
                            ) : Material(
                              elevation: 5.0,
                              borderRadius: BorderRadius.circular(30.0),
                              color: Color(0xff01A0C7),
                              child: MaterialButton(
                                padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                onPressed: signIn,
                                child: Text(
                                  "Login",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
                              child: Material(
                                elevation: 5.0,
                                borderRadius: BorderRadius.circular(30.0),
                                color: Color(0xff01A0C7),
                                child: MaterialButton(
                                  padding: EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignUpPage()),
                                    );
                                  },
                                  child: Text(
                                    "Cadastro",
                                    textAlign: TextAlign.center,
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
    );
  }

  void signIn() async {
    try {
      setState(() {
        isLoading = true;
      });
      FirebaseUser user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text))
          .user;

      MaterialPageRoute(builder: (BuildContext context) => LoggedInHomepage());
    } catch (e) {
      setState(() {
        isLoading = false;
      });
        return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              // Retrieve the text the user has entered by using the
              // TextEditingController.
              content: Text('Usuário ou senha não coincidem.'),
            );
          },
        );

      print(e.message);
    }
  }
}
