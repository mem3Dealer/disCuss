import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:my_chat_app/cubit/cubit/authorize_state.dart';
import 'package:my_chat_app/models/user.dart';
import 'package:my_chat_app/services/auth.dart';
import 'package:my_chat_app/services/database.dart';

// part 'authorize_state.dart';

class AuthorizeCubit extends Cubit<AuthorizeState> {
  final data = GetIt.I.get<DataBaseService>();
  final auth = GetIt.I.get<AuthService>();
  final fbAuth = FirebaseAuth.instance.currentUser;
  AuthorizeCubit() : super(AuthorizeState(isLoggedIn: false));

  Future<void> signIn(String email, String password) async {
    dynamic signInRes = await auth.signInWithEmailandPassword(email, password);

    signInRes != null
        ? emit(state.copyWith(isLoggedIn: true))
        : emit(state.copyWith(isLoggedIn: false));
  }

  void logOut() {}

  Future<void> registrate(String name, String email, String password) async {
    dynamic regResult =
        await auth.registerWithEmailandPassword(name, email, password);
    final myUser = MyUser(name: name, email: email, uid: fbAuth!.uid);

    emit(state.copyWith(currentUser: myUser));
    regResult != null
        ? emit(state.copyWith(isLoggedIn: true))
        : emit(state.copyWith(isLoggedIn: false));
  }
}
