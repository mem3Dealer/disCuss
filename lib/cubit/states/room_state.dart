import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:my_chat_app/models/message.dart';
import 'package:my_chat_app/models/room.dart';

// part of 'room_cubit.dart';

class RoomState {
  List<Message>? messagesOfThisChatRoom;
  List<Room>? listRooms;
  Room? currentRoom;
  int? version;
  // int currentStep;

  RoomState({
    this.messagesOfThisChatRoom,
    this.listRooms,
    this.currentRoom,
    this.version,
  });

  RoomState copyWith({
    List<Message>? messagesOfThisChatRoom,
    List<Room>? listRooms,
    Room? currentRoom,
    int? version,
  }) {
    return RoomState(
      messagesOfThisChatRoom:
          messagesOfThisChatRoom ?? this.messagesOfThisChatRoom,
      listRooms: listRooms ?? this.listRooms,
      currentRoom: currentRoom ?? this.currentRoom,
      version: version ?? this.version,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'messagesOfThisChatRoom':
          messagesOfThisChatRoom?.map((x) => x.toMap()).toList(),
      'listRooms': listRooms?.map((x) => x.toMap()).toList(),
      'currentRoom': currentRoom?.toMap(),
      'version': version,
    };
  }

  factory RoomState.fromMap(Map<String, dynamic> map) {
    return RoomState(
      messagesOfThisChatRoom: List<Message>.from(
          map['messagesOfThisChatRoom']?.map((x) => Message.fromMap(x))),
      listRooms: List<Room>.from(map['listRooms']?.map((x) => Room.fromMap(x))),
      currentRoom: Room.fromMap(map['currentRoom']),
      version: map['version'],
    );
  }

  String toJson() => json.encode(toMap());

  factory RoomState.fromJson(String source) =>
      RoomState.fromMap(json.decode(source));

  @override
  String toString() {
    return 'RoomState(messagesOfThisChatRoom: $messagesOfThisChatRoom, listRooms: $listRooms, currentRoom: $currentRoom, version: $version)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is RoomState &&
        listEquals(other.messagesOfThisChatRoom, messagesOfThisChatRoom) &&
        listEquals(other.listRooms, listRooms) &&
        other.currentRoom == currentRoom &&
        other.version == version;
  }

  @override
  int get hashCode {
    return messagesOfThisChatRoom.hashCode ^
        listRooms.hashCode ^
        currentRoom.hashCode ^
        version.hashCode;
  }
}
