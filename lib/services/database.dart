import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

  CollectionReference dummyChats =
      FirebaseFirestore.instance.collection('chatsCollection');

  Stream<QuerySnapshot> roomsStream(MyUser currentUser) {
    return FirebaseFirestore.instance
        .collection('chatsCollection')
        .orderBy('lastMessage.time', descending: true)
        .snapshots();
  }

  // Future<List<Room>?> getRooms() async {
  //   var serverRooms = await dummyChats.get();
  //   return serverRooms.docs.map<Room>((e) => Room.fromSnapshot(e)).toList();
  // }

  // Future<String> getUserNickName(String uid) async {
  //   final thatUser = await userCollection.where('uid', isEqualTo: uid).snapshots();
  //   thatUser.map<MyUser>((e) => MyUser.fromSnapshot(e)).toList();
  // }

  Future<void> createGroup(List<MyUser>? selectedUsers, MyUser? user,
      String topicTheme, String topicContent, bool isPrivate,
      {Message? lastMessage, String? groupName}
      // String userId,
      ) async {
    List _mappedUsers = [];

    selectedUsers!.forEach((element) {
      _mappedUsers.add(element.toMap());
    });
    // Room newRoom;
    DocumentReference roomDocRef = await dummyChats.add({
      'lastMessage': {
        'content': 'hello world',
        'sender': user?.senderToMap(),
        'time': DateTime.now()
      },
      'isPrivate': isPrivate,
      'topicTheme': topicTheme,
      'topicContent': topicContent,
      // 'groupName': groupName,
      'members': _mappedUsers,
      // 'groupID': '',
      // 'admin': user?.toMap(),
      'creationTime': DateTime.now().toUtc()
    });
    // .then((value) {
    //   final fbObject  = value.get().then((val){
    //     final doc =
    //     val.data();
    //     doc.
    //     });
    //   newRoom = Room(
    //   groupID:value.id,
    //   groupName: fbObject. groupName.toString()}
    //  ));

    // await roomDocRef.update({'groupID': roomDocRef.id});

    // var memberDocRef = FirebaseFirestore.instance
    //     .collection('chatsCollection')
    //     .doc(roomDocRef.id)
    //     .collection('members');

    // selectedUsers.forEach((element) {
    //   memberDocRef.doc(element.name).set(
    //       {'name': element.name, 'uid': element.uid, 'email': element.email});
    // });
    // return roomDocRef.id;
  }

  Future addNewUserToRoom(String groupID, List<MyUser>? selectedUsers) async {
    List _list = [];

    selectedUsers?.forEach((element) {
      _list.add(element.toMap());
    });

    dummyChats.doc(groupID).update({'members': FieldValue.arrayUnion(_list)});
  }

  Stream<QuerySnapshot> usersStream() => FirebaseFirestore.instance
      .collection('users')
      // .orderBy('time', descending: true)
      .snapshots();

  // Stream<QuerySnapshot> chatStream() => FirebaseFirestore.instance
  //     .collection('chat')
  //     .orderBy('time', descending: true)
  //     .snapshots();

  Stream<QuerySnapshot> chatStream(String groupId) => FirebaseFirestore.instance
      .collection('chatsCollection')
      .doc(groupId)
      .collection('messages')
      .orderBy('time', descending: true)
      .snapshots();

  Future<void>? sendMessage(
      TextEditingController _controller, MyUser sender, String groupID) {
    CollectionReference testChat =
        dummyChats.doc(groupID).collection('messages');
    // String? userName = FirebaseAuth.instance.currentUser?.displayName;
    // Stream<QuerySnapshot> _userStream = users.snapshots();
    // try {
    print('Controlle text ${_controller.text}');

    final message = {
      'recentMessage': _controller.text,
      'time': DateTime.now().toUtc(),
      'sender': sender.senderToMap(),
      // 'author':
    };
    print(message);
    if (_controller.text.isNotEmpty) {
      testChat.add(message).then((doc) =>
          testChat.doc(doc.id).get().then((value) => print(value.data())));

      dummyChats.doc(groupID).update({'lastMessage': message});
    }
    // } catch (e, trace) {
    //   debugPrint("Error is $e. Stack = $trace");
    // }
    _controller.clear();
  }

  Future<void>? updateUserData(MyUser user) async {
    return await userCollection.doc(user.uid).set({
      'name': user.name,
      'email': user.email,
      'uid': user.uid,
      'isOwner': user.isOwner,
      'isAdmin': user.isAdmin,
      'canWrite': user.canWrite,
      'isApporved': user.isApporved,
      'nickName': user.nickName
    });
  }

//TODO: refactor seart with filter
  Future<List<MyUser>?> getUsers({String? searchString}) async {
    // print('Before get');.

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

  Future<void> deleteRoom(String groupId) async {
    dummyChats.doc(groupId).delete();
    // print('DELETEROOM HAPPENED');
  }

  Future<void> leaveRoom(String groupId, MyUser user) async {
    dummyChats.doc(groupId).update({
      'members': FieldValue.arrayRemove([user.toMap()])
    });
    // print('leaveROOM HAPPENED');
  }

  Future<void> updateRoom(String groupId, Room? roomToUpdate) async {
    List membersToUpdate = [];

    roomToUpdate!.members?.forEach((element) {
      membersToUpdate.add(element.toMap());
    });

    dummyChats.doc(groupId).update({'members': membersToUpdate});
    print('UPDATING HAS HAPPENED');
  }

  Future<void> editRoom(
      String groupID,
      String? topicTheme,
      String? topicContent,
      List<MyUser>? selectedUsers,
      bool? isPrivate) async {
    List? newMembers = [];

    selectedUsers?.forEach((element) {
      newMembers.add(element.toMap());
    });

    dummyChats.doc(groupID).update({
      if (topicTheme != '') 'topicTheme': topicTheme,
      if (topicContent != '') 'topicContent': topicContent,
      if (selectedUsers != null) 'members': newMembers,
      if (isPrivate != null) 'isPrivate': isPrivate,
    });
  }
}
