import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  String? uid;
  String? name;
  String? email;
  MyUser({
    this.uid,
    this.name,
    this.email,
  });

  MyUser copyWith({
    String? uid,
    String? name,
    String? email,
  }) {
    return MyUser(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
    };
  }

  factory MyUser.fromMap(Map<String, dynamic> map) {
    return MyUser(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MyUser.fromJson(String source) => MyUser.fromMap(json.decode(source));

  @override
  String toString() => 'MyUser(uid: $uid, name: $name, email: $email)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MyUser &&
        other.uid == uid &&
        other.name == name &&
        other.email == email;
  }

  @override
  int get hashCode => uid.hashCode ^ name.hashCode ^ email.hashCode;

  static fromSnapshot(QueryDocumentSnapshot<Object?> e) {
    return MyUser(
      uid: e.id,
      name: e.get('name'),
      email: e.get('email'),
    );
  }
}
