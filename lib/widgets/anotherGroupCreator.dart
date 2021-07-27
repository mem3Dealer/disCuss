import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:my_chat_app/cubit/cubit/auth_cubit.dart';
import 'package:my_chat_app/cubit/cubit/room_cubit.dart';
import 'package:my_chat_app/cubit/cubit/user_cubit.dart';
import 'package:my_chat_app/cubit/cubit/user_state.dart';
import 'package:my_chat_app/models/user.dart';
import 'package:my_chat_app/services/database.dart';

class AnotherGroupCreator extends StatelessWidget {
  // var formKey = GlobalKey<FormState>();
  // const AnotherGroupCreator({ Key? key }) : super(key: key);
  // AnotherGroupCreator(this.formKey);
  // List avavailfableChats = [];
  TextEditingController _textFieldController = TextEditingController();
  final userCubit = GetIt.I.get<UserCubit>();
  final authCubit = GetIt.I.get<AuthCubit>();
  final roomCubit = GetIt.I.get<RoomCubit>();
  final data = GetIt.I.get<DataBaseService>();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Create new room"),
      content: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              TextFormField(
                controller: _textFieldController,
                key: formKey,
                validator: (val) =>
                    val!.isEmpty ? "Please enter group`s name" : null,
                decoration: InputDecoration(hintText: 'Enter group`s name...'),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 10,
              ),
              BlocBuilder<UserCubit, UserListState>(
                bloc: userCubit,
                builder: (context, state) {
                  // state.selectedUsers = [];
                  // List _list = [];
                  return Column(
                    children: [
                      // (state.selectedUsers == null)
                      //     ? Text('')
                      //     : Text('Selected Members: ${_list.toString()}'),
                      // SizedBox(
                      //   height: 20,
                      // ),

                      // Column(
                      //   children: [
                      //     Text(
                      //         "SELS ARE ${state.selectedUsers.toString()}"),
                      //     Container(child: Text(_list.toString())),
                      //     Text(state.version.toString()),
                      //   ],
                      // ),

                      Container(
                        height: 300,
                        width: 300,
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
                              if (listUsers[index] ==
                                  authCubit.state.currentUser)
                                return SizedBox.shrink();
                              else
                                return ListTile(
                                  onTap: () {
                                    userCubit.selectUser(listUsers[index]);
                                  },
                                  trailing: state.selectedUsers!
                                          .contains(listUsers[index])
                                      // ==
                                      //     selected.contains(listUsers[index])
                                      ? Icon(Icons.check_box)
                                      : Icon(Icons.check_box_outline_blank),
                                  title: Text(
                                    listUsers[index].name.toString(),
                                  ),
                                  subtitle:
                                      Text(listUsers[index].email.toString()),
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
      actions: <Widget>[
        TextButton(
          child: Text("Create"),
          onPressed: () {
            // print(formKey.currentState);
            // bool aga = _textFieldController.text.isNotEmpty;
            // print(aga);
            if (formKey.currentState!.validate()) {
              print('validated');
              // data.createGroup(
              //   userCubit.state.selectedUsers!,
              //   authCubit.state.currentUser!,
              //   _textFieldController.text,
              // );
            } else {
              print('did not validated');
              // userCubit.state.error = 'please enter group name';
              // print(error);
            }
            // data.updateRoomData(_textFieldController.text);
            // Navigator.of(context).pop();
            // print(_textFieldController.text);
          },
        ),
      ],
    );
  }
// .then((value) {
//       userCubit.dismissSelected();
//       // userCubit.state.selectedUsers?.clear();
//       print("this is state after dismiss: ${userCubit.state.selectedUsers}");
//       _textFieldController.clear();
//     });
}
