import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:my_chat_app/models/message.dart';
import 'package:my_chat_app/models/user.dart';

class Room {
  bool isPrivate = false;
  String? topicTheme;
  String? topicContent;
  Message? lastMessage;
  String? groupID;
  // String? groupName;
  // MyUser? admin;
  List<MyUser>? members;
  List<Message>? chatMessages;
  // bool isActive;

  Room({
    required this.isPrivate,
    this.topicTheme,
    this.topicContent,
    this.lastMessage,
    this.groupID,
    this.members,
    this.chatMessages,
  });

  // static fromSnapshot(QueryDocumentSnapshot<Object?> e) {
  //   return Room(e.get('groupName'), e.get('admin'), e.get('groupID'),
  //       e.get('members').toString());
  // }

  Room copyWith({
    bool? isPrivate,
    String? topicTheme,
    String? topicContent,
    Message? lastMessage,
    String? groupID,
    List<MyUser>? members,
    List<Message>? chatMessages,
  }) {
    return Room(
      isPrivate: isPrivate ?? this.isPrivate,
      topicTheme: topicTheme ?? this.topicTheme,
      topicContent: topicContent ?? this.topicContent,
      lastMessage: lastMessage ?? this.lastMessage,
      groupID: groupID ?? this.groupID,
      members: members ?? this.members,
      chatMessages: chatMessages ?? this.chatMessages,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isPrivate': isPrivate,
      'topicTheme': topicTheme,
      'topicContent': topicContent,
      'lastMessage': lastMessage?.toMap(),
      'groupID': groupID,
      'members': members?.map((x) => x.toMap()).toList(),
      'chatMessages': chatMessages?.map((x) => x.toMap()).toList(),
    };
  }

  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      isPrivate: map['isPrivate'],
      topicTheme: map['topicTheme'],
      topicContent: map['topicContent'],
      lastMessage: Message.fromMap(map['lastMessage']),
      groupID: map['groupID'],
      members: List<MyUser>.from(map['members']?.map((x) => MyUser.fromMap(x))),
      chatMessages: List<Message>.from(
          map['chatMessages']?.map((x) => Message.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Room.fromJson(String source) => Room.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Room(isPrivate: $isPrivate, topicTheme: $topicTheme, topicContent: $topicContent, lastMessage: $lastMessage, groupID: $groupID, members: $members, chatMessages: $chatMessages)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Room &&
        other.isPrivate == isPrivate &&
        other.topicTheme == topicTheme &&
        other.topicContent == topicContent &&
        other.lastMessage == lastMessage &&
        other.groupID == groupID &&
        listEquals(other.members, members) &&
        listEquals(other.chatMessages, chatMessages);
  }

  @override
  int get hashCode {
    return isPrivate.hashCode ^
        topicTheme.hashCode ^
        topicContent.hashCode ^
        lastMessage.hashCode ^
        groupID.hashCode ^
        members.hashCode ^
        chatMessages.hashCode;
  }

  static fromSnapshot(QueryDocumentSnapshot<Object?> e) {
    return Room(
        isPrivate: e.get('isPrivate'),
        topicContent: e.get('topicContent'),
        topicTheme: e.get('topicTheme'),
        lastMessage: Message.fromMap(e.get('lastMessage')),
        groupID: e.id,
        // groupName: e.get('groupName'),
        // admin: MyUser.fromMap(e.get('admin')),
        members: e
            .get('members')
            .map<MyUser>((user) => MyUser.fromMap(user))
            .toList());
  }
}
