import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:schools_out/entities/message.dart';
import 'package:schools_out/entities/user.dart';
import 'package:schools_out/services/messageService.dart';

bool isInitialized = true;

class ChatPage extends StatefulWidget {
  final User user;

  const ChatPage(this.user);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool isInitialized = true;
  Future<List<String>> futureMessageHistory;
  SocketIO socketIO;
  List<Message> messages = new List<Message>();
  double height, width;
  TextEditingController textController;
  ScrollController scrollController;

  @override
  void dispose() {
    socketIO.sendMessage(
        'send_message', json.encode({'message': widget.user.nickname + ' se desconectou'}));
    socketIO.unSubscribesAll();
    socketIO.disconnect();
    super.dispose();
  }

  @override
  void initState() {
    isInitialized = true;

    futureMessageHistory = getMessageHistory();
    //Initializing the message list
    messages = List<Message>();
    //Initializing the TextEditingController and ScrollController
    textController = TextEditingController();
    scrollController = ScrollController();
    //Creating the socket
    socketIO = SocketIOManager().createSocketIO(
      'https://schools-out-backend.herokuapp.com',
      '/chat',
    );
    //Call init before doing anything with socket
    socketIO.init();

    //Subscribe to an event to listen to
    socketIO.subscribe('receive_message', (jsonData) {
      //Convert the JSON data received into a Map
      Map<String, dynamic> data = json.decode(jsonData);
      this.setState(() => messages.add(new Message(data['message'], false)));
      Timer(
          Duration(milliseconds: 1000),
          () => scrollController
              .jumpTo(scrollController.position.maxScrollExtent));
    });
    //Connect to the socket
    socketIO.connect();
    super.initState();
  }

  Widget buildSingleMessage(int index) {
    if (messages[index].isMine) {
      return Container(
        alignment: Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.all(20.0),
          margin: const EdgeInsets.only(bottom: 20.0, right: 20.0),
          decoration: BoxDecoration(
            color: Colors.blueGrey[600],
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Text(
            messages[index].data,
            style: TextStyle(color: Colors.white, fontSize: 15.0),
          ),
        ),
      );
    } else {
      return Container(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(20.0),
          margin: const EdgeInsets.only(bottom: 20.0, left: 20.0),
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Text(
            messages[index].data,
            style: TextStyle(color: Colors.white, fontSize: 15.0),
          ),
        ),
      );
    }
  }

  Widget buildMessageList() {
    return Container(
      height: height * 0.72,
      width: width,
      child: ListView.builder(
        controller: scrollController,
        itemCount: messages.length,
        itemBuilder: (BuildContext context, int index) {
          return buildSingleMessage(index);
        },
      ),
    );
  }

  Widget buildChatInput() {
    return Container(
      width: width * 0.7,
      padding: const EdgeInsets.all(2.0),
      margin: const EdgeInsets.only(left: 40.0),
      child: TextField(
        decoration: InputDecoration.collapsed(
          hintText: 'Escreva sua mensagem...',
        ),
        controller: textController,
      ),
    );
  }

  Widget buildSendButton() {
    return FloatingActionButton(
      backgroundColor: Colors.blueGrey[600],
      onPressed: () {
        //Check if the textfield has text or not
        if (textController.text.isNotEmpty) {
          var messageWithUser =
              widget.user.nickname + ': ' + textController.text;

          //Send the message as JSON data to send_message event
          socketIO.sendMessage(
              'send_message', json.encode({'message': messageWithUser}));
          //Add the message to the list
          this.setState(
              () => messages.add(new Message(textController.text, true)));
          textController.text = '';
          //Scrolldown the list to show the latest message
          Timer(
              Duration(milliseconds: 1000),
              () => scrollController
                  .jumpTo(scrollController.position.maxScrollExtent));
        }
      },
      child: Icon(
        Icons.send,
        size: 30,
      ),
    );
  }

  Widget buildInputArea() {
    return Container(
      height: height * 0.1,
      width: width,
      child: Row(
        children: <Widget>[
          buildChatInput(),
          buildSendButton(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return FutureBuilder(
      future: futureMessageHistory,
      initialData: [],
      builder: (_, snapshot) {
        if (snapshot.data == null) {
          return Scaffold(
              body: Center(
            child: CircularProgressIndicator(),
          ));
        } else if (snapshot.data.length > 0) {
          if (isInitialized) {
            var oldMessages = snapshot.data;
            isInitialized = false;
            for (var i = 0; i < oldMessages.length; i++) {
              messages.add(new Message(oldMessages[i], false));
            }
            Timer(
                Duration(milliseconds: 100),
                () => scrollController
                    .jumpTo(scrollController.position.maxScrollExtent));
          }

          return Scaffold(
            appBar: AppBar(
              iconTheme: new IconThemeData(color: Colors.white),
              centerTitle: true,
              title: Text(
                "School's Out Chat",
                style: TextStyle(
                    color: Colors.white, fontSize: 28, fontFamily: 'Toontime'),
              ),
              backgroundColor: Colors.blueGrey[600],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: height * 0.05),
                  buildMessageList(),
                  buildInputArea(),
                ],
              ),
            ),
          );
        } else {
          if (messages.length > 0) {
            return Scaffold(
              appBar: AppBar(
                iconTheme: new IconThemeData(color: Colors.white),
                centerTitle: true,
                title: Text(
                  "School's Out Chat",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontFamily: 'Toontime'),
                ),
                backgroundColor: Colors.blueGrey[600],
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: height * 0.05),
                    buildMessageList(),
                    buildInputArea(),
                  ],
                ),
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                iconTheme: new IconThemeData(color: Colors.white),
                centerTitle: true,
                title: Text(
                  "School's Out Chat",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontFamily: 'Toontime'),
                ),
                backgroundColor: Colors.blueGrey[600],
              ),
              bottomNavigationBar: buildInputArea(),
              body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: height * 0.05),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(20.0),
                        margin: const EdgeInsets.only(bottom: 20.0, left: 20.0),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Text(
                          'Carregando Mensagens antigas...',
                          style: TextStyle(color: Colors.white, fontSize: 15.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }
      },
    );
  }
}
