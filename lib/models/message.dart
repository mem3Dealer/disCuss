import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:my_chat_app/models/user.dart';
import 'package:my_chat_app/widgets/messageTile.dart';

class Message {
  String? content;
  String? sender;
  Timestamp? time;
  bool isFirst;
  bool isLast;

  Message({
    this.content,
    this.sender,
    this.time,
    this.isFirst = true,
    this.isLast = false,
  });

  Message copyWith({
    String? content,
    String? sender,
    Timestamp? time,
    bool? isFirst,
    bool? isLast,
  }) {
    return Message(
      content: content ?? this.content,
      sender: sender ?? this.sender,
      time: time ?? this.time,
      isFirst: isFirst ?? this.isFirst,
      isLast: isLast ?? this.isLast,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'sender': sender,
      // 'time': time?.toMap(),
      'isFirst': isFirst,
      'isLast': isLast,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      content: map['content'],
      sender: map['sender'],
      // time: Timestamp.fromMap(map['time']),
      isFirst: map['isFirst'],
      isLast: map['isLast'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Message(content: $content, sender: $sender, time: $time, isFirst: $isFirst, isLast: $isLast)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Message &&
        other.content == content &&
        other.sender == sender &&
        other.time == time &&
        other.isFirst == isFirst &&
        other.isLast == isLast;
  }

  @override
  int get hashCode {
    return content.hashCode ^
        sender.hashCode ^
        time.hashCode ^
        isFirst.hashCode ^
        isLast.hashCode;
  }

  // String? getAuthorName(String sender, List? listUsers) {
  //   return listUsers!.firstWhere((e) => e.uid == sender).sender;
  // }

  static fromSnapshot(QueryDocumentSnapshot<Object?> e) {
    return Message(
        content: e.get('recentMessage'),
        sender: e.get('sender'),
        time: e.get('time'));
  }

  // String? getUserName(String? sender) {
  //   return listUsers
  //       .firstWhere((e) => e.uid == sender,
  //           orElse: () => MyUser(name: 'null name'))
  //       .name;
  // }
  getTimed(
      Timestamp? stamp, index, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    final messages = snapshot.data?.docs;
    int _timeStamp = messages?[index]['time'].seconds;
    var date = DateTime.fromMillisecondsSinceEpoch(_timeStamp * 1000);
    var formattedDate = DateFormat('HH:mm dd.MM.yy', 'ru').format(date);
    return formattedDate;
  }

  String? getUserName(String sender, List<MyUser>? listUsers) {
    return listUsers!
        .firstWhere((e) => e.uid == sender,
            orElse: () => MyUser(name: 'null name'))
        .name;
  }

  makeMessagesDataList(AsyncSnapshot<QuerySnapshot<Object?>> snapshot,
      List<Message>? listChat, List<MyUser>? listUsers) {
    bool _isNewAuthor;
    bool _isAuthorOver;
    final messages = snapshot.data?.docs;

    List<MyUser>? listUsers;

    String? senderId = FirebaseAuth.instance.currentUser?.uid;

    // return listChat?.forEach((element) {
    //   element.getTimed(time.toString(), element, snapshot);
    //   element.content.toString();
    //   element.getUserName(sender!, listUsers);
    // });

    // return Expanded(
    //   child: Container(
    //       child: listChat == null
    //           ? Center(
    //               child: CircularProgressIndicator(),
    //             )
    //           : ListView.builder(

    //               // reverse: true,
    //               shrinkWrap: true,
    //               itemCount: listChat.length,
    //               itemBuilder: (context, index) {

    //                 int _timeStamp = listChat[index].time!.seconds;
    //                 var date =
    //                     DateTime.fromMillisecondsSinceEpoch(_timeStamp * 1000);
    //                 var formattedDate =
    //                     DateFormat('HH:mm dd.MM.yy', 'ru').format(date);

    //                 if (index > 0 && index < listChat.length)
    //                   _isNewAuthor = listChat[index - 1].sender.toString() !=
    //                       listChat[index].sender.toString();
    //                 else
    //                   _isNewAuthor = false;

    //                 if (index > 0 && index < listChat.length - 1)
    //                   _isAuthorOver = listChat[index - 1].sender.toString() !=
    //                       listChat[index].sender.toString();
    //                 else
    //                   _isAuthorOver = true;

    //                 return MessageTile(
    //                     time: formattedDate,
    //                     message: listChat[index].content.toString(),
    //                     author: _isNewAuthor
    //                         ? getUserName(listChat[index].sender.toString())
    //                         : '',
    //                     sentByMe: senderId == listChat[index].sender.toString(),
    //                     firstMessageOfAuthor: _isNewAuthor,
    //                     lastMessageOfAuthor: _isAuthorOver);
    //               })),
    // );
  }
}
