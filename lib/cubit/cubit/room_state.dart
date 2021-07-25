import 'dart:convert';

import 'package:my_chat_app/models/room.dart';

// part of 'room_cubit.dart';

class RoomState {
  Room? room;
  int? version;
  int currentStep;

  RoomState({
    this.room,
    this.version,
    required this.currentStep,
  });

  RoomState copyWith({
    Room? room,
    int? version,
    int? currentStep,
  }) {
    return RoomState(
      room: room ?? this.room,
      version: version ?? this.version,
      currentStep: currentStep ?? this.currentStep,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'room': room?.toMap(),
      'version': version,
      'currentStep': currentStep,
    };
  }

  factory RoomState.fromMap(Map<String, dynamic> map) {
    return RoomState(
      room: Room.fromMap(map['room']),
      version: map['version'],
      currentStep: map['currentStep'],
    );
  }

  String toJson() => json.encode(toMap());

  factory RoomState.fromJson(String source) =>
      RoomState.fromMap(json.decode(source));

  @override
  String toString() =>
      'RoomState(room: $room, version: $version, currentStep: $currentStep)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RoomState &&
        other.room == room &&
        other.version == version &&
        other.currentStep == currentStep;
  }

  @override
  int get hashCode => room.hashCode ^ version.hashCode ^ currentStep.hashCode;
}
