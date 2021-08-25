import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:my_chat_app/cubit/cubit/auth_cubit.dart';
import 'package:my_chat_app/cubit/cubit/room_cubit.dart';
import 'package:my_chat_app/cubit/states/room_state.dart';
import 'package:my_chat_app/cubit/cubit/user_cubit.dart';
import 'package:my_chat_app/models/message.dart';
import 'package:my_chat_app/models/room.dart';
import 'package:my_chat_app/models/user.dart';
import 'package:my_chat_app/services/database.dart';
import 'package:my_chat_app/widgets/messageTile.dart';
import 'package:my_chat_app/pages/roomMembersPage.dart';
import '../sliver_test.dart';

class ChatPage extends StatefulWidget {
  final String groupID;
  ChatPage(this.groupID);
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference chat = FirebaseFirestore.instance.collection('chat');
  String? senderId = FirebaseAuth.instance.currentUser?.uid;
  List<MyUser>? listUsers;
  final _messageEditingController = TextEditingController();
  final _scrollController = new ScrollController();
  final data = GetIt.I.get<DataBaseService>();
  final userCubit = GetIt.I.get<UserCubit>();
  final authCubit = GetIt.I.get<AuthCubit>();
  final roomCubit = GetIt.I.get<RoomCubit>();
  // int maxLines = 1;

  @override
  void initState() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 100), value: 1.0, vsync: this);
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
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  bool get _isPanelVisible {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  static const _PANEL_HEADER_HEIGHT = 40.0;

  Animation<RelativeRect> _getPanelAnimation(BoxConstraints constraints) {
    final double height = constraints.biggest.height;
    final double top = height - _PANEL_HEADER_HEIGHT;
    final double bottom = -_PANEL_HEADER_HEIGHT;
    return RelativeRectTween(
      begin: RelativeRect.fromLTRB(0.0, top, 0.0, bottom),
      end: RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  Widget build(BuildContext context) {
    Room? currentRoom = roomCubit.state.currentRoom;
    final requestSentSnackBar = SnackBar(
        duration: Duration(seconds: 2),
        content: Text(
          'Join reqeust sent. Fingers crossed',
        ));
    final youHaveJoinedSnackBar = SnackBar(
        duration: Duration(seconds: 2),
        content: Text(
          'You have joined this room. Be nice!',
        ));
    return BlocBuilder<RoomCubit, RoomState>(
      bloc: roomCubit,
      builder: (context, state) {
        // var top = 0.0;
        // final tbHeight = 50.0;
        MyUser? currentMemberofThisRoom = roomCubit.getoLocalUser();
        bool userIsbanned = (currentMemberofThisRoom?.uid != null &&
            currentMemberofThisRoom?.canWrite == false &&
            currentMemberofThisRoom?.isApporved == false);
        // List<Message>? _localChat = state.messagesOfThisChatRoom;
        String title = " ${roomCubit.state.currentRoom?.topicTheme!}";

        // BoxConstraints? constraints;

        return Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Text(
                title,
                style: Theme.of(context).textTheme.headline1,
                overflow: TextOverflow.ellipsis,
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Row(
                    children: [
                      if (!userIsbanned)
                        IconButton(
                            splashRadius: 15,
                            onPressed: () {
                              _controller.fling(
                                  velocity: _isPanelVisible ? -1.0 : 1.0);
                            },
                            icon: Icon(Icons.info_outline_rounded)),
                      if (currentMemberofThisRoom?.isApporved == false &&
                          currentMemberofThisRoom?.canWrite == false)
                        IconButton(
                            onPressed: () {
                              roomCubit.sentRequest(
                                authCubit.state.currentUser,
                              );
                              currentRoom!.isPrivate
                                  ? ScaffoldMessenger.of(context)
                                      .showSnackBar(requestSentSnackBar)
                                  : ScaffoldMessenger.of(context)
                                      .showSnackBar(youHaveJoinedSnackBar);
                            },
                            icon: Icon(Icons.add)),
                      if (currentMemberofThisRoom?.isApporved == true &&
                          currentMemberofThisRoom?.canWrite == true)
                        IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      RoomMembersPage(widget.groupID),
                                ),
                              );
                            },
                            icon: Icon(Icons.people))
                    ],
                  ),
                )
              ],
            ),
            body: LayoutBuilder(
              builder: _buildChatBody,
            )
            // _buildChatBody(userIsbanned, currentRoom,
            //     currentMemberofThisRoom, _localChat)
            );
      },
    );
  }

  Widget _buildChatBody(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    Room? currentRoom = roomCubit.state.currentRoom;
    List<Message>? _localChat = roomCubit.state.messagesOfThisChatRoom;
    MyUser? currentMemberofThisRoom = roomCubit.getoLocalUser();
    bool userIsbanned = (currentMemberofThisRoom?.uid != null &&
        currentMemberofThisRoom?.canWrite == false &&
        currentMemberofThisRoom?.isApporved == false);
    final Animation<RelativeRect> animation = _getPanelAnimation(constraints);
    final ThemeData theme = Theme.of(context);
    String content = " ${roomCubit.state.currentRoom?.topicContent!}";
    String topic = " ${roomCubit.state.currentRoom?.topicTheme!}";

    return Container(
      color: theme.primaryColor,
      child: Stack(
        children: <Widget>[
          Center(
              // decoration: BoxDecoration(color: theme.primaryColor),
              child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Text('Topic of this discussion:',
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w300)),
                  SizedBox(height: 10),
                  Text(topic, style: TextStyle(fontSize: 20)),
                  SizedBox(height: 20),
                  Text('Content of this discussion:',
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w300)),
                  SizedBox(height: 10),
                  Text(
                    content,
                    style: TextStyle(fontSize: 20),
                    // textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          )),
          PositionedTransition(
            rect: animation,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0)),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: theme.brightness == Brightness.dark
                          ? ExactAssetImage('assets/dark_back.png')
                          : ExactAssetImage('assets/light_back.png')),
                  color: theme.scaffoldBackgroundColor,
                ),
                child: BackdropFilter(
                  filter: theme.brightness == Brightness.dark
                      ? ImageFilter.blur(sigmaX: 13.0, sigmaY: 13.0)
                      : ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
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
                                    : _buildChat(_localChat))),
                      if (currentMemberofThisRoom?.canWrite == false ||
                          currentMemberofThisRoom?.isApporved == false ||
                          currentMemberofThisRoom == null)
                        Container()
                      else
                        BlocBuilder<RoomCubit, RoomState>(
                          bloc: roomCubit,
                          builder: (context, state) {
                            return Column(
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 13.0, right: 13),
                                  child: Divider(
                                    height: 2,
                                    thickness: 2.5,
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                sendFieldandButton(),
                                SizedBox(
                                  height: 8,
                                ),
                              ],
                            );
                          },
                        )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Row _appBarButtons(bool userIsbanned, MyUser currentMemberofThisRoom, Room currentRoom, BuildContext context, SnackBar requestSentSnackBar, SnackBar youHaveJoinedSnackBar) {
  //   return
  // }
  Align sendFieldandButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.transparent),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 7.0, right: 7),
                    child: Container(
                      child: Padding(
                        padding: EdgeInsets.zero,
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
                              hintText: 'type here...',
                              fillColor: Colors.grey[300]),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 8.0, left: 5),
                  child: sendButton(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget sendButton() {
    return GestureDetector(
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
            borderRadius: BorderRadius.all(Radius.elliptical(17, 17))),
        child: Center(child: Icon(Icons.send, color: Colors.white)),
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
