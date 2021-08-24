import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:my_chat_app/cubit/cubit/auth_cubit.dart';

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
  String error = '';
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
                      decoration:
                          InputDecoration().copyWith(hintText: 'E-mail'),
                      validator: (val) =>
                          val!.isEmpty ? "Enter a valid email" : null,
                    ), // email
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      // initialValue: 'test123',
                      controller: _passwordController,
                      decoration:
                          InputDecoration().copyWith(hintText: 'Password'),
                      validator: (val) =>
                          val!.length < 6 ? "Enter an password 6+ long" : null,
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
                        if (_formKey.currentState!.validate()) {
                          await authCubit.signIn(_emailController.text.trim(),
                              _passwordController.text.trim());
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
