import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:my_chat_app/cubit/states/auth_state.dart';
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

  Future<String?> signIn(String email, String password) async {
    var signInRes = await auth.signInWithEmailandPassword(email, password);

// print('AND THIS IS OUR CURRENT USER: ${signInRes}');
    if (signInRes != null && signInRes.runtimeType == MyUser) {
      String? nickName = await fetchNickName(signInRes.uid.toString());
      // print("I see $signInRes");
      emit(state.copyWith(
          isLoggedIn: true, currentUser: signInRes.copyWith(nickName: nickName), version: state.version! + 1));
    }
    if (signInRes != null && signInRes.runtimeType == String) {
      emit(state.copyWith(version: state.version! + 1));
      print('WE ARE RETURINGN STRING: AND IT IS: $signInRes');
      return signInRes;
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
    final userExists = data.userCollection.where('nickName', isEqualTo: val).get().then((snapshot) {
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

    auth
        .signOut()
        .catchError((e) => print(e.stackTrace.toString()))
        .whenComplete(() => emit(state.copyWith(isLoggedIn: false, version: state.version! + 1)));
    print('LOG OUT PRINT: ${state.isLoggedIn}, ${fbAuth}');
  }

  Future<dynamic> registrate(String name, String email, String password, String nickName) async {
    dynamic regResult = await auth.registerWithEmailandPassword(name, email, password, nickName);

    print("I watch $regResult");
    if (regResult != null && regResult.runtimeType == MyUser) {
      emit(state.copyWith(
          currentUser: regResult.copyWith(nickName: nickName),
          isLoggedIn: true,
          error: '',
          version: state.version! + 1));
      print(state.currentUser);
    } else if (regResult != null && regResult.runtimeType == String) {
      emit(state.copyWith(version: state.version! + 1));
      print("THIS IS another print: $regResult");
      return regResult;
    }
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    return AuthState(currentUser: MyUser.fromHydrant(json), version: 0, isLoggedIn: false);
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    return state.currentUser?.toHydrant();
  }
}
