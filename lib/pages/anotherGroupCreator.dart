import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:my_chat_app/cubit/cubit/auth_cubit.dart';
import 'package:my_chat_app/cubit/cubit/room_cubit.dart';
import 'package:my_chat_app/cubit/cubit/room_state.dart';
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
  TextEditingController _topicTheme = TextEditingController();
  TextEditingController _topicContent = TextEditingController();
  final scrollController = ScrollController();
  final userCubit = GetIt.I.get<UserCubit>();
  final authCubit = GetIt.I.get<AuthCubit>();
  final roomCubit = GetIt.I.get<RoomCubit>();
  final data = GetIt.I.get<DataBaseService>();
  bool _isPrivate = false;

  @override
  Widget build(BuildContext context) {
    // print(roomCubit.state.currentRoom!.isPrivate);
    userCubit.state.selectedUsers?.add(authCubit.state.currentUser!.copyWith(
        isOwner: true, canWrite: true, isAdmin: true, isApporved: true));
    // print("PRINT FROM BUILD: ${userCubit.state.selectedUsers}");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('What do you want to discuss?'),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: BlocBuilder<RoomCubit, RoomState>(
                bloc: roomCubit,
                builder: (context, state) {
                  return IconButton(
                      onPressed: () {
                        _isPrivate = roomCubit.markAsPrivate();
                      },
                      icon: state.currentRoom!.isPrivate
                          ? Icon(Icons.lock)
                          : Icon(Icons.lock_open));
                },
              ))
        ],
      ),
      body: Container(
        child: Column(
          children: [
            SingleChildScrollView(
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
                          controller: _topicTheme,
                          validator: (val) => val!.isEmpty
                              ? "Please enter discussion topic!"
                              : null,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 8.0),
                              hintText: 'What`s the topic? Be laconic.'),
                          // onFieldSubmitted: (val) {
                          //   _textFieldController.clear();
                          // },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          maxLines: 5,
                          // maxLength: ,
                          // focusNode: FocusNode(),
                          // autofocus: true,
                          controller: _topicContent,
                          validator: (val) => val!.isEmpty
                              ? "Please enter discussion topic!"
                              : null,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 8.0),
                              hintText:
                                  'What happened? Expand the topic. \nPress lock icon above, if you want this room to be private.'),
                          // onFieldSubmitted: (val) {
                          //   _textFieldController.clear();
                          // },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      // SizedBox(
                      //   height: 10,
                      // ),
                      BlocBuilder<UserCubit, UserListState>(
                        bloc: userCubit,
                        builder: (context, state) {
                          // state.selectedUsers = [];
                          // List _list = [];
                          return Container(
                            height: 350,
                            width: 300,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: state.listUsers?.length,
                                itemBuilder: (context, index) {
                                  // List<MyUser>? selected = state.selectedUsers;
                                  List<MyUser>? listUsers = state.listUsers;
                                  if (listUsers?[index] ==
                                      authCubit.state.currentUser)
                                    return SizedBox.shrink();
                                  else
                                    return ListTile(
                                      onTap: () {
                                        userCubit.selectUser(
                                            listUsers![index], index);
                                      },
                                      trailing: listUsers![index].isSelected!
                                          //  state.selectedUsers!
                                          //         .contains(listUsers[index])
                                          ? Icon(Icons.check_box)
                                          : Icon(Icons.check_box_outline_blank),
                                      title: Text(
                                        listUsers[index].name.toString(),
                                      ),
                                      subtitle: Text(
                                          listUsers[index].email.toString()),
                                    );
                                }),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
            // Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: TextButton(
                child: Text(
                  "Create",
                  style: TextStyle(fontSize: 20, color: Colors.deepPurple),
                ),
                onPressed: () {
                  // List<MyUser> selected = [];
                  // selected.addAll()
                  if (formKey.currentState!.validate()) {
                    roomCubit
                        .createRoom(
                            userCubit.state.selectedUsers!,
                            authCubit.state.currentUser!,
                            context,
                            _topicTheme.text,
                            _topicContent.text,
                            _isPrivate)
                        .then((value) {
                      userCubit.state.selectedUsers!.clear();
                      _topicContent.clear();
                      _topicTheme.clear();
                    });
                  } else {
                    print('did not validated');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
