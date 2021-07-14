// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/models/message.dart';
import 'package:my_chat_app/models/user.dart';

class DataBaseService {
  String? uid;
  DataBaseService({this.uid});

  // Stream<QuerySnapshot>? _chat;

  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  // CollectionReference messagesCollection =
  //     FirebaseFirestore.instance.collection('chat');

  CollectionReference chat = FirebaseFirestore.instance.collection('chat');

  var senderId = FirebaseAuth.instance.currentUser?.uid;

  Stream<QuerySnapshot> chatStream() => FirebaseFirestore.instance
      .collection('chat')
      .orderBy('time', descending: true)
      .snapshots();

  Future<void> addUser(String email, String name, String password) {
    return userCollection.add({
      'email': email,
      'name': name,
      'password': password,
    }).then((value) => print('user added'));
  }
  // void sendMessage(chatMessageMap) {
  //   FirebaseFirestore.instance.collection('chat').add(chatMessageMap);
  //   FirebaseFirestore.instance.collection('chat').doc('hey').update({
  //     'recentMessage': chatMessageMap['message'],
  //     // 'MessageSender': chatMessageMap['sender'],
  //     'MessageTime': chatMessageMap['time'].toString()
  //   });
  // }

  Future<void>? sendMessage(
      TextEditingController _controller, String senderId) {
    // String? userName = FirebaseAuth.instance.currentUser?.displayName;
    // Stream<QuerySnapshot> _userStream = users.snapshots();
    // try {
    print('Controlle text ${_controller.text}');
    final message = {
      'recentMessage': _controller.text,
      'time': DateTime.now().toUtc(),
      'sender': senderId,
      // 'author':
    };
    print(message);
    if (_controller.text.isNotEmpty) {
      chat.add(message).then(
          (doc) => chat.doc(doc.id).get().then((value) => print(value.data())));
    }
    // } catch (e, trace) {
    //   debugPrint("Error is $e. Stack = $trace");
    // }
  }

  String? getUserName(String uid, List listUsers) {
    return listUsers
        .firstWhere((element) => element.uid == uid,
            orElse: () => MyUser(name: 'null name?'))
        .name;
  }

  Future<void>? updateUserData(
      String name, String email, String password) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'email': email,
      'password': password,
    });
  }

  Future<List<MyUser>?> getUsers() async {
    var serverUsers = await userCollection.get();
    return serverUsers.docs.map<MyUser>((e) => MyUser.fromSnapshot(e)).toList();
  }

  Future<List<Message>> getChat() async {
    var serverChat = await chat.orderBy('time').get();
    return serverChat.docs
        .map<Message>((e) => Message.fromSnapshot(e))
        .toList();
  }
}
