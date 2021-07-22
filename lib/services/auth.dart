import "package:firebase_auth/firebase_auth.dart";
import 'package:my_chat_app/models/user.dart';
import 'package:my_chat_app/services/database.dart';
// import 'package:my_chat_app/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create User object based on FB
  MyUser? _userFromFirebase(User? user) {
    return user != null ? MyUser(uid: user.uid) : null;
  }

  // auth change user stream!
  Stream<MyUser?> get user {
    return _auth
        .authStateChanges()
        // .map((User? user) => _userFromFirebase(user));
        .map(_userFromFirebase);
    // мапирует стрим юзера с ФБ в MyUser. То есть работа с моим классом ?
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email and passw
  Future registerWithEmailandPassword(
      String uid, String name, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? _fbUser = result.user;

      //create a new doc for that user with the uid
      // await DataBaseService().updateUserData(name, email, password);

      return _userFromFirebase(_fbUser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with email and password
  Future<MyUser?> signInWithEmailandPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? _fbUser = result.user;
      return _userFromFirebase(_fbUser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
