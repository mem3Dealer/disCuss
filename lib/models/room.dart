import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';

import 'package:my_chat_app/models/message.dart';
import 'package:my_chat_app/models/user.dart';

class Room {
  String? groupID;
  String? groupName;
  MyUser? admin; // Firebase does not accept MyUser class. I cant have it back
  List<MyUser>? members; // тоже самое здесь
  List<Message>? chatMessages;
  // bool isActive;

  Room({
    this.groupID,
    this.groupName,
    this.admin,
    this.members,
    this.chatMessages,
  });

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
  }) {
    return Room(
      groupID: groupID ?? this.groupID,
      groupName: groupName ?? this.groupName,
      admin: admin ?? this.admin,
      members: members ?? this.members,
      chatMessages: chatMessages ?? this.chatMessages,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'groupID': groupID,
      'groupName': groupName,
      'admin': admin?.toMap(),
      'members': members?.map((x) => x.toMap()).toList(),
      'chatMessages': chatMessages?.map((x) => x.toMap()).toList(),
    };
  }

  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      groupID: map['groupID'],
      groupName: map['groupName'],
      admin: MyUser.fromMap(map['admin']),
      members: List<MyUser>.from(map['members']?.map((x) => MyUser.fromMap(x))),
      chatMessages: List<Message>.from(
          map['chatMessages']?.map((x) => Message.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Room.fromJson(String source) => Room.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Room(groupID: $groupID, groupName: $groupName, admin: $admin, members: $members, chatMessages: $chatMessages)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Room &&
        other.groupID == groupID &&
        other.groupName == groupName &&
        other.admin == admin &&
        listEquals(other.members, members) &&
        listEquals(other.chatMessages, chatMessages);
  }

  @override
  int get hashCode {
    return groupID.hashCode ^
        groupName.hashCode ^
        admin.hashCode ^
        members.hashCode ^
        chatMessages.hashCode;
  }

  static fromSnapshot(QueryDocumentSnapshot<Object?> e) {
    return Room(
        groupID: e.get('groupID'),
        groupName: e.get('groupName'),
        admin: MyUser.fromMap(e.get('admin')),
        members: e
            .get('members')
            .map<MyUser>((user) => MyUser.fromMap(user))
            .toList());
  }
}
