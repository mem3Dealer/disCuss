import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:my_chat_app/cubit/cubit/auth_cubit.dart';
import 'package:my_chat_app/cubit/states/auth_state.dart';
import 'package:my_chat_app/cubit/cubit/room_cubit.dart';

import 'package:my_chat_app/cubit/states/room_state.dart';

import 'package:my_chat_app/cubit/cubit/user_cubit.dart';

import 'package:my_chat_app/models/room.dart';
import 'package:my_chat_app/pages/chatPage.dart';
import 'package:my_chat_app/services/database.dart';
import 'package:my_chat_app/services/wrapper.dart';
import 'package:my_chat_app/pages/anotherGroupCreator.dart';

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
  // final _auth = GetIt.I.get<FirebaseAuth>();
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
    // print("PRINT FROM UILD: ${userCubit.state.listUsers}");
    // final currentUser = authCubit.state.currentUser;
    // final AuthService _auth = AuthService();
    // var senderId = FirebaseAuth.instance.currentUser?.uid;
    return BlocBuilder<AuthCubit, AuthState>(
      bloc: authCubit,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: IconButton(
                // style: ButtonStyle(
                //     backgroundColor: MaterialStateProperty.all<Color>(
                //         Colors.amber.shade700)),
                icon: Icon(Icons.exit_to_app),
                onPressed: () async {
                  await authCubit.logOut();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Wrapper()));
                  // print(
                  //     'THIS IS LOG OUT PRINT. first param: ${authCubit.fbAuth}, second: ${authCubit.state.isLoggedIn}');
                  // await _auth.signOut();
                },
                // label: Text('Log out'),
              ),
            )
          ], title: Text("${authCubit.state.currentUser?.nickName}`s available rooms")),
          body: Center(
            child: Container(
                child: BlocBuilder<RoomCubit, RoomState>(
                    bloc: roomCubit,
                    builder: (context, state) {
                      if (state.listRooms == null) {
                        return Center(
                          child: Text('There is a problem, no doubt'),
                        );
                      } else if (state.listRooms!.length > 0) return _buildRooms(state);
                      return CircularProgressIndicator();
                      // print("FILTER 1: ${state.listRooms}");
                      // if (state.listRooms != null &&
                      //  state.listRooms?.length != 0)
                      //   return _buildRooms(state);
                      // else if (state.listRooms?.length == 0)
                      //   return Center(
                      //     child: Container(
                      //       child: Text(
                      //         'There are no chats for you \n Go create one',
                      //         textAlign: TextAlign.center,
                      //         style: TextStyle(
                      //             fontSize: 25, fontWeight: FontWeight.w300),
                      //       ),
                      //     ),
                      //   );
                      // else if(state.listRooms?.length ==0) CircularProgressIndicator();
                      // return Container();
                    })),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              // print(authCubit.state.currentUser);
              // roomCubit.loadRooms();
              Navigator.of(context).push(MaterialPageRoute<void>(
                      builder: (BuildContext context) =>
                          // SliverPage()
                          AnotherGroupCreator(false))
                  // )
                  );
            },
          ),
        );
      },
    );
  }

  Container _buildRooms(RoomState state) {
    return Container(
        child:
            // Text(roomCubit.displayRooms().toString())
            ListView.builder(
                itemCount: state.listRooms?.length,
                itemBuilder: (context, index) {
                  List<Room>? _list = state.listRooms;
                  // MyUser? currentUser = authCubit.state.currentUser;
                  return Column(
                    children: [
                      ListTile(
                        trailing: _list![index].isPrivate
                            ? Text(
                                'private',
                                style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                              )
                            : SizedBox.shrink(),
                        title: Text("${_list[index].topicTheme}"),
                        subtitle: _list[index].isPrivate
                            ? _list[index].members?.contains(roomCubit.getoLocalUser(thatRoom: _list[index])) == true
                                ? Text(
                                    "${_list[index].lastMessage?.sender?.name}: ${_list[index].lastMessage?.content}")
                                : null
                            : Text("${_list[index].lastMessage?.sender?.name}: ${_list[index].lastMessage?.content}"),
                        // : Text(
                        //     "${_list[index].lastMessage?.sender?.name}: ${_list[index].lastMessage?.content}"),
                        onTap: () {
                          roomCubit.setRoomAsCurrent(_list[index].groupID!);
                          roomCubit.loadChat(_list[index].groupID!);
                          // print(
                          //     'THIS IS THAT: ${state.currentRoom}');
                          Navigator.of(context).push(MaterialPageRoute<void>(
                            builder: (BuildContext context) => ChatPage(_list[index].groupID!),
                          ));
                        },
                      ),
                      Divider()
                    ],
                  );
                })
        // Text("${currentUser?.uid.toString()} \n\n $senderId")
        // roomCubit.displayRooms(),
        );
  }
}
