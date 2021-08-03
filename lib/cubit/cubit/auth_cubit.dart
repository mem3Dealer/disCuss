import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:my_chat_app/cubit/cubit/auth_state.dart';
import 'package:my_chat_app/models/user.dart';
import 'package:my_chat_app/services/auth.dart';
import 'package:my_chat_app/services/database.dart';
// import ''

// part 'authorize_state.dart';

class AuthCubit extends HydratedCubit<AuthState> {
  final currentUser = MyUser();
  final data = GetIt.I.get<DataBaseService>();
  final auth = GetIt.I.get<AuthService>();
  final fbAuth = FirebaseAuth.instance.currentUser;
  AuthCubit() : super(AuthState(isLoggedIn: false, version: 0));

  Future<void> signIn(String email, String password) async {
    MyUser? signInRes = await auth.signInWithEmailandPassword(email, password);

    if (signInRes != null) {
      print("I see $signInRes");
      emit(state.copyWith(
          isLoggedIn: true,
          currentUser: signInRes,
          version: state.version! + 1));
    }
  }

  Future<void> logOut() async {
    // print('AYYY');
    try {
      await auth.signOut();
      emit(state.copyWith(isLoggedIn: false, version: state.version! - 1));
      print(state.version);
    } catch (e) {
      print(e.toString());
      // return null;
    }
  }

  Future<void> registrate(String name, String email, String password) async {
    MyUser? regResult =
        await auth.registerWithEmailandPassword(name, email, password);
    if (regResult != null) {
      // final currentUser = MyUser(
      //     name: regResult.displayName,
      //     email: regResult.email,
      //     uid: regResult.uid);
      print("I watch $regResult");
      emit(state.copyWith(
          currentUser: regResult.copyWith(
              name: regResult.name), //ПРИ РЕГЕ НЕ СОБИРАЕТ ИМЯ ПОЧЕМУ-ТО
          isLoggedIn: true,
          error: '',
          version: state.version! + 1));
      print(state.currentUser);
    } else {
      emit(
        state.copyWith(
            isLoggedIn: false, error: 'We did not manage to register you.'),
      );
    }
    // print(myUser);
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    return AuthState(
        currentUser: MyUser.fromHydrant(json), version: 0, isLoggedIn: false);
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    return state.currentUser?.toHydrant();
  }

  void checkUser() {
    if (state.currentUser != null) {
      auth.signInWithEmailandPassword(state.currentUser!.email.toString(),
          state.currentUser!.password.toString());
    }
  }
}
