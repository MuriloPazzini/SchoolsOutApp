import 'dart:io';
import 'dart:async';

import "package:firebase_storage/firebase_storage.dart";
import 'package:cached_network_image/cached_network_image.dart';
import 'package:schools_out/entities/user.dart';
import 'package:schools_out/pages/home.dart';
import 'package:schools_out/services/userService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

TextEditingController emailController = new TextEditingController();
TextEditingController nickNameController = new TextEditingController();
TextEditingController aboutMeController = new TextEditingController();
TextEditingController passwordController = new TextEditingController();
bool isLoading = false;
File avatarImageFile;
String id = '';
String nickname = '';
String aboutMe = '';
String photoUrl = '';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String photoUrl = '';
  SharedPreferences prefs;

  final nickNameField = TextField(
    controller: nickNameController,
    obscureText: false,
    decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Apelido",
        hintStyle: TextStyle(fontFamily: 'Lemon'),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: new BorderSide(width: 1, color: Colors.teal)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: new BorderSide(width: 1, color: Colors.teal))),
  );
  final aboutMeField = TextField(
    controller: aboutMeController,
    obscureText: false,
    decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Interesses",
        hintStyle: TextStyle(fontFamily: 'Lemon'),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: new BorderSide(width: 1, color: Colors.teal)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: new BorderSide(width: 1, color: Colors.teal))),
  );
  final emailField = TextField(
    controller: emailController,
    obscureText: false,
    decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "E-mail",
        hintStyle: TextStyle(fontFamily: 'Lemon'),
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
        hintStyle: TextStyle(fontFamily: 'Lemon'),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: new BorderSide(width: 1, color: Colors.teal)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: new BorderSide(width: 1, color: Colors.teal))),
  );

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        avatarImageFile = image;
      });
    }
  }

  Future handleUpdateData(userId, photoUrlRef) async {
    var collectionRef = Firestore.instance.collection('users');

    String nicknameValue = nickNameController.text;
    String aboutMeValue = aboutMeController.text;

    User newUser = new User(
        userId, nicknameValue, aboutMeValue, photoUrlRef, new List<String>());

    await RegisterNewUser(newUser).then((data) async {
      await SharedPreferences.getInstance().then((SharedPreferences sp) {
        prefs = sp;
        prefs.setString('userId', userId);
        prefs.setStringList('owned', new List<String>());
        prefs.setString('nickname', nicknameValue);
        prefs.setString('aboutMe', aboutMeValue);
        prefs.setString('photoUrl', photoUrlRef);

        print(prefs);

        Fluttertoast.showToast(msg: "Registrado com sucesso");

        Navigator.of(context).pop();
        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (BuildContext context) => new HomePage(),
          ),
        );
      });
    }).catchError((err) {
      setState(() {
        isLoading = false;
      });
      print(err);

      Fluttertoast.showToast(msg: err.toString());
    });
  }

  Future uploadFile(fileName) async {
    if (fileName != null && fileName != '') {
      StorageReference reference =
          FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = reference.putFile(avatarImageFile);
      StorageTaskSnapshot storageTaskSnapshot;
      uploadTask.onComplete.then((value) {
        if (value.error == null) {
          storageTaskSnapshot = value;
          storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
            photoUrl = downloadUrl;
            handleUpdateData(fileName, photoUrl);
          }, onError: (err) {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: 'Esse arquivo não é uma imagem');
          });
        } else {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: 'Esse arquivo não é uma imagem');
        }
      }, onError: (err) {
        setState(() {
          isLoading = false;
        });
        print(err.toString());
        Fluttertoast.showToast(msg: err.toString());
      });
    }
  }

  @override
  void initState() {
    super.initState();
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return new Scaffold(
        appBar: new AppBar(
          iconTheme: new IconThemeData(color: Colors.white),
          centerTitle: true,
          backgroundColor: Colors.grey[100],
          title: Text(
            "Registro",
            style: TextStyle(
                color: Colors.black, fontSize: 28, fontFamily: 'Lemon'),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    (avatarImageFile == null)
                        ? (photoUrl != ''
                            ? Material(
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.blueGrey[600]),
                                    ),
                                    width: 90.0,
                                    height: 90.0,
                                    padding: EdgeInsets.all(20.0),
                                  ),
                                  imageUrl: photoUrl,
                                  width: 90.0,
                                  height: 90.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(45.0)),
                                clipBehavior: Clip.hardEdge,
                              )
                            : Icon(
                                Icons.account_circle,
                                size: 90.0,
                                color: Colors.grey,
                              ))
                        : Material(
                            child: Image.file(
                              avatarImageFile,
                              width: 90.0,
                              height: 90.0,
                              fit: BoxFit.cover,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(45.0)),
                            clipBehavior: Clip.hardEdge,
                          ),
                    IconButton(
                      icon: Icon(
                        Icons.camera_alt,
                        color: Colors.grey,
                      ),
                      onPressed: getImage,
                      padding: EdgeInsets.all(30.0),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.grey,
                      iconSize: 30.0,
                    ),
                    SizedBox(height: 45.0),
                    nickNameField,
                    SizedBox(height: 25.0),
                    aboutMeField,
                    SizedBox(height: 25.0),
                    emailField,
                    SizedBox(height: 25.0),
                    passwordField,
                    SizedBox(
                      height: 35.0,
                    ),
                    Center(
                      child: CircularProgressIndicator(),
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
    } else {
      return new Scaffold(
        appBar: new AppBar(
          iconTheme: new IconThemeData(color: Colors.white),
          centerTitle: true,
          backgroundColor: Colors.grey[100],
          title: Text(
            "School's Out",
            style: TextStyle(
                color: Colors.black, fontSize: 28, fontFamily: 'Lemon'),
          ),
        ),
        floatingActionButton: new FloatingActionButton(
          backgroundColor: Colors.grey[100],
          child: Icon(Icons.check),
          onPressed: signUp,
          foregroundColor: Colors.black,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    (avatarImageFile == null)
                        ? (photoUrl != ''
                            ? Material(
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.blueGrey[600]),
                                    ),
                                    width: 90.0,
                                    height: 90.0,
                                    padding: EdgeInsets.all(20.0),
                                  ),
                                  imageUrl: photoUrl,
                                  width: 90.0,
                                  height: 90.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(45.0)),
                                clipBehavior: Clip.hardEdge,
                              )
                            : Icon(
                                Icons.account_circle,
                                size: 90.0,
                                color: Colors.grey,
                              ))
                        : Material(
                            child: Image.file(
                              avatarImageFile,
                              width: 90.0,
                              height: 90.0,
                              fit: BoxFit.cover,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(45.0)),
                            clipBehavior: Clip.hardEdge,
                          ),
                    IconButton(
                      icon: Icon(
                        Icons.camera_alt,
                        color: Colors.grey,
                      ),
                      onPressed: getImage,
                      padding: EdgeInsets.all(30.0),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.grey,
                      iconSize: 30.0,
                    ),
                    SizedBox(height: 45.0),
                    nickNameField,
                    SizedBox(height: 25.0),
                    aboutMeField,
                    SizedBox(height: 25.0),
                    emailField,
                    SizedBox(height: 25.0),
                    passwordField,
                    SizedBox(
                      height: 35.0,
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
              content: Text('Senha deve conter ao menos 8 caracteres!'),
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
              content: Text('E-mail não é válido!'),
            );
          },
        );
      }

      if (avatarImageFile == null) {
        setState(() {
          isLoading = false;
        });

        return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              // Retrieve the text the user has entered by using the
              // TextEditingController.
              content: Text('Insira uma imagem para seu perfil!'),
            );
          },
        );
      }

      AuthResult result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);

      if (result != null) {
        await uploadFile(result.user.uid);
      }
    } catch (e) {
      String errorToShow;

      setState(() {
        isLoading = false;
      });

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
          case 'The email address is already in use by another account.':
            errorToShow = 'E-mail já cadastrado';
            break;
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
