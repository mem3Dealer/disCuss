// import 'dart:convert';

// import 'package:flutter/foundation.dart';

import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:my_chat_app/models/user.dart';

// of 'user_cubit.dart';

class UserListState {
  List<MyUser>? listUsers;
  List<MyUser>? selectedUsers;
  UserListState({
    this.listUsers,
    this.selectedUsers,
  });

  UserListState copyWith({
    List<MyUser>? listUsers,
    List<MyUser>? selectedUsers,
  }) {
    return UserListState(
      listUsers: listUsers ?? this.listUsers,
      selectedUsers: selectedUsers ?? this.selectedUsers,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'listUsers': listUsers?.map((x) => x.toMap()).toList(),
      'selectedUsers': selectedUsers?.map((x) => x.toMap()).toList(),
    };
  }

  factory UserListState.fromMap(Map<String, dynamic> map) {
    return UserListState(
      listUsers: List<MyUser>.from(map['listUsers']?.map((x) => MyUser.fromMap(x))),
      selectedUsers: List<MyUser>.from(map['selectedUsers']?.map((x) => MyUser.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserListState.fromJson(String source) => UserListState.fromMap(json.decode(source));

  @override
  String toString() => 'UserListState(listUsers: $listUsers, selectedUsers: $selectedUsers)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserListState &&
        listEquals(other.listUsers, listUsers) &&
        listEquals(other.selectedUsers, selectedUsers);
  }

  @override
  int get hashCode => listUsers.hashCode ^ selectedUsers.hashCode;
}
