import 'package:bloc/bloc.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:my_chat_app/cubit/cubit/auth_cubit.dart';
import 'package:my_chat_app/cubit/states/room_state.dart';
import 'package:my_chat_app/cubit/cubit/user_cubit.dart';

import 'package:my_chat_app/models/message.dart';
import 'package:my_chat_app/models/room.dart';
import 'package:my_chat_app/models/user.dart';

import 'package:my_chat_app/services/database.dart';

// part 'room_state.dart';

class RoomCubit extends Cubit<RoomState> {
  final authCubit = GetIt.I.get<AuthCubit>();
  final userCubit = GetIt.I.get<UserCubit>();
  final data = GetIt.I.get<DataBaseService>();
  Room? backUpRoomState;
  RoomCubit()
      : super(RoomState(
          version: 0,
          listRooms: [],
          currentRoom: Room(isPrivate: false),
          // messagesOfThisChatRoom: []
        ));

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

    Room? newCurrentRoom;
    newCurrentRoom?.chatMessages = [];

    try {
      // print(state.listRooms);
      newCurrentRoom = state.listRooms?.firstWhere((element) {
        return element.groupID == groupId;
      });
    } on Exception catch (e) {
      print(e);
    }

    data.chatStream(groupId).listen((result) {
      List<Message>? _msg =
          result.docs.map<Message>((e) => Message.fromSnapshot(e)).toList();
      final _messages = _msg.reversed.toList();
      for (int i = 0; i < _messages.length; i++) {
        // print('$i ${_messages[i].sender?.name}');
        if (i > 0 && i < _messages.length - 1) {
          _messages[i].isLast =
              _messages[i].sender?.uid != _messages[i + 1].sender?.uid;
        } else {
          // _messages[i].isFirst = false;
          _messages[i].isLast = true;
        }

        if (i > 0 && i < _messages.length) {
          _messages[i].isFirst =
              _messages[i - 1].sender?.uid != _messages[i].sender?.uid;
        } else {
          _messages[i].isFirst = true;
        }
        _listOfMessages = _messages.reversed.toList();
      }

      emit(state.copyWith(
          currentRoom: newCurrentRoom?.copyWith(chatMessages: _listOfMessages),
          version: state.version! + 1));
      // print('THIS IS NEW ROOM: ${state.currentRoom?.chatMessages}');
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

  void kickUser(String groupID, MyUser? userToRemove) {
    // data.kickUser(groupID, [userToRemove.toMap()]);
    List<MyUser>? _newMembers = state.currentRoom!.members;
    _newMembers!.remove(userToRemove);
    emit(state.copyWith(
        currentRoom: state.currentRoom?.copyWith(members: _newMembers),
        version: state.version! + 1));
    // print('STATE ROOM: ${state.currentRoom}, ${state.version}');
    // print('STATE ');
  }

  // Future<void> setRoomAsCurrent(String groupId) async {
  //   // print("THIS IS GROUPID: $groupId, ${state.listRooms?.length}");
  //   Room? newCurrentRoom;
  //   try {
  //     // print(state.listRooms);
  //     newCurrentRoom = state.listRooms?.firstWhere((element) {
  //       return element.groupID == groupId;
  //     });
  //   } on Exception catch (e) {
  //     print(e);
  //   }
  //   // print('PRINTOUT FROM SETTER: ${newCurrentRoom?.groupID}');
  //   emit(state.copyWith(
  //       currentRoom: newCurrentRoom, version: state.version! + 1));
  // }

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

  MyUser? getoLocalUser({Room? thatRoom}) {
    MyUser? user;
    if (thatRoom == null)
      user = state.currentRoom!.members?.firstWhere((element) {
        return element.uid == authCubit.state.currentUser!.uid;
      }, orElse: () => MyUser());
    else
      user = thatRoom.members?.firstWhere((element) {
        return element.uid == authCubit.state.currentUser!.uid;
      }, orElse: () => MyUser());
    return user;
  }

  Future<void> sentRequest(
    MyUser? user,
  ) async {
    state.currentRoom!.isPrivate
        ? data.addNewUserToRoom(
            state.currentRoom!.groupID!, [user!.copyWith(isApporved: true)])
        : data.addNewUserToRoom(state.currentRoom!.groupID!,
            [user!.copyWith(isApporved: true, canWrite: true)]);
    state.currentRoom!.isPrivate
        ? state.currentRoom?.members?.add(user.copyWith(isApporved: true))
        : state.currentRoom?.members
            ?.add(user.copyWith(isApporved: true, canWrite: true));
    emit(state.copyWith(
        version: state.version! + 1, currentRoom: state.currentRoom));
    // print('CHECK CHECK $user');
  }

  Future<void> changeUserPrivileges(MyUser? user,
      {bool? canWrite, bool? isAdmin, bool? isApporved}) async {
    List<MyUser>? listMembers = state.currentRoom?.members;
    int? index = listMembers?.indexOf(user!);
    // if (canWrite != null) {
    MyUser? newUser = listMembers![index!]
        .copyWith(canWrite: canWrite, isAdmin: isAdmin, isApporved: isApporved);
    listMembers.setAll(index, [newUser]);
    Room? newRoom = state.currentRoom?.copyWith(members: listMembers);
    emit(state.copyWith(version: state.version! + 1, currentRoom: newRoom));
    // print('COMPLETED');
  }

  Future<void> updateRoomData(
      {String? topicTheme,
      String? topicContent,
      List<MyUser>? selectedUsers,
      bool? isPrivate}) async {
    selectedUsers?.forEach((element) {
      state.currentRoom?.members?.add(element.copyWith(
          canWrite: true, isApporved: true, isSelected: false));
    });

    List<MyUser>? updatedMembers = state.currentRoom?.members;

    data.editRoom(state.currentRoom!.groupID!, topicTheme, topicContent,
        updatedMembers, isPrivate);

    // emit(state.copyWith(
    //     version: state.version! + 1,
    //     currentRoom: state.currentRoom?.copyWith(
    //         topicContent: topicContent,
    //         topicTheme: topicTheme,
    //         members: updatedMembers)));

    if (topicContent != '' || topicContent != null) {
      emit(state.copyWith(
          version: state.version! + 1,
          currentRoom: state.currentRoom?.copyWith(
            topicContent: topicContent,
          )));
    }
    if (topicTheme != '' || topicTheme != null) {
      emit(state.copyWith(
          version: state.version! + 1,
          currentRoom: state.currentRoom?.copyWith(
            topicTheme: topicTheme,
          )));
    }

    if (isPrivate != null) {
      emit(state.copyWith(
          currentRoom: state.currentRoom?.copyWith(isPrivate: isPrivate)));
    }

    // if (updatedMembers.isNotEmpty) {
    emit(state.copyWith(
        version: state.version! + 1,
        currentRoom: state.currentRoom?.copyWith(
          members: updatedMembers,
        )));
    // }
    // print(
    //     'THIS IS another PRINT: ${state.currentRoom?.topicContent}, ${state.currentRoom?.topicTheme}');
  }

  // void addNewMember(MyUser? user) {
  //   List<MyUser>? _members = state.currentRoom?.members;
  //   _members?.add(
  //       user!.copyWith(isSelected: true, canWrite: true, isApporved: true));

  //   emit(
  //     state.copyWith(
  //         version: state.version! + 1,
  //         currentRoom: state.currentRoom?.copyWith(members: _members)),
  //   );
  // }

  Future<void> saveRoomChanges() async {
    data.updateRoom(state.currentRoom!.groupID!, state.currentRoom!);
    emit(state.copyWith(
        version: state.version! + 1, currentRoom: state.currentRoom));
    // print('PRINT OUT FROM CUBIT');
  }

  List<MyUser>? backUpUsers() {
    backUpRoomState = state.currentRoom?.copyWith();
    // print("BACKUP IS: $backUpRoomState");
  }

  void discardChanges() {
    // print('DISCARD PRINT: $backUpRoomState');
    // Room? _newRoom = state.currentRoom?.copyWith(members: backUpRoomState);
    emit(state.copyWith(
        currentRoom: backUpRoomState, version: state.version! + 1));
  }
}
