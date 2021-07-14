// import 'dart:html';

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:my_chat_app/models/message.dart';
import 'package:my_chat_app/models/user.dart';
import 'package:my_chat_app/pages/register.dart';
import 'package:my_chat_app/services/auth.dart';
import 'package:my_chat_app/services/database.dart';
import 'package:my_chat_app/widgets/chatMessages.dart';
import 'package:my_chat_app/widgets/messageTile.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:collection/collection.dart';
import 'package:my_chat_app/widgets/sendFieldandButton.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController messageEditingController = TextEditingController();
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference chat = FirebaseFirestore.instance.collection('chat');
  DataBaseService data = DataBaseService();
  ScrollController _scrollController = new ScrollController();
  String? senderId = FirebaseAuth.instance.currentUser?.uid;
  bool needsToScroll = false;
  Message message = Message();

  // var currentUserId = FirebaseAuth.instance.currentUser!.uid;
  List<Message>? listChat;
  List<MyUser>? listUsers;

  Future<void> addUser(String email, String name, String password) {
    return users.add({
      'email': email,
      'name': name,
      'password': password,
    }).then((value) => print('user added'));
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      initializeDateFormatting('ru');
      if (listUsers == null) {
        final usersData = await data.getUsers();
        listUsers = usersData?.toList();
        setState(() {});
      }
    });
    super.initState();
  }

  Widget _chatMessages(List<Message> messagesList) {

    return Container(
      child: listUsers == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              controller: _scrollController,
              reverse: true,
              shrinkWrap: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                int _timeStamp = _messages[index]['time'].seconds;
                var date =
                    DateTime.fromMillisecondsSinceEpoch(_timeStamp * 1000);
                var formattedDate =
                    DateFormat('HH:mm dd.MM.yy', 'ru').format(date);

                final message = _messages[index];

                return MessageTile(
                    time: formattedDate,
                    firstMessageOfAuthor:  message.isFirst,
                    lastMessageOfAuthor: message.isLast,
                    author: message.isFirst
                        ? message.getUserName(listUsers)
                        : '',
                    message: message.content,
                    sentByMe:
                        senderId == message.sender
                        );
              }),
    );
  }

  List<Message> makeMessagesDataList(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {

    List<Massage> _messages = snapshot.data?.docs.map((e)=>Message.fromSnapshot).toList();
      for(int i=0; i<_messages.length; i++){
                if (i < _messages.length)
                  messages[i].isFirst = _messages[i - 1]sender != _messages[i]sender;
                else
                  messages[i].isFirst = false;

                if (i < _messages.length - 1)
                  messages[i].isLast = _messages[i + 1].sender != _messages[i]sender;
                else
                  messages[i].isLast = true;
      }
    return _messages;
    };


  Widget buttonSend() {
    return GestureDetector(
      // behavior: HitTestBehavior.translucent,
      onTap: () {
        data.sendMessage(messageEditingController, senderId.toString());
        // print(snapshot.docs.length);
        setState(() {
          // print(listChat.toString());
          messageEditingController.text = '';
        });
        print('pressed');
      },
      child: Container(
        height: 50.0,
        width: 50.0,
        decoration: BoxDecoration(
            color: Colors.blueAccent, borderRadius: BorderRadius.circular(50)),
        child: Center(child: Icon(Icons.send, color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    return Scaffold(
      appBar: AppBar(
        title: Text(
            listUsers?.firstWhere((element) => element.uid == senderId).name ??
                'Loading'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton.icon(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.amber.shade700)),
              icon: Icon(Icons.person),
              onPressed: () async {
                await _auth.signOut();
              },
              label: Text('Log out'),
            ),
          )
        ],
      ),
      body: Container(
          child: StreamBuilder<QuerySnapshot>(
              stream: data.chatStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final messageDataList = makeMessagesDataList(
                      snapshot);
                  // make everithing with
                  
                  
                  
                  return Column(children: [
                    _chatMessages(snapshot),
                    SendFieldAndButton()

                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        // height: 50,
                        width: MediaQuery.of(context).size.width,
                        // color: Colors.red,
                        child: Row(
                          // main AxisAlignment: MainAxisAlignment.start,
                          children: [
                            textField(messageEditingController),
                            buttonSend()
                          ],
                        ),
                      ),
                    ),
                  ]);
                } else {
                  return Container(child: Center(child: Text('loading...')));
                }
              })),
    );
  }

}

Widget textField(TextEditingController messageEditingController) {
  return Expanded(
    child: Container(
      child: TextField(
        controller: messageEditingController,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          // fillColor: Colors.pink,
          hintText: 'type here',
        ),
      ),
    ),
  );
}