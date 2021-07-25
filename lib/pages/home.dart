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
  TextEditingController _textFieldController = TextEditingController();
  // String? groupName;
  // List avavailfableChats = [];
  final userCubit = GetIt.I.get<UserCubit>();
  final authCubit = GetIt.I.get<AuthCubit>();
  final roomCubit = GetIt.I.get<RoomCubit>();

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
              print('senderId is: ${FirebaseAuth.instance.currentUser?.uid}');
              print("currentUser is: ${currentUser!.uid}");
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => GroupCreator()));
              _showDialog();
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

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // String? currentUserName = data.getUserName(_currentUserId, listUsers!);
        return AlertDialog(
          title: Text("Create new room"),
          content: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  TextField(
                    decoration:
                        InputDecoration(hintText: 'Enter group`s name...'),
                    controller: _textFieldController,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  BlocBuilder<UserCubit, UserListState>(
                    bloc: userCubit,
                    builder: (context, state) {
                      state.selectedUsers = [];
                      // List _list = [];
                      // state.selectedUsers?.forEach((element) {
                      //   _list.add(element.name);
                      // });
                      return Column(
                        children: [
                          // (state.selectedUsers == null)
                          //     ? Text('')
                          //     : Text('Selected Members: ${_list.toString()}'),
                          // SizedBox(
                          //   height: 20,
                          // ),
                          Text(state.selectedUsers.toString()),
                          Container(
                            height: 300,
                            width: 300,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: state.listUsers!.length,
                                itemBuilder: (context, index) {
                                  List<MyUser>? listUsers = state.listUsers!;
                                  // bool selected ;
                                  return ListTile(
                                    onTap: () {
                                      userCubit.selectUser(listUsers[index]);
                                      // print(state.selectedUsers);
                                    },
                                    // trailing: userCubit.selected(index)
                                    //     ? Icon(Icons.check_box)
                                    //     : Container(),
                                    title: Text(
                                      listUsers[index].name.toString(),
                                      style: TextStyle(
                                          color: state.selectedUsers!
                                                  .contains(listUsers[index])
                                              ? Colors.green
                                              : Colors.red),
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
              child: Text("Next"),
              onPressed: () {
                // data.createGroup(
                //   authCubit.state.currentUser!,
                //   _textFieldController.text,
                // );
                // data.updateRoomData(_textFieldController.text);
                // Navigator.of(context).pop();
                // print(_textFieldController.text);
              },
            ),
          ],
        );
      },
    ).then((value) {
      userCubit.state.selectedUsers?.clear();
      _textFieldController.clear();
    });
  }
// }
}
// class GroupCreator extends StatefulWidget {
//   List<MyUser>? listUsers;
//   // const GroupCreator({Key? key}) : super(key: key);
//   GroupCreator(this.listUsers);

//   @override
//   _GroupCreatorState createState() => _GroupCreatorState();
// }

// class _GroupCreatorState extends State<GroupCreator> {
//   DataBaseService data = DataBaseService();
//   // List<MyUser> listUsers = [];
//   String _currentUserId = FirebaseAuth.instance.currentUser!.uid.toString();

//   List<MyUser> availableUsers = [];
//   int _currentStep = 0;
//   StepperType stepperType = StepperType.vertical;
//   // bool isSelected = true;
//   List<MyUser> selectedUsers = [];
//   final _groupNameController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     // bool amIHere = widget.listUsers!.contains(_currentUserId);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('create new room'),
//       ),
//       body: Container(
//         child: Column(
//           children: [
//             Expanded(
//                 child: Stepper(
//               type: stepperType,
//               physics: ScrollPhysics(),
//               currentStep: _currentStep,
//               onStepTapped: (step) => tapped(step),
//               onStepContinue: continued,
//               onStepCancel: cancel,
//               steps: <Step>[
//                 Step(
//                     // isActive: _currentStep >= 0,
//                     // state: _currentStep == 0
//                     //     ? StepState.complete
//                     //     : StepState.disabled,
//                     title: Text('Enter group`s name'),
//                     content: TextField(
//                       controller: _groupNameController,
//                       decoration: InputDecoration(hintText: 'type here'),
//                     )),
//                 Step(
//                   title: Text('Pick members, $_currentStep'),
//                   content: SizedBox(
//                     child: Column(
//                       children: [
//                         // Text(widget.listUsers.toString()),
//                         ListView.builder(
//                             shrinkWrap: true,
//                             itemCount: widget.listUsers?.length,
//                             itemBuilder: (context, index) {
//                               // var listData = ;
//                               bool isSelected = selectedUsers
//                                   .contains(widget.listUsers![index].uid);

//                               if (widget.listUsers![index].uid!
//                                   .contains(_currentUserId))
//                                 Container();
//                               else
//                                 return ListTile(
//                                   // trailing: GestureDetector(
//                                   //   child: Icon(Icons.close),
//                                   //   onTap: () {
//                                   //     selectedUsers.removeAt(index);
//                                   //     print('pressed');

//                                   //     setState(() {
//                                   //       print(selectedUsers);
//                                   //     });
//                                   //   },
//                                   // ),
//                                   leading: isSelected
//                                       // isSelected
//                                       ? Icon(Icons.select_all_rounded)
//                                       : Icon(Icons.circle),
//                                   title: Text(
//                                     // myCurrentUser(),
//                                     widget.listUsers![index].name.toString(),
//                                     style: TextStyle(
//                                         color: isSelected
//                                             ? Colors.purple.shade900
//                                             : Colors.black),
//                                   ),
//                                   subtitle: Text(
//                                       widget.listUsers![index].email.toString(),
//                                       style: TextStyle(
//                                           color: isSelected
//                                               ? Colors.purple.shade900
//                                               : Colors.black)),
//                                   onTap: () {
//                                     availableUsers
//                                         .add(widget.listUsers![index]);
//                                     // availableUsers.add(_currentUserId);
//                                     selectedUsers =
//                                         availableUsers.toSet().toList();
//                                     print(selectedUsers);
//                                     setState(() {});
//                                   },
//                                 );
//                               return SizedBox.shrink();
//                             }),
//                       ],
//                     ),
//                   ),
//                 ),
//                 // Step(
//                 //     title: Text('we good with this?'),
//                 //     content: Column(
//                 //       children: [
//                 //         Text('Group name: ${_groupNameController.text}'),
//                 //         SizedBox(
//                 //           height: 20,
//                 //         ),
//                 //         Text(getSelectedNames().toString()),
//                 //       ],
//                 //     ))
//               ],
//             ))
//           ],
//         ),
//       ),
//     );
//   }

//   // String myCurrentUser() {
//   //   String myCurrentUser = '';
//   //   widget.listUsers!.firstWhere((e) {

//   //   });
//   //   // print(widget.listUsers.contains(_currentUserId));
//   //   return myCurrentUser;
//   // }
//   // List<String> getSelectedNames() {
//   //   List<String> selectedNames = [];
//   //   selectedUsers.forEach((element) {
//   //     var name = data.getUserName(element.toString(), selectedUsers);
//   //     selectedNames.add(name!);
//   //   });
//   //   return selectedNames;
//   // }

//   tapped(int step) {
//     setState(() => _currentStep = step);
//   }

//   continued() {
//     _currentStep < 1 ? setState(() => _currentStep += 1) : print("hello");
//   }

//   // createGroup() {
//   //   String? currentUserName =
//   //       data.getUserName(_currentUserId, widget.listUsers!);

//   //   data.createGroup(selectedUsers, currentUserName, _groupNameController.text);

//   //   // print('$currentUserName');
//   //   // print("${widget.listUsers!}");
//   // }

//   // continued() {
//   //   // String? currentUserName = data.getUserName(_currentUserId, listUsers!);
//   //   setState(() {
//   //     _currentStep < 1 ? _currentStep += 1 : _currentStep = 0;

//   //     // if (_currentStep > 1)
//   //     //   data.createGroup(
//   //     //       selectedUsers, currentUserName, _groupNameController.text);

//   //     Navigator.pop(context
//   //         // context, MaterialPageRoute(builder: (context) => ChatPage())
//   //         );
//   //   });
//   // }

//   cancel() {
//     setState(() {
//       _currentStep > 0 ? _currentStep -= 1 : _currentStep = 0;
//     });
//   }
// }
