import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:my_chat_app/cubit/cubit/auth_cubit.dart';

class SignInPage extends StatefulWidget {
  final Function letsToggleView;
  SignInPage({required this.letsToggleView});
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final authCubit = GetIt.I.get<AuthCubit>();
  String? _emailError;
  String? _passError;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            scale: 0.3,
            repeat: ImageRepeat.repeat,
            // fit: BoxFit.cover,
            image: theme.brightness == Brightness.dark
                ? ExactAssetImage('assets/dark_back.png')
                : ExactAssetImage('assets/light_back.jpg')),
      ),
      child: BackdropFilter(
        filter: theme.brightness == Brightness.dark
            ? ImageFilter.blur(sigmaX: 13.0, sigmaY: 13.0)
            : ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: true,
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 43.0),
              child: Form(
                key: _formKey,
                child: Container(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration().copyWith(
                              alignLabelWithHint: true,
                              labelText: 'E-mail',
                              labelStyle: TextStyle(
                                  color: Theme.of(context).accentColor),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always),
                          validator: (val) {
                            if (val?.isEmpty == true) {
                              return 'Enter a valid email';
                            }
                            if (_emailError?.isNotEmpty == true) {
                              return _emailError;
                            }
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration().copyWith(
                              labelStyle: TextStyle(
                                  color: Theme.of(context).accentColor),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelText: 'Password'),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Please, enter password';
                            }
                            if (val.length < 6) {
                              return 'Enter password 6+ long';
                            }
                            if (_passError?.isNotEmpty == true) {
                              return _passError;
                            }
                          },
                          obscureText: true,
                        ),
                        SizedBox(height: 10),
                        TextButton(
                            onPressed: () {
                              widget.letsToggleView();
                            },
                            child: Text(
                              'New to DisCuss? Register',
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                            )),
                        SizedBox(height: 10),
                        ElevatedButton(
                          child: Text(
                            'Sign in',
                          ),
                          onPressed: () async {
                            _passError = '';
                            _emailError = '';
                            var result = await authCubit.signIn(
                                _emailController.text.trim(),
                                _passwordController.text.trim());
                            if (result?.isNotEmpty == true) {
                              if (result!.contains('password')) {
                                _passError = result;
                              } else if (result.contains('User')) {
                                _emailError = result;
                                print('THAT print from button: $_emailError');
                              }
                            }
                            if (_formKey.currentState!.validate()) {}
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
