import 'package:flutter/material.dart';
import 'package:my_chat_app/models/user.dart';
import 'package:my_chat_app/pages/authenticate.dart';
import 'package:my_chat_app/pages/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  // const Wrapper({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    // print(user);

    if (user == null) {
      return Authenticate();
    } else {
      return HomePage();
    }
  }
}
