import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:my_chat_app/cubit/cubit/authorize_cubit.dart';
import 'package:my_chat_app/pages/register.dart';
import 'package:my_chat_app/pages/signIn.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  final authCubit = GetIt.I.get<AuthorizeCubit>();
  bool showSignIt = true;

  void toggleView() {
    setState(() {
      showSignIt = !showSignIt;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: authCubit.state.isLoggedIn
            ? SignInPage(
                letsToggleView: toggleView,
              )
            : RegisterPage(letsToggleView: toggleView));
  }
}
