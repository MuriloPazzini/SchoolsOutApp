import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      print(e.message);
    }
  }
}
