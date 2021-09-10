import 'dart:math';
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
import 'package:my_chat_app/shared/myScaffold.dart';
import 'package:my_chat_app/widgets/messageTile.dart';
import 'package:my_chat_app/pages/room_members_page.dart';
// import '../sliver_test.dart';
import 'package:animated_icon_button/animated_icon_button.dart';

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
          content: Text('Hit + to send messages in this room',
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

      // print(roomCubit.state.messagesOfThisChatRoom);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isPanelVisible {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  static const _PANEL_HEADER_HEIGHT = 77.0;

  Animation<RelativeRect> _getPanelAnimation(BoxConstraints constraints) {
    final double height = constraints.biggest.height;
    final double top = height - _PANEL_HEADER_HEIGHT;
    return RelativeRectTween(
      begin: RelativeRect.fromLTRB(0.0, top, 0.0, 0.0),
      end: RelativeRect.fromLTRB(0.0, 0, 0.0, 0.0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.ease));
  }

  @override
  Widget build(BuildContext context) {
    Room? currentRoom = roomCubit.state.currentRoom;
    MyUser? currentMemberofThisRoom = roomCubit.getoLocalUser();
    bool? didIWrite;

    didIWrite = currentRoom?.chatMessages?.any((element) {
      return element.sender?.uid == currentMemberofThisRoom?.uid;
    });

    if (didIWrite == false) {
      _controller.fling(velocity: -1);
    }

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
        String title = " ${roomCubit.state.currentRoom?.topicTheme}";
        final ThemeData theme = Theme.of(context);
        // BoxConstraints? constraints;

        // Color color = Color.fromARGB(255, Random().nextInt(100) + 100,
        //     Random().nextInt(100) + 100, Random().nextInt(100) + 100);
        // // int hexCode = color.value;
        return
            // MyScaffold(
            //   Text(
            //     title,
            //     style: Theme.of(context).textTheme.headline1,
            //     overflow: TextOverflow.ellipsis,
            //   ),
            //   LayoutBuilder(
            //     builder: _buildChatBody,
            //   ),
            //   actions: [
            //     Padding(
            //       padding: EdgeInsets.only(right: 10.0),
            //       child: Row(
            //         children: [
            //           if (!userIsbanned)
            //             AnimatedIconButton(
            //                 splashRadius: 5,
            //                 onPressed: () {
            //                   _controller.fling(
            //                       velocity: _isPanelVisible ? -1.0 : 1.0);
            //                   // print(_controller.velocity);
            //                 },
            //                 icons: [
            //                   AnimatedIconItem(
            //                       icon: Icon(
            //                     Icons.arrow_downward_sharp,
            //                     size: 24,
            //                     color: theme.brightness == Brightness.light
            //                         ? Colors.black
            //                         : Colors.white,
            //                   )),
            //                   AnimatedIconItem(
            //                       icon: Icon(
            //                     Icons.arrow_upward_sharp,
            //                     color: theme.brightness == Brightness.light
            //                         ? Colors.black
            //                         : Colors.white,
            //                     size: 24,
            //                   )),
            //                 ]),
            //           if (currentMemberofThisRoom?.isApporved == false &&
            //               currentMemberofThisRoom?.canWrite == false)
            //             IconButton(
            //                 onPressed: () {
            //                   roomCubit.sentRequest(
            //                     authCubit.state.currentUser,
            //                   );
            //                   currentRoom!.isPrivate
            //                       ? ScaffoldMessenger.of(context)
            //                           .showSnackBar(requestSentSnackBar)
            //                       : ScaffoldMessenger.of(context)
            //                           .showSnackBar(youHaveJoinedSnackBar);
            //                 },
            //                 icon: Icon(Icons.add)),
            //           if (currentMemberofThisRoom?.isApporved == true &&
            //               currentMemberofThisRoom?.canWrite == true)
            //             IconButton(
            //                 padding: EdgeInsets.zero,
            //                 onPressed: () {
            //                   Navigator.of(context).push(
            //                     MaterialPageRoute<void>(
            //                       builder: (BuildContext context) =>
            //                           RoomMembersPage(widget.groupID),
            //                     ),
            //                   );
            //                 },
            //                 icon: Icon(Icons.people))
            //         ],
            //       ),
            //     )
            //   ],
            // );
            Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      scale: theme.brightness == Brightness.dark ? 7.5 : 0.3,
                      repeat: ImageRepeat.repeat,
                      // fit: BoxFit.cover,
                      image: theme.brightness == Brightness.dark
                          ? ExactAssetImage('assets/dark_back.png')
                          : ExactAssetImage('assets/light_back.jpg')),
                ),
                child: BackdropFilter(
                    filter: theme.brightness == Brightness.dark
                        ? ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0)
                        : ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                    child: Scaffold(
                      backgroundColor: Colors.transparent,
                      appBar: AppBar(
                        backgroundColor: Colors.transparent,
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
                                  AnimatedIconButton(
                                      splashRadius: 5,
                                      onPressed: () {
                                        _controller.fling(
                                            velocity:
                                                _isPanelVisible ? -1.0 : 1.0);
                                        // print(_controller.velocity);
                                      },
                                      icons: [
                                        AnimatedIconItem(
                                            icon: Icon(
                                          Icons.arrow_downward_sharp,
                                          size: 24,
                                          color: theme.brightness ==
                                                  Brightness.light
                                              ? Colors.black
                                              : Colors.white,
                                        )),
                                        AnimatedIconItem(
                                            icon: Icon(
                                          Icons.arrow_upward_sharp,
                                          color: theme.brightness ==
                                                  Brightness.light
                                              ? Colors.black
                                              : Colors.white,
                                          size: 24,
                                        )),
                                      ]),
                                if (currentMemberofThisRoom?.isApporved ==
                                        false &&
                                    currentMemberofThisRoom?.canWrite == false)
                                  IconButton(
                                      onPressed: () {
                                        roomCubit.sentRequest(
                                          authCubit.state.currentUser,
                                        );
                                        currentRoom!.isPrivate
                                            ? ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                                    requestSentSnackBar)
                                            : ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                                    youHaveJoinedSnackBar);
                                      },
                                      icon: Icon(Icons.add)),
                                if (currentMemberofThisRoom?.isApporved ==
                                        true &&
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
                      ),

                      // _buildChatBody(userIsbanned, currentRoom,
                      //     currentMemberofThisRoom, _localChat)
                    )));
      },
    );
  }

  Widget _buildChatBody(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    Room? currentRoom = roomCubit.state.currentRoom;
    List<Message>? _localChat = currentRoom?.chatMessages;
    MyUser? currentMemberofThisRoom = roomCubit.getoLocalUser();
    bool userIsbanned = (currentMemberofThisRoom?.uid != null &&
        currentMemberofThisRoom?.canWrite == false &&
        currentMemberofThisRoom?.isApporved == false);
    final Animation<RelativeRect> animation = _getPanelAnimation(constraints);
    final ThemeData theme = Theme.of(context);
    String content = " ${roomCubit.state.currentRoom?.topicContent}";
    String topic = " ${roomCubit.state.currentRoom?.topicTheme}";

    // print('Colors is: $color');

    // print('THIS IS PRINT FROM BUILD:$_localChat ');
    return Container(
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(15.0),
            child: SafeArea(
              minimum: EdgeInsets.only(bottom: 70),
              child: ListView(
                // mainAxisAlignment: MainAxisAlignment.start,
                // mainAxisSize: MainAxisSize.max,
                children: [
                  Text(topic,
                      style: theme.textTheme.headline5,
                      textAlign: TextAlign.justify),
                  SizedBox(height: 20),
                  Container(
                    child: Text(content,
                        style: theme.textTheme.bodyText1,
                        textAlign: TextAlign.justify),
                  ),
                  // SizedBox(height: 30),
                ],
              ),
            ),
          ),
          PositionedTransition(
            rect: animation,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0)),
              child: Align(
                alignment: Alignment.bottomCenter,
                heightFactor: 1.0,
                child: Container(
                  decoration: BoxDecoration(
                    // image: DecorationImage(
                    //     fit: BoxFit.cover,
                    //     image: theme.brightness == Brightness.dark
                    //         ? ExactAssetImage('assets/dark_back.png')
                    //         : ExactAssetImage('assets/light_back.png')),
                    color: theme.scaffoldBackgroundColor,
                  ),
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
                        if (_localChat?.isEmpty == true)
                          Expanded(
                              child: Container(
                                  child: Center(
                                      child: Chip(
                                          label:
                                              Text('ooops... Such empty!')))))
                        else if (_localChat?.isNotEmpty == true)
                          Expanded(child: _buildChat(_localChat)),
                      // _localChat.forEach((element) {
                      //     element.time.toString();
                      //   })
                      // Center(
                      //     child: Text(_localChat!.first.time.toString())),
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
          // ),
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
      child: GestureDetector(
        onTap: () {
          _controller.fling(velocity: 1);
        },
        // onVerticalDrag: (details) {
        //   _controller.fling(velocity: 1);
        //   print('hey');
        // },
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

  Widget _buildChat(List<Message>? _localChat) {
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
            userColorCode: message.sender!.colorCode!,
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
