import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:my_chat_app/cubit/cubit/auth_cubit.dart';
import 'package:my_chat_app/cubit/cubit/user_cubit.dart';
import 'package:my_chat_app/services/database.dart';

class RegisterPage extends StatefulWidget {
  // const RegisterPage({Key? key}) : super(key: key);
  final Function? letsToggleView;
  RegisterPage({required this.letsToggleView});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  // final _auth = AuthService();
  final data = DataBaseService();
  final userCubit = GetIt.I.get<UserCubit>();
  final authCubit = GetIt.I.get<AuthCubit>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nickNameController = TextEditingController();
  String? nickNameValidator;
  String? _emailTaken;
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
          body: Center(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 25.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration().copyWith(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelText: 'What is your name?',
                              helperText:
                                  'It should be at least 4 characters long'),
                          validator: (val) => val!.isEmpty
                              ? "Please, enter your name"
                              : val.length < 4
                                  ? 'Name should be at least 4 chars long'
                                  : null),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                          // initialValue: '@',
                          controller: _nickNameController,
                          decoration: InputDecoration().copyWith(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelText: 'Enter your nickname',
                              helperText: 'It should start with @'),
                          // onSaved:   authCubit.isNickNameUnique(_nickNameController.text).toString();,
                          validator: (val) {
                            if (val?.contains('@') == false) {
                              return 'please enter nickname starting with @';
                            }
                            if (val!.length <= 4) {
                              return 'Nickname should be at least 4 characters long';
                            }
                            if (nickNameValidator == '') {
                              return null;
                            } else
                              return nickNameValidator.toString();
                          }),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration().copyWith(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelText: 'Enter e-mail'),
                          validator: (val) {
                            if (val?.isEmpty == true) {
                              return 'Enter an email adress';
                            } else if (val?.contains('@') == false) {
                              return 'Please enter valid email';
                            } else if (_emailTaken?.isNotEmpty == true) {
                              return _emailTaken;
                            }
                          }), // email
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration().copyWith(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Create password',
                            helperText:
                                'It should be at least 6 chatacters long'),
                        validator: (val) => val!.length < 6
                            ? "Enter an password 6+ long"
                            : null,
                        obscureText: true,
                      ), // password
                      SizedBox(height: 10),
                      TextButton(
                          onPressed: () {
                            widget.letsToggleView!();
                          },
                          child: Text('Already have an account? Sign in',
                              style: TextStyle(
                                  color: Theme.of(context).accentColor))),
                      SizedBox(height: 10),
                      ElevatedButton(
                        child: Text('Register'),
                        onPressed: () async {
                          nickNameValidator = await authCubit
                              .isNickNameUnique(_nickNameController.text);

                          var result = await authCubit.registrate(
                              _nameController.text.trim(),
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                              _nickNameController.text.trim());

                          print('THIS IS THIS PRINT: $result');
                          if (result != null && result.runtimeType == String) {
                            _emailTaken = result;
                          }

                          if (_formKey.currentState!.validate()) {
                            // try {
                            // } catch (e) {
                            //   print('ERROR IS ${}');
                            // }
                          }
                        },
                      ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      // Text('')
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
