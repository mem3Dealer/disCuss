import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:my_chat_app/cubit/cubit/auth_cubit.dart';
import 'package:my_chat_app/cubit/cubit/auth_state.dart';
import 'package:my_chat_app/cubit/cubit/room_cubit.dart';

import 'package:my_chat_app/cubit/cubit/room_state.dart';

import 'package:my_chat_app/cubit/cubit/user_cubit.dart';

import 'package:my_chat_app/cubit/cubit/user_state.dart';
import 'package:my_chat_app/models/room.dart';
import 'package:my_chat_app/models/user.dart';
import 'package:my_chat_app/pages/chatPage.dart';
import 'package:my_chat_app/services/auth.dart';
import 'package:my_chat_app/services/database.dart';
import 'package:my_chat_app/widgets/anotherGroupCreator.dart';
import 'package:my_chat_app/widgets/groupCreator.dart';
import 'package:provider/single_child_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List<MyUser>? listUsers;
  List<Room>? listRooms;
  final data = GetIt.I.get<DataBaseService>();

  // String? groupName;
  // List avavailfableChats = [];
  final userCubit = GetIt.I.get<UserCubit>();
  final authCubit = GetIt.I.get<AuthCubit>();
  final roomCubit = GetIt.I.get<RoomCubit>();
  final formKey = GlobalKey<FormState>();
  // final dialog = GetIt.I.get<AnotherGroupCreator>();

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      if (userCubit.state.listUsers == null) {
        await userCubit.getUsersList();
        // userCubit.getCurrentUser();
        // var myUser = await userCubit.getCurrentUser();
        // currentUser = myUser!;
        // print("currentUser is: ${authCubit.state.currentUser}");
        // print("currentUser is $currentUser");
        // final usersData = await data.getUsers();
        // listUsers = usersData?.toList();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = authCubit.state.currentUser;
    // final AuthService _auth = AuthService();
    // var senderId = FirebaseAuth.instance.currentUser?.uid;
    return BlocBuilder<AuthCubit, AuthState>(
      bloc: authCubit,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.amber.shade700)),
                child: Icon(Icons.exit_to_app),
                onPressed: () async {
                  await authCubit.logOut();
                  print(
                      'THIS IS LOG OUT PRINT. first param: ${authCubit.fbAuth}, second: ${authCubit.state.isLoggedIn}');
                  // await _auth.signOut();
                },
                // label: Text('Log out'),
              ),
            )
          ], title: Text("${currentUser?.name}`s chats")),
          body: Center(
            child: Container(
                child: BlocBuilder<RoomCubit, RoomState>(
              bloc: roomCubit,
              builder: (context, state) {
                return Container(
                  child:
                      // Text("${currentUser?.uid.toString()} \n\n $senderId")
                      roomCubit.displayRooms(),
                );
              },
            )
                // BlocBuilder<UserCubit, UserListState>(
                //   bloc: userCubit,
                //   builder: (context, state) {
                //     return Column(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         BlocBuilder<AuthCubit, AuthState>(
                //           bloc: authCubit,
                //           builder: (context, state) {
                //             return Text(state.currentUser.toString());
                //           },
                //         ),
                //         SizedBox(
                //           height: 30,
                //         ),
                //         Text(userCubit.state.listUsers.toString()),
                //       ],
                //     );
                //   },
                // ),
                ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              // print(userCubit.state.listUsers?.map((e) => e.name));
              // print(userCubit.state.listUsers?.map((e) => e.email));
              // print(authCubit.state.currentUser);
              // print('senderId is: ${FirebaseAuth.instance.currentUser?.uid}');
              // print("currentUser is: ${currentUser!.uid}");
              // print("this is state: ${userCubit.state.selectedUsers}");
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => GroupCreator()));

              showModalBottomSheet(
                  isScrollControlled: true,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20), bottom: Radius.zero),
                  ),
                  // useRootNavigator: true,
                  context: context,
                  builder: (context) {
                    return AnotherGroupCreator();
                  });

              //     .then((value) {
              //   userCubit.dismissSelected();
              //   userCubit.state.selectedUsers?.clear();
              //   print(
              //       "this is state after dismiss: ${userCubit.state.selectedUsers}");
              //   // _textFieldController.clear();
              // });
              // GroupCreator(listUsers);
              // print('pressed');
            },
          ),
        );
      },
    );
  }
}
