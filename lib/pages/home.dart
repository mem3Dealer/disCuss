import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:my_chat_app/cubit/cubit/auth_cubit.dart';
import 'package:my_chat_app/cubit/cubit/auth_state.dart';
import 'package:my_chat_app/cubit/cubit/room_cubit.dart';

import 'package:my_chat_app/cubit/cubit/room_state.dart';

import 'package:my_chat_app/cubit/cubit/user_cubit.dart';

import 'package:my_chat_app/models/room.dart';
import 'package:my_chat_app/services/database.dart';
import 'package:my_chat_app/services/wrapper.dart';
import 'package:my_chat_app/widgets/anotherGroupCreator.dart';

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
      }
      roomCubit.loadRooms();
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
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Wrapper()));
                  // print(
                  //     'THIS IS LOG OUT PRINT. first param: ${authCubit.fbAuth}, second: ${authCubit.state.isLoggedIn}');
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
                      if (state.listRooms != null)
                        // if (state
                        //     .listRooms!.isNotEmpty)
                        return Container(
                            child:
                                // Text(roomCubit.displayRooms().toString())
                                ListView.builder(
                                    itemCount: state.listRooms?.length,
                                    itemBuilder: (context, index) {
                                      List<Room>? _list = state.listRooms;
                                      return Column(
                                        children: [
                                          ListTile(
                                            title: Text(
                                                "${_list?[index].groupName}"),
                                            subtitle: Text(
                                                'Created by: ${_list?[index].admin?.name}'),
                                            onTap: () {},
                                          ),
                                          Divider()
                                        ],
                                      );
                                    })
                            // Text("${currentUser?.uid.toString()} \n\n $senderId")
                            // roomCubit.displayRooms(),
                            );
                      else
                        return state.listRooms == null
                            ? CircularProgressIndicator()
                            : Center(
                                child: Container(
                                  child: Text(
                                      'There are no chats for you! \n Go create one!'),
                                ),
                              );
                      // return Container();
                    })),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              print(authCubit.state.currentUser);
              // roomCubit.loadRooms();

              // showModalBottomSheet(
              //     isScrollControlled: true,
              //     elevation: 5,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.vertical(
              //           top: Radius.circular(20), bottom: Radius.zero),
              //     ),
              //     // useRootNavigator: true,
              //     context: context,
              //     builder: (context) {
              //       return AnotherGroupCreator();
              //     });
            },
          ),
        );
      },
    );
  }
}
