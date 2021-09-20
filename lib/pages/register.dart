import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:my_chat_app/core/localization/generated/l10n.dart';
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
    final trText = GetIt.I.get<I10n>();
    final ThemeData theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            scale: theme.brightness == Brightness.dark ? 7.5 : 0.3,
            repeat: ImageRepeat.repeat,
            // fit: BoxFit.cover,
            image: theme.brightness == Brightness.dark
                ? ExactAssetImage('assets/images/dark_back.png')
                : ExactAssetImage('assets/images/light_back.jpg')),
      ),
      child: BackdropFilter(
        filter: theme.brightness == Brightness.dark
            ? ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0)
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
                              labelText: trText.regNameLabel,
                              helperText: trText.regNameHelper),
                          validator: (val) => val!.isEmpty
                              ? trText.regNameMissing
                              : val.length < 2
                                  ? trText.regNameTooShort
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
                              labelText: trText.regNickNameLabel,
                              helperText: trText.regNickNameHelper),
                          // onSaved:   authCubit.isNickNameUnique(_nickNameController.text).toString();,
                          validator: (val) {
                            if (val?.contains('@') == false) {
                              return trText.regNickNameNoAt;
                            }
                            if (val!.length <= 4) {
                              return trText.regNickNameTooShort;
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
                              labelText: trText.regEmail),
                          validator: (val) {
                            if (val?.isEmpty == true) {
                              return trText.regEmailIsEmpty;
                            } else if (val?.contains('@') == false) {
                              return trText.regEmailNoAt;
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
                            labelText: trText.regPassword,
                            helperText: trText.regPasswordHelper),
                        validator: (val) => val!.length < 6
                            ? trText.regPasswordIsTooShort
                            : null,
                        obscureText: true,
                      ), // password
                      SizedBox(height: 10),
                      TextButton(
                          onPressed: () {
                            widget.letsToggleView!();
                          },
                          child: Text(trText.regYouAreNotNew,
                              style: TextStyle(
                                  color: Theme.of(context).accentColor))),
                      SizedBox(height: 10),
                      ElevatedButton(
                        child: Text(trText.regRegister),
                        onPressed: () async {
                          _emailTaken = '';
                          nickNameValidator = await authCubit
                              .isNickNameUnique(_nickNameController.text);

                          if (_formKey.currentState!.validate()) {
                            var result = await authCubit.registrate(
                                _nameController.text.trim(),
                                _emailController.text.trim(),
                                _passwordController.text.trim(),
                                _nickNameController.text.trim());

                            // print('THIS IS THIS PRINT: $result');
                            if (result != null &&
                                result == AuthResultStatus.emailAlreadyExists) {
                              _emailTaken =
                                  AuthExceptionHandler.generateExceptionMessage(
                                      result);
                            }
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
