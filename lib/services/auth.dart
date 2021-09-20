import "package:firebase_auth/firebase_auth.dart";
import 'package:get_it/get_it.dart';
import 'package:my_chat_app/core/localization/generated/l10n.dart';
import 'package:my_chat_app/cubit/cubit/auth_cubit.dart';
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
      await dbService.updateUserData(newUser!, nickName: nickName);

      int colorCode = await AuthCubit().fetchColor(newUser.uid!);

      print('FILTER: $newUser');
      return newUser.copyWith(colorCode: colorCode);
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
    // AuthResultStatus? _status;
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? _fbUser = result.user;

      if (_fbUser != null) {
        // _status = AuthResultStatus.successful;
        return _userFromFirebase(_fbUser, password);
      } else {
        // _status = null;
      }
      // print("FB USER IS ${_fbUser.toString()}");
    } catch (e) {
      print('Exception @createAccount: $e');
      // _status = AuthExceptionHandler.handleException(e);
      return e;
    }
    // return AuthExceptionHandler.generateExceptionMessage(_status);
  }
}

// enum AuthResultStatus {
//   successful,
//   emailAlreadyExists,
//   wrongPassword,
//   invalidEmail,
//   userNotFound,
//   userDisabled,
//   operationNotAllowed,
//   tooManyRequests,
//   undefined,
// }

// class AuthExceptionHandler {
//   static handleException(e) {
//     print(e.code);
//     var status;
//     switch (e.code) {
//       case "invalid-email ":
//         status = AuthResultStatus.invalidEmail;
//         break;
//       case "wrong-password":
//         status = AuthResultStatus.wrongPassword;
//         break;
//       case "user-not-found":
//         status = AuthResultStatus.userNotFound;
//         break;
//       case "user-disabled":
//         status = AuthResultStatus.userDisabled;
//         break;
//       case "too-many-requests":
//         status = AuthResultStatus.tooManyRequests;
//         break;
//       case "operation-not-allowed":
//         status = AuthResultStatus.operationNotAllowed;
//         break;
//       case "email-already-in-use":
//         status = AuthResultStatus.emailAlreadyExists;
//         break;
//       default:
//         status = AuthResultStatus.undefined;
//     }
//     return status;
//   }

//   ///
//   /// Accepts AuthExceptionHandler.errorType
//   ///
//   static generateExceptionMessage(exceptionCode) {
//     final trText = GetIt.I.get<I10n>();
//     String errorMessage;
//     switch (exceptionCode) {
//       case AuthResultStatus.invalidEmail:
//         errorMessage = trText.authStatusInvEmail;
//         break;
//       case AuthResultStatus.wrongPassword:
//         errorMessage = trText.authStatusWrongPassword;
//         break;
//       case AuthResultStatus.userNotFound:
//         errorMessage = trText.authStatusUserNotFound;
//         break;
//       case AuthResultStatus.userDisabled:
//         errorMessage = trText.authStatusUserDisabled;
//         break;
//       case AuthResultStatus.tooManyRequests:
//         errorMessage = trText.authStatusTooManyRequests;
//         break;
//       case AuthResultStatus.operationNotAllowed:
//         errorMessage = trText.authStatusOperationNotAllowed;
//         break;
//       case AuthResultStatus.emailAlreadyExists:
//         errorMessage = trText.authStatusEmailAlreadyExists;
//         break;
//       default:
//         errorMessage = trText.authStatusUndefError;
//     }

//     return errorMessage;
//   }
// }
