import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:my_chat_app/models/user.dart';

class AuthState {
  int? version;
  String? error;
  MyUser? currentUser;
  bool isLoggedIn;
  AuthState({
    this.version,
    this.error,
    this.currentUser,
    required this.isLoggedIn,
  });

  AuthState copyWith({
    int? version,
    String? error,
    MyUser? currentUser,
    bool? isLoggedIn,
  }) {
    return AuthState(
      version: version ?? this.version,
      error: error ?? this.error,
      currentUser: currentUser ?? this.currentUser,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'version': version,
      'error': error,
      'currentUser': currentUser?.toMap(),
      'isLoggedIn': isLoggedIn,
    };
  }

  factory AuthState.fromMap(Map<String, dynamic> map) {
    return AuthState(
      version: map['version'],
      error: map['error'],
      currentUser: MyUser.fromMap(map['currentUser']),
      isLoggedIn: map['isLoggedIn'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthState.fromJson(String source) =>
      AuthState.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AuthState(version: $version, error: $error, currentUser: $currentUser, isLoggedIn: $isLoggedIn)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthState &&
        other.version == version &&
        other.error == error &&
        other.currentUser == currentUser &&
        other.isLoggedIn == isLoggedIn;
  }

  @override
  int get hashCode {
    return version.hashCode ^
        error.hashCode ^
        currentUser.hashCode ^
        isLoggedIn.hashCode;
  }
}
