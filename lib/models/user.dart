import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  bool? isSelected = false;
  bool? isOwner = false;
  bool? isAdmin = false;
  bool? canWrite = false;
  bool? isApporved = false;
  String? uid;
  String? name;
  String? email;
  String? password;
  MyUser({
    this.isSelected = false,
    this.isOwner = false,
    this.isAdmin = false,
    this.canWrite = false,
    this.isApporved = false,
    this.uid,
    this.name,
    this.email,
    this.password,
  });

  MyUser copyWith({
    bool? isSelected,
    bool? isOwner,
    bool? isAdmin,
    bool? canWrite,
    bool? isApporved,
    String? uid,
    String? name,
    String? email,
    String? password,
  }) {
    return MyUser(
      isSelected: isSelected ?? this.isSelected,
      isOwner: isOwner ?? this.isOwner,
      isAdmin: isAdmin ?? this.isAdmin,
      canWrite: canWrite ?? this.canWrite,
      isApporved: isApporved ?? this.isApporved,
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isSelected': isSelected,
      'isOwner': isOwner,
      'isAdmin': isAdmin,
      'canWrite': canWrite,
      'isApporved': isApporved,
      'uid': uid,
      'name': name,
      'email': email,
      // 'password': password,
    };
  }

  Map<String, dynamic> toHydrant() {
    return {
      'uid': uid, 'name': name, 'email': email,
      //  'password': password
    };
  }

  factory MyUser.fromMap(Map<String, dynamic> map) {
    return MyUser(
      isSelected: map['isSelected'],
      isOwner: map['isOwner'],
      isAdmin: map['isAdmin'],
      canWrite: map['canWrite'],
      isApporved: map['isApporved'],
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
    );
  }
  factory MyUser.fromHydrant(Map<String, dynamic> map) {
    return MyUser(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MyUser.fromJson(String source) => MyUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MyUser(isSelected: $isSelected, isOwner: $isOwner, isAdmin: $isAdmin, canWrite: $canWrite, isApporved: $isApporved, uid: $uid, name: $name, email: $email, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MyUser &&
        other.isSelected == isSelected &&
        other.isOwner == isOwner &&
        other.isAdmin == isAdmin &&
        other.canWrite == canWrite &&
        other.isApporved == isApporved &&
        other.uid == uid &&
        other.name == name &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode {
    return isSelected.hashCode ^
        isOwner.hashCode ^
        isAdmin.hashCode ^
        canWrite.hashCode ^
        isApporved.hashCode ^
        uid.hashCode ^
        name.hashCode ^
        email.hashCode ^
        password.hashCode;
  }

  static fromSnapshot(QueryDocumentSnapshot e) {
    return MyUser(
        uid: e.id,
        name: e.get('name'),
        email: e.get('email'),
        isOwner: e.get('isOwner'),
        isAdmin: e.get('isAdmin'),
        canWrite: e.get('canWrite'),
        isApporved: e.get('isApporved'));
  }

  // static myFromSnapshot(QueryDocumentSnapshot<Object?> e) {
  //   return MyUser(
  //     uid: e.get('uid'),
  //     name: e.get('name'),
  //     email: e.get('email'),

  //   );
  // }
}
