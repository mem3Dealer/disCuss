import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:my_chat_app/core/localization/generated/l10n.dart';
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
  String? _otherError;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
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
                              labelText: trText.email,
                              labelStyle: TextStyle(
                                  color: Theme.of(context).accentColor),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always),
                          validator: (val) {
                            if (val?.isEmpty == true) {
                              return trText.emailIsEmpty;
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
                              labelText: trText.password),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return trText.passwordIsIncorrect;
                            }
                            if (val.length < 6) {
                              return trText.passwordIsTooShort;
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
                              // 'New to DisCuss? Register',
                              trText.areYouNew,
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                            )),
                        SizedBox(height: 5),
                        _otherError?.isNotEmpty == true
                            ? Text(
                                "$_otherError",
                                style: theme.textTheme.caption
                                    ?.copyWith(color: Colors.red),
                              )
                            : SizedBox.shrink(),
                        SizedBox(height: 5),
                        ElevatedButton(
                          child: Text(
                            trText.signIn,
                          ),
                          onPressed: () async {
                            _passError = '';
                            _emailError = '';
                            _otherError = '';
                            var result = await authCubit.signIn(
                                _emailController.text.trim(),
                                _passwordController.text.trim());
                            if (result?.runtimeType == AuthResultStatus) {
                              // print("THATS IT: $result");
                              result == AuthResultStatus.invalidEmail
                                  ? _emailError = AuthExceptionHandler
                                      .generateExceptionMessage(result)
                                  : result == AuthResultStatus.wrongPassword
                                      ? _passError = AuthExceptionHandler
                                          .generateExceptionMessage(result)
                                      : _otherError = AuthExceptionHandler
                                          .generateExceptionMessage(result);
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
