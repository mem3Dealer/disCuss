import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:my_chat_app/models/room.dart';

// / part of 'room_cubit.dart';
class RoomState {
  // List<Message>? messagesOfThisChatRoom;
  String? category;
  List<Room>? listRooms;
  Room? currentRoom;
  int? version;
  // int currentStep;
  RoomState({
    this.category,
    this.listRooms,
    this.currentRoom,
    this.version,
  });
  RoomState copyWith({
    String? category,
    List<Room>? listRooms,
    Room? currentRoom,
    int? version,
  }) {
    return RoomState(
      category: category ?? this.category,
      listRooms: listRooms ?? this.listRooms,
      currentRoom: currentRoom ?? this.currentRoom,
      version: version ?? this.version,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'listRooms': listRooms?.map((x) => x.toMap()).toList(),
      'currentRoom': currentRoom?.toMap(),
      'version': version,
    };
  }

  factory RoomState.fromMap(Map<String, dynamic> map) {
    return RoomState(
      category: map['category'],
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
    return 'RoomState(category: $category, listRooms: $listRooms, currentRoom: $currentRoom, version: $version)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RoomState &&
        other.category == category &&
        listEquals(other.listRooms, listRooms) &&
        other.currentRoom == currentRoom &&
        other.version == version;
  }

  @override
  int get hashCode {
    return category.hashCode ^
        listRooms.hashCode ^
        currentRoom.hashCode ^
        version.hashCode;
  }
}
