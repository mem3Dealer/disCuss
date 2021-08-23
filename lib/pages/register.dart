import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:my_chat_app/cubit/cubit/auth_cubit.dart';
import 'package:my_chat_app/cubit/cubit/user_cubit.dart';
import 'package:my_chat_app/services/database.dart';
import 'package:my_chat_app/shared/input.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      // appBar: AppBar(
      //   // actions: [
      //   // Padding(
      //   //   padding: const EdgeInsets.all(7.0),
      //   //   child: ElevatedButton.icon(
      //   //     icon: Icon(Icons.person),
      //   //     label: Text('Sign In'),
      //   //     onPressed: () {
      //   //       widget.letsToggleView!();
      //   //     },
      //   //   ),
      //   // )
      //   // ],
      //   title: Text('Create new account'),
      // ),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
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
                          hintText: 'What is your name?',
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
                          hintText: 'Enter your nickname',
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
                      decoration: InputDecoration()
                          .copyWith(hintText: 'Enter your e-mail'),
                      validator: (val) => val!.isEmpty
                          ? "Enter an email adress"
                          : val.contains('@')
                              ? null
                              : 'Please enter valid email' //TODO вывести ошибку занятого имейл
                      ), // email
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration().copyWith(
                        hintText: 'Create password',
                        helperText: 'It should be at least 6 chatacters long'),
                    validator: (val) =>
                        val!.length < 6 ? "Enter an password 6+ long" : null,
                    obscureText: true,
                  ), // password
                  SizedBox(height: 10),
                  TextButton(
                      onPressed: () {
                        widget.letsToggleView!();
                      },
                      child: Text('Already have an account? Sign in',
                          style:
                              TextStyle(color: Theme.of(context).accentColor))),
                  SizedBox(height: 10),
                  ElevatedButton(
                    child: Text('Register'),
                    onPressed: () async {
                      nickNameValidator = await authCubit
                          .isNickNameUnique(_nickNameController.text);

                      if (_formKey.currentState!.validate()) {
                        // try {
                        authCubit.registrate(
                            _nameController.text.trim(),
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                            _nickNameController.text.trim());
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
    );
  }
}
