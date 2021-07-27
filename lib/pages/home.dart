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

  // Future<List> availableChats() async {
  //   List avavailableChats = [];
  //   // var res =
  //   //     await roomsCollection.where('admin', whereIn: ['someone']).get();
  //   var res = await roomsCollection
  //       .where('members', arrayContains: _currentUserId)
  //       .get();

  //   res.docs.forEach((res) {
  //     avavailableChats.add(res.id);
  //     print(res.id);
  //   });
  //   print(avavailableChats);
  //   return avavailableChats;
  // }

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
              // print(authCubit.state.currentUser);
              // print('senderId is: ${FirebaseAuth.instance.currentUser?.uid}');
              // print("currentUser is: ${currentUser!.uid}");
              // print("this is state: ${userCubit.state.selectedUsers}");
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => GroupCreator()));
              AnotherGroupCreator();
              // GroupCreator(listUsers);
              // print('pressed');
            },
          ),
        );
      },
    );
  }

  // Widget showRooms() {
  //   return Container(
  //       child: BlocBuilder<UserCubit, UserListState>(
  //     bloc: userCubit,
  //     builder: (context, state) {
  //       return StreamBuilder<QuerySnapshot>(
  //         stream: data.roomsStream(),
  //         builder: (context, snapshot) {
  //           var roomData = snapshot.data?.docs;
  //           if (snapshot.hasData)
  //             return ListView.builder(
  //               itemCount: snapshot.data?.docs.length,
  //               itemBuilder: (context, index) {
  //                 // if (roomData[index]['members'].contains(_currentUserId))
  //                 return Column(
  //                   children: [
  //                     // if (listRooms![index].members.contains(_currentUserId))
  //                     ListTile(
  //                       title: Text(
  //                           "${roomData?[index]['groupName']} + ${roomData?[index]['groupID']}"),
  //                       subtitle:
  //                           Text("Created by: ${listRooms?[index].admin}"),
  //                       onTap: () {
  //                         Navigator.push(
  //                             context,
  //                             MaterialPageRoute(
  //                                 builder: (context) =>
  //                                     ChatPage(roomData?[index]['groupID'])));
  //                       },
  //                     ),
  //                     Divider()
  //                   ],
  //                 );
  //               },
  //             );
  //           else
  //             return Center(child: CircularProgressIndicator());
  //         },
  //       );
  //     },
  //   ));
  // }

//   void _showDialog() {
//     userCubit.state.selectedUsers?.add(authCubit.state.currentUser!);

//     // String error = '';
//     // flutter defined function
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         // String? currentUserName = data.getUserName(_currentUserId, listUsers!);
//         return AlertDialog(
//           title: Text("Create new room"),
//           content: SingleChildScrollView(
//             child: Container(
//               child: Column(
//                 children: [
//                   TextFormField(
//                     controller: _textFieldController,
//                     key: formKey,
//                     validator: (val) =>
//                         val!.isEmpty ? "Please enter group`s name" : null,
//                     decoration:
//                         InputDecoration(hintText: 'Enter group`s name...'),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   BlocBuilder<UserCubit, UserListState>(
//                     bloc: userCubit,
//                     builder: (context, state) {
//                       // state.selectedUsers = [];
//                       List _list = [];
//                       return Column(
//                         children: [
//                           // (state.selectedUsers == null)
//                           //     ? Text('')
//                           //     : Text('Selected Members: ${_list.toString()}'),
//                           // SizedBox(
//                           //   height: 20,
//                           // ),

//                           // Column(
//                           //   children: [
//                           //     Text(
//                           //         "SELS ARE ${state.selectedUsers.toString()}"),
//                           //     Container(child: Text(_list.toString())),
//                           //     Text(state.version.toString()),
//                           //   ],
//                           // ),

//                           Container(
//                             height: 300,
//                             width: 300,
//                             child: ListView.builder(
//                                 shrinkWrap: true,
//                                 itemCount: state.listUsers!.length,
//                                 itemBuilder: (context, index) {
//                                   // List<MyUser>? selected = state.selectedUsers;
//                                   List<MyUser>? listUsers = state.listUsers!;
//                                   // bool selected ;
//                                   // state.selectedUsers = [];
//                                   // if (state.selectedUsers!
//                                   //     .contains(listUsers[index]))
//                                   if (listUsers[index] ==
//                                       authCubit.state.currentUser)
//                                     return SizedBox.shrink();
//                                   else
//                                     return ListTile(
//                                       onTap: () {
//                                         userCubit.selectUser(listUsers[index]);
//                                         // print(
//                                         //     "THIS IS PRINT FROM TILE ${state.selectedUsers}");
//                                         // print(state.version);
//                                         // state.selectedUsers?.forEach((element) {
//                                         //   _list.add(element.name);
//                                         //   print(_list);
//                                         // });
//                                       },
//                                       trailing: state.selectedUsers!
//                                               .contains(listUsers[index])
//                                           // ==
//                                           //     selected.contains(listUsers[index])
//                                           ? Icon(Icons.check_box)
//                                           : Icon(Icons.check_box_outline_blank),
//                                       title: Text(
//                                         listUsers[index].name.toString(),
//                                       ),
//                                       subtitle: Text(
//                                           listUsers[index].email.toString()),
//                                     );
//                                 }),
//                           )
//                         ],
//                       );
//                     },
//                   )
//                 ],
//               ),
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text("Create"),
//               onPressed: () {
//                 // print(formKey.currentState);
//                 // bool aga = _textFieldController.text.isNotEmpty;
//                 // print(aga);
//                 if (formKey.currentState!.validate()) {
//                   data.createGroup(
//                     userCubit.state.selectedUsers!,
//                     authCubit.state.currentUser!,
//                     _textFieldController.text,
//                   );
//                 } else {
//                   // userCubit.state.error = 'please enter group name';
//                   // print(error);
//                 }
//                 // data.updateRoomData(_textFieldController.text);
//                 // Navigator.of(context).pop();
//                 // print(_textFieldController.text);
//               },
//             ),
//           ],
//         );
//       },
//     ).then((value) {
//       userCubit.dismissSelected();
//       // userCubit.state.selectedUsers?.clear();
//       print("this is state after dismiss: ${userCubit.state.selectedUsers}");
//       _textFieldController.clear();
//     });
//   }
// // }
}
