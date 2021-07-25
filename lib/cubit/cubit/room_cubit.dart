import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:my_chat_app/cubit/cubit/room_state.dart';
import 'package:my_chat_app/models/room.dart';
import 'package:my_chat_app/services/database.dart';

// part 'room_state.dart';

class RoomCubit extends Cubit<RoomState> {
  final data = GetIt.I.get<DataBaseService>();
  RoomCubit() : super(RoomState(version: 0, currentStep: 0));

  StreamBuilder displayRooms() {
    return StreamBuilder<QuerySnapshot>(
      stream: data.roomsStream(),
      builder: (context, snapshot) {
        var roomDataList = snapshot.data?.docs;
        if (snapshot.hasData) {
          // print(roomDataList);
          return ListView.builder(
            itemCount: roomDataList?.length,
            itemBuilder: (context, index) {
              if (roomDataList?.length == 0) {
                return Center(
                  child: Container(
                    child: Text('hey'),
                  ),
                );
              }
              return Column(
                children: [
                  ListTile(
                    title: Text(
                        "${roomDataList?[index]['groupName']} + ${roomDataList?[index]['groupID']}"),
                    subtitle: Text(
                        "Created by: ${roomDataList?[index]['admin'].toString()}"),
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) =>
                      //             ChatPage(roomDataList?[index]['groupID'])));
                    },
                  ),
                  Divider()
                ],
              );
            },
          );
        } else
          return Center(child: CircularProgressIndicator());
      },
    );
  }

  void loadMessages() {}

  void sendMessage() {}

  void addUser() {}

  void kickUser() {}

  void initRoom() {}

  void dissolveRoom() {}

  void stepTapped(int step) {
    // print('this shit');
    emit(state.copyWith(
        currentStep: state.currentStep = step, version: state.version! + 1));
  }

  void stepContinue() {
    // print('hey');
    if (state.currentStep < 3) {
      // print('ayy');
      emit(state.copyWith(
          currentStep: state.currentStep + 1, version: state.version! + 1));
    } else if (state.currentStep <= 3) {
      emit(state.copyWith(
          currentStep: state.currentStep = 0, version: state.version! - 1));
      print('CREATED');
    }
  }

  void stepCancel() {
    if (state.currentStep > 0) {
      emit(state.copyWith(currentStep: state.currentStep--));
    } else {
      emit(state.copyWith(currentStep: 0));
    }
  }
}
