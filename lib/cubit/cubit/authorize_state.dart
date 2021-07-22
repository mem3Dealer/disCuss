import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:my_chat_app/models/user.dart';

class AuthorizeState {
  MyUser? currentUser;
  bool isLoggedIn;

  AuthorizeState({
    this.currentUser,
    required this.isLoggedIn,
  });

  AuthorizeState copyWith({
    MyUser? currentUser,
    bool? isLoggedIn,
  }) {
    return AuthorizeState(
      currentUser: currentUser ?? this.currentUser,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'currentUser': currentUser?.toMap(),
      'isLoggedIn': isLoggedIn,
    };
  }

  factory AuthorizeState.fromMap(Map<String, dynamic> map) {
    return AuthorizeState(
      currentUser: MyUser.fromMap(map['currentUser']),
      isLoggedIn: map['isLoggedIn'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthorizeState.fromJson(String source) =>
      AuthorizeState.fromMap(json.decode(source));

  @override
  String toString() =>
      'AuthorizeState(currentUser: $currentUser, isLoggedIn: $isLoggedIn)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthorizeState &&
        other.currentUser == currentUser &&
        other.isLoggedIn == isLoggedIn;
  }

  @override
  int get hashCode => currentUser.hashCode ^ isLoggedIn.hashCode;
}
