// import 'dart:html';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/models/message.dart';
import 'package:my_chat_app/models/room.dart';
import 'package:my_chat_app/models/user.dart';

class DataBaseService {
  // String? uid;
  DataBaseService() {
    initializeFB();
  }

  bool _inited = false;
  void initializeFB() async {
    if (!_inited) {
      await Firebase.initializeApp();
      _inited = true;
    }
  }

  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  CollectionReference chat = FirebaseFirestore.instance.collection('chat');
  CollectionReference dummyChats =
      FirebaseFirestore.instance.collection('dummyCollection');
  var senderId = FirebaseAuth.instance.currentUser?.uid;

  Stream<QuerySnapshot> roomsStream() => FirebaseFirestore.instance
      .collection('dummyCollection')
      .where('members', arrayContains: senderId)
      .snapshots();

  // Future<List<Room>?> getRooms() async {
  //   var serverRooms = await dummyChats.get();
  //   return serverRooms.docs.map<Room>((e) => Room.fromSnapshot(e)).toList();
  // }

  Future createGroup(
    List<MyUser> selectedUsers,
    String? userName,
    String groupName,
    // String userId,
  ) async {
    DocumentReference roomDocRef = await dummyChats.add({
      'groupName': groupName,
      'members': selectedUsers,
      'groupID': '',
      'admin': userName
    });

    await roomDocRef.update({'groupID': roomDocRef.id});

    // await FirebaseFirestore.instance
    //     .collection('dummyCollection')
    //     .doc(roomDocRef.id)
    //     .collection('messages')
    //     .add({
    //   'recentMessage': '',
    //   'time': DateTime.now().toUtc(),
    //   'sender': ''
    // });

    // await roomDocRef.update({
    //   'members': FieldValue.arrayUnion([userId])
    // });
  }

  Stream<QuerySnapshot> usersStream() => FirebaseFirestore.instance
      .collection('users')
      // .orderBy('time', descending: true)
      .snapshots();

  Stream<QuerySnapshot> chatStream() => FirebaseFirestore.instance
      .collection('chat')
      .orderBy('time', descending: true)
      .snapshots();

  Stream<QuerySnapshot> testStream(String groupId) => FirebaseFirestore.instance
      .collection('dummyCollection')
      .doc(groupId)
      .collection('messages')
      .orderBy('time', descending: true)
      .snapshots();

  Future<void> addUser(String email, String name, String password) {
    return userCollection.add({
      'email': email,
      'name': name,
      'password': password,
    }).then((value) => print('user added'));
  }

  Future<void>? sendMessage(
      TextEditingController _controller, String senderId, String groupID) {
    CollectionReference testChat =
        dummyChats.doc(groupID).collection('messages');
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
      testChat.add(message).then(
          (doc) => chat.doc(doc.id).get().then((value) => print(value.data())));
    }
    // } catch (e, trace) {
    //   debugPrint("Error is $e. Stack = $trace");
    // }
  }

  // String? getUserName(String uid, List<MyUser> listUsers) {
  //   return listUsers
  //       .firstWhere((element) => element.uid == uid,
  //           orElse: () => MyUser(name: 'null name?'))
  //       .name;
  // }

  // Future<void> updateRoomData(String groupName) async {
  //   return await dummyChats.doc(uid).set({'groupName': groupName});
  // }

  Future<void>? updateUserData(
      String uid, String name, String email, String password) async {
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
