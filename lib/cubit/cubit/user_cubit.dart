import 'dart:convert';
import 'dart:core';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:my_chat_app/cubit/cubit/auth_cubit.dart';
import 'package:my_chat_app/cubit/cubit/user_state.dart';
import 'package:my_chat_app/models/user.dart';
import 'package:my_chat_app/services/auth.dart';
import 'package:my_chat_app/services/database.dart';

// part 'user_state.dart';

class UserCubit extends Cubit<UserListState> {
  List<MyUser>? _selectedUsers = [];
  final data = GetIt.I.get<DataBaseService>();
  // final authCubit = GetIt.I.get<AuthCubit>();
  // dynamic auth = FirebaseAuth.instance.currentUser!();

  UserCubit() : super(UserListState(version: 0, selectedUsers: []));

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
    // List<MyUser>? filtered = collected?.toSet().toList();
    // state.selectedUsers = filtered;
    // print("first SELECTED users: ${state.selectedUsers}");
    // _selectedUsers?.add(user);
    // if (!_selectedUsers.contains(user)) {
    //   _selectedUsers.add(user);
    // } else {
    //   _selectedUsers.add(user);
    // }

    // // _selectedUsers.add(user);
    // print("SELECTED users: $_selectedUsers");

    state.selectedUsers?.add(user);
    // List<MyUser> _filteredList = state.selectedUsers.toSet().toList();

    // print("FILTERED LIST IS:  $_filteredList");
    // print('SOMETHING HAPPENED');
    //  var selected = state.selectedUsers?.add(user);
    // state.selectedUsers = _filteredList;
    var clear = state.selectedUsers?.toSet().toList();
    emit(state.copyWith(selectedUsers: clear, version: state.version! + 1));
    // _filteredList.clear();
    print(' SELECTED USERS FROM THIS FUNCTION: ${state.selectedUsers}');
  }

  void dismissSelected() {
    state.selectedUsers?.clear();
    emit(state.copyWith(
        selectedUsers: state.selectedUsers, version: state.version! - 1));
  }
}
