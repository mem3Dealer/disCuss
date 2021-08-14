// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get_it/get_it.dart';
// import 'package:my_chat_app/cubit/cubit/room_cubit.dart';
// import 'package:my_chat_app/cubit/cubit/room_state.dart';
// import 'package:my_chat_app/cubit/cubit/user_cubit.dart';
// import 'package:my_chat_app/cubit/cubit/user_state.dart';
// import 'package:my_chat_app/models/user.dart';
// import 'package:my_chat_app/services/database.dart';

// class AddNewUser extends StatelessWidget {
//   AddNewUser(this.groupId, {Key? key}) : super(key: key);
//   String groupId;
//   final roomCubit = GetIt.I.get<RoomCubit>();
//   final userCubit = GetIt.I.get<UserCubit>();
//   final data = GetIt.I.get<DataBaseService>();

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<RoomCubit, RoomState>(
//       bloc: roomCubit,
//       builder: (context, state) {
//         return Scaffold(
//             appBar: AppBar(title: Text('Add new member')),
//             body: Container(
//                 child: Center(
//               child: Column(
//                 children: [
//                   Container(
//                     // height: 300,
//                     // width: 300,
//                     child: SingleChildScrollView(
//                       child: ListView.builder(
//                           shrinkWrap: true,
//                           itemCount: state.currentRoom?.members?.length,
//                           // state.room?.members?.length,
//                           itemBuilder: (context, index) {
//                             List<MyUser>? _users = state.currentRoom?.members;
//                             // List<MyUser>? _localUsers =
//                             //     state.currentRoom!.members!;
//                             // List<String>? _localUsersId = [];

//                             // _localUsers.forEach((element) {
//                             //   _localUsersId.add(element.uid!);
//                             // });

//                             // // print('FILTER: $_localUsersId');
//                             // if (_users![index].isApporved == true &&
//                             //     _users[index].canWrite == false)

//                             return BlocBuilder<UserCubit, UserListState>(
//                               bloc: userCubit,
//                               builder: (context, state) {
//                                 return ListTile(
//                                     onTap: () {
//                                       userCubit.selectUser(_users![index]);
//                                       // print(_users[index]);
//                                     },
//                                     // trailing: Checkbox(
//                                     //   onChanged: (val) {
//                                     //     roomCubit.letThemWrite(_users?[index],
//                                     //         !_users![index].canWrite!);
//                                     //   },
//                                     //   value: _users![index].canWrite,
//                                     // ),
//                                     // _users[index].isSelected!
//                                     //     ? Icon(Icons.check_box)
//                                     //     : Icon(Icons.check_box_outline_blank),
//                                     title: Text(_users![index].name.toString()),
//                                     // Text(_members![index].name!),
//                                     subtitle:
//                                         Text(_users[index].email.toString())
//                                     // Text(_members[index].email!),
//                                     );
//                               },
//                             );
//                           }
//                           //  else
//                           //   return SizedBox.shrink();
//                           ),
//                     ),
//                   ),
//                   Spacer(),
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 15.0),
//                     child: Align(
//                       alignment: Alignment.bottomCenter,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           ElevatedButton(
//                               onPressed: () {
//                                 userCubit.dismissSelected();
//                                 Navigator.of(context).pop();
//                               },
//                               child: Text('Never mind')),
//                           ElevatedButton(
//                               onPressed: () {
//                                 // roomCubit.letThemWrite(
//                                 //     groupId, key);
//                                 // roomCubit.addUserToThisRoom(groupId, context,
//                                 //     userCubit.state.selectedUsers!);
//                                 // data.addNewUserToRoom(
//                                 //     groupId, userCubit.state.selectedUsers);
//                                 // userCubit.state.selectedUsers!.clear();
//                                 // Navigator.of(context).pop();
//                               },
//                               child: Text('Add`em'))
//                         ],
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             )));
//       },
//     );
//   }
// }
