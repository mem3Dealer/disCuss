import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:my_chat_app/cubit/cubit/auth_cubit.dart';
import 'package:my_chat_app/cubit/cubit/room_cubit.dart';
import 'package:my_chat_app/cubit/cubit/room_state.dart';
import 'package:my_chat_app/cubit/cubit/user_cubit.dart';
import 'package:my_chat_app/models/message.dart';
import 'package:my_chat_app/models/room.dart';
import 'package:my_chat_app/models/user.dart';
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
      bool userIsbanned = (currentMemberofThisRoom?.uid != null &&
          currentMemberofThisRoom?.canWrite == false &&
          currentMemberofThisRoom?.isApporved == false);
      final entrySnackBar = SnackBar(
          duration: Duration(seconds: 3),
          content: Text(
              'Well, ${authCubit.state.currentUser?.name}, you can`t write here. Go ask for perm.',
              style: TextStyle(
                fontSize: 17,
              )));
      final entryPublicRoomSnackBar = SnackBar(
          duration: Duration(seconds: 3),
          content: Text('Hit join to send messages in this room',
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
      if (!userIsbanned) if (roomCubit.state.currentRoom?.isPrivate ==
          true) if (currentMemberofThisRoom?.canWrite == false &&
              currentMemberofThisRoom?.isApporved == false ||
          currentMemberofThisRoom == null) {
        ScaffoldMessenger.of(context).showSnackBar(entrySnackBar);
      }
      if (!userIsbanned) if (roomCubit.state.currentRoom?.isPrivate ==
          false) if (currentMemberofThisRoom?.canWrite ==
              false ||
          currentMemberofThisRoom?.isApporved == false)
        ScaffoldMessenger.of(context).showSnackBar(entryPublicRoomSnackBar);
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
        var top = 0.0;
        final tbHeight = 50.0;
        MyUser? currentMemberofThisRoom = roomCubit.getoLocalUser();
        bool userIsbanned = (currentMemberofThisRoom?.uid != null &&
            currentMemberofThisRoom?.canWrite == false &&
            currentMemberofThisRoom?.isApporved == false);
        List<Message>? _localChat = state.messagesOfThisChatRoom;
        String title = " ${roomCubit.state.currentRoom?.topicTheme!}";
        String content = " ${roomCubit.state.currentRoom?.topicContent!}";

        return Scaffold(
            body: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      // toolbarHeight: tbHeight,
                      expandedHeight: 200,
                      // ((title.length / 30) * 36 +
                      //     (content.length / 60) * 20),
                      floating: true,
                      pinned: true,
                      flexibleSpace: LayoutBuilder(builder:
                          (BuildContext context, BoxConstraints constraints) {
                        // print('constraints=' + constraints.toString());
                        top = constraints.biggest.height;
                        return FlexibleSpaceBar(
                          centerTitle: true,
                          titlePadding: EdgeInsets.all(8.0),
                          title: SingleChildScrollView(
                            physics: NeverScrollableScrollPhysics(),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(title,
                                    maxLines: top <= tbHeight ? 1 : 10,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      // color: Colors.white,
                                      fontSize: 16.0,
                                    )),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 15.0),
                                  child: Text(content,
                                      style: TextStyle(
                                        // color: Colors.white,
                                        fontSize: 10.0,
                                      )),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                      // FlexibleSpaceBar(
                      //     collapseMode: CollapseMode.parallax,
                      //     centerTitle: true,

                      //     title: Padding(
                      //         padding: const EdgeInsets.all(10.0),
                      //         child: Center(
                      //           child: Column(
                      //             children: [
                      //               AutoSizeText(
                      //                 state.currentRoom!.topicContent
                      //                     .toString(),
                      //                 // style: TextStyle(fontSize: 25),
                      //                 minFontSize: 17.0,
                      //                 maxFontSize: 25.0,
                      //                 maxLines: 7,

                      //                 // textAlign: TextAlign.center,
                      //               ),
                      //               AutoSizeText(
                      //                 state.currentRoom!.topicTheme
                      //                     .toString(),
                      //                 textAlign: TextAlign.center,
                      //                 style: TextStyle(fontSize: 20),
                      //                 // minFontSize: 15,
                      //                 maxLines: 1,
                      //               ),
                      //             ],
                      //           ),
                      //           // Text(
                      //           //   content,
                      //           //   overflow: TextOverflow.ellipsis,
                      //           //   maxLines: 7,
                      //           // ),
                      //         ))),

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
                              if (!userIsbanned)
                                if (currentMemberofThisRoom?.isApporved ==
                                        false &&
                                    currentMemberofThisRoom?.canWrite == false)
                                  ElevatedButton(
                                      onPressed: () {
                                        roomCubit.sentRequest(
                                          authCubit.state.currentUser,
                                          // currentRoom.isPrivate
                                        );
                                        currentRoom!.isPrivate
                                            ? ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                                    requestSentSnackBar)
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
                      if (userIsbanned)
                        Expanded(
                          child: Chip(
                            label: Text('You were banned from this discussion'),
                          ),
                        )
                      else if (currentRoom?.isPrivate == true)
                        Expanded(
                            child: Container(
                                child: currentMemberofThisRoom?.canWrite ==
                                            false &&
                                        currentMemberofThisRoom?.isApporved ==
                                            false
                                    ? Center(
                                        child: Text(
                                          'You are not yet member of this group',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 23,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      )
                                    : currentMemberofThisRoom?.isApporved ==
                                                true &&
                                            currentMemberofThisRoom?.canWrite ==
                                                false
                                        ? Center(
                                            child: Text(
                                              'Your request is under develeopement',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 23,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          )
                                        : _localChat!.isEmpty
                                            ? Center(
                                                child: Chip(
                                                    label: Text(
                                                        'ooops... Such empty!')))
                                            : _buildChat(_localChat)))
                      else if (currentRoom?.isPrivate == false)
                        Expanded(
                            child: Container(
                                child: _localChat!.isEmpty
                                    ? Center(
                                        child: Chip(
                                            label:
                                                Text('ooops... Such empty!')))
                                    : _buildChat(_localChat)
                                //  _buildChat(currentRoom!.chatMessages!)
                                )),
                      if (
                      // currentRoom?.isPrivate == true &&
                      currentMemberofThisRoom?.canWrite == false ||
                          currentMemberofThisRoom?.isApporved == false ||
                          currentMemberofThisRoom == null)
                        Container()
                      else
                        BlocBuilder<RoomCubit, RoomState>(
                          bloc: roomCubit,
                          builder: (context, state) {
                            return Column(
                              children: [
                                SizedBox(
                                  height: 8,
                                ),
                                sendFieldandButton(),
                              ],
                            );
                          },
                        )
                    ],
                  ),
                )));
      },
    );
  }

  Align sendFieldandButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10),
            child: Divider(
              height: 1,
              // color: Colors.grey[600],
              thickness: 2,
            ),
          ),
          Container(
            height: 70,
            decoration: BoxDecoration(color: Colors.transparent),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 7.0, right: 7),
                    child: Container(
                      // margin: EdgeInsetsGeometry.lerp(5, 0, 0),
                      // decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.all(Radius.circular(20)),
                      //     color: Color(0XFFFCFAF9).withOpacity(0.7)),
                      child: Padding(
                        padding: EdgeInsets.only(left: 3.0),
                        child: TextField(
                          maxLines: null,
                          controller: _messageEditingController,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration().copyWith(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              hintStyle: TextStyle(color: Colors.black54),
                              // border: InputBorder(borderSide: BorderSide),
                              hintText: 'type here...',
                              fillColor: Colors.grey[300]
                              // Color(0XFFFCFAF9).withOpacity(0.7)
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 8.0, left: 5),
                  child: GestureDetector(
                    // behavior: HitTestBehavior.translucent,
                    onTap: () {
                      _messageEditingController.text.trim();
                      if (_messageEditingController.text.isNotEmpty)
                        data.sendMessage(_messageEditingController.text.trim(),
                            authCubit.state.currentUser!, widget.groupID);
                      _messageEditingController.clear();
                    },
                    child: Container(
                      height: 50.0,
                      width: 50.0,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius:
                              BorderRadius.all(Radius.elliptical(17, 17))),
                      child:
                          Center(child: Icon(Icons.send, color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ListView _buildChat(List<Message>? _localChat) {
    return ListView.builder(
      controller: _scrollController,
      reverse: true,
      shrinkWrap: true,
      itemCount: _localChat?.length,
      itemBuilder: (context, index) {
        final message = _localChat![index];
        int _timeStamp = message.time!.seconds;
        var date = DateTime.fromMillisecondsSinceEpoch(_timeStamp * 1000);
        var formattedDate = DateFormat('HH:mm dd.MM.yy', 'ru').format(date);
        return MessageTile(
            time: formattedDate,
            firstMessageOfAuthor: message.isFirst,
            lastMessageOfAuthor: message.isLast,
            author: message.isFirst
                ? message.getUserName(
                    message.sender, roomCubit.state.currentRoom?.members)
                : '',
            message: message.content!.trim(),
            sentByMe: senderId == message.sender?.uid);
      },
    );
  }
}
