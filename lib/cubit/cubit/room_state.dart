import 'dart:convert';

import 'package:my_chat_app/models/room.dart';

// part of 'room_cubit.dart';

class RoomState {
  Room? room;
  int? version;

  RoomState({
    this.room,
    this.version,
  });

  RoomState copyWith({
    Room? room,
    int? version,
  }) {
    return RoomState(
      room: room ?? this.room,
      version: version ?? this.version,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'room': room!.toMap(),
      'version': version,
    };
  }

  factory RoomState.fromMap(Map<String, dynamic> map) {
    return RoomState(
      room: Room.fromMap(map['room']),
      version: map['version'],
    );
  }

  String toJson() => json.encode(toMap());

  factory RoomState.fromJson(String source) =>
      RoomState.fromMap(json.decode(source));

  @override
  String toString() => 'RoomState(room: $room, version: $version)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RoomState && other.room == room && other.version == version;
  }

  @override
  int get hashCode => room.hashCode ^ version.hashCode;
}
