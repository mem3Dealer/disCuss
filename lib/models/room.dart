import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:my_chat_app/models/message.dart';
import 'package:my_chat_app/models/user.dart';

class Room {
  String groupID;
  String groupName;
  MyUser? admin;
  List<MyUser>? members;
  List<Message>? chatMessages;
  bool isActive;

  Room(
    this.groupID,
    this.groupName,
    this.admin,
    this.members,
    this.chatMessages,
    this.isActive,
  );

  // static fromSnapshot(QueryDocumentSnapshot<Object?> e) {
  //   return Room(e.get('groupName'), e.get('admin'), e.get('groupID'),
  //       e.get('members').toString());
  // }

  Room copyWith({
    String? groupID,
    String? groupName,
    MyUser? admin,
    List<MyUser>? members,
    List<Message>? chatMessages,
    bool? isActive,
  }) {
    return Room(
      groupID ?? this.groupID,
      groupName ?? this.groupName,
      admin ?? this.admin,
      members ?? this.members,
      chatMessages ?? this.chatMessages,
      isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'groupID': groupID,
      'groupName': groupName,
      'admin': admin?.toMap(),
      'members': members?.map((x) => x.toMap()).toList(),
      'chatMessages': chatMessages?.map((x) => x.toMap()).toList(),
      'isActive': isActive,
    };
  }

  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      map['groupID'],
      map['groupName'],
      MyUser.fromMap(map['admin']),
      List<MyUser>.from(map['members']?.map((x) => MyUser.fromMap(x))),
      List<Message>.from(map['chatMessages']?.map((x) => Message.fromMap(x))),
      map['isActive'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Room.fromJson(String source) => Room.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Room(groupID: $groupID, groupName: $groupName, admin: $admin, members: $members, chatMessages: $chatMessages, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Room &&
        other.groupID == groupID &&
        other.groupName == groupName &&
        other.admin == admin &&
        listEquals(other.members, members) &&
        listEquals(other.chatMessages, chatMessages) &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return groupID.hashCode ^
        groupName.hashCode ^
        admin.hashCode ^
        members.hashCode ^
        chatMessages.hashCode ^
        isActive.hashCode;
  }
}
