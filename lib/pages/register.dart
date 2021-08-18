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
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(7.0),
            child: ElevatedButton.icon(
              icon: Icon(Icons.person),
              label: Text('Sign In'),
              onPressed: () {
                widget.letsToggleView!();
              },
            ),
          )
        ],
        title: Text('this is register page'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: textInputDecoration.copyWith(
                      hintText: 'What`s your name?'),
                  validator: (val) =>
                      val!.isEmpty ? "introduce yourself" : null,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                    // initialValue: '@',
                    controller: _nickNameController,
                    decoration: textInputDecoration.copyWith(
                        hintText: 'Create nick name.'),
                    // onSaved:   authCubit.isNickNameUnique(_nickNameController.text).toString();,
                    validator: (val) {
                      if (val?.contains('@') == false) {
                        return 'please enter nickname starting with @';
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
                  decoration: textInputDecoration.copyWith(hintText: 'Email'),
                  validator: (val) => val!.isEmpty ? "Enter an email" : null,
                ), // email
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration:
                      textInputDecoration.copyWith(hintText: 'Password'),
                  validator: (val) =>
                      val!.length < 6 ? "Enter an password 6+ long" : null,
                  obscureText: true,
                ), // password
                SizedBox(height: 20),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.purple.shade900)),
                  child:
                      Text('Register', style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    nickNameValidator = await authCubit
                        .isNickNameUnique(_nickNameController.text);

                    if (_formKey.currentState!.validate()) {
                      authCubit.registrate(
                          _nameController.text,
                          _emailController.text,
                          _passwordController.text,
                          _nickNameController.text);
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Text('')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
