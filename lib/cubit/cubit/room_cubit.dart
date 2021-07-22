import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:my_chat_app/cubit/cubit/room_state.dart';
import 'package:my_chat_app/models/room.dart';
import 'package:my_chat_app/services/database.dart';

// part 'room_state.dart';

class RoomCubit extends Cubit<RoomState> {
  final data = GetIt.I.get<DataBaseService>();
  RoomCubit() : super(RoomState());

  void loadMessages() {}

  void sendMessage() {}

  void addUser() {}

  void kickUser() {}

  void initRoom() {}

  void dissolveRoom() {}
}
