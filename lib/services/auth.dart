import "package:firebase_auth/firebase_auth.dart";
import 'package:get_it/get_it.dart';
import 'package:my_chat_app/models/user.dart';
import 'package:my_chat_app/services/database.dart';
// import 'package:my_chat_app/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final dbService = GetIt.I.get<DataBaseService>();
  //create User object based on FB

  MyUser? _userFromFirebase(User? user, String password) {
    return user != null
        ? MyUser(
            uid: user.uid,
            name: user.displayName,
            email: user.email,
            password: password)
        : null;
  }

  // // auth change user stream!
  // Stream<MyUser?> get user {
  //   return _auth
  //       .authStateChanges()
  //       // .map((User? user) => _userFromFirebase(user));
  //       .map(_userFromFirebase);
  //   // мапирует стрим юзера с ФБ в MyUser. То есть работа с моим классом ?
  // }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email and passw
  Future<dynamic> registerWithEmailandPassword(
      String name, String email, String password, String nickName) async {
    AuthResultStatus _status;
    MyUser? newUser;

    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User? _fbUser = result.user;

      if (_fbUser != null) {
        _status = AuthResultStatus.successful;
      } else {
        _status = AuthResultStatus.undefined;
      }

      _fbUser?.updateDisplayName(name);

      newUser = _userFromFirebase(_fbUser, password)
          ?.copyWith(name: name, nickName: nickName);

      //create a new doc for that user with the uid
      await dbService.updateUserData(newUser!);

      print('FILTER: $newUser');
      return newUser;
      // _userFromFirebase(_fbUser, password);
    } catch (e) {
      print('Exception @createAccount: $e');
      _status = AuthExceptionHandler.handleException(e);
    }
    return AuthExceptionHandler.generateExceptionMessage(_status);
  }

  //sign in with email and password
  Future<dynamic> signInWithEmailandPassword(
      String email, String password) async {
    AuthResultStatus? _status;
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? _fbUser = result.user;

      if (_fbUser != null) {
        _status = AuthResultStatus.successful;
        return _userFromFirebase(_fbUser, password);
      } else {
        _status = null;
      }
      // print("FB USER IS ${_fbUser.toString()}");
    } catch (e) {
      print('Exception @createAccount: $e');
      _status = AuthExceptionHandler.handleException(e);
    }
    return AuthExceptionHandler.generateExceptionMessage(_status);
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
      case "ERROR_USER_DISABLED":
        status = AuthResultStatus.userDisabled;
        break;
      case "ERROR_TOO_MANY_REQUESTS":
        status = AuthResultStatus.tooManyRequests;
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
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
    String errorMessage;
    switch (exceptionCode) {
      case AuthResultStatus.invalidEmail:
        errorMessage = "Your email address appears to be malformed.";
        break;
      case AuthResultStatus.wrongPassword:
        errorMessage = "Your password is wrong.";
        break;
      case AuthResultStatus.userNotFound:
        errorMessage = "User with this email doesn't exist.";
        break;
      case AuthResultStatus.userDisabled:
        errorMessage = "User with this email has been disabled.";
        break;
      case AuthResultStatus.tooManyRequests:
        errorMessage = "Too many requests. Try again later.";
        break;
      case AuthResultStatus.operationNotAllowed:
        errorMessage = "Signing in with Email and Password is not enabled.";
        break;
      case AuthResultStatus.emailAlreadyExists:
        errorMessage =
            "This email has already been registered. Please login or reset your password.";
        break;
      default:
        errorMessage = "An undefined Error happened.";
    }

    return errorMessage;
  }
}
