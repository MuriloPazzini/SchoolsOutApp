import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schools_out/pages/loggedInHome.dart';

TextEditingController emailController = new TextEditingController();
TextEditingController passwordController = new TextEditingController();
bool isLoading = false;

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password;

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
    return new Scaffold(
      appBar: new AppBar(
        iconTheme: new IconThemeData(color: Colors.blueGrey[600]),
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
                      : Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(30.0),
                          color: Color(0xff01A0C7),
                          child: MaterialButton(
                            padding:
                                EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            onPressed: signUp,
                            child: Text(
                              "Cadastrar",
                              textAlign: TextAlign.center,
                            ),
                          ),
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

  void signUp() async {
    try {
      setState(() {
        isLoading = true;
      });
      if (passwordController.text.length < 8) {
        setState(() {
          isLoading = false;
        });
        return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              // Retrieve the text the user has entered by using the
              // TextEditingController.
              content: Text('Senha deve conter ao menos 8 caracteres.'),
            );
          },
        );
      }

      if (!RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(emailController.text)) {
        setState(() {
          isLoading = false;
        });
        return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              // Retrieve the text the user has entered by using the
              // TextEditingController.
              content: Text('E-mail não é válido'),
            );
          },
        );
      }

      AuthResult result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);

      await Firestore.instance
          .collection('users')
          .add({'user_id': result.user.uid, 'role': 'free'});

      setState(() {
        isLoading = false;
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        MaterialPageRoute(
            builder: (BuildContext context) => LoggedInHomepage());
      });

      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // Retrieve the text the user has entered by using the
            // TextEditingController.
            content: Text('Cadastro efetuado com sucesso!'),
          );
        },
      );
    } catch (e) {

      String errorToShow;

      if (Platform.isAndroid) {
        switch (e.message) {
          case 'There is no user record corresponding to this identifier. The user may have been deleted.':
            errorToShow = 'Usuário não encontrado';
            break;
          case 'The password is invalid or the user does not have a password.':
            errorToShow = 'Senha é inválida';
            break;
          case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
            errorToShow = 'Problema com conexão';
            break;
          // ...
          default:
            errorToShow = 'Ocorreu um problema ao autenticar';
        }
      } else if (Platform.isIOS) {
        switch (e.code) {
          case 'Error 17011':
            errorToShow = 'Usuário não encontrado';
            break;
          case 'Error 17009':
            errorToShow = 'Senha é inválida';
            break;
          case 'Error 17020':
            errorToShow = 'Problema com conexão';
            break;
          // ...
          default:
            errorToShow = 'Ocorreu um problema ao autenticar';
        }
      }
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // Retrieve the text the user has entered by using the
            // TextEditingController.
            content: Text(errorToShow),
          );
        },
      );
    }
  }
}
