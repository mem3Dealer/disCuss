import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:my_chat_app/core/localization/generated/l10n.dart';
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
  final trText = GetIt.I.get<I10n>();
  final fbAuth = FirebaseAuth.instance.currentUser;
  AuthCubit() : super(AuthState(isLoggedIn: false, version: 0));

  Future<dynamic> signIn(String email, String password) async {
    AuthResultStatus? _status;
    var signInRes = await auth.signInWithEmailandPassword(email, password);

// print('AND THIS IS OUR CURRENT USER: ${signInRes}');
    if (signInRes != null && signInRes.runtimeType == MyUser) {
      String? nickName = await fetchNickName(signInRes.uid.toString());
      int userColorCode = await fetchColor((signInRes.uid));
      // print('FILTER: $userColorCode');
      if (userColorCode == 0) {
        data.updateUserData(signInRes, nickName: nickName);
        userColorCode = await fetchColor((signInRes.uid));
      }
      // print("I see $signInRes")
      _status = AuthResultStatus.successful;
      emit(state.copyWith(
          isLoggedIn: true,
          currentUser:
              signInRes.copyWith(nickName: nickName, colorCode: userColorCode),
          version: state.version! + 1));
    }
    if (signInRes != null && signInRes.runtimeType != MyUser) {
      emit(state.copyWith(version: state.version! + 1));
      _status = AuthExceptionHandler.handleException(signInRes);
      // print('WE ARE RETURINGN STRING: AND IT IS: ${_status}');
      return _status;
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

  Future<int> fetchColor(String uid) async {
    int result = 0;
    var docRef = data.userCollection.doc(uid);

    await docRef.get().then((value) {
      result = value.get('colorCode');
    });
    return result;
  }

  Future<String> isNickNameUnique(String val) async {
    final userExists = data.userCollection
        .where('nickName', isEqualTo: val)
        .get()
        .then((snapshot) {
      return snapshot.docs.length > 0;
    });

    if (await userExists) {
      // print('THIS IS PRINT FROM THIS FUNC: $userExists');
      return trText.nickNameIsTaken;
    } else
      return '';
  }

  Future<void> logOut() async {
    // print('AYYY');

    auth
        .signOut()
        .catchError((e) => print(e.stackTrace.toString()))
        .whenComplete(() => emit(
            state.copyWith(isLoggedIn: false, version: state.version! + 1)));
    print('LOG OUT PRINT: ${state.isLoggedIn}, ${fbAuth}');
  }

  Future<dynamic> registrate(
      String name, String email, String password, String nickName) async {
    dynamic regResult = await auth.registerWithEmailandPassword(
        name, email, password, nickName);
    AuthResultStatus? _status;
    // print("I watch $regResult");

    if (regResult != null && regResult.runtimeType == MyUser) {
      _status = AuthResultStatus.successful;
      emit(state.copyWith(
          currentUser: regResult.copyWith(nickName: nickName),
          isLoggedIn: true,
          error: '',
          version: state.version! + 1));
      // print("Filter: final outprint: ${state.currentUser}");

    } else if (regResult != null && regResult.runtimeType != MyUser) {
      _status = AuthExceptionHandler.handleException(regResult);
      emit(state.copyWith(version: state.version! + 1));
      print("THIS IS another print: $_status");
      return _status;
    }
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

enum AuthResultStatus {
  successful,
  emailAlreadyExists,
  wrongPassword,
  invalidEmail,
  userNotFound,
  userDisabled,
  operationNotAllowed,
  tooManyRequests,
  undefined,
}

class AuthExceptionHandler {
  static handleException(e) {
    print(e.code);
    var status;
    switch (e.code) {
      case "invalid-email ":
        status = AuthResultStatus.invalidEmail;
        break;
      case "wrong-password":
        status = AuthResultStatus.wrongPassword;
        break;
      case "user-not-found":
        status = AuthResultStatus.userNotFound;
        break;
      case "user-disabled":
        status = AuthResultStatus.userDisabled;
        break;
      case "too-many-requests":
        status = AuthResultStatus.tooManyRequests;
        break;
      case "operation-not-allowed":
        status = AuthResultStatus.operationNotAllowed;
        break;
      case "email-already-in-use":
        status = AuthResultStatus.emailAlreadyExists;
        break;
      default:
        status = AuthResultStatus.undefined;
    }
    return status;
  }

  ///
  /// Accepts AuthExceptionHandler.errorType
  ///
  static generateExceptionMessage(exceptionCode) {
    final trText = GetIt.I.get<I10n>();
    String errorMessage;
    switch (exceptionCode) {
      case AuthResultStatus.invalidEmail:
        errorMessage = trText.authStatusInvEmail;
        break;
      case AuthResultStatus.wrongPassword:
        errorMessage = trText.authStatusWrongPassword;
        break;
      case AuthResultStatus.userNotFound:
        errorMessage = trText.authStatusUserNotFound;
        break;
      case AuthResultStatus.userDisabled:
        errorMessage = trText.authStatusUserDisabled;
        break;
      case AuthResultStatus.tooManyRequests:
        errorMessage = trText.authStatusTooManyRequests;
        break;
      case AuthResultStatus.operationNotAllowed:
        errorMessage = trText.authStatusOperationNotAllowed;
        break;
      case AuthResultStatus.emailAlreadyExists:
        errorMessage = trText.authStatusEmailAlreadyExists;
        break;
      default:
        errorMessage = trText.authStatusUndefError;
    }

    return errorMessage;
  }
}
