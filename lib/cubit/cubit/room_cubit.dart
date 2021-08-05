import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:my_chat_app/cubit/cubit/auth_cubit.dart';
import 'package:my_chat_app/cubit/cubit/room_state.dart';
import 'package:my_chat_app/cubit/cubit/user_cubit.dart';
import 'package:my_chat_app/cubit/cubit/user_state.dart';
import 'package:my_chat_app/models/message.dart';
import 'package:my_chat_app/models/room.dart';
import 'package:my_chat_app/models/user.dart';
import 'package:my_chat_app/pages/chatPage.dart';
import 'package:my_chat_app/services/database.dart';
import 'package:my_chat_app/widgets/messageTile.dart';

// part 'room_state.dart';

class RoomCubit extends Cubit<RoomState> {
  final authCubit = GetIt.I.get<AuthCubit>();
  final userCubit = GetIt.I.get<UserCubit>();
  final data = GetIt.I.get<DataBaseService>();
  RoomCubit() : super(RoomState(version: 0, currentRoom: Room()));

  Future<void> loadRooms() async {
    // Stream filtered = data.roomsStream().where((event) {
    //   return event.docs.contains(authCubit.state.currentUser?.toMap());
    // });

    // print(
    //     'THESE ARE PRINTS FROM FUNC: ${filtered.length}, ${authCubit.state.currentUser} ');

    data.roomsStream(authCubit.state.currentUser!).listen((result) {
      List<Room> listOfRooms =
          result.docs.map<Room>((e) => Room.fromSnapshot(e)).toList();

      // if (result.docs.contains(authCubit.state.currentUser?.toMap())
      // List someList = result.docs
      // );

      // someList.forEach((element) {
      //   listOfRooms.add(Room.fromSnapshot(element));
      // });
      emit(state.copyWith(listRooms: listOfRooms));
    });

    // print(filtered.length);
    // return listOfRooms;

    // return StreamBuilder<QuerySnapshot>(
    //   stream: data.roomsStream(),
    //   builder: (context, snapshot) {
    //     var roomDataList = snapshot.data?.docs;
    //     if (snapshot.hasData) {
    //       // return Center(
    //       //     child: Container(
    //       //         child: Text(
    //       //   roomDataList!.length.toString(),
    //       // )));
    //       // print(roomDataList);
    //       if (roomDataList?.length != 0)
    //         return ListView.builder(
    //           itemCount: roomDataList?.length,
    //           itemBuilder: (context, index) {
    //             return Column(
    //               children: [
    //                 ListTile(
    //                   title: Text("${roomDataList?[index]['groupName']}"),
    //                   subtitle: Text(
    //                       "Created by: ${roomDataList?[index]['admin']['name'].toString()}"),
    //                   onTap: () {
    //                     Navigator.push(
    //                         context,
    //                         MaterialPageRoute(
    //                             builder: (context) =>
    //                                 ChatPage(roomDataList?[index]['groupID'])));
    //                   },
    //                 ),
    //                 Divider()
    //               ],
    //             );
    //           },
    //         );
    //       else
    //         return Center(
    //           child: Container(
    //             child: Text('There are no chats for you lmao'),
    //           ),
    //         );
    //     } else
    //       return Center(child: CircularProgressIndicator());
    //   },
    // );
  }

  // void loadRooms() {}

  Future<void> loadChat(String groupId) async {}

  void loadMessages() {}

  Widget addUserToThisRoom(
    String groupID,
  ) {
    Room? localRoom = state.currentRoom;
    // return StreamBuilder<QuerySnapshot>(
    //   stream: data.roomMembers(groupID),
    //   builder: (context, snapshot) {

    // List<MyUser>? _localUsers = snapshot.data?.docs
    //     .map<MyUser>((e) => MyUser.myFromSnapshot(e))
    //     .toList();

    return SingleChildScrollView(
        child: BlocBuilder<UserCubit, UserListState>(
            bloc: userCubit,
            builder: (context, state) {
              return Container(
                height: 300,
                width: 400,
                child: Column(children: [
                  Text('whom to add', style: TextStyle(fontSize: 25)),
                  Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.listUsers?.length,
                          itemBuilder: (context, index) {
                            List<MyUser>? listUsers = state.listUsers;

                            if (!localRoom!.members!
                                .contains(listUsers?[index])) {
                              return BlocBuilder<UserCubit, UserListState>(
                                bloc: userCubit,
                                builder: (context, state) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10),
                                    child: ListTile(
                                      onTap: () {
                                        userCubit.selectUser(listUsers![index]);
                                      },
                                      trailing: state.selectedUsers!
                                              .contains(listUsers![index])
                                          // ==
                                          //     selected.contains(listUsers[index])
                                          ? Icon(Icons.check_box)
                                          : Icon(Icons.check_box_outline_blank),
                                      title: Text(
                                        listUsers[index].name.toString(),
                                      ),
                                      subtitle: Text(
                                          listUsers[index].email.toString()),
                                    ),
                                  );
                                },
                              );
                            } else {
                              return SizedBox.shrink();
                            }
                          })),
                  TextButton(
                      onPressed: () {
                        data
                            .addNewUserToRoom(
                                groupID, userCubit.state.selectedUsers)
                            .then((value) {
                          userCubit.state.selectedUsers!.clear();
                          Navigator.of(context).pop();
                        });
                      },
                      child: Text('Add`em',
                          style: TextStyle(
                              fontSize: 20, color: Colors.deepPurple)))
                ]),
              );
            }));
  }

  void kickUser(String groupID, MyUser userToRemove) {
    data.kickUser(groupID, [userToRemove.toMap()]);
    var _newMembers = state.currentRoom!.members;
    _newMembers!.remove(userToRemove);
    emit(state.copyWith(
        currentRoom: state.currentRoom?.copyWith(members: _newMembers),
        version: state.version! + 1));
    print('STATE ROOM: ${state.currentRoom}, ${state.version}');
    // print('STATE ');
  }

  // Widget showRoomMembers(String groupID) {
  //   return AlertDialog(
  //     title: Text('Chat members'),
  //     content: Container(
  //       height: 300,
  //       width: 300,
  //       child: SingleChildScrollView(
  //         child: ListView.builder(
  //             shrinkWrap: true,
  //             itemCount: state.currentRoom?.members?.length,
  //             itemBuilder: (context, index) {
  //               List? _members = state.currentRoom?.members;
  //               return ListTile(
  //                 trailing: IconButton(
  //                   icon: Icon(Icons.delete),
  //                   onPressed: () {
  //                     kickUser(groupID, [_members?[index].toMap()]);
  //                     // print([_members?[index]]
  //                     //     .runtimeType);
  //                   },
  //                 ),
  //                 title: Text(_members?[index].name),
  //                 subtitle: Text(_members?[index].email),
  //               );
  //             }),
  //       ),
  //     ),
  //     actions: [TextButton(onPressed: () {}, child: Text('shmyak'))],
  //   );
  // }

  Widget messageInputAndSendButton(String groupID) {
    TextEditingController messageEditingController = TextEditingController();
    String? senderId = authCubit.state.currentUser?.uid;
    return Row(
      children: [
        Expanded(
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
        ),
        GestureDetector(
          // behavior: HitTestBehavior.translucent,
          onTap: () {
            data
                .sendMessage(
                    messageEditingController, senderId.toString(), groupID)
                ?.then((value) => messageEditingController.clear());
            // print(snapshot.docs.length);
            print('pressed');
          },
          child: Container(
            height: 50.0,
            width: 50.0,
            decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(50)),
            child: Center(child: Icon(Icons.send, color: Colors.white)),
          ),
        ),
      ],
    );
  }

  // void kickUser(String groupID, List list) {
  //   data.kickUser(groupID, list);
  //   emit(state);
  // }

  void setRoomAsCurrent(Room? thisRoom) {
    emit(state.copyWith(currentRoom: thisRoom, version: state.version! + 1));
  }

  void initRoom() {}

  void dissolveRoom() {}

  Widget showChat(
      List<Message> messageDataList, List<MyUser>? listUsers, String groupId) {
    ScrollController _scrollController = new ScrollController();
    String? senderId = authCubit.state.currentUser?.uid;
    return Container(
      child: messageDataList.isEmpty
          ? Center(child: Chip(label: Text('ooops... Such empty!')))
          : ListView.builder(
              controller: _scrollController,
              reverse: true,
              shrinkWrap: true,
              itemCount: messageDataList.length,
              itemBuilder: (context, index) {
                // String localeTag =
                //     Localizations.localeOf(context).toLanguageTag();
                int _timeStamp = messageDataList[index].time!.seconds;
                var date =
                    DateTime.fromMillisecondsSinceEpoch(_timeStamp * 1000);
                var formattedDate =
                    DateFormat('HH:mm dd.MM.yy', 'ru').format(date);

                final message = messageDataList[index];

                return MessageTile(
                    time: formattedDate,
                    firstMessageOfAuthor: message.isFirst,
                    lastMessageOfAuthor: message.isLast,
                    author: message.isFirst
                        ? message.getUserName(message.sender, listUsers)
                        : '',
                    message: message.content,
                    sentByMe: senderId == message.sender);
              }),
    );
  }

  List<Message> makeMessagesDataList(
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    List<Message>? _messages = snapshot.data?.docs
        .map<Message>((e) => Message.fromSnapshot(e))
        .toList();
    for (int i = 0; i < _messages!.length; i++) {
      if (i > 0 && i < _messages.length - 1)
        _messages[i].isFirst = _messages[i + 1].sender != _messages[i].sender;
      else
        _messages[i].isFirst = false;

      if (i > 0 && i < _messages.length)
        _messages[i].isLast = _messages[i - 1].sender != _messages[i].sender;
      else
        _messages[i].isLast = true;
    }
    return _messages;
  }
}
