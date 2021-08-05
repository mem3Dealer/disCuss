import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:my_chat_app/cubit/cubit/auth_cubit.dart';
import 'package:my_chat_app/models/message.dart';
import 'package:my_chat_app/models/room.dart';
import 'package:my_chat_app/models/user.dart';

class DataBaseService {
  // String? uid;
  DataBaseService() {
    // initializeFB();
  }

  // final authCubit = GetIt.I.get<AuthCubit>();
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  // var currentUser = AuthCubit().state.currentUser?.toMap();

  // currentUser() {
  //   var currentuser = AuthCubit().state.currentUser;

  //   // FirebaseAuth.instance.currentUser;
  //   // MyUser(
  //   //         name: currentuser?.displayName.toString(),
  //   //         email: currentuser?.email,
  //   //         uid: currentuser?.uid)
  //   //     .toMap();
  // }

  // CollectionReference chat = FirebaseFirestore.instance.collection('chat');
  CollectionReference dummyChats =
      FirebaseFirestore.instance.collection('chatsCollection');

  Stream<QuerySnapshot> roomsStream(MyUser currentUser) {
    return FirebaseFirestore.instance
        .collection('chatsCollection')
        .where('members', arrayContains: currentUser.toMap())
        .snapshots();
  }

  // Future<List<Room>?> getRooms() async {
  //   var serverRooms = await dummyChats.get();
  //   return serverRooms.docs.map<Room>((e) => Room.fromSnapshot(e)).toList();
  // }

  Future createGroup(
    List<MyUser>? selectedUsers,
    MyUser? user,
    String groupName,
    // String userId,
  ) async {
    List _mappedUsers = [];
    selectedUsers!.forEach((element) {
      _mappedUsers.add(element.toMap());
    });

    DocumentReference roomDocRef = await dummyChats.add({
      'groupName': groupName,
      'members': _mappedUsers,
      'groupID': '',
      'admin': user?.toMap(),
      'creationTime': DateTime.now().toUtc()
    });

    await roomDocRef.update({'groupID': roomDocRef.id});

    // var memberDocRef = FirebaseFirestore.instance
    //     .collection('chatsCollection')
    //     .doc(roomDocRef.id)
    //     .collection('members');

    // selectedUsers.forEach((element) {
    //   memberDocRef.doc(element.name).set(
    //       {'name': element.name, 'uid': element.uid, 'email': element.email});
    // });
  }

  Future addNewUserToRoom(String groupID, List<MyUser>? selectedUsers) async {
    List _list = [];

    // var memberDocRef = FirebaseFirestore.instance
    //     .collection('chatsCollection')
    //     .doc(groupID)
    //     .collection('members');

    selectedUsers?.forEach((element) {
      _list.add(element.toMap());
    });

    dummyChats.doc(groupID).update({'members': FieldValue.arrayUnion(_list)});

    // selectedUsers?.forEach((element) {
    //   memberDocRef.doc(element.name).set(
    //       {'name': element.name, 'uid': element.uid, 'email': element.email});
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
      .collection('chatsCollection')
      .doc(groupId)
      .collection('messages')
      .orderBy('time', descending: true)
      .snapshots();

  // Stream<QuerySnapshot> roomMembers(String groupId) =>
  //     FirebaseFirestore.instance
  //         .collection('chatsCollection')
  //         .doc(groupId)
  //         .snapshots();

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
      testChat.add(message).then((doc) =>
          testChat.doc(doc.id).get().then((value) => print(value.data())));
    }
    // } catch (e, trace) {
    //   debugPrint("Error is $e. Stack = $trace");
    // }
  }

  Future<void>? updateUserData(String uid, String name, String email) async {
    return await userCollection
        .doc(uid)
        .set({'name': name, 'email': email, 'uid': uid});
  }

//TODO: refactor seart with filter
  Future<List<MyUser>?> getUsers({String? searchString}) async {
    print('Before get');

    QuerySnapshot? serverUsers;
    try {
      serverUsers = await userCollection.get();
      // print("USERS: $serverUsers");
    } catch (e) {
      print("ERROR: ${e.toString()}");
    }
    return serverUsers?.docs
        .map<MyUser>((e) => MyUser.fromSnapshot(e))
        .toList();
  }

  Future<List<Room>?> getRooms() async {
    var serverRooms = await dummyChats.get();
    return serverRooms.docs.map<Room>((e) => Room.fromSnapshot(e)).toList();
  }

  Future<void> kickUser(String groupID, List<Map<String, dynamic>> list) async {
    DocumentReference roomDocRef =
        FirebaseFirestore.instance.collection('chatsCollection').doc(groupID);

    roomDocRef.update({"members": FieldValue.arrayRemove(list)});
    // print('we got here');
  }
}
