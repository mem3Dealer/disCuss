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
  AuthCubit()
      : super(AuthState(
            isLoggedIn: false,
            version: 0)); //НУЖНО ЛИ ТУТ ОБЪВЯЛЯТЬ КАРРЕНТЮЗЕРА?

  Future<void> signIn(String email, String password) async {
    MyUser? signInRes = await auth.signInWithEmailandPassword(email, password);
    if (signInRes != null) {
      String? nickName = await fetchNickName(signInRes.uid.toString());
      print("I see $signInRes");
      emit(state.copyWith(
          isLoggedIn: true,
          currentUser: signInRes.copyWith(nickName: nickName),
          version: state.version! + 1));
      print('AND THIS IS OUR CURRENT USER: ${state.currentUser}');
    }
  }

  Future<String>? fetchNickName(String uid) async {
    String? result;
    var docRef = data.userCollection.doc(uid);
    await docRef.get().then((value) {
      result = value.get('nickName');
    });
    // print('RESULT IS $result');

    return result.toString();
    // MyUse;r.fromSnapshot(that
  }

  Future<String> isNickNameUnique(String val) async {
    final userExists = data.userCollection
        .where('nickName', isEqualTo: val)
        .get()
        .then((snapshot) {
      return snapshot.docs.length > 0;
    });

    if (await userExists) {
      print('THIS IS PRINT FROM THIS FUNC: $userExists');
      return 'This username is already taken :(';
    } else
      return '';
  }

  Future<void> logOut() async {
    // print('AYYY');
    try {
      await auth.signOut();
      emit(state.copyWith(isLoggedIn: false, version: state.version! - 1));
      print('LOG OUT PRINT: ${state.isLoggedIn}, ${state.version}');
    } catch (e) {
      print(e.toString());
      // return null;
    }
  }

  Future<void> registrate(
      String name, String email, String password, String nickName) async {
    MyUser? regResult = await auth.registerWithEmailandPassword(
        name, email, password, nickName);

    if (regResult != null) {
      // final currentUser = MyUser(
      //     name: regResult.displayName,
      //     email: regResult.email,
      //     uid: regResult.uid);
      print("I watch $regResult");
      emit(state.copyWith(
          currentUser: regResult.copyWith(nickName: nickName),
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
}
