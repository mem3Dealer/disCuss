import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:my_chat_app/cubit/cubit/auth_cubit.dart';
import 'package:my_chat_app/cubit/states/auth_state.dart';

class SignInPage extends StatefulWidget {
  // const SignInPage({Key? key}) : super(key: key);
  final Function letsToggleView;
  SignInPage({required this.letsToggleView});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  // final _auth = AuthService();
  final authCubit = GetIt.I.get<AuthCubit>();
  // final _auth = GetIt.I.get<FirebaseAuth>();

  // String email = '';
  // String password = '';
  String? _emailError;
  String? _passError;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        // appBar: AppBar(
        //   title: Text('Sign In'),
        // ),
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
                      // initialValue: 'test@mail.com',
                      controller: _emailController,
                      decoration: InputDecoration().copyWith(
                          alignLabelWithHint: true,
                          // hintText: 'E-mail',
                          labelText: 'E-mail',
                          labelStyle:
                              TextStyle(color: Theme.of(context).accentColor),
                          floatingLabelBehavior: FloatingLabelBehavior.always),
                      validator: (val) {
                        if (val?.isEmpty == true) {
                          return 'Enter a valid email';
                        }
                        if (_emailError?.isNotEmpty == true) {
                          return _emailError;
                        }
                      },
                    ), // email
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      // initialValue: 'test123',
                      controller: _passwordController,
                      decoration: InputDecoration().copyWith(
                          labelStyle:
                              TextStyle(color: Theme.of(context).accentColor),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'Password'),
                      validator: (val) {
                        // val!.length < 6 ? "Enter an password 6+ long" : null,
                        if (val!.length < 6) {
                          return 'Enter an password 6+ long';
                        }
                        if (_passError?.isNotEmpty == true) {
                          // print('this is error: $_emailError');
                          return _passError;
                        }
                      },
                      obscureText: true,
                      // onChanged: (val) {
                      //   setState(() {
                      //     password = val;
                      //   });
                      // },
                    ), // password
                    SizedBox(height: 10),
                    TextButton(
                        onPressed: () {
                          widget.letsToggleView();
                        },
                        child: Text(
                          'New to DisCuss? Register',
                          style:
                              TextStyle(color: Theme.of(context).accentColor),
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
                          } else if (result.contains('user')) {
                            _emailError = result;
                          }
                          // print('that if shit here:$_emailError');
                          // return _emailError;
                        }
                        print(
                            'THAT print from button: $_passError, $_emailError');
                        if (_formKey.currentState!.validate()) {
                          // _passError = '';
                          // _emailError = '';
                          // result!.isNotEmpty ? _emailError = result : null;

                        }
                      },
                    ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    // Text(error)
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
