// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:my_chat_app/cubit/cubit/auth_cubit.dart';
import 'package:my_chat_app/cubit/cubit/room_cubit.dart';
import 'package:my_chat_app/cubit/cubit/room_state.dart';
import 'package:my_chat_app/cubit/cubit/user_cubit.dart';
import 'package:my_chat_app/models/message.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:my_chat_app/models/room.dart';
import 'package:my_chat_app/models/user.dart';
import 'package:my_chat_app/pages/addNewMember.dart';
import 'package:my_chat_app/services/database.dart';
import 'package:my_chat_app/widgets/messageTile.dart';
import 'package:my_chat_app/pages/roomMembersPage.dart';

class ChatPage extends StatefulWidget {
  final String groupID;

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
  // DataBaseService data = DataBaseService();
  // ScrollController _scrollController = new ScrollController();
  String? senderId = FirebaseAuth.instance.currentUser?.uid;
  // bool needsToScroll = false;
  // Message message = Message();

  // var currentUserId = FirebaseAuth.instance.currentUser!.uid;

  List<MyUser>? listUsers;
  // List<Room>? listRooms;
  final _messageEditingController = TextEditingController();
  final _scrollController = new ScrollController();
  final data = GetIt.I.get<DataBaseService>();
  final userCubit = GetIt.I.get<UserCubit>();
  final authCubit = GetIt.I.get<AuthCubit>();
  final roomCubit = GetIt.I.get<RoomCubit>();

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      MyUser? currentMemberofThisRoom = roomCubit.getoLocalUser();
      final entrySnackBar = SnackBar(
          duration: Duration(seconds: 3),
          content: Text(
              'Well, ${authCubit.state.currentUser?.name}, you can`t write here. Go ask for perm.',
              style: TextStyle(
                fontSize: 17,
              )));
      // final youAreNotWelcome = SnackBar(
      //     duration: Duration(seconds: 3),
      //     content: Text(
      //         'Sorry to say that, ${authCubit.state.currentUser?.name}, but it seems to be you were not accepted into this conversation.',
      //         style: TextStyle(
      //           fontSize: 17,
      //         )));
      if (roomCubit.state.currentRoom?.isPrivate ==
          true) if (currentMemberofThisRoom?.canWrite == false &&
              currentMemberofThisRoom?.isApporved == true ||
          currentMemberofThisRoom == null) {
        ScaffoldMessenger.of(context).showSnackBar(entrySnackBar);
      }

      // if (currentMemberofThisRoom?.canWrite == false &&
      //     currentMemberofThisRoom?.isApporved == false) {
      //   ScaffoldMessenger.of(context).showSnackBar(youAreNotWelcome);
      // }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Room? currentRoom = roomCubit.state.currentRoom;
    final requestSentSnackBar = SnackBar(
        duration: Duration(seconds: 2),
        content: Text('Join reqeust sent. Fingers crossed',
            style: TextStyle(
              fontSize: 17,
            )));
    final youHaveJoinedSnackBar = SnackBar(
        duration: Duration(seconds: 2),
        content: Text('You have joined this room. Be nice!',
            style: TextStyle(
              fontSize: 17,
            )));
    // print("TRYNNA GET CURRENT ROOM: ${roomCubit.state.currentRoom}");

    return BlocBuilder<RoomCubit, RoomState>(
      bloc: roomCubit,
      builder: (context, state) {
        MyUser? currentMemberofThisRoom = roomCubit.getoLocalUser();
        List<Message>? _localChat = state.messagesOfThisChatRoom;
        return Scaffold(
            body: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      expandedHeight: 200,
                      floating: false,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        collapseMode: CollapseMode.parallax,
                        centerTitle: true,
                        background: Center(
                            child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: AutoSizeText(
                            currentRoom!.topicContent.toString(),
                            // style: TextStyle(fontSize: 25),
                            minFontSize: 17.0,
                            maxFontSize: 25.0,
                            maxLines: 5,
                            textAlign: TextAlign.center,
                          ),
                        )),
                        title: AutoSizeText(
                          currentRoom.topicTheme.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                          // minFontSize: 15,
                          maxLines: 1,
                        ),
                      ),
                      actions: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Row(
                            children: [
                              // if (currentMemberofThisRoom?.isAdmin == true)
                              //   IconButton(
                              //       onPressed: () {
                              //         Navigator.of(context).push(
                              //           MaterialPageRoute<void>(
                              //             builder: (BuildContext context) =>
                              //                 AddNewUser(widget.groupID),
                              //           ),
                              //         );
                              //       },
                              //       icon: Icon(Icons.add)),
                              if (currentMemberofThisRoom?.isApporved ==
                                      false &&
                                  currentMemberofThisRoom?.canWrite == false)
                                ElevatedButton(
                                    onPressed: () {
                                      roomCubit.sentRequest(
                                          authCubit.state.currentUser,
                                          currentRoom.isPrivate);
                                      currentRoom.isPrivate
                                          ? ScaffoldMessenger.of(context)
                                              .showSnackBar(requestSentSnackBar)
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                                  youHaveJoinedSnackBar);
                                    },
                                    child: Text('join')),
                              if (currentMemberofThisRoom?.isApporved == true &&
                                  currentMemberofThisRoom?.canWrite == true)
                                IconButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute<void>(
                                          builder: (BuildContext context) =>
                                              RoomMembersPage(widget.groupID),
                                          // fullscreenDialog: true
                                        ),
                                      );
                                      // print(
                                      //     "State room is: ${roomCubit.state.currentRoom?.admin}");
                                    },
                                    icon: Icon(Icons.people))
                            ],
                          ),
                        ),
                      ],
                    )
                  ];
                },
                body: Container(
                  child: Column(
                    children: [
                      Expanded(
                          child: Container(
                              child: currentMemberofThisRoom?.isApporved ==
                                          false &&
                                      currentMemberofThisRoom?.canWrite == false
                                  ? Center(
                                      child: Text(
                                        'This chat is visible only for members.\nYou are not one of them.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    )
                                  : currentMemberofThisRoom?.canWrite == true
                                      ? _localChat!.isEmpty
                                          ? Center(
                                              child:
                                                  Text('ooops... Such empty!'))
                                          : ListView.builder(
                                              controller: _scrollController,
                                              reverse: true,
                                              shrinkWrap: true,
                                              itemCount: _localChat.length,
                                              itemBuilder: (context, index) {
                                                final message =
                                                    _localChat[index];
                                                int _timeStamp =
                                                    message.time!.seconds;
                                                var date = DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        _timeStamp * 1000);
                                                var formattedDate = DateFormat(
                                                        'HH:mm dd.MM.yy', 'ru')
                                                    .format(date);
                                                return MessageTile(
                                                    time: formattedDate,
                                                    firstMessageOfAuthor:
                                                        message.isFirst,
                                                    lastMessageOfAuthor:
                                                        message.isLast,
                                                    author: message.isFirst
                                                        ? message.getUserName(
                                                            message.sender
                                                                .toString(),
                                                            listUsers)
                                                        : '',
                                                    message: message.content,
                                                    sentByMe: senderId ==
                                                        message.sender?.uid);
                                              },
                                            )
                                      : Center(
                                          child: Text(
                                            'Chat is only available to accpted members',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ))),
                      if (currentRoom?.isPrivate == true &&
                              currentMemberofThisRoom?.canWrite == false ||
                          currentMemberofThisRoom == null)
                        Container()
                      else
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: TextField(
                                      controller: _messageEditingController,
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                          hintText: 'type here',
                                          fillColor: Colors.transparent),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                // behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  data.sendMessage(
                                      _messageEditingController,
                                      authCubit.state.currentUser!,
                                      widget.groupID);
                                },
                                child: Container(
                                  height: 50.0,
                                  width: 50.0,
                                  decoration: BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Center(
                                      child: Icon(Icons.send,
                                          color: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                        )
                    ],
                  ),
                )));
      },
    );
  }
}
