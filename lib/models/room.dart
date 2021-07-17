import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Room {
  String groupName;
  String admin;
  String members;
  String groupID;
  Room(
    this.groupName,
    this.admin,
    this.members,
    this.groupID,
  );

  static fromSnapshot(QueryDocumentSnapshot<Object?> e) {
    return Room(e.get('groupName'), e.get('admin'), e.get('groupID'),
        e.get('members').toString());
  }

  Room copyWith({
    String? groupName,
    String? admin,
    String? members,
    String? groupID,
  }) {
    return Room(
      groupName ?? this.groupName,
      admin ?? this.admin,
      members ?? this.members,
      groupID ?? this.groupID,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'groupName': groupName,
      'admin': admin,
      'members': members,
      'groupID': groupID,
    };
  }

  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      map['groupName'],
      map['admin'],
      map['members'],
      map['groupID'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Room.fromJson(String source) => Room.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Room(groupName: $groupName, admin: $admin, members: $members, groupID: $groupID)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Room &&
        other.groupName == groupName &&
        other.admin == admin &&
        other.members == members &&
        other.groupID == groupID;
  }

  @override
  int get hashCode {
    return groupName.hashCode ^
        admin.hashCode ^
        members.hashCode ^
        groupID.hashCode;
  }
}
