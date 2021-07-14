import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/models/user.dart';
import 'package:my_chat_app/pages/authenticate.dart';
import 'package:my_chat_app/pages/home.dart';
import 'package:my_chat_app/pages/register.dart';
import 'package:my_chat_app/services/auth.dart';
import 'package:my_chat_app/services/wrapper.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.data);
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return StreamProvider<MyUser?>.value(
              initialData: null,
              value: AuthService().user,
              child: MaterialApp(
                home: Wrapper(),
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
