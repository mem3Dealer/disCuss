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
  Future<MyUser?> registerWithEmailandPassword(
      String name, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User? _fbUser = result.user;
      _fbUser?.updateDisplayName(name);

      //create a new doc for that user with the uid
      await dbService.updateUserData(_fbUser!.uid, name, email);

      return _userFromFirebase(_fbUser, password);
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
        email: email,
        password: password,
      );
      User? _fbUser = result.user;
      // print("FB USER IS ${_fbUser.toString()}");
      return _userFromFirebase(_fbUser, password);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
