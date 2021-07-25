import 'dart:convert';
import 'dart:core';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:my_chat_app/cubit/cubit/user_state.dart';
import 'package:my_chat_app/models/user.dart';
import 'package:my_chat_app/services/auth.dart';
import 'package:my_chat_app/services/database.dart';

// part 'user_state.dart';

class UserCubit extends Cubit<UserListState> {
  final data = GetIt.I.get<DataBaseService>();
  // dynamic auth = FirebaseAuth.instance.currentUser!();

  UserCubit() : super(UserListState(version: 0));

  Future<void> getUsersList() async {
    List<MyUser>? _usersList = await data.getUsers();
    state.listUsers = _usersList;
    emit(state.copyWith(version: state.version));
  }

  MyUser? getCurrentUser() {
    state.listUsers?.firstWhere((e) {
      return e.uid == FirebaseAuth.instance.currentUser?.uid;
    });
  }

  void selectUser(MyUser user) {
    print("first SELECTED users: ${state.selectedUsers}");
    var _selectedUsers = state.selectedUsers!;

    if (!_selectedUsers.contains(user)) {
      _selectedUsers.add(user);
    }

    // List<MyUser> _filteredList = _selectedUsers.toSet().toList();
    // print(_filteredList);
    // print('SOMETHING HAPPENED');
    //  var selected = state.selectedUsers?.add(user);
    print("SELECTED users: $_selectedUsers");
    emit(state.copyWith(
        selectedUsers: _selectedUsers, version: state.version! + 1));
  }
}
