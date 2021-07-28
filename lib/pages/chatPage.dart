// import 'dart:html';

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:my_chat_app/cubit/cubit/auth_cubit.dart';
import 'package:my_chat_app/cubit/cubit/room_cubit.dart';
import 'package:my_chat_app/cubit/cubit/room_state.dart';
import 'package:my_chat_app/cubit/cubit/user_cubit.dart';
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

class ChatPage extends StatefulWidget {
  String groupID;

  ChatPage(this.groupID);
  // ChatPage({Key? key, required this.groupID}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // Stream<QuerySnapshot>? _chat;
  // TextEditingController messageEditingController = TextEditingController();
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference chat = FirebaseFirestore.instance.collection('chat');
  DataBaseService data = DataBaseService();
  // ScrollController _scrollController = new ScrollController();
  String? senderId = FirebaseAuth.instance.currentUser?.uid;
  bool needsToScroll = false;
  Message message = Message();

  // var currentUserId = FirebaseAuth.instance.currentUser!.uid;

  List<MyUser>? listUsers;

  final userCubit = GetIt.I.get<UserCubit>();
  final authCubit = GetIt.I.get<AuthCubit>();
  final roomCubit = GetIt.I.get<RoomCubit>();
  // Future<void> addUser(String email, String name, String password) {
  //   return users.add({
  //     'email': email,
  //     'name': name,
  //     'password': password,
  //   }).then((value) => print('user added'));
  // }

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      if (listUsers == null) {
        final usersData = await data.getUsers();
        listUsers = usersData?.reversed.toList();
        setState(() {});
      }
    });
    super.initState();
  }

  // Widget _chatMessages(List<Message> messageDataList) {
  //   return Container(
  //     child: listUsers == null
  //         ? Center(
  //             child: CircularProgressIndicator(),
  //           )
  //         : ListView.builder(
  //             controller: _scrollController,
  //             reverse: true,
  //             shrinkWrap: true,
  //             itemCount: messageDataList.length,
  //             itemBuilder: (context, index) {
  //               // String localeTag =
  //               //     Localizations.localeOf(context).toLanguageTag();
  //               int _timeStamp = messageDataList[index].time!.seconds;
  //               var date =
  //                   DateTime.fromMillisecondsSinceEpoch(_timeStamp * 1000);
  //               var formattedDate =
  //                   DateFormat('HH:mm dd.MM.yy', 'ru').format(date);

  //               final message = messageDataList[index];

  //               return MessageTile(
  //                   time: formattedDate,
  //                   firstMessageOfAuthor: message.isFirst,
  //                   lastMessageOfAuthor: message.isLast,
  //                   author: message.isFirst
  //                       ? message.getUserName(message.sender, listUsers)
  //                       : '',
  //                   message: message.content,
  //                   sentByMe: senderId == message.sender);
  //             }),
  //   );
  //   ;
  // }

  // List<Message> makeMessagesDataList(
  //     AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
  //   List<Message>? _messages = snapshot.data?.docs
  //       .map<Message>((e) => Message.fromSnapshot(e))
  //       .toList();
  //   for (int i = 0; i < _messages!.length; i++) {
  //     if (i > 0 && i < _messages.length - 1)
  //       _messages[i].isFirst = _messages[i + 1].sender != _messages[i].sender;
  //     else
  //       _messages[i].isFirst = false;

  //     if (i > 0 && i < _messages.length)
  //       _messages[i].isLast = _messages[i - 1].sender != _messages[i].sender;
  //     else
  //       _messages[i].isLast = true;
  //   }
  //   return _messages;
  // }

  // String? getUserName(String uid) {
  //   return listUsers!
  //       .firstWhere((element) => element.uid == uid,
  //           orElse: () => MyUser(name: 'null name'))
  //       .name;
  // }

  // Widget buttonSend() {
  //   return GestureDetector(
  //     // behavior: HitTestBehavior.translucent,
  //     onTap: () {
  //       data.sendMessage(
  //           messageEditingController, senderId.toString(), widget.groupID);
  //       // print(snapshot.docs.length);
  //       setState(() {
  //         messageEditingController.text = '';
  //       });
  //       print('pressed');
  //     },
  //     child: Container(
  //       height: 50.0,
  //       width: 50.0,
  //       decoration: BoxDecoration(
  //           color: Colors.blueAccent, borderRadius: BorderRadius.circular(50)),
  //       child: Center(child: Icon(Icons.send, color: Colors.white)),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // final AuthService _auth = AuthService();
    return BlocBuilder<RoomCubit, RoomState>(
      bloc: roomCubit,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(authCubit.state.currentUser?.name
                // listUsers
                //       ?.firstWhere((element) => element.uid == senderId)
                //       .name
                ??
                'Loading'), //TODO change to group name here
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return roomCubit.addUserToThisRoom(widget.groupID);
                          });
                    },
                    icon: Icon(Icons.add)),
              )
            ],
          ),
          body: Container(
              child: StreamBuilder<QuerySnapshot>(
                  stream: data.testStream(widget.groupID),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final messageDataList =
                          roomCubit.makeMessagesDataList(snapshot);
                      return Column(children: [
                        Expanded(
                            child: roomCubit.showChat(
                                messageDataList, listUsers, widget.groupID)),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                              color: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              width: MediaQuery.of(context).size.width,
                              child: roomCubit
                                  .messageInputAndSendButton(widget.groupID)
                              // Row(
                              //   children: [
                              //     // textField(messageEditingController),
                              //     // roomCubit.buttonSend(widget.groupID)
                              //   ],
                              // ),
                              ),
                        ),
                      ]);
                    } else {
                      // ? SingleChildScrollView(
                      //     child: Text(listChat.toString()))
                      return Container(
                          child: Center(child: Text('loading...')));
                    }
                  })),
        );
      },
    );
  }

  // makeMessagesDataList(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {}
}

// Widget textField(TextEditingController messageEditingController) {
//   return Expanded(
//     child: Container(
//       child: TextField(
//         controller: messageEditingController,
//         style: TextStyle(color: Colors.black),
//         decoration: InputDecoration(
//           // fillColor: Colors.pink,
//           hintText: 'type here',
//         ),
//       ),
//     ),
//   );
// }
