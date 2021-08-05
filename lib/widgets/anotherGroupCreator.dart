import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:my_chat_app/cubit/cubit/auth_cubit.dart';
import 'package:my_chat_app/cubit/cubit/room_cubit.dart';
import 'package:my_chat_app/cubit/cubit/user_cubit.dart';
import 'package:my_chat_app/cubit/cubit/user_state.dart';
import 'package:my_chat_app/models/user.dart';
import 'package:my_chat_app/services/database.dart';

final formKey = GlobalKey<FormState>();

class AnotherGroupCreator extends StatefulWidget {
  @override
  _AnotherGroupCreatorState createState() => _AnotherGroupCreatorState();
}

class _AnotherGroupCreatorState extends State<AnotherGroupCreator> {
  TextEditingController _textFieldController = TextEditingController();
  final userCubit = GetIt.I.get<UserCubit>();
  final authCubit = GetIt.I.get<AuthCubit>();
  final roomCubit = GetIt.I.get<RoomCubit>();
  final data = GetIt.I.get<DataBaseService>();

  @override
  Widget build(BuildContext context) {
    userCubit.state.selectedUsers?.add(authCubit.state.currentUser!);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            "Create new room",
            style: TextStyle(fontSize: 25),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        // focusNode: FocusNode(),
                        // autofocus: true,
                        controller: _textFieldController,
                        validator: (val) => val!.isEmpty ? "Please enter group`s name" : null,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 8.0), hintText: 'Enter group`s name...'),
                        // onFieldSubmitted: (val) {
                        //   _textFieldController.clear();
                        // },
                      ),
                    ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    BlocBuilder<UserCubit, UserListState>(
                      bloc: userCubit,
                      builder: (context, state) {
                        // state.selectedUsers = [];
                        // List _list = [];
                        return Column(
                          children: [
                            Container(
                              // height: 500,
                              // width: 300,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: state.listUsers!.length,
                                  itemBuilder: (context, index) {
                                    // List<MyUser>? selected = state.selectedUsers;
                                    List<MyUser>? listUsers = state.listUsers!;
                                    // bool selected ;
                                    // state.selectedUsers = [];
                                    // if (state.selectedUsers!
                                    //     .contains(listUsers[index]))
                                    if (listUsers[index] == authCubit.state.currentUser)
                                      return SizedBox.shrink();
                                    else
                                      return ListTile(
                                        onTap: () {
                                          userCubit.selectUser(listUsers[index]);
                                        },
                                        trailing: state.selectedUsers!.contains(listUsers[index])
                                            // ==
                                            //     selected.contains(listUsers[index])
                                            ? Icon(Icons.check_box)
                                            : Icon(Icons.check_box_outline_blank),
                                        title: Text(
                                          listUsers[index].name.toString(),
                                        ),
                                        subtitle: Text(listUsers[index].email.toString()),
                                      );
                                  }),
                            )
                          ],
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        TextButton(
          child: Text(
            "Create",
            style: TextStyle(fontSize: 20, color: Colors.deepPurple),
          ),
          onPressed: () {
            // print(formKey.currentState);
            // bool aga = _textFieldController.text.isNotEmpty;
            // print(aga);
            if (formKey.currentState!.validate()) {
              data
                  .createGroup(
                userCubit.state.selectedUsers!,
                authCubit.state.currentUser!,
                _textFieldController.text,
              )
                  .then((value) {
                _textFieldController.clear();
                userCubit.dismissSelected();
                Navigator.of(context).pop();
              });
            } else {
              print('did not validated');
            }
            // data.updateRoomData(_textFieldController.text);
            // Navigator.of(context).pop();
            // print(_textFieldController.text);
          },
        ),
      ],
    );
  }
}
