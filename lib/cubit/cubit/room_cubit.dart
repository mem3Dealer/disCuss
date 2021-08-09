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
  RoomCubit()
      : super(RoomState(
            version: 0,
            listRooms: [],
            currentRoom: Room(isPrivate: false),
            messagesOfThisChatRoom: []));

  Future<void> loadRooms() async {
    List<Room>? thisFuckingList = [];

    data.roomsStream(authCubit.state.currentUser!).listen((result) {
      List<Room> listOfRooms =
          result.docs.map<Room>((e) => Room.fromSnapshot(e)).toList();
      // print('FIRST ONE: $listOfRooms');
      thisFuckingList = listOfRooms;

      // print('SECOND ONE: $listOfRooms');
      emit(state.copyWith(
          listRooms: thisFuckingList, version: state.version! + 1));
    });
    // print('PRINT OUT FROM LOADROOMS: ${state.listRooms}');
  }

  Future<void> loadChat(String groupId) async {
    List<Message>? _listOfMessages = [];

    data.chatStream(groupId).listen((result) {
      List<Message>? _messages =
          result.docs.map<Message>((e) => Message.fromSnapshot(e)).toList();

      for (int i = 0; i < _messages.length; i++) {
        if (i > 0 && i < _messages.length - 1)
          _messages[i].isFirst = _messages[i + 1].sender != _messages[i].sender;
        else
          _messages[i].isFirst = false;

        if (i > 0 && i < _messages.length)
          _messages[i].isLast = _messages[i - 1].sender != _messages[i].sender;
        else
          _messages[i].isLast = true;
        _listOfMessages = _messages;
      }
      emit(state.copyWith(
          messagesOfThisChatRoom: _listOfMessages,
          version: state.version! + 1));
    });
  }

  Future<void> addUserToThisRoom(
      String groupId, BuildContext context, List<MyUser> selectedUsers) async {
    data.addNewUserToRoom(groupId, selectedUsers);
    state.currentRoom?.members?.addAll(selectedUsers);
    userCubit.dismissSelected();
    Navigator.of(context).pop();
    // print('FILTER1: ${state.currentRoom?.members}');
    emit(state.copyWith(
      version: state.version! + 1,
    ));
  }

  void kickUser(String groupID, MyUser userToRemove) {
    data.kickUser(groupID, [userToRemove.toMap()]);
    var _newMembers = state.currentRoom!.members;
    _newMembers!.remove(userToRemove);
    emit(state.copyWith(
        currentRoom: state.currentRoom?.copyWith(members: _newMembers),
        version: state.version! + 1));
    // print('STATE ROOM: ${state.currentRoom}, ${state.version}');
    // print('STATE ');
  }

  Future<void> setRoomAsCurrent(String groupId) async {
    // print("THIS IS GROUPID: $groupId, ${state.listRooms?.length}");
    Room? newCurrentRoom;
    try {
      // print(state.listRooms);
      newCurrentRoom = state.listRooms?.firstWhere((element) {
        return element.groupID == groupId;
      });
    } on Exception catch (e) {
      print(e);
    }
    // print('PRINTOUT FROM SETTER: ${newCurrentRoom}');
    emit(state.copyWith(
        currentRoom: newCurrentRoom, version: state.version! + 1));
  }

  Future<void> createRoom(
      List<MyUser>? selectedUsers,
      MyUser? creator,
      BuildContext context,
      String topicTheme,
      String topicContent,
      bool isPrivate) async {
    List<MyUser> _filtered = selectedUsers!.toSet().toList();

    await data.createGroup(
        _filtered, creator, topicTheme, topicContent, isPrivate);
    emit(state.copyWith(
        currentRoom: Room(
            isPrivate: isPrivate,
            // groupID: ,
            // groupName: textFieldController.text,
            // admin: creator,
            members: _filtered)));
    userCubit.dismissSelected();
    // textFieldController.clear();
    // print('NEW ROOM DONE: ${state.currentRoom}');
    Navigator.of(context).pop(); //TODO: ДОБАВИТЬ ПРЕХОД В НОВУЮ КОМНАТУ
  }

  Future<void> dissolveRoom(String groupId) async {
    data.deleteRoom(groupId);
    emit(state.copyWith(
        listRooms: state.listRooms, version: state.version! + 1));
    // print('PRINTOUT FROM CUBIT');
  }

  Future<void> leaveRoom(String groupId, MyUser user) async {
    data.leaveRoom(groupId, user);
    emit(state.copyWith(
        listRooms: state.listRooms, version: state.version! + 1));
    print('PRINTOUT FROM CUBIT');
  }

  bool markAsPrivate() {
    // bool _isprivate = state.currentRoom!.isPrivate;
    // print("PRINT FROM THIS MARKER: ${_isprivate}");
    // _isprivate = !_isprivate;
    // print("PRINT FROM THIS MARKER: ${_isprivate}");
    state.currentRoom!.isPrivate = !state.currentRoom!.isPrivate;
    emit(state.copyWith(version: state.version! + 1));
    return state.currentRoom!.isPrivate;
    // print("PRINT FROM THIS MARKER: ${state.currentRoom!.isPrivate}");
    // return state.currentRoom?.isPrivate;
  }

  MyUser? getoLocalUser() {
    MyUser? user = state.currentRoom!.members!.firstWhere((element) {
      return element.uid == authCubit.state.currentUser!.uid;
    }, orElse: () => MyUser());
    return user;
  }

  Future<void> sentRequest(MyUser? user, String groupID, bool isPrivate) async {
    isPrivate
        ? data.addNewUserToRoom(groupID, [user!.copyWith(isApporved: true)])
        : data.addNewUserToRoom(
            groupID, [user!.copyWith(isApporved: true, canWrite: true)]);
    state.currentRoom?.members?.add(user.copyWith(isApporved: true));
    emit(state.copyWith(
      version: state.version! + 1,
    ));
    print('CHECK CHECK $user');
  }

  Future<void> letThemWrite(String groupId, int key) async {
    // var serverRooms = await data.dummyChats.get();
    // List rooms =
    //     serverRooms.docs.map<Room>((e) => Room.fromSnapshot(e)).toList();
    // Room? thisRoom = rooms.firstWhere((element) {
    //   return element == myroom;
    // });
    // var updtae = {};
    // updtae['members.$key.canWrite'] = true;

    // var sht = data.dummyChats.doc(groupId).update(updtae);
    // print(thisRoom);

    data.dummyChats.doc(groupId).update({'members.$key.canWrite': true});
  }
}
