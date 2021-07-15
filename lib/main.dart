import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/models/user.dart';
import 'package:my_chat_app/services/auth.dart';
import 'package:my_chat_app/services/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('ru', ''), // English, no country code
                  // Spanish, no country code
                ],
                home: Wrapper(),
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
